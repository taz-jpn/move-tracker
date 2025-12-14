import sharp from 'sharp';

// Feature graphic: 1024x500px
const width = 1024;
const height = 500;

console.log('Feature graphicを生成中...');

// スクリーンショット1と3を読み込んで並べる
const screenshot1 = await sharp('docs/screenshots/1-main-kmh-light.png')
  .resize(null, height) // 高さを500pxに合わせる
  .toBuffer();

const screenshot3 = await sharp('docs/screenshots/3-seven-segment.png')
  .resize(null, height) // 高さを500pxに合わせる
  .toBuffer();

// 各スクリーンショットのメタデータを取得
const meta1 = await sharp(screenshot1).metadata();
const meta3 = await sharp(screenshot3).metadata();

// スクリーンショットの幅を計算（アスペクト比を維持）
const ss1Width = Math.round(meta1.width);
const ss3Width = Math.round(meta3.width);

// 2つのスクリーンショットを中央に配置するための計算
const totalSSWidth = ss1Width + ss3Width;
const spacing = 40; // 2つの画像の間隔
const totalWidth = totalSSWidth + spacing;
const startX = Math.round((width - totalWidth) / 2);

// グラデーション背景を作成
const backgroundSvg = `
<svg width="${width}" height="${height}" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bg-gradient" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:#1a1a1a;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#2a2a2a;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#1a1a1a;stop-opacity:1" />
    </linearGradient>
    <radialGradient id="glow-left" cx="25%" cy="50%" r="50%">
      <stop offset="0%" style="stop-color:#00ff88;stop-opacity:0.2" />
      <stop offset="100%" style="stop-color:#00ff88;stop-opacity:0" />
    </radialGradient>
    <radialGradient id="glow-right" cx="75%" cy="50%" r="50%">
      <stop offset="0%" style="stop-color:#0088ff;stop-opacity:0.2" />
      <stop offset="100%" style="stop-color:#0088ff;stop-opacity:0" />
    </radialGradient>
  </defs>

  <!-- 背景 -->
  <rect width="${width}" height="${height}" fill="url(#bg-gradient)"/>

  <!-- グロー効果 -->
  <ellipse cx="${width * 0.25}" cy="${height * 0.5}" rx="300" ry="200" fill="url(#glow-left)"/>
  <ellipse cx="${width * 0.75}" cy="${height * 0.5}" rx="300" ry="200" fill="url(#glow-right)"/>
</svg>
`;

const background = await sharp(Buffer.from(backgroundSvg))
  .resize(width, height)
  .toBuffer();

// スクリーンショットを背景に合成
await sharp(background)
  .composite([
    {
      input: screenshot1,
      left: startX,
      top: 0
    },
    {
      input: screenshot3,
      left: startX + ss1Width + spacing,
      top: 0
    }
  ])
  .png()
  .toFile('resources/feature-graphic.png');

console.log('✓ Feature graphic生成完了: resources/feature-graphic.png');
console.log(`  サイズ: ${width}x${height}px`);
console.log(`  スクリーンショット1: ${ss1Width}x${height}px`);
console.log(`  スクリーンショット3: ${ss3Width}x${height}px`);
console.log(`  間隔: ${spacing}px`);
