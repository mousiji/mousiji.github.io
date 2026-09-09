# AGENTS.md — AI 接手指引

> 本文件供 **AI 助手 / 新设备** 快速理解本仓库。任何 AI 开始操作本项目前，请先通读本文件。
> 完整面向人的维护指南见 [README.md](README.md)。

## 1. 项目是什么

「斯基」的个人博客（卡片式），技术栈 **Astro 5 + TypeScript + 纯 CSS**，静态站点托管在 **GitHub Pages**，源码仓库与线上 Pages 同仓库 `mousiji/mousiji.github.io`（`main` 分支即源码，push 自动构建部署）。

- 线上地址：https://mousiji.github.io
- 内容源：`src/content/blog/*.md`（Markdown 文章）、`src/content/friends/*.json`（友链）
- 评论区：Giscus（GitHub Discussions），配置在 `src/components/Giscus.astro`
- 后台：Decap CMS，位于 `public/admin/`（本地免登录 / 线上 DecapBridge 登录）

## 2. 最常用的命令

```bash
npm install           # 安装依赖（node_modules 不入库）
npm run dev           # 本地开发 http://localhost:4321
npm run dev:admin     # 本地开发 + Decap CMS 后台代理（http://localhost:4321/admin）
npm run build         # 构建到 dist/（产物不入库）
npm run preview       # 预览构建结果
```

本项目目录本身就是 git 工作副本，直接 `git add/commit/push origin main` 即可发布，**不要用临时目录中转**。

## 3. 写文章（最高频任务）

在 `src/content/blog/` 新建 `<slug>.md`：

```markdown
---
title: "标题"
description: "卡片摘要（可选）"
pubDate: 2026-09-08
tags: ["标签"]
heroImage: "/images/xxx.jpg"   # 可选封面图，放 public/images/
draft: false                    # true=草稿不发布
---

正文 Markdown...
```

**草稿机制（务必遵守）**：`draft: true` 的文章只在本地 dev 出现（带黄色角标），**不会**进线上。判断某篇文章线上能否显示 = 查 frontmatter 的 `draft`。文章 schema 在 `src/content/config.ts`（日期字段是 `z.coerce.date()`，兼容字符串日期）。

写作前可参考现成草稿 `src/content/blog/writing-template.md`（含 frontmatter 说明 + Markdown 语法速查）。

## 4. 站点配置快速索引

| 要改什么 | 改哪里 |
|---|---|
| 首页标题「斯基」/ 签名「很高兴见到你=w=」 | `src/pages/index.astro` |
| 关于页 | `src/pages/about.astro` |
| 头像 | 替换 `public/images/avatar.png` |
| 主题色 | `public/styles/global.css` 与 `src/styles/global.css`（**两份需同步修改**，页面实际引用 `/styles/global.css` 即 public 那份） |
| 友链 | `src/content/friends/` 下加/改 JSON |
| 评论 | `src/components/Giscus.astro`（repo-id `R_kgDOIrvofQ`，category `General`） |
| 站点 URL/RSS | `astro.config.mjs`、`src/pages/rss.xml.ts` |

深色/浅色 = `:root` 与 `[data-theme="dark"]` 两套 CSS 变量，改色要两套都改。

## 5. Decap CMS 后台（重要上下文）

- `public/admin/`：自托管 CMS（`decap-cms.js` ~5MB 勿删、`zh_Hans.js` 中文包、`config.yml` 配置）
- **本地模式**：`npm run dev:admin` → 开 `localhost:4321/admin` 免登录直写 git 工作区（靠 decap-server 8081 代理）。decap-server 必须在 git 仓库内运行
- **线上模式**：`https://mousiji.github.io/admin` → 走 **DecapBridge** 登录（git-gateway + PKCE），任何设备可发文
  - DecapBridge 站点 ID：`128bad09-388e-4892-a189-c4d7f0d20e8b`
  - 配置全在 `public/admin/config.yml` 的 `backend` 段（base_url/auth_endpoint/gateway_url）
  - 登录态 = DecapBridge 账号 cookie（auth.decapbridge.com 域），非 GitHub OAuth
  - 维护/邀请协作者：https://decapbridge.com
- 切换登录方案 = 只改 `config.yml` 的 `backend` 段，与站点代码解耦

## 6. 部署与 CI

- `.github/workflows/deploy.yml`：push 到 `main` → 构建 `npm run build` → 部署 GitHub Pages
- 部署约需 2 分钟；验证线上生效可 curl `https://mousiji.github.io` 或查 GitHub Actions 状态
- **推送限制**：本地 git 凭据可能无 `workflow` 权限——改 `.github/workflows/` 时可能被拒，需用户在 GitHub 网页端操作或换有权限的凭据

## 7. 变更记录（新 AI 必读）

- **2026-09-08**：从旧 Gridea 静态站迁移到 Astro 卡片式博客，全部功能重建上线
- **2026-09-08（第二轮）**：接入 Decap CMS 后台（自托管）+ 草稿本地预览机制 + 写作模板草稿；站点文案定为「斯基 / 很高兴见到你=w=」
- **2026-09-08（第三轮）**：线上后台接入 DecapBridge 登录（git-gateway/PKCE），`/admin` 可在任意设备登录发文；保留本地免登录模式
- **2026-09-08（第四轮：SEO）**：加 robots.txt（指向 sitemap）、每页 canonical + OG/twitter 标签、标题统一「斯基的个人博客」、文章页 og:type=article；Bing Webmaster 已验证（meta `msvalidate.01` 在 BaseLayout），sitemap-index.xml 已提交。换域名时靠 GitHub Pages 自动 301，并改 astro.config.mjs 的 `site`
- **2026-09-09（第五轮：访问统计 + 联系图标）**：页脚接不蒜子全站访问统计（busuanzi，改 `BaseFooter.astro`，公共服务 `https://busuanzi.ibruce.info`，国内可达；数字回填前显示 `…` 占位、不阻塞布局）；「关于」页新增 GitHub / 邮箱圆形图标快捷链接（改 `src/pages/about.astro`，样式 `.contact-icons` 加在 global.css 末尾，两份已同步）
- **2026-09-09（第六轮：文章阅读量）**：文章详情页 `post-meta` 增加「阅读 … 次」（busuanzi `page_pv`，改 `src/pages/blog/[slug].astro`，复用页脚已加载的脚本，无需新增 script；仅文章页显示，首页卡片因单页加载只取到当前路径、无法逐篇显示）

## 8. 坑与约定

- `.astro/`、`node_modules/`、`dist/` 不入库
- 图片引用写绝对路径 `/images/xxx.png`，文件放 `public/images/`
- `public/styles/global.css` 与 `src/styles/global.css` 内容相同，**改 CSS 必须同步两份**（src 那份是历史遗留，仍被部分引用场景使用；实际线上生效的是 public 那份，改错会导致样式不生效或后台样式错乱）
- 深色模式评论跟随：Giscus 用 MutationObserver 监听 `data-theme` 自动同步，勿破坏
- 用户（博主）编程基础较弱：解释性回复要通俗；涉及外部账号/生产发布的操作先说明再做
