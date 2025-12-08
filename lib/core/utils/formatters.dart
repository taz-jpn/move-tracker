class Formatters {
  Formatters._();

  /// 秒を時間:分:秒形式に変換
  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

  /// 距離をフォーマット（メートル → km表示）
  static String formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    } else {
      return '${meters.toStringAsFixed(0)} m';
    }
  }

  /// 速度をフォーマット
  static String formatSpeed(double kmh) {
    return '${kmh.toStringAsFixed(1)} km/h';
  }

  /// スコアをフォーマット
  static String formatScore(double score) {
    return score.toStringAsFixed(0);
  }
}
