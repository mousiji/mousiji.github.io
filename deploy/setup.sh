#!/usr/bin/env bash
# mousiji 博客服务器一键初始化（Debian/Ubuntu/CentOS/Alpine 都认）
# 用法：bash deploy/setup.sh   （在仓库 clone 目录里执行）
set -e

echo "==> 1/7 安装 nginx + rsync + certbot ..."
if command -v apt-get >/dev/null 2>&1; then
  # rsync = CI 推送必需（Debian 13 精简镜像默认没有）；certbot = 签 HTTPS 证书
  apt-get update -y && apt-get install -y nginx rsync certbot python3-certbot-nginx
elif command -v dnf >/dev/null 2>&1; then
  dnf install -y nginx rsync certbot python3-certbot-nginx
elif command -v yum >/dev/null 2>&1; then
  yum install -y nginx rsync certbot python3-certbot-nginx
elif command -v apk >/dev/null 2>&1; then
  apk add nginx rsync certbot
else
  echo "未识别的包管理器，请手动安装 nginx 后重跑"; exit 1
fi

echo "==> 2/7 让出 80 端口（停用镜像自带的 caddy / 占用者）..."
if ss -lntp 2>/dev/null | grep -q ':80 ' && systemctl list-unit-files 2>/dev/null | grep -q '^caddy.service'; then
  systemctl disable --now caddy 2>/dev/null || true
  echo "    已停用 caddy（还原命令：systemctl enable --now caddy）"
fi

echo "==> 3/7 创建站点目录 ..."
mkdir -p /var/www/mousiji

echo "==> 4/7 写入 nginx 配置 ..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true      # Debian 默认站点让位
[ -f /etc/nginx/conf.d/default.conf ] && \
  mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak   # CentOS 默认站点让位
cp "$SCRIPT_DIR/nginx.conf" /etc/nginx/conf.d/mousiji.conf

echo "==> 5/7 系统防火墙放行 80/443（若 ufw 未启用则跳过）..."
if command -v ufw >/dev/null 2>&1 && ufw status 2>/dev/null | grep -q "Status: active"; then
  ufw allow 80/tcp
  ufw allow 443/tcp
fi

echo "==> 6/7 检测并启动 ..."
nginx -t
systemctl enable nginx
systemctl restart nginx

echo "==> 7/7 上 HTTPS（DNS 已生效才执行；证书 90 天自动续期）..."
if curl -sI http://moskie.vip 2>/dev/null | head -n 1 | grep -q '200\|301\|302\|404'; then
  certbot --nginx -d moskie.vip -d www.moskie.vip --redirect --agree-tos --register-unsafely-without-email \
    && echo "    HTTPS 已签发" \
    || echo "    ⚠️ certbot 失败（多半是 DNS 还没生效），稍后重跑本脚本即可"
else
  echo "    ⏭️ 域名还没解析到本机，跳过签证书（DNS 生效后重跑本脚本）"
fi

echo ""
echo "✅ nginx 初始化完成。本机自检："
curl -sI http://127.0.0.1 | head -n 1 || true
echo "（CI 还没推送内容前返回的是空目录/404，属正常）"
