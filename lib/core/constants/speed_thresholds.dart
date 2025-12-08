class SpeedThresholds {
  SpeedThresholds._();

  // 速度閾値 (km/h)
  static const double stationaryMax = 3.0;
  static const double walkingMin = 3.0;
  static const double walkingMax = 6.0;
  static const double cyclingMin = 7.0;
  static const double cyclingMax = 29.0;
  static const double vehicleMin = 30.0;

  // スコア倍率
  static const double walkingMultiplier = 3.0;
  static const double cyclingMultiplier = 2.0;
  static const double vehicleMultiplier = 1.0;
  static const double stationaryMultiplier = 0.0;
}
