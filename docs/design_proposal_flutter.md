# モバイルマップアプリ設計提案書（Flutter版）

## 1. プロジェクト概要

### 1.1 アプリ名（仮称）
**MoveTracker** - 移動記録＆スコアリングアプリ

### 1.2 Flutter採用の理由

| 観点 | Flutter | React + Capacitor |
|------|---------|-------------------|
| **レンダリング** | Skiaエンジンで直接描画（60fps） | WebViewベース |
| **地図パフォーマンス** | ネイティブ同等 | DOM操作のオーバーヘッド |
| **GPS処理** | ネイティブコード直接呼び出し | JSブリッジ経由 |
| **バッテリー効率** | 優れている | WebView分の消費あり |
| **起動速度** | 高速（AOTコンパイル） | やや遅い |
| **地図のスクロール** | 滑らか | カクつく可能性 |

**結論**: 地図操作の滑らかさ、GPS追跡のリアルタイム性、バッテリー効率を重視する場合、Flutterが優位。

---

## 2. 技術スタック

### 2.1 コアフレームワーク
| 技術 | バージョン | 用途 |
|------|------------|------|
| **Flutter** | 3.x | クロスプラットフォームフレームワーク |
| **Dart** | 3.x | プログラミング言語 |

### 2.2 地図関連パッケージ
| パッケージ | 用途 |
|------------|------|
| **flutter_map** | OpenStreetMap対応の軽量地図ライブラリ |
| **latlong2** | 緯度経度計算 |
| **flutter_map_tile_caching** | オフラインタイルキャッシュ |

### 2.3 位置情報・センサー
| パッケージ | 用途 |
|------------|------|
| **geolocator** | GPS位置情報取得（高精度） |
| **flutter_background_geolocation** | バックグラウンドGPS追跡 |

### 2.4 状態管理・データ
| パッケージ | 用途 |
|------------|------|
| **riverpod** | 状態管理（推奨） |
| **isar** | 高速ローカルDB（NoSQL） |
| **shared_preferences** | 設定保存 |

### 2.5 UI/UX
| パッケージ | 用途 |
|------------|------|
| **go_router** | 画面遷移 |
| **fl_chart** | グラフ描画 |
| **flutter_hooks** | Reactライクなフック |

---

## 3. アーキテクチャ

### 3.1 全体構成（Clean Architecture）

```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐ │
│  │   Screens   │  │   Widgets   │  │   Controllers   │ │
│  └─────────────┘  └─────────────┘  └─────────────────┘ │
├─────────────────────────────────────────────────────────┤
│                   Application Layer                      │
│  ┌─────────────────────────────────────────────────┐   │
│  │              State Management (Riverpod)         │   │
│  │  ┌───────────┐ ┌───────────┐ ┌───────────────┐  │   │
│  │  │ Location  │ │  Track    │ │    Score      │  │   │
│  │  │ Provider  │ │  Provider │ │   Provider    │  │   │
│  │  └───────────┘ └───────────┘ └───────────────┘  │   │
│  └─────────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────────┤
│                     Domain Layer                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐ │
│  │  Entities   │  │  UseCases   │  │  Repositories   │ │
│  │             │  │             │  │  (Interfaces)   │ │
│  └─────────────┘  └─────────────┘  └─────────────────┘ │
├─────────────────────────────────────────────────────────┤
│                      Data Layer                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐ │
│  │    Isar     │  │  Geolocator │  │  flutter_map    │ │
│  │  (Storage)  │  │   (GPS)     │  │   (Map Tiles)   │ │
│  └─────────────┘  └─────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

### 3.2 flutter_map vs 他の地図ライブラリ比較

| ライブラリ | OSM対応 | パフォーマンス | カスタマイズ性 | ライセンス |
|------------|---------|----------------|----------------|------------|
| **flutter_map** | ◎ | ◎ | ◎ | BSD |
| google_maps_flutter | △（別途API） | ◎ | △ | 有料API |
| mapbox_gl | ◎ | ◎ | ◎ | 有料（一部） |

**flutter_map採用理由**:
- OpenStreetMapネイティブサポート
- 完全無料
- Polyline描画の柔軟性
- 軽量で高速

---

## 4. 画面設計

### 4.1 画面一覧

| 画面 | 説明 |
|------|------|
| **MapScreen** | 地図表示、現在地、軌跡表示、トラッキング操作 |
| **ScoreScreen** | 移動手段別スコア表示、統計グラフ |
| **HistoryScreen** | 過去の移動記録一覧 |
| **TrackDetailScreen** | 個別トラックの詳細表示 |
| **SettingsScreen** | アプリ設定 |

### 4.2 メイン画面レイアウト

```
┌────────────────────────────────────┐
│           AppBar (透過)            │
│  [メニュー]              [設定]    │
├────────────────────────────────────┤
│                                    │
│         FlutterMap                 │
│      (OpenStreetMap Tiles)         │
│                                    │
│            📍 現在地               │
│         ═══軌跡═══                 │
│                    [現在地ボタン]  │
│                    [ズーム +/-]    │
├────────────────────────────────────┤
│  ┌────────────────────────────┐   │
│  │ 🚶 5.2 km/h │ 徒歩 │ +3pt/min │ │
│  └────────────────────────────┘   │
├────────────────────────────────────┤
│      [ ▶ 開始 ]  [ ⏹ 停止 ]       │
├────────────────────────────────────┤
│  🗺️        🏆        📋        ⚙️  │
│  Map      Score    History   Settings│
└────────────────────────────────────┘
```

---

## 5. 速度判定・スコアリングシステム

### 5.1 速度帯と移動手段の分類

| 速度帯 | 移動手段 | スコア倍率 | 色 |
|--------|----------|------------|-----|
| **3〜6 km/h** | 徒歩 | 3.0x | 緑 `#4CAF50` |
| **7〜29 km/h** | 自転車 | 2.0x | 青 `#2196F3` |
| **30 km/h以上** | 車・列車 | 1.0x | オレンジ `#FF9800` |
| **3 km/h未満** | 停止 | 0x | グレー `#9E9E9E` |

### 5.2 速度判定ロジック（Dart）

```dart
enum TransportMode {
  stationary,
  walking,
  cycling,
  vehicle,
}

extension TransportModeExtension on TransportMode {
  double get scoreMultiplier {
    switch (this) {
      case TransportMode.walking:
        return 3.0;
      case TransportMode.cycling:
        return 2.0;
      case TransportMode.vehicle:
        return 1.0;
      case TransportMode.stationary:
        return 0.0;
    }
  }

  Color get color {
    switch (this) {
      case TransportMode.walking:
        return const Color(0xFF4CAF50);
      case TransportMode.cycling:
        return const Color(0xFF2196F3);
      case TransportMode.vehicle:
        return const Color(0xFFFF9800);
      case TransportMode.stationary:
        return const Color(0xFF9E9E9E);
    }
  }
}

TransportMode detectTransportMode(double speedKmh) {
  if (speedKmh < 3) return TransportMode.stationary;
  if (speedKmh <= 6) return TransportMode.walking;
  if (speedKmh <= 29) return TransportMode.cycling;
  return TransportMode.vehicle;
}
```

---

## 6. データモデル（Isar）

### 6.1 位置データ

```dart
import 'package:isar/isar.dart';

part 'location_point.g.dart';

@collection
class LocationPoint {
  Id id = Isar.autoIncrement;

  late int trackSessionId;
  late DateTime timestamp;
  late double latitude;
  late double longitude;
  late double accuracy;
  double? speed;        // m/s
  double? speedKmh;     // km/h

  @enumerated
  late TransportMode mode;
}
```

### 6.2 トラッキングセッション

```dart
@collection
class TrackSession {
  Id id = Isar.autoIncrement;

  late DateTime startTime;
  DateTime? endTime;

  @enumerated
  late TrackStatus status;

  late double totalDistance;     // メートル
  late int durationSeconds;

  // 集計データ
  late int walkingSeconds;
  late int cyclingSeconds;
  late int vehicleSeconds;
  late double totalScore;

  // リレーション
  final points = IsarLinks<LocationPoint>();
}

enum TrackStatus { active, paused, completed }
```

### 6.3 累計スコア

```dart
@collection
class ScoreSummary {
  Id id = Isar.autoIncrement;

  late double totalScore;
  late double walkingScore;
  late int walkingSeconds;
  late double cyclingScore;
  late int cyclingSeconds;
  late double vehicleScore;
  late int vehicleSeconds;
  late DateTime lastUpdated;
}
```

---

## 7. 主要機能の実装

### 7.1 地図表示（flutter_map）

```dart
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = ref.watch(currentLocationProvider);
    final trackPoints = ref.watch(trackPointsProvider);

    return FlutterMap(
      options: MapOptions(
        initialCenter: currentLocation ?? LatLng(35.6812, 139.7671),
        initialZoom: 15.0,
        maxZoom: 18.0,
        minZoom: 3.0,
      ),
      children: [
        // OpenStreetMap タイルレイヤー
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.movetracker',
          maxZoom: 19,
        ),

        // 軌跡ポリライン（速度帯で色分け）
        PolylineLayer(
          polylines: _buildColoredPolylines(trackPoints),
        ),

        // 現在地マーカー
        if (currentLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: currentLocation,
                width: 40,
                height: 40,
                child: const CurrentLocationMarker(),
              ),
            ],
          ),
      ],
    );
  }

  List<Polyline> _buildColoredPolylines(List<LocationPoint> points) {
    // 速度帯ごとにセグメント分割して色分け
    final polylines = <Polyline>[];
    // ... セグメント処理
    return polylines;
  }
}
```

### 7.2 GPS トラッキング（geolocator）

```dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  Stream<Position> get positionStream {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,  // 5m移動で更新
      ),
    );
  }

  Future<Position?> getCurrentPosition() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
```

### 7.3 バックグラウンドトラッキング

```dart
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class BackgroundLocationService {
  Future<void> initialize() async {
    await bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 10.0,
      stopOnTerminate: false,
      startOnBoot: true,
      enableHeadless: true,
      // バッテリー最適化
      heartbeatInterval: 60,
      preventSuspend: true,
    ));
  }

  void startTracking() {
    bg.BackgroundGeolocation.start();
  }
}
```

### 7.4 状態管理（Riverpod）

```dart
// 現在位置のProvider
final currentLocationProvider = StreamProvider<LatLng?>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  return locationService.positionStream.map(
    (pos) => LatLng(pos.latitude, pos.longitude),
  );
});

// トラッキング状態のProvider
final trackingStateProvider = StateNotifierProvider<TrackingNotifier, TrackingState>((ref) {
  return TrackingNotifier(ref);
});

// スコアのProvider
final scoreProvider = FutureProvider<ScoreSummary>((ref) async {
  final db = ref.watch(isarProvider);
  return db.scoreSummarys.where().findFirst() ?? ScoreSummary.empty();
});
```

---

## 8. ディレクトリ構成

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── speed_thresholds.dart
│   ├── extensions/
│   │   └── transport_mode_extension.dart
│   └── utils/
│       ├── distance_calculator.dart
│       └── speed_calculator.dart
│
├── data/
│   ├── models/
│   │   ├── location_point.dart
│   │   ├── track_session.dart
│   │   └── score_summary.dart
│   ├── repositories/
│   │   ├── location_repository.dart
│   │   ├── track_repository.dart
│   │   └── score_repository.dart
│   └── services/
│       ├── location_service.dart
│       ├── background_location_service.dart
│       └── isar_service.dart
│
├── domain/
│   ├── entities/
│   │   └── transport_mode.dart
│   └── usecases/
│       ├── start_tracking.dart
│       ├── stop_tracking.dart
│       └── calculate_score.dart
│
├── presentation/
│   ├── providers/
│   │   ├── location_provider.dart
│   │   ├── tracking_provider.dart
│   │   └── score_provider.dart
│   ├── screens/
│   │   ├── map_screen.dart
│   │   ├── score_screen.dart
│   │   ├── history_screen.dart
│   │   └── settings_screen.dart
│   └── widgets/
│       ├── map/
│       │   ├── map_widget.dart
│       │   ├── current_location_marker.dart
│       │   └── track_polyline.dart
│       ├── score/
│       │   ├── score_card.dart
│       │   └── score_chart.dart
│       └── common/
│           ├── speed_indicator.dart
│           └── tracking_controls.dart
│
└── router/
    └── app_router.dart

test/
├── unit/
├── widget/
└── integration/
```

---

## 9. pubspec.yaml

```yaml
name: move_tracker
description: 移動記録＆スコアリングアプリ
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.10.0'

dependencies:
  flutter:
    sdk: flutter

  # 地図
  flutter_map: ^6.1.0
  latlong2: ^0.9.0
  flutter_map_tile_caching: ^9.0.0

  # 位置情報
  geolocator: ^11.0.0
  flutter_background_geolocation: ^4.14.0

  # 状態管理
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

  # データベース
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  shared_preferences: ^2.2.0

  # UI
  go_router: ^13.0.0
  fl_chart: ^0.66.0
  flutter_hooks: ^0.20.0
  hooks_riverpod: ^2.4.0

  # ユーティリティ
  intl: ^0.18.0
  uuid: ^4.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  isar_generator: ^3.1.0
  flutter_lints: ^3.0.0
  mockito: ^5.4.0

flutter:
  uses-material-design: true
```

---

## 10. パフォーマンス最適化

### 10.1 地図レンダリング
```dart
// タイルキャッシュ設定
final store = FMTCStore('mapStore');
await store.manage.create();

TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  tileProvider: store.getTileProvider(),  // キャッシュ使用
)
```

### 10.2 軌跡描画の最適化
```dart
// Douglas-Peuckerアルゴリズムで点を間引き
List<LatLng> simplifyPath(List<LatLng> points, double tolerance) {
  // 表示用に点を削減（元データは保持）
}
```

### 10.3 バッテリー最適化
| 状態 | GPS間隔 | 精度 |
|------|---------|------|
| 移動中（高速） | 3秒 | High |
| 移動中（低速） | 5秒 | High |
| 停止中 | 30秒 | Balanced |
| バックグラウンド | 10秒 | Balanced |

---

## 11. React+Capacitor vs Flutter 比較まとめ

| 項目 | React + Capacitor | Flutter |
|------|-------------------|---------|
| **地図スクロール** | △ DOM経由 | ◎ ネイティブ描画 |
| **GPS精度/速度** | ○ JSブリッジ | ◎ 直接アクセス |
| **バッテリー** | △ WebView消費 | ◎ 効率的 |
| **アプリサイズ** | ○ 小さめ | △ やや大きい |
| **開発速度** | ◎ Web技術流用 | ○ 学習コスト |
| **ホットリロード** | ○ | ◎ 高速 |
| **バックグラウンド** | △ 制限あり | ◎ 対応良好 |

**推奨**: 地図パフォーマンスとバッテリー効率を重視 → **Flutter版**

---

## 12. 開発フェーズ

### Phase 1: 基盤構築
- [ ] Flutterプロジェクト作成
- [ ] アーキテクチャ設計・ディレクトリ構成
- [ ] Isar/Riverpod設定
- [ ] ルーティング設定

### Phase 2: 地図機能
- [ ] flutter_map統合
- [ ] OpenStreetMapタイル表示
- [ ] 地図操作（ズーム、パン、回転）
- [ ] タイルキャッシュ設定

### Phase 3: 位置情報
- [ ] GPS取得実装
- [ ] 現在地マーカー表示
- [ ] リアルタイム位置更新
- [ ] 精度フィルタリング

### Phase 4: トラッキング
- [ ] 軌跡記録機能
- [ ] 速度計算・移動手段判定
- [ ] セグメント色分け描画
- [ ] バックグラウンドトラッキング

### Phase 5: スコアリング
- [ ] スコア計算ロジック
- [ ] スコア表示UI
- [ ] 統計グラフ

### Phase 6: 仕上げ
- [ ] 履歴機能
- [ ] 設定画面
- [ ] テスト
- [ ] iOS/Androidビルド・リリース準備
