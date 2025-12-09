import 'dart:collection';
import '../constants/gps_filter_config.dart';

/// GPS速度データのフィルタリングと平滑化を行うクラス
class SpeedFilter {
  final Queue<double> _speedHistory = Queue<double>();
  double? _lastValidSpeed;
  DateTime? _lastValidTime;

  /// 速度履歴をクリア（セッション開始時に呼ぶ）
  void reset() {
    _speedHistory.clear();
    _lastValidSpeed = null;
    _lastValidTime = null;
  }

  /// GPSの精度が許容範囲内かチェック
  bool isAccuracyAcceptable(double accuracyMeters) {
    return accuracyMeters <= GpsFilterConfig.maxAccuracyMeters;
  }

  /// 時間ギャップが大きすぎないかチェック
  bool hasValidTimeGap(DateTime currentTime) {
    if (_lastValidTime == null) return true;
    final gap = currentTime.difference(_lastValidTime!).inSeconds;
    return gap <= GpsFilterConfig.maxTimeGapSeconds;
  }

  /// 加速度が物理的に妥当かチェック
  bool isAccelerationRealistic(double currentSpeed, Duration timeDiff) {
    if (_lastValidSpeed == null) return true;
    if (timeDiff.inSeconds <= 0) return true;

    final speedChange = (currentSpeed - _lastValidSpeed!).abs();
    final accelerationPerSecond = speedChange / timeDiff.inSeconds;

    return accelerationPerSecond <= GpsFilterConfig.maxAccelerationKmhPerSecond;
  }

  /// 速度が物理的にありえる範囲かチェック
  bool isSpeedRealistic(double speedKmh) {
    return speedKmh >= 0 && speedKmh <= GpsFilterConfig.maxRealisticSpeedKmh;
  }

  /// 移動平均で速度を平滑化
  double getSmoothedSpeed(double rawSpeed) {
    // 履歴に追加
    _speedHistory.addLast(rawSpeed);

    // ウィンドウサイズを超えたら古いデータを削除
    while (_speedHistory.length > GpsFilterConfig.speedAverageWindowSize) {
      _speedHistory.removeFirst();
    }

    // 平均を計算
    if (_speedHistory.isEmpty) return rawSpeed;
    final sum = _speedHistory.reduce((a, b) => a + b);
    return sum / _speedHistory.length;
  }

  /// フィルタリングを適用して速度を取得
  /// 無効なデータの場合はnullを返す
  double? filterSpeed({
    required double rawSpeed,
    required double accuracy,
    required DateTime currentTime,
  }) {
    // 1. 精度チェック
    if (!isAccuracyAcceptable(accuracy)) {
      return null;
    }

    // 2. 物理的にありえる速度かチェック
    if (!isSpeedRealistic(rawSpeed)) {
      return null;
    }

    // 3. 時間ギャップチェック
    if (!hasValidTimeGap(currentTime)) {
      // 時間が空きすぎた場合はリセットして、今回のデータから再開
      _speedHistory.clear();
      _lastValidSpeed = rawSpeed;
      _lastValidTime = currentTime;
      return getSmoothedSpeed(rawSpeed);
    }

    // 4. 加速度チェック
    if (_lastValidTime != null) {
      final timeDiff = currentTime.difference(_lastValidTime!);
      if (!isAccelerationRealistic(rawSpeed, timeDiff)) {
        // 異常な加速の場合は前回の速度を維持（または無視）
        return _lastValidSpeed ?? 0;
      }
    }

    // 5. 移動平均で平滑化
    final smoothedSpeed = getSmoothedSpeed(rawSpeed);

    // 有効なデータとして記録
    _lastValidSpeed = smoothedSpeed;
    _lastValidTime = currentTime;

    return smoothedSpeed;
  }
}
