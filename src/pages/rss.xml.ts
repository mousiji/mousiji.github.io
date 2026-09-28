import rss from '@astrojs/rss';
import type { APIContext } from 'astro';
import { getPublishedPosts } from '../lib/posts';

export async function GET(context: APIContext) {
  const posts = await getPublishedPosts();

  return rss({
    title: 'mousiji 的博客',
    description: '温故而知新 - mousiji 的个人博客',
    site: context.site!,
    items: posts.map((post) => ({
      title: post.data.title,
      pubDate: post.data.pubDate,
      description: post.data.description || '',
      link: `/blog/${post.slug}/`,
    })),
    customData: `<language>zh-CN</language>`,
  });
}