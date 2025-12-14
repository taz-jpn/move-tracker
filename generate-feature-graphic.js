import sharp from 'sharp';

// Feature Graphic: 1024x500px
const width = 1024;
const height = 500;

const featureGraphicSvg = `
<svg width="${width}" height="${height}" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bg-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#4CAF50;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#2196F3;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#3F51B5;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="pin-gradient" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#e0e0e0;stop-opacity:1" />
    </linearGradient>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="4" stdDeviation="8" flood-opacity="0.3"/>
    </filter>
  </defs>

  <!-- 背景 -->
  <rect width="${width}" height="${height}" fill="url(#bg-gradient)"/>

  <!-- 点線の軌跡 -->
  <path d="M 100 400 Q 300 100 500 250 T 900 150"
        fill="none" stroke="#ffffff" stroke-width="4"
        stroke-dasharray="15 10" opacity="0.4"/>

  <!-- 収集ドット -->
  <circle cx="200" cy="320" r="18" fill="#FFD700" opacity="0.9"/>
  <circle cx="380" cy="180" r="14" fill="#C0C0C0" opacity="0.8"/>
  <circle cx="600" cy="280" r="18" fill="#FFD700" opacity="0.9"/>
  <circle cx="800" cy="160" r="14" fill="#FFD700" opacity="0.8"/>

  <!-- 位置マーカー（左側） -->
  <g transform="translate(150, 180)" filter="url(#shadow)">
    <path d="M0 -60 C-40 -60 -60 -30 -60 10 C-60 50 0 100 0 100 C0 100 60 50 60 10 C60 -30 40 -60 0 -60 Z"
          fill="url(#pin-gradient)"/>
    <circle cx="0" cy="5" r="28" fill="#4CAF50"/>
    <circle cx="0" cy="5" r="18" fill="#ffffff"/>
    <!-- 歩く人 -->
    <g transform="translate(0, 5)">
      <circle cx="0" cy="-10" r="5" fill="#4CAF50"/>
      <line x1="0" y1="-5" x2="0" y2="5" stroke="#4CAF50" stroke-width="3" stroke-linecap="round"/>
      <line x1="-7" y1="-1" x2="7" y2="1" stroke="#4CAF50" stroke-width="2.5" stroke-linecap="round"/>
      <line x1="0" y1="5" x2="-5" y2="13" stroke="#4CAF50" stroke-width="2.5" stroke-linecap="round"/>
      <line x1="0" y1="5" x2="5" y2="12" stroke="#4CAF50" stroke-width="2.5" stroke-linecap="round"/>
    </g>
  </g>

  <!-- アプリ名 -->
  <text x="520" y="220"
        font-family="Arial, sans-serif"
        font-size="72"
        font-weight="bold"
        fill="#ffffff"
        text-anchor="middle">MoveTracker</text>

  <!-- サブテキスト -->
  <text x="520" y="280"
        font-family="Arial, sans-serif"
        font-size="24"
        fill="#ffffff"
        text-anchor="middle"
        opacity="0.9">Track your movement, collect dots, earn points!</text>

  <!-- アイコン表示（右側） -->
  <g transform="translate(850, 350)">
    <circle r="50" fill="rgba(255,255,255,0.2)"/>
    <text x="0" y="8"
          font-family="Arial, sans-serif"
          font-size="24"
          font-weight="bold"
          fill="#ffffff"
          text-anchor="middle">3x</text>
    <text x="0" y="28"
          font-family="Arial, sans-serif"
          font-size="12"
          fill="#ffffff"
          text-anchor="middle"
          opacity="0.8">WALKING</text>
  </g>

  <!-- スコアバッジ -->
  <g transform="translate(750, 380)">
    <circle r="35" fill="rgba(255,255,255,0.2)"/>
    <text x="0" y="5"
          font-family="Arial, sans-serif"
          font-size="18"
          font-weight="bold"
          fill="#FFD700"
          text-anchor="middle">+10</text>
    <text x="0" y="20"
          font-family="Arial, sans-serif"
          font-size="10"
          fill="#ffffff"
          text-anchor="middle"
          opacity="0.8">pts</text>
  </g>
</svg>
`;

console.log('Feature Graphic を生成中...');

await sharp(Buffer.from(featureGraphicSvg))
  .resize(width, height)
  .png()
  .toFile('resources/feature-graphic.png');

console.log('✓ resources/feature-graphic.png (1024x500)');
console.log('\n完了！');
