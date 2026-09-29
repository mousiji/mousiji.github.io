#!/usr/bin/env bash
# mousiji 博客服务器一键初始化（Debian/Ubuntu/CentOS/Alpine 都认）
# 用法：bash deploy/setup.sh   （在仓库 clone 目录里执行）
set -e

echo "==> 1/5 安装 nginx ..."
if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y && apt-get install -y nginx
elif command -v dnf >/dev/null 2>&1; then
  dnf install -y nginx
elif command -v yum >/dev/null 2>&1; then
  yum install -y nginx
elif command -v apk >/dev/null 2>&1; then
  apk add nginx
else
  echo "未识别的包管理器，请手动安装 nginx 后重跑"; exit 1
fi

echo "==> 2/5 创建站点目录 ..."
mkdir -p /var/www/mousiji

echo "==> 3/5 写入 nginx 配置 ..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true      # Debian 默认站点让位
[ -f /etc/nginx/conf.d/default.conf ] && \
  mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak   # CentOS 默认站点让位
cp "$SCRIPT_DIR/nginx.conf" /etc/nginx/conf.d/mousiji.conf

echo "==> 4/5 系统防火墙放行 80/443（若 ufw 未启用则跳过）..."
if command -v ufw >/dev/null 2>&1 && ufw status 2>/dev/null | grep -q "Status: active"; then
  ufw allow 80/tcp
  ufw allow 443/tcp
fi

echo "==> 5/5 检测并启动 ..."
nginx -t
systemctl enable nginx
systemctl restart nginx

echo ""
echo "✅ nginx 初始化完成。本机自检："
curl -sI http://127.0.0.1 | head -n 1 || true
echo "（CI 还没推送内容前返回的是空目录/404，属正常）"
