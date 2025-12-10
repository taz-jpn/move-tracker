enum TrackStatus { active, paused, completed }

class TrackSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final TrackStatus status;
  final double totalDistance; // メートル
  final int durationSeconds;
  final int walkingSeconds;
  final int cyclingSeconds;
  final int vehicleSeconds;
  final double totalScore;
  final int dotCount; // 収集ドット数
  final int dotScore; // ドットスコア

  TrackSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.status,
    this.totalDistance = 0,
    this.durationSeconds = 0,
    this.walkingSeconds = 0,
    this.cyclingSeconds = 0,
    this.vehicleSeconds = 0,
    this.totalScore = 0,
    this.dotCount = 0,
    this.dotScore = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start_time': startTime.millisecondsSinceEpoch,
      'end_time': endTime?.millisecondsSinceEpoch,
      'status': status.index,
      'total_distance': totalDistance,
      'duration_seconds': durationSeconds,
      'walking_seconds': walkingSeconds,
      'cycling_seconds': cyclingSeconds,
      'vehicle_seconds': vehicleSeconds,
      'total_score': totalScore,
      'dot_count': dotCount,
      'dot_score': dotScore,
    };
  }

  factory TrackSession.fromMap(Map<String, dynamic> map) {
    return TrackSession(
      id: map['id'] as String,
      startTime: DateTime.fromMillisecondsSinceEpoch(map['start_time'] as int),
      endTime: map['end_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['end_time'] as int)
          : null,
      status: TrackStatus.values[map['status'] as int],
      totalDistance: map['total_distance'] as double,
      durationSeconds: map['duration_seconds'] as int,
      walkingSeconds: map['walking_seconds'] as int,
      cyclingSeconds: map['cycling_seconds'] as int,
      vehicleSeconds: map['vehicle_seconds'] as int,
      totalScore: map['total_score'] as double,
      dotCount: (map['dot_count'] as int?) ?? 0,
      dotScore: (map['dot_score'] as int?) ?? 0,
    );
  }

  TrackSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    TrackStatus? status,
    double? totalDistance,
    int? durationSeconds,
    int? walkingSeconds,
    int? cyclingSeconds,
    int? vehicleSeconds,
    double? totalScore,
    int? dotCount,
    int? dotScore,
  }) {
    return TrackSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      totalDistance: totalDistance ?? this.totalDistance,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      walkingSeconds: walkingSeconds ?? this.walkingSeconds,
      cyclingSeconds: cyclingSeconds ?? this.cyclingSeconds,
      vehicleSeconds: vehicleSeconds ?? this.vehicleSeconds,
      totalScore: totalScore ?? this.totalScore,
      dotCount: dotCount ?? this.dotCount,
      dotScore: dotScore ?? this.dotScore,
    );
  }
}
