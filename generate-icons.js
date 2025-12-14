import sharp from 'sharp';
import fs from 'fs';

// MoveTracker アイコン用SVG (1024x1024)
const iconSvg = `
<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg">
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
      <feDropShadow dx="0" dy="10" stdDeviation="20" flood-opacity="0.3"/>
    </filter>
  </defs>

  <rect width="1024" height="1024" rx="200" fill="url(#bg-gradient)"/>
  <circle cx="512" cy="480" r="280" fill="none" stroke="#ffffff" stroke-width="8" stroke-dasharray="30 20" opacity="0.4"/>

  <circle cx="280" cy="380" r="30" fill="#FFD700" opacity="0.9"/>
  <circle cx="744" cy="380" r="30" fill="#FFD700" opacity="0.9"/>
  <circle cx="512" cy="200" r="25" fill="#C0C0C0" opacity="0.8"/>
  <circle cx="340" cy="620" r="20" fill="#FFD700" opacity="0.7"/>
  <circle cx="684" cy="620" r="20" fill="#FFD700" opacity="0.7"/>

  <g filter="url(#shadow)">
    <path d="M512 180 C380 180 280 280 280 400 C280 520 512 750 512 750 C512 750 744 520 744 400 C744 280 644 180 512 180 Z" fill="url(#pin-gradient)"/>
    <circle cx="512" cy="400" r="120" fill="#4CAF50"/>
    <circle cx="512" cy="400" r="80" fill="#ffffff"/>
    <g transform="translate(512, 400)">
      <circle cx="0" cy="-45" r="20" fill="#4CAF50"/>
      <line x1="0" y1="-25" x2="0" y2="20" stroke="#4CAF50" stroke-width="12" stroke-linecap="round"/>
      <line x1="-30" y1="-5" x2="30" y2="5" stroke="#4CAF50" stroke-width="10" stroke-linecap="round"/>
      <line x1="0" y1="20" x2="-25" y2="55" stroke="#4CAF50" stroke-width="10" stroke-linecap="round"/>
      <line x1="0" y1="20" x2="25" y2="50" stroke="#4CAF50" stroke-width="10" stroke-linecap="round"/>
    </g>
  </g>

  <text x="512" y="920" font-family="Arial, sans-serif" font-size="100" font-weight="bold" fill="#ffffff" text-anchor="middle" opacity="0.95">MOVE</text>
</svg>
`;

// Adaptive icon foreground (背景なし)
const iconForegroundSvg = `
<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="pin-fg" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#e0e0e0;stop-opacity:1" />
    </linearGradient>
  </defs>

  <circle cx="300" cy="340" r="26" fill="#FFD700" opacity="0.9"/>
  <circle cx="724" cy="340" r="26" fill="#FFD700" opacity="0.9"/>
  <circle cx="512" cy="190" r="20" fill="#C0C0C0" opacity="0.8"/>

  <path d="M512 220 C400 220 320 300 320 400 C320 500 512 700 512 700 C512 700 704 500 704 400 C704 300 624 220 512 220 Z" fill="url(#pin-fg)"/>
  <circle cx="512" cy="400" r="100" fill="#4CAF50"/>
  <circle cx="512" cy="400" r="68" fill="#ffffff"/>

  <g transform="translate(512, 400)">
    <circle cx="0" cy="-38" r="16" fill="#4CAF50"/>
    <line x1="0" y1="-22" x2="0" y2="16" stroke="#4CAF50" stroke-width="10" stroke-linecap="round"/>
    <line x1="-24" y1="-3" x2="24" y2="3" stroke="#4CAF50" stroke-width="8" stroke-linecap="round"/>
    <line x1="0" y1="16" x2="-20" y2="45" stroke="#4CAF50" stroke-width="8" stroke-linecap="round"/>
    <line x1="0" y1="16" x2="20" y2="40" stroke="#4CAF50" stroke-width="8" stroke-linecap="round"/>
  </g>

  <text x="512" y="850" font-family="Arial, sans-serif" font-size="80" font-weight="bold" fill="#333333" text-anchor="middle">MOVE</text>
</svg>
`;

// スプラッシュスクリーン用SVG
const splashSvg = `
<svg width="2732" height="2732" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="splash-bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#4CAF50;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#2196F3;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#3F51B5;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="splash-pin" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#e0e0e0;stop-opacity:1" />
    </linearGradient>
    <filter id="splash-shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="15" stdDeviation="30" flood-opacity="0.3"/>
    </filter>
  </defs>

  <rect width="2732" height="2732" fill="url(#splash-bg)"/>
  <circle cx="1366" cy="1200" r="450" fill="none" stroke="#ffffff" stroke-width="12" stroke-dasharray="40 25" opacity="0.3"/>

  <circle cx="916" cy="950" r="40" fill="#FFD700" opacity="0.8"/>
  <circle cx="1816" cy="950" r="40" fill="#FFD700" opacity="0.8"/>
  <circle cx="1366" cy="750" r="35" fill="#C0C0C0" opacity="0.7"/>
  <circle cx="1000" cy="1450" r="30" fill="#FFD700" opacity="0.6"/>
  <circle cx="1732" cy="1450" r="30" fill="#FFD700" opacity="0.6"/>

  <g filter="url(#splash-shadow)">
    <path d="M1366 700 C1150 700 1000 850 1000 1050 C1000 1250 1366 1600 1366 1600 C1366 1600 1732 1250 1732 1050 C1732 850 1582 700 1366 700 Z" fill="url(#splash-pin)"/>
    <circle cx="1366" cy="1050" r="180" fill="#4CAF50"/>
    <circle cx="1366" cy="1050" r="120" fill="#ffffff"/>
    <g transform="translate(1366, 1050)">
      <circle cx="0" cy="-65" r="30" fill="#4CAF50"/>
      <line x1="0" y1="-35" x2="0" y2="30" stroke="#4CAF50" stroke-width="18" stroke-linecap="round"/>
      <line x1="-45" y1="-5" x2="45" y2="10" stroke="#4CAF50" stroke-width="14" stroke-linecap="round"/>
      <line x1="0" y1="30" x2="-35" y2="85" stroke="#4CAF50" stroke-width="14" stroke-linecap="round"/>
      <line x1="0" y1="30" x2="35" y2="75" stroke="#4CAF50" stroke-width="14" stroke-linecap="round"/>
    </g>
  </g>

  <text x="1366" y="2050" font-family="Arial, sans-serif" font-size="200" font-weight="bold" fill="#ffffff" text-anchor="middle" letter-spacing="15">MoveTracker</text>
  <text x="1366" y="2200" font-family="Arial, sans-serif" font-size="70" fill="#ffffff" text-anchor="middle" opacity="0.8">Track your movement, collect dots, earn points!</text>
</svg>
`;

if (!fs.existsSync('resources')) {
  fs.mkdirSync('resources');
}

console.log('MoveTracker アセット生成開始...\n');

await sharp(Buffer.from(iconSvg)).resize(1024, 1024).png().toFile('resources/icon.png');
console.log('✓ resources/icon.png (1024x1024)');

await sharp(Buffer.from(iconSvg)).resize(512, 512).png().toFile('resources/icon-512.png');
console.log('✓ resources/icon-512.png (512x512)');

await sharp(Buffer.from(iconForegroundSvg)).resize(1024, 1024).png().toFile('resources/icon-foreground.png');
console.log('✓ resources/icon-foreground.png (1024x1024)');

await sharp(Buffer.from(splashSvg)).resize(2732, 2732).png().toFile('resources/splash.png');
console.log('✓ resources/splash.png (2732x2732)');

console.log('\n完了！');
