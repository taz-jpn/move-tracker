import '../../domain/entities/transport_mode.dart';

class LocationPoint {
  final String id;
  final String sessionId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double? speed; // m/s
  final double? speedKmh;
  final TransportMode mode;

  LocationPoint({
    required this.id,
    required this.sessionId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.speed,
    this.speedKmh,
    required this.mode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'speed': speed,
      'speed_kmh': speedKmh,
      'mode': mode.index,
    };
  }

  factory LocationPoint.fromMap(Map<String, dynamic> map) {
    return LocationPoint(
      id: map['id'] as String,
      sessionId: map['session_id'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      accuracy: map['accuracy'] as double,
      speed: map['speed'] as double?,
      speedKmh: map['speed_kmh'] as double?,
      mode: TransportMode.values[map['mode'] as int],
    );
  }

  LocationPoint copyWith({
    String? id,
    String? sessionId,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? speed,
    double? speedKmh,
    TransportMode? mode,
  }) {
    return LocationPoint(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      speed: speed ?? this.speed,
      speedKmh: speedKmh ?? this.speedKmh,
      mode: mode ?? this.mode,
    );
  }
}
