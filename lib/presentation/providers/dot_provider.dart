import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../data/models/collectible_dot.dart';
import '../../data/services/dot_service.dart';

/// ドットの状態
class DotState {
  final List<CollectibleDot> dots;
  final int collectedCount;
  final int totalScore;
  final LatLng? lastSpawnPosition;
  final List<CollectibleDot> recentlyCollected; // 最近収集したドット（アニメーション用）

  DotState({
    this.dots = const [],
    this.collectedCount = 0,
    this.totalScore = 0,
    this.lastSpawnPosition,
    this.recentlyCollected = const [],
  });

  DotState copyWith({
    List<CollectibleDot>? dots,
    int? collectedCount,
    int? totalScore,
    LatLng? lastSpawnPosition,
    List<CollectibleDot>? recentlyCollected,
  }) {
    return DotState(
      dots: dots ?? this.dots,
      collectedCount: collectedCount ?? this.collectedCount,
      totalScore: totalScore ?? this.totalScore,
      lastSpawnPosition: lastSpawnPosition ?? this.lastSpawnPosition,
      recentlyCollected: recentlyCollected ?? this.recentlyCollected,
    );
  }

  /// 未収集のドットのみ
  List<CollectibleDot> get uncollectedDots =>
      dots.where((d) => !d.collected).toList();
}

/// ドット管理のNotifier
class DotNotifier extends StateNotifier<DotState> {
  final DotService _dotService = DotService();

  DotNotifier() : super(DotState());

  /// トラッキング開始時にドットを初期生成
  void initializeDots(LatLng currentPosition) {
    final dots = _dotService.generateDotsAround(
      currentPosition,
      DotConfig.initialDotCount,
    );

    state = DotState(
      dots: dots,
      lastSpawnPosition: currentPosition,
    );
  }

  /// 位置更新時に呼び出し - 収集チェックと追加生成
  void onPositionUpdate(LatLng currentPosition, double currentSpeedKmh) {
    // 収集チェック
    final collected = _dotService.checkCollection(
      currentPosition: currentPosition,
      dots: state.dots,
      currentSpeedKmh: currentSpeedKmh,
    );

    if (collected.isNotEmpty) {
      final addedScore = collected.fold<int>(0, (sum, dot) => sum + dot.score);

      state = state.copyWith(
        collectedCount: state.collectedCount + collected.length,
        totalScore: state.totalScore + addedScore,
        recentlyCollected: collected,
      );
    }

    // 追加生成チェック
    if (state.lastSpawnPosition != null) {
      final distanceFromLastSpawn = _dotService.calculateDistance(
        state.lastSpawnPosition!,
        currentPosition,
      );

      if (distanceFromLastSpawn >= DotConfig.spawnTriggerDistance) {
        _spawnMoreDots(currentPosition);
      }
    }
  }

  /// 追加ドットを生成
  void _spawnMoreDots(LatLng currentPosition) {
    final newDots = _dotService.generateDotsAround(
      currentPosition,
      DotConfig.spawnCount,
    );

    state = state.copyWith(
      dots: [...state.dots, ...newDots],
      lastSpawnPosition: currentPosition,
    );
  }

  /// 最近収集したドットをクリア（アニメーション終了後に呼ぶ）
  void clearRecentlyCollected() {
    state = state.copyWith(recentlyCollected: []);
  }

  /// トラッキング終了時にリセット
  void reset() {
    state = DotState();
  }

  /// 現在のセッションのスコアを取得
  int getSessionScore() => state.totalScore;
}

/// ドットプロバイダー
final dotProvider = StateNotifierProvider<DotNotifier, DotState>((ref) {
  return DotNotifier();
});
