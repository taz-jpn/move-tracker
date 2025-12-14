import sharp from 'sharp';
import fs from 'fs';

// アイコン用SVG (1024x1024)
const iconSvg = `
<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg">
  <!-- グラデーション背景 -->
  <defs>
    <radialGradient id="bg-gradient" cx="50%" cy="50%" r="50%">
      <stop offset="0%" style="stop-color:#2a2a2a;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#1a1a1a;stop-opacity:1" />
    </radialGradient>
    <linearGradient id="meter-gradient" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#00ff88;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#0088ff;stop-opacity:1" />
    </linearGradient>
  </defs>

  <!-- 背景 -->
  <rect width="1024" height="1024" rx="180" fill="url(#bg-gradient)"/>

  <!-- メーター外枠 -->
  <circle cx="512" cy="512" r="400" fill="none" stroke="url(#meter-gradient)" stroke-width="20"/>
  <circle cx="512" cy="512" r="380" fill="none" stroke="#0088ff" stroke-width="5" opacity="0.5"/>

  <!-- 目盛り -->
  <g transform="translate(512, 512)">
    <!-- 0° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#ffffff" stroke-width="8" transform="rotate(150)"/>
    <!-- 20° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#ffffff" stroke-width="8" transform="rotate(170)"/>
    <!-- 40° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#ffffff" stroke-width="8" transform="rotate(190)"/>
    <!-- 60° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#00ff88" stroke-width="10" transform="rotate(210)"/>
    <!-- 80° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#ffffff" stroke-width="8" transform="rotate(230)"/>
    <!-- 100° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#ffffff" stroke-width="8" transform="rotate(250)"/>
    <!-- 120° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#ffffff" stroke-width="8" transform="rotate(270)"/>
    <!-- 140° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#ffffff" stroke-width="8" transform="rotate(290)"/>
    <!-- 160° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#ffffff" stroke-width="8" transform="rotate(310)"/>
    <!-- 180° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#ffffff" stroke-width="8" transform="rotate(330)"/>
    <!-- 200° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#ffffff" stroke-width="8" transform="rotate(350)"/>
    <!-- 220° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#ffffff" stroke-width="8" transform="rotate(10)"/>
    <!-- 240° -->
    <line x1="0" y1="-360" x2="0" y2="-320" stroke="#ffffff" stroke-width="8" transform="rotate(30)"/>

    <!-- 針 (60°の位置を指す) -->
    <line x1="0" y1="0" x2="0" y2="-320" stroke="#ff3366" stroke-width="15" transform="rotate(210)" stroke-linecap="round"/>
  </g>

  <!-- 中心の円 -->
  <circle cx="512" cy="512" r="30" fill="#ff3366"/>
  <circle cx="512" cy="512" r="20" fill="#1a1a1a"/>

  <!-- テキスト -->
  <text x="512" y="720" font-family="Arial, sans-serif" font-size="80" font-weight="bold" fill="#ffffff" text-anchor="middle">SPEED</text>
</svg>
`;

// スプラッシュスクリーン用SVG (2732x2732)
const splashSvg = `
<svg width="2732" height="2732" xmlns="http://www.w3.org/2000/svg">
  <!-- グラデーション背景 -->
  <defs>
    <linearGradient id="splash-gradient" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#1a1a1a;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#2a2a2a;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#1a1a1a;stop-opacity:1" />
    </linearGradient>
    <radialGradient id="glow" cx="50%" cy="45%" r="40%">
      <stop offset="0%" style="stop-color:#00ff88;stop-opacity:0.3" />
      <stop offset="100%" style="stop-color:#0088ff;stop-opacity:0" />
    </radialGradient>
  </defs>

  <!-- 背景 -->
  <rect width="2732" height="2732" fill="url(#splash-gradient)"/>

  <!-- グロー効果 -->
  <ellipse cx="1366" cy="1200" rx="800" ry="600" fill="url(#glow)"/>

  <!-- メインメーター -->
  <g transform="translate(1366, 1366)">
    <!-- 外枠 -->
    <circle r="600" fill="none" stroke="#00ff88" stroke-width="30" opacity="0.8"/>
    <circle r="570" fill="none" stroke="#0088ff" stroke-width="8" opacity="0.6"/>

    <!-- 目盛り (12個) -->
    <g opacity="0.9">
      ${Array.from({ length: 13 }, (_, i) => {
        const angle = i * 20 + 150;
        const isMain = i % 3 === 0;
        return `<line x1="0" y1="-550" x2="0" y2="${isMain ? -480 : -500}"
                      stroke="${isMain ? '#00ff88' : '#ffffff'}"
                      stroke-width="${isMain ? 12 : 8}"
                      transform="rotate(${angle})"
                      stroke-linecap="round"/>`;
      }).join('\n      ')}
    </g>

    <!-- 針 -->
    <line x1="0" y1="0" x2="0" y2="-480"
          stroke="#ff3366" stroke-width="20"
          transform="rotate(210)"
          stroke-linecap="round"/>

    <!-- 中心 -->
    <circle r="50" fill="#ff3366"/>
    <circle r="35" fill="#2a2a2a"/>
  </g>

  <!-- アプリ名 -->
  <text x="1366" y="2200"
        font-family="Arial, sans-serif"
        font-size="160"
        font-weight="bold"
        fill="#ffffff"
        text-anchor="middle"
        letter-spacing="10">SPEED METER</text>

  <!-- サブテキスト -->
  <text x="1366" y="2350"
        font-family="Arial, sans-serif"
        font-size="60"
        fill="#00ff88"
        text-anchor="middle"
        opacity="0.8">GPS Speedometer</text>
</svg>
`;

// アイコン生成
console.log('アイコンを生成中...');
await sharp(Buffer.from(iconSvg))
  .resize(1024, 1024)
  .png()
  .toFile('resources/icon.png');

console.log('✓ アイコン生成完了: resources/icon.png');

// 512x512アイコン生成（Google Play用）
console.log('512x512アイコンを生成中...');
await sharp(Buffer.from(iconSvg))
  .resize(512, 512)
  .png()
  .toFile('resources/icon-512.png');

console.log('✓ 512x512アイコン生成完了: resources/icon-512.png');

// スプラッシュスクリーン生成
console.log('スプラッシュスクリーンを生成中...');
await sharp(Buffer.from(splashSvg))
  .resize(2732, 2732)
  .png()
  .toFile('resources/splash.png');

console.log('✓ スプラッシュスクリーン生成完了: resources/splash.png');

console.log('\n画像生成が完了しました！');
console.log('次のステップ: npx @capacitor/assets generate を実行してください');
