class ScoreSummary {
  final double totalScore;
  final double walkingScore;
  final int walkingSeconds;
  final double cyclingScore;
  final int cyclingSeconds;
  final double vehicleScore;
  final int vehicleSeconds;
  final DateTime lastUpdated;

  ScoreSummary({
    this.totalScore = 0,
    this.walkingScore = 0,
    this.walkingSeconds = 0,
    this.cyclingScore = 0,
    this.cyclingSeconds = 0,
    this.vehicleScore = 0,
    this.vehicleSeconds = 0,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory ScoreSummary.empty() => ScoreSummary();

  Map<String, dynamic> toMap() {
    return {
      'total_score': totalScore,
      'walking_score': walkingScore,
      'walking_seconds': walkingSeconds,
      'cycling_score': cyclingScore,
      'cycling_seconds': cyclingSeconds,
      'vehicle_score': vehicleScore,
      'vehicle_seconds': vehicleSeconds,
      'last_updated': lastUpdated.millisecondsSinceEpoch,
    };
  }

  factory ScoreSummary.fromMap(Map<String, dynamic> map) {
    return ScoreSummary(
      totalScore: map['total_score'] as double,
      walkingScore: map['walking_score'] as double,
      walkingSeconds: map['walking_seconds'] as int,
      cyclingScore: map['cycling_score'] as double,
      cyclingSeconds: map['cycling_seconds'] as int,
      vehicleScore: map['vehicle_score'] as double,
      vehicleSeconds: map['vehicle_seconds'] as int,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(map['last_updated'] as int),
    );
  }

  ScoreSummary copyWith({
    double? totalScore,
    double? walkingScore,
    int? walkingSeconds,
    double? cyclingScore,
    int? cyclingSeconds,
    double? vehicleScore,
    int? vehicleSeconds,
    DateTime? lastUpdated,
  }) {
    return ScoreSummary(
      totalScore: totalScore ?? this.totalScore,
      walkingScore: walkingScore ?? this.walkingScore,
      walkingSeconds: walkingSeconds ?? this.walkingSeconds,
      cyclingScore: cyclingScore ?? this.cyclingScore,
      cyclingSeconds: cyclingSeconds ?? this.cyclingSeconds,
      vehicleScore: vehicleScore ?? this.vehicleScore,
      vehicleSeconds: vehicleSeconds ?? this.vehicleSeconds,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
