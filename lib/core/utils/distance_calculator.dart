import 'dart:math';

class DistanceCalculator {
  DistanceCalculator._();

  static const double _earthRadius = 6371000; // メートル

  /// Haversine公式で2点間の距離を計算（メートル）
  static double calculate(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _earthRadius * c;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
