# deploy/ — 服务器部署手册（moskie.vip）

> 架构：GitHub = 大脑（源码/构建/密钥），服务器 = 显示器（只放可再生的静态文件）。
> **服务器上没有任何独有数据，换机器 = 重跑本手册，零迁移。**

## 日常发布（你只需要）

写文章 → `git push` → GitHub Actions 自动构建 → `deploy-server` job rsync 到服务器 → 完成。
**不需要登录服务器做任何事。**

## 首次部署 / 换服务器时（在服务器 root 下执行）

```bash
# ① 拉取部署配置
git clone https://github.com/mousiji/mousiji.github.io.git /opt/blog-deploy

# ② 一键初始化 nginx
bash /opt/blog-deploy/deploy/setup.sh

# ③ 装 CI 部署公钥（内容取自 GitHub Secret / 工作区 deploy_key.pub）
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo '<把 deploy_key.pub 整行粘这里>' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# ④ 上 HTTPS（需 DNS 已生效；证书自动续期）
apt-get install -y certbot python3-certbot-nginx
certbot --nginx -d moskie.vip -d www.moskie.vip --redirect
```

之后只需：**GitHub 仓库 Settings → Secrets 改 `SERVER_HOST` 为新 IP → 随便 push 一次**，旧机器可直接丢弃。

## 加新域名 / 子域名（同一台服务器可挂无限个）

1. 新域名在注册商处加 A 记录 → 服务器 IP
2. 把 `deploy/nginx.conf` 的 `server_name` 抄一段改成新域名（或加进现有那行，空格分隔）
3. `cp` 进 `/etc/nginx/conf.d/` 后 `nginx -t && systemctl reload nginx`
4. `certbot --nginx -d 新域名` 签证书

## 常见操作

```bash
nginx -t                                # 配置检查
systemctl reload nginx                  # 重载配置（不中断）
systemctl restart nginx                 # 重启
tail -f /var/log/nginx/mousiji.error.log # 错误日志
bash /opt/blog-deploy/deploy/setup.sh   # 重跑初始化（⚠️ 会覆盖 certbot 对配置的改动，之后重跑 certbot）
```

## GitHub Secrets（Settings → Secrets and variables → Actions）

| Secret | 作用 |
|---|---|
| `SERVER_HOST` | 服务器 IP（换机器只改这里） |
| `SERVER_USER` | SSH 用户（root） |
| `SERVER_SSH_KEY` | 部署私钥（`deploy_key`，**永不进仓库**） |
