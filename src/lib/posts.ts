import { getCollection } from 'astro:content';

/**
 * 获取「应该展示」的文章集合，并按发布时间倒序排列。
 *
 * 草稿规则（draft）：`draft: true` 的文章只在本地 `npm run dev` 里出现，
 * 生产构建会自动排除（线上 404）。
 *
 * 以前这条过滤规则在 7 个页面里各抄了一遍，现在统一收口到这里：
 * 想改草稿规则（例如以后加「定时发布」）只需要改这一个文件。
 */
export async function getPublishedPosts() {
  const posts = await getCollection('blog', ({ data }) => import.meta.env.DEV || !data.draft);
  posts.sort((a, b) => b.data.pubDate.getTime() - a.data.pubDate.getTime());
  return posts;
}
