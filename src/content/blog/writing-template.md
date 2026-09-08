---
title: "✍️ 写作模板与 Markdown 语法速查"
description: "新文章写作参考：frontmatter 各字段说明 + 常用 Markdown 语法演示，复制到本地预览即可对照渲染效果。"
pubDate: 2026-09-08
tags: ["写作", "Markdown"]
draft: true
---

> ⚠️ 这是一篇 **草稿**（`draft: true`），只会在本地预览出现，不会发布到线上。
> 写作时**复制本文件**，改文件名（`文件名.md` = 网址的 slug），改掉 frontmatter，正文可保留本页作为语法对照，也可以全部删掉重写。

---

## 一、frontmatter 模板（每篇文章开头的 `---` 之间）

```yaml
---
title: "文章标题"
description: "摘要，显示在首页/博客列表的卡片上"
pubDate: 2026-09-08        # 发布日期 YYYY-MM-DD
updatedDate: 2026-09-09    # 可选：更新日期
heroImage: "/images/xxx.jpg"  # 可选：封面图，放 public/images/ 下
tags: ["标签A", "标签B"]       # 可选：标签（用于标签页）
draft: false                   # true=草稿不发布；false=发布
---
```

| frontmatter 字段 | 必填 | 说明 |
|---|---|---|
| `title` | ✅ | 文章标题 |
| `description` | 推荐 | 卡片摘要（空则显示占位） |
| `pubDate` | ✅ | 发布日期，格式 `YYYY-MM-DD` |
| `updatedDate` | 选 | 有内容更新时补写 |
| `heroImage` | 选 | 封面图路径，图片放在 `public/images/` |
| `tags` | 选 | 标签数组，会自动出现在「标签」页 |
| `draft` | 选 | `true` = 草稿，只本地可见 |

---

## 二、Markdown 语法演示

### 1. 标题
# 一级标题（H1，一般不用于正文）
## 二级标题（H2）
### 三级标题（H3）
#### 四级标题（H4）
##### 五级标题（H5）
###### 六级标题（H6）

### 2. 强调
**加粗**　*斜体*　***粗斜体***　~~删除线~~　`行内代码`

### 3. 引用
> 这是一段引用。
> 引用里可以**加粗**，也可以放列表：
> - 条目一
> - 条目二

### 4. 列表

无序列表：
- 苹果
- 香蕉
- 橙子
  - 嵌套子项

有序列表：
1. 第一步
2. 第二步
3. 第三步

任务列表：
- [x] 已完成
- [ ] 待办

### 5. 链接
[点击访问 mousiji 的博客](https://mousiji.github.io)

### 6. 图片
![替代文字描述](/images/avatar.png "头像")

### 7. 代码块
```js
// JavaScript 示例
function greet(name) {
  return `你好，${name}！`;
}
console.log(greet("世界"));
```

```python
# Python 示例
def greet(name):
    return f"你好，{name}！"
print(greet("世界"))
```

```css
/* CSS 示例 */
.blog-card {
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}
```

```html
<!-- HTML 示例 -->
<div class="box">Hello</div>
```

### 8. 表格
| 品牌 | 国家 | 状态 |
| :--- | :---: | ---: |
| SU | US | ✅ |
| EO | CA | ✅ |
| HQL | US | ⏳ |

### 9. 分割线
---

### 10. 表情与特殊符号
直接粘贴 emoji 即可：🎉 ✍️ 🚀 💡 ⚠️ ✅

### 11. 注释（读者看不到）
<!-- 这是一条注释，不会显示在页面上 -->

---

## 三、发布前检查清单

- [ ] `draft` 已改为 `false`（或删除该行，默认即发布）
- [ ] `description` 已填写
- [ ] 图片路径正确（以 `/images/` 开头）
- [ ] 标签已归档到「标签」页
- [ ] 本地 `npm run dev` 预览渲染正常
