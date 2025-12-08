# MoveTracker - 移動記録＆スコアリングアプリ

## プロジェクト概要
GPSで移動を記録し、移動手段（徒歩/自転車/車）ごとにスコア化するFlutterモバイルアプリ。

## 技術スタック
- **フレームワーク**: Flutter 3.x / Dart 3.x
- **状態管理**: Riverpod
- **地図**: flutter_map + OpenStreetMap
- **位置情報**: geolocator
- **データベース**: SQLite (sqflite)
- **ルーティング**: go_router

## ディレクトリ構成
```
lib/
├── main.dart              # エントリーポイント
├── app.dart               # アプリ設定・テーマ
├── core/                  # 共通定数・ユーティリティ
│   ├── constants/         # 色、速度閾値
│   └── utils/             # 距離計算、フォーマッター
├── data/                  # データ層
│   ├── models/            # データモデル
│   └── services/          # DB、GPS サービス
├── domain/                # ドメイン層
│   └── entities/          # 移動手段enum等
└── presentation/          # UI層
    ├── providers/         # Riverpod プロバイダー
    ├── screens/           # 画面
    └── widgets/           # UIウィジェット
```

## 主要機能
1. **地図表示**: OpenStreetMapタイル表示
2. **GPS追跡**: リアルタイム位置取得
3. **軌跡記録**: 移動経路をポリラインで描画（速度帯で色分け）
4. **スコアリング**: 移動時間×倍率でポイント計算

## 速度判定ルール
| 速度 | 移動手段 | スコア倍率 | 色 |
|------|----------|------------|-----|
| 3-6 km/h | 徒歩 | 3.0x | 緑 |
| 7-29 km/h | 自転車 | 2.0x | 青 |
| 30+ km/h | 車・列車 | 1.0x | オレンジ |
| <3 km/h | 停止 | 0x | グレー |

## コマンド
```bash
# 依存関係インストール
flutter pub get

# 静的解析
flutter analyze

# 実行
flutter run

# ビルド
flutter build apk      # Android
flutter build ios      # iOS
```

## 開発時の注意
- 位置情報権限は `android/app/src/main/AndroidManifest.xml` と `ios/Runner/Info.plist` で設定済み
- 地図タイルはOpenStreetMapを使用（利用規約に従いUserAgentを設定）
- スコア計算は `lib/presentation/providers/tracking_provider.dart` の `stopSession()` で実行
