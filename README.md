# mousiji 的个人博客

> 温故而知新

基于 **Astro** 构建的卡片式个人博客，托管于 **GitHub Pages**。

## 快速导航

- 线上地址：https://mousiji.github.io
- 技术栈：Astro 5 + TypeScript + CSS
- 评论系统：Giscus（基于 GitHub Discussions）
- 部署方式：GitHub Actions 自动部署

---

## 📁 项目结构

```
astro-blog/
├── src/
│   ├── components/          # 可复用组件
│   │   ├── BaseHeader.astro   # 导航栏（含深色模式切换）
│   │   ├── BaseFooter.astro   # 页脚
│   │   └── Giscus.astro       # Giscus 评论区
│   ├── layouts/
│   │   └── BaseLayout.astro   # 全局布局模板
│   ├── pages/               # 路由页面
│   │   ├── index.astro        # 首页
│   │   ├── about.astro        # 关于页面
│   │   ├── friends.astro      # 友链页面
│   │   ├── 404.astro          # 404 页面
│   │   ├── blog/
│   │   │   ├── index.astro    # 博客列表页
│   │   │   └── [slug].astro   # 文章详情页
│   │   ├── tags/
│   │   │   ├── index.astro    # 标签总览页
│   │   │   └── [tag].astro    # 标签筛选页
│   │   └── rss.xml.ts         # RSS 订阅
│   ├── content/
│   │   ├── config.ts          # 内容类型定义
│   │   ├── blog/              # 📝 文章（Markdown）
│   │   │   ├── hello-gridea.md
│   │   │   ├── migrate-to-astro.md
│   │   │   └── writing-template.md  # ✍️ 写作模板草稿（draft:true，不发布，可复制改写）
│   │   └── friends/           # 🤝 友链数据（JSON）
│   │       └── gridea.json
│   └── styles/
│       └── global.css         # 全局样式（含深色/浅色主题）
├── public/
│   ├── admin/                 # 🖥️ Decap CMS 网页后台（本地自托管，不依赖 CDN）
│   │   ├── index.html           # 后台入口页面
│   │   ├── config.yml           # 后台配置（集合/字段/后端）
│   │   ├── decap-cms.js         # Decap CMS 核心（约 5MB 自托管文件）
│   │   └── zh_Hans.js           # 简体中文界面语言包
│   ├── images/                # 图片资源
│   │   ├── avatar.png
│   │   └── hello-gridea.png
│   ├── styles/
│   │   └── global.css
│   └── favicon.ico
├── .github/workflows/
│   └── deploy.yml             # GitHub Actions 自动部署配置
├── astro.config.mjs           # Astro 配置
├── package.json
└── README.md                  # 本文档 - 项目维护指南
```

---

## 📝 如何写新文章

在 `src/content/blog/` 目录下创建 `.md` 文件，文件名为 URL 中的 slug（例如 `my-new-post.md`）。

**文章模板：**

```markdown
---
title: "文章标题"
description: "文章摘要，会显示在卡片上"
pubDate: 2026-09-08
tags: ["标签1", "标签2"]
heroImage: "/images/xxx.jpg"    # 可选，封面图路径
draft: false                    # true 则不发布
---

这里是文章正文，支持 Markdown 语法。
```

**添加封面图：** 将图片放到 `public/images/` 目录下，`heroImage` 字段写 `/images/xxx.jpg`。

> ✍️ **写作模板**：仓库里自带一篇草稿 `src/content/blog/writing-template.md`，包含 frontmatter 字段说明 + 常用 Markdown 语法演示。复制该文件改名即可开始写作（本地 `npm run dev` 后访问 `/blog/writing-template/` 可看到渲染效果）。

> 🎨 **草稿机制（draft）**：`draft: true` 的文章只在本地预览出现（卡片带黄色「草稿」角标），**不会**进入线上首页/列表/RSS，也不会生成线上页面。把 `draft` 改为 `false` 或删除该行后才发布。

---

## 🖥️ Decap CMS 网页后台

项目内置 **Decap CMS**（前身 Netlify CMS），可以通过网页可视化编辑文章和友链，改动直接提交到 GitHub 仓库。

### 后台地址

| 环境 | 地址 | 登录方式 |
|---|---|---|
| 本地开发 | `http://localhost:4321/admin` | 免登录，直接编辑本地仓库 |
| 线上 | `https://mousiji.github.io/admin` | DecapBridge 账号（需受邀/注册） |

### 本地使用（免登录，推荐日常写作用）

```bash
npm install          # 首次运行安装依赖
npm run dev:admin    # 同时启动博客(4321) + CMS 本地代理(8081)
```

然后浏览器打开 `http://localhost:4321/admin`，即可直接编辑文章/友链——本地代理会把改动写入当前 Git 仓库工作区，**无需登录**。写完 `git push origin main` 即发布。

> 说明：`decap-server`（本地代理）必须在 Git 仓库内运行，这就是本项目 `astro-blog/` 目录本身是 Git 工作副本的原因。

### 文章支持的字段（与后台表单一一对应）

```yaml
---
title: "文章标题"
description: "摘要"
pubDate: 2026-09-08
tags: ["标签"]
heroImage: "/images/xxx.jpg"   # 后台可上传图片
draft: false                   # 后台有「草稿」开关
---
```

后台还提供 **友链** 集合（`src/content/friends/` 下 JSON），可增删改友链卡片。

### 线上后台（已接入 DecapBridge 登录）

线上 `/admin` 通过 **DecapBridge**（托管认证网关）登录，后端为 `git-gateway` + PKCE，手机/任何设备打开 `https://mousiji.github.io/admin` 即可发文，无需本地电脑。配置位于 `public/admin/config.yml` 的 `backend` 段（`base_url` / `auth_endpoint` / `gateway_url` 指向 decapbridge.com）。

- 站点 ID：`128bad09-388e-4892-a189-c4d7f0d20e8b`（在 decapbridge.com 后台可查）
- 登录入口：DecapBridge 自己的账号体系（支持邮箱密码 / Google / Microsoft），**不是 GitHub 授权页**
- 每次提交会带上操作者信息（见 `commit_messages`），方便追溯
- 维护入口：https://decapbridge.com → 该站点 → 可邀请/移除协作者、查看使用情况
- 若服务不可用/想改回自建 OAuth：替换 `backend` 段为自建网关配置即可（`name: github` + `base_url`）

> 注意：`local_backend: true` 仅在浏览器地址为 `localhost` 时生效（配合 `decap-server` 本地免登录）；线上访问时自动走 DecapBridge 登录，两者互不影响。

---

## 🤝 如何添加友链

在 `src/content/friends/` 目录下创建 `.json` 文件：

```json
{
  "name": "网站名称",
  "url": "https://example.com",
  "avatar": "https://example.com/avatar.png",
  "description": "一句话描述"
}
```

`avatar` 为可选字段，不填则默认显示博客头像。

---

## 🎨 主题定制

### 颜色主题

所有颜色变量定义在 `src/styles/global.css` 的 `:root`（浅色）和 `[data-theme="dark"]`（深色）中：

| 变量 | 作用 |
|---|---|
| `--bg-primary` | 页面背景色 |
| `--bg-card` | 卡片背景色 |
| `--text-primary` | 主文字色 |
| `--text-secondary` | 辅助文字色 |
| `--accent` | 主题色（绿色系） |
| `--accent-hover` | 主题色悬停态 |
| `--border-color` | 边框色 |
| `--tag-bg` | 标签背景色 |
| `--shadow` / `--shadow-hover` | 卡片阴影 |

### 修改主题色

把 `--accent` 和 `--accent-hover` 的值改成你喜欢的颜色即可。例如换蓝色：

```css
--accent: #378ADD;
--accent-hover: #185FA5;
```

### 修改首页信息

在 `src/pages/index.astro` 中修改：
- 标题：`<h1>斯基</h1>`
- 签名：`<p>很高兴见到你=w=</p>`
- 头像：替换 `public/images/avatar.png`

在 `src/pages/about.astro` 中修改关于页面内容。

---

## 🚀 部署流程

### 自动部署（推荐）

代码推送到 GitHub 的 `main` 分支后，GitHub Actions 会自动构建并部署。

```bash
git add .
git commit -m "更新内容"
git push origin main
```

等待约 2 分钟后，访问 https://mousiji.github.io 即可看到更新。

### 手动部署

```bash
npm run build    # 生成 dist/ 目录
```

`dist/` 目录下的内容就是完整的静态站点，可以直接部署到任何静态托管服务。

---

## ⚙️ 配置说明

### Astro 配置

`astro.config.mjs` 中的关键配置：

```js
site: 'https://mousiji.github.io',  // 站点 URL
```

### Giscus 评论

`src/components/Giscus.astro` 中的配置：

```js
data-repo: 'mousiji/mousiji.github.io'
data-repo-id: 'R_kgDOIrvofQ'
data-category: 'General'
data-category-id: 'DIC_kwDOIrvofc4DFHla'
```

### RSS 订阅

`src/pages/rss.xml.ts` 中配置站点标题、描述等信息。

---

## 💻 本地开发

```bash
# 安装依赖（首次运行）
npm install

# 启动开发服务器
npm run dev
# 访问 http://localhost:4321

# 构建生产版本
npm run build

# 预览构建结果
npm run preview
```

---

## 🔧 技术栈

| 技术 | 用途 |
|---|---|
| [Astro](https://astro.build) | 静态站点框架 |
| TypeScript | 类型安全 |
| CSS Custom Properties | 主题系统（深色/浅色） |
| Giscus | 评论系统（基于 GitHub Discussions） |
| GitHub Actions | CI/CD 自动部署 |
| GitHub Pages | 静态托管 |

---

## 📋 维护检查清单

- [ ] 写新文章 → `src/content/blog/` 下加 `.md` 文件
- [ ] 加友链 → `src/content/friends/` 下加 `.json` 文件
- [ ] 换头像 → 替换 `public/images/avatar.png`
- [ ] 改主题色 → 修改 `src/styles/global.css` 中的 `--accent`
- [ ] 更新关于页 → 修改 `src/pages/about.astro`
- [ ] 部署 → `git push` 到 GitHub main 分支

---

## 🤖 AI 接手须知

> 以下内容专为 AI 模型/新设备接手时设计，包含项目关键上下文。

### 项目快照

| 项目 | 详情 |
|---|---|
| 仓库 | `mousiji/mousiji.github.io` |
| 线上地址 | https://mousiji.github.io |
| 框架 | Astro 5 |
| 部署方式 | GitHub Actions → GitHub Pages（push 到 main 分支自动构建） |
| 评论系统 | Giscus（GitHub Discussions） |

### 代码改动记录

- **2026-09-08（第二轮：CMS + 草稿预览）**
  - 新增：Decap CMS 网页后台（`public/admin/`，自托管核心与中文包，不依赖 CDN）
  - 新增：本地 CMS 代理命令 `npm run dev:admin`（并行启动 `astro dev` + `decap-server`）
  - 新增：草稿本地预览——开发环境显示 `draft: true` 文章（带「草稿」角标与横幅），生产构建自动排除
  - 新增：写作模板草稿 `src/content/blog/writing-template.md`（frontmatter 说明 + Markdown 语法速查）
  - 调整：文章 schema 日期字段改用 `z.coerce.date()`，兼容 CMS 写入的字符串日期
  - 变更：站点名/文案已由线上改为「斯基的个人博客 / 很高兴见到你=w=」
- **2026-09-08**：从 Gridea 迁移到 Astro，卡片式布局上线
  - 新增：深色/浅色模式切换
  - 新增：Giscus 评论区（repo-id: `R_kgDOIrvofQ`, category: `General`, category-id: `DIC_kwDOIrvofc4DFHla`）
  - 新增：友链系统（`src/content/friends/` 下 JSON 文件）
  - 新增：标签系统（自动汇总文章标签）
  - 新增：RSS 订阅
  - 迁移：保留旧文章《Hello Gridea》和头像
  - 新增：第一篇迁移记录文章《博客迁移记：从 Gridea 到 Astro》

### 注意事项

- `.astro/` 目录是 Astro 的缓存目录，不要提交到 Git
- 图片资源放在 `public/images/` 下，引用路径写 `/images/xxx.png`
- 修改主题色需同时改 `:root`（浅色）和 `[data-theme="dark"]`（深色）两套变量
- 评论区的深色模式跟随通过 MutationObserver 监听 `data-theme` 属性变化自动同步
- `public/admin/decap-cms.js` 是自托管的 CMS 核心文件（约 5MB），**不要删除**；升级 CMS 时用官方构建替换它
- Decap CMS 的 `local_backend` 依赖 Git 仓库：本地 CMS 会把文章改动写进工作区并可通过 `git push origin main` 发布
- 线上 `/admin` 若要免本地可用，需额外配置 OAuth 网关（见上文「线上后台」）

### 快速上手命令

```bash
npm install           # 安装依赖
npm run dev           # 本地开发 http://localhost:4321（不含 CMS 代理）
npm run dev:admin     # 本地开发 + CMS 后台代理（http://localhost:4321/admin）
npm run build         # 构建到 dist/
npm run preview       # 预览构建结果
```