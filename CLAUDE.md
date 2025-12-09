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
1. **地図表示**: CartoDB Voyagerタイル表示（Retina対応）
2. **GPS追跡**: リアルタイム位置取得（フィルタリング付き）
3. **スコアリング**: 移動時間×倍率でポイント計算
4. **ドット収集**: パックマン風のドット収集ゲーム機能
5. **メダルシステム**: 実績に応じたメダル獲得

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
- 地図タイルはCartoDB Voyagerを使用（UserAgent設定済み）
- スコア計算は `lib/presentation/providers/tracking_provider.dart` の `stopSession()` で実行

## 技術的な注意点

### GPSフィルタリング
歩行中のGPSジャンプによる誤検出対策として以下を実装:
- `lib/core/constants/gps_filter_config.dart`: フィルタ設定
- `lib/core/utils/speed_filter.dart`: 速度フィルタ（移動平均、加速度制限）
- 精度20m以下のポイントのみ使用、時間ギャップ検出

### Riverpod ref.listen の制限
**重要**: `ref.listen(currentLatLngProvider, ...)` を使用するとGPSが停止する問題あり。
位置更新に反応する処理は、代わりにコールバック方式を使用:
```dart
// tracking_provider.dart
typedef PositionUpdateCallback = void Function(LatLng position, double speedKmh);
ref.read(trackingProvider.notifier).setPositionUpdateCallback(callback);
```

### IndexedStack とデータ更新
`IndexedStack`では画面が常にメモリ保持されるため、`FutureProvider.autoDispose`が効かない。
タブ切り替え時に `ref.invalidate()` で明示的にデータを再取得:
```dart
// main_screen.dart
onDestinationSelected: (index) {
  if (index == 1) ref.invalidate(scoreSummaryProvider);
  // ...
}
```

## 開発履歴

### 2024-12 実装済み機能
1. **GPSフィルタリング**: 歩行中の誤検出を45%→13%に改善
2. **軌跡ポリライン削除**: GPS精度問題のため削除
3. **メダルシステム**: 13種類のメダル（距離、連続、スコア、特殊）
4. **ドット収集システム**:
   - パックマン風のドット収集ゲーム
   - 3種類のドット（normal/silver/gold）
   - 速度30km/h以下、15m以内で収集可能
5. **地図タイル変更**: OpenStreetMap → CartoDB Voyager（Retina対応）

### ゲーム機能の設計ドキュメント
- `docs/game_features_proposal.md`: ゲーム機能提案書
