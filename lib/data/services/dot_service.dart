import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import '../models/collectible_dot.dart';

/// ドット生成・管理のための設定
class DotConfig {
  DotConfig._();

  /// 収集可能な距離（メートル）
  static const double collectRadius = 30.0;

  /// 初期生成数
  static const int initialDotCount = 15;

  /// 追加生成のトリガー距離（メートル）
  static const int spawnTriggerDistance = 100;

  /// 追加生成数
  static const int spawnCount = 5;

  /// 生成範囲（メートル）- 現在地からの半径
  static const double spawnRadius = 200.0;

  /// 最小生成距離（メートル）- 現在地から近すぎないように
  static const double minSpawnDistance = 30.0;

  /// ドットタイプの出現確率
  static const double normalRate = 0.80;
  static const double silverRate = 0.15;
  // goldRate = 0.05 (残り)

  /// 車での収集を許可する最大速度（km/h）
  static const double maxCollectSpeedKmh = 30.0;
}

/// ドット生成・収集サービス
class DotService {
  final Uuid _uuid = const Uuid();
  final Random _random = Random();
  final Distance _distance = const Distance();

  /// 現在地周辺にドットを生成
  List<CollectibleDot> generateDotsAround(LatLng center, int count) {
    final dots = <CollectibleDot>[];

    for (int i = 0; i < count; i++) {
      final dot = _generateRandomDot(center);
      dots.add(dot);
    }

    return dots;
  }

  /// ランダムな位置にドットを1つ生成
  CollectibleDot _generateRandomDot(LatLng center) {
    // ランダムな方向と距離
    final angle = _random.nextDouble() * 2 * pi;
    final distance = DotConfig.minSpawnDistance +
        _random.nextDouble() * (DotConfig.spawnRadius - DotConfig.minSpawnDistance);

    // 緯度・経度のオフセットを計算
    // 1度 ≒ 111km なので、メートルから度に変換
    final latOffset = (distance * cos(angle)) / 111000;
    final lngOffset = (distance * sin(angle)) / (111000 * cos(center.latitude * pi / 180));

    final position = LatLng(
      center.latitude + latOffset,
      center.longitude + lngOffset,
    );

    return CollectibleDot(
      id: _uuid.v4(),
      position: position,
      type: _randomDotType(),
      createdAt: DateTime.now(),
    );
  }

  /// 確率に基づいてドットタイプを決定
  DotType _randomDotType() {
    final rand = _random.nextDouble();
    if (rand < DotConfig.normalRate) {
      return DotType.normal;
    } else if (rand < DotConfig.normalRate + DotConfig.silverRate) {
      return DotType.silver;
    } else {
      return DotType.gold;
    }
  }

  /// 現在地から収集可能なドットをチェック
  /// 収集されたドットのリストを返す
  List<CollectibleDot> checkCollection({
    required LatLng currentPosition,
    required List<CollectibleDot> dots,
    required double currentSpeedKmh,
  }) {
    // 速度が高すぎる場合は収集不可
    if (currentSpeedKmh > DotConfig.maxCollectSpeedKmh) {
      return [];
    }

    final collected = <CollectibleDot>[];

    for (final dot in dots) {
      if (dot.collected) continue;

      final distanceMeters = _distance.as(
        LengthUnit.Meter,
        currentPosition,
        dot.position,
      );

      if (distanceMeters <= DotConfig.collectRadius) {
        dot.collected = true;
        collected.add(dot);
      }
    }

    return collected;
  }

  /// 2点間の距離を計算（メートル）
  double calculateDistance(LatLng from, LatLng to) {
    return _distance.as(LengthUnit.Meter, from, to);
  }
}
