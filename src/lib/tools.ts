/**
 * 工具区注册表：新增工具时在这里加一条，并新建 `src/pages/tools/<slug>.astro` 页面即可。
 */
export interface ToolInfo {
  slug: string;
  name: string;
  icon: string;
  desc: string;
}

export const tools: ToolInfo[] = [
  {
    slug: 'timezones',
    name: '时区速查',
    icon: '🌍',
    desc: '北京时间对照全球主要市场当地时间，自动判断对方是否在工作时间，跨时区沟通前看一眼。',
  },
];
