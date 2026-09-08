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
│   │   │   └── migrate-to-astro.md
│   │   └── friends/           # 🤝 友链数据（JSON）
│   │       └── gridea.json
│   └── styles/
│       └── global.css         # 全局样式（含深色/浅色主题）
├── public/
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
- 标题：`<h1>mousiji</h1>`
- 座右铭：`<p>温故而知新</p>`
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

### 快速上手命令

```bash
npm install        # 安装依赖
npm run dev        # 本地开发 http://localhost:4321
npm run build      # 构建到 dist/
npm run preview    # 预览构建结果
```