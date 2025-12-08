import 'distance_calculator.dart';

class SpeedCalculator {
  SpeedCalculator._();

  /// 2点間の速度を計算 (km/h)
  static double calculateSpeedKmh({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
    required Duration timeDiff,
  }) {
    if (timeDiff.inSeconds == 0) return 0;

    final distanceMeters = DistanceCalculator.calculate(lat1, lon1, lat2, lon2);
    final hours = timeDiff.inMilliseconds / (1000 * 60 * 60);

    if (hours == 0) return 0;

    final distanceKm = distanceMeters / 1000;
    return distanceKm / hours;
  }

  /// m/s から km/h に変換
  static double msToKmh(double ms) {
    return ms * 3.6;
  }

  /// km/h から m/s に変換
  static double kmhToMs(double kmh) {
    return kmh / 3.6;
  }
}
