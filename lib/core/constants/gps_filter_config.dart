/// GPSフィルタリングの設定値
class GpsFilterConfig {
  GpsFilterConfig._();

  // 精度フィルタ: これより精度が悪い（値が大きい）データは除外
  static const double maxAccuracyMeters = 20.0;

  // 時間ギャップ: これ以上の時間が空いたら速度計算をリセット
  static const int maxTimeGapSeconds = 5;

  // 加速度制限: 1秒あたりの最大速度変化 (km/h)
  // 人間の急加速・急減速を考慮して設定
  static const double maxAccelerationKmhPerSecond = 10.0;

  // 移動平均のウィンドウサイズ
  static const int speedAverageWindowSize = 3;

  // distanceFilter: 位置更新の最小移動距離 (メートル)
  static const int distanceFilterMeters = 10;

  // 物理的にありえない最大速度 (km/h)
  // これを超える速度は異常値として扱う
  static const double maxRealisticSpeedKmh = 150.0;
}
