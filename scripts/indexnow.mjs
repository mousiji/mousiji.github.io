const HOST = 'mousiji.github.io';
const KEY = '07fa94bbf68e17d1cef47d801f1f1c66';
const BASE = `https://${HOST}`;

async function fetchXml(url) {
  try {
    const res = await fetch(url);
    if (!res.ok) return '';
    return await res.text();
  } catch {
    return '';
  }
}

async function collectUrls() {
  const urls = new Set();
  const queue = [`${BASE}/sitemap-index.xml`, `${BASE}/sitemap-0.xml`];
  const seen = new Set();

  while (queue.length > 0) {
    const current = queue.shift();
    if (seen.has(current)) continue;
    seen.add(current);

    const xml = await fetchXml(current);
    if (!xml) continue;

    for (const match of xml.matchAll(/<loc>([^<]+)<\/loc>/g)) {
      const loc = match[1];
      if (loc.endsWith('.xml')) queue.push(loc);
      else urls.add(loc);
    }
  }

  return [...urls];
}

const urlList = await collectUrls();

if (urlList.length === 0) {
  console.log('未从 sitemap 获取到任何 URL，跳过 IndexNow 提交。');
  process.exit(0);
}

console.log(`准备向 IndexNow 提交 ${urlList.length} 个 URL：`);
urlList.forEach((u) => console.log(`  - ${u}`));

const payload = {
  host: HOST,
  key: KEY,
  keyLocation: `${BASE}/${KEY}.txt`,
  urlList,
};

const res = await fetch('https://api.indexnow.org/indexnow', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json; charset=utf-8' },
  body: JSON.stringify(payload),
});

console.log(`IndexNow 响应：HTTP ${res.status} ${res.statusText}`);

if (res.status >= 400) {
  console.error(await res.text());
  process.exit(1);
}

console.log('提交成功（200/202 均表示已被接收）。');
