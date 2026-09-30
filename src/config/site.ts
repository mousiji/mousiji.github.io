/**
 * 站点级配置（收口这些「填个码就能生效」的开关，避免到处翻文件）
 */

/**
 * 百度站长验证验证码。
 * - 获取：https://ziyuan.baidu.com → 站点管理 → 添加 https://moskie.vip → 选「HTML 标签验证」→ 复制 content 的值
 * - 填入后重新构建/推送即生效；留空字符串则页面不输出该 meta（当前状态）。
 * - 备选：选「文件验证」的话，把百度给的 .html 文件放进 public/ 就行，此处保持为空。
 */
export const BAIDU_VERIFICATION = '';
