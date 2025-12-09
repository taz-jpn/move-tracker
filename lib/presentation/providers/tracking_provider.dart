import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/location_point.dart';
import '../../data/models/medal.dart';
import '../../data/models/track_session.dart';
import '../../data/services/database_service.dart';
import '../../data/services/location_service.dart';
import '../../data/services/medal_service.dart';
import '../../domain/entities/transport_mode.dart';
import '../../core/utils/speed_calculator.dart';
import '../../core/utils/speed_filter.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

class TrackingState {
  final bool isTracking;
  final TrackSession? currentSession;
  final List<LocationPoint> trackPoints;
  final double currentSpeed;
  final TransportMode currentMode;
  final double sessionDistance;
  final int sessionDuration;
  final List<MedalType> newlyEarnedMedals; // 今回獲得したメダル

  TrackingState({
    this.isTracking = false,
    this.currentSession,
    this.trackPoints = const [],
    this.currentSpeed = 0,
    this.currentMode = TransportMode.stationary,
    this.sessionDistance = 0,
    this.sessionDuration = 0,
    this.newlyEarnedMedals = const [],
  });

  TrackingState copyWith({
    bool? isTracking,
    TrackSession? currentSession,
    List<LocationPoint>? trackPoints,
    double? currentSpeed,
    TransportMode? currentMode,
    double? sessionDistance,
    int? sessionDuration,
    List<MedalType>? newlyEarnedMedals,
  }) {
    return TrackingState(
      isTracking: isTracking ?? this.isTracking,
      currentSession: currentSession ?? this.currentSession,
      trackPoints: trackPoints ?? this.trackPoints,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      currentMode: currentMode ?? this.currentMode,
      sessionDistance: sessionDistance ?? this.sessionDistance,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      newlyEarnedMedals: newlyEarnedMedals ?? this.newlyEarnedMedals,
    );
  }
}

class TrackingNotifier extends StateNotifier<TrackingState> {
  final DatabaseService _databaseService;
  final LocationService _locationService;
  final Uuid _uuid = const Uuid();
  final SpeedFilter _speedFilter = SpeedFilter();
  StreamSubscription<Position>? _positionSubscription;
  Timer? _durationTimer;
  DateTime? _lastPointTime;

  TrackingNotifier(this._databaseService, this._locationService)
      : super(TrackingState()) {
    _loadActiveSession();
  }

  Future<void> _loadActiveSession() async {
    final session = await _databaseService.getActiveSession();
    if (session != null) {
      final points = await _databaseService.getPointsForSession(session.id);
      state = state.copyWith(
        currentSession: session,
        trackPoints: points,
        isTracking: true,
        sessionDistance: session.totalDistance,
        sessionDuration: session.durationSeconds,
      );
      _startTracking();
    }
  }

  Future<void> startSession() async {
    final session = TrackSession(
      id: _uuid.v4(),
      startTime: DateTime.now(),
      status: TrackStatus.active,
    );

    await _databaseService.insertSession(session);

    // フィルタをリセット
    _speedFilter.reset();
    _lastPointTime = null;

    state = state.copyWith(
      isTracking: true,
      currentSession: session,
      trackPoints: [],
      sessionDistance: 0,
      sessionDuration: 0,
    );

    _startTracking();
  }

  void _startTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = _locationService.getPositionStream().listen(
      _onPositionUpdate,
    );

    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.isTracking) {
        state = state.copyWith(
          sessionDuration: state.sessionDuration + 1,
        );
      }
    });
  }

  Future<void> _onPositionUpdate(Position position) async {
    if (!state.isTracking || state.currentSession == null) return;

    final now = DateTime.now();
    double rawSpeedKmh = 0;
    double addedDistance = 0;

    // GPSから速度を取得
    if (position.speed >= 0) {
      rawSpeedKmh = SpeedCalculator.msToKmh(position.speed);
    }

    // 前回のポイントとの距離を計算
    if (state.trackPoints.isNotEmpty) {
      final lastPoint = state.trackPoints.last;
      addedDistance = _locationService.calculateDistance(
        lastPoint.latitude,
        lastPoint.longitude,
        position.latitude,
        position.longitude,
      );

      // 速度を距離と時間から再計算（GPSの速度が不正確な場合）
      if (_lastPointTime != null) {
        final timeDiff = now.difference(_lastPointTime!);
        if (timeDiff.inSeconds > 0) {
          final calculatedSpeed = SpeedCalculator.calculateSpeedKmh(
            lat1: lastPoint.latitude,
            lon1: lastPoint.longitude,
            lat2: position.latitude,
            lon2: position.longitude,
            timeDiff: timeDiff,
          );
          // GPSの速度と計算速度の平均を取る
          if (rawSpeedKmh > 0) {
            rawSpeedKmh = (rawSpeedKmh + calculatedSpeed) / 2;
          } else {
            rawSpeedKmh = calculatedSpeed;
          }
        }
      }
    }

    // フィルタを適用して速度を取得
    final filteredSpeed = _speedFilter.filterSpeed(
      rawSpeed: rawSpeedKmh,
      accuracy: position.accuracy,
      currentTime: now,
    );

    // フィルタで除外された場合はこのポイントをスキップ
    if (filteredSpeed == null) {
      return;
    }

    final speedKmh = filteredSpeed;
    _lastPointTime = now;
    final mode = TransportModeExtension.fromSpeed(speedKmh);

    final point = LocationPoint(
      id: _uuid.v4(),
      sessionId: state.currentSession!.id,
      timestamp: DateTime.now(),
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      speed: position.speed,
      speedKmh: speedKmh,
      mode: mode,
    );

    await _databaseService.insertLocationPoint(point);

    final newDistance = state.sessionDistance + addedDistance;
    final newPoints = [...state.trackPoints, point];

    state = state.copyWith(
      trackPoints: newPoints,
      currentSpeed: speedKmh,
      currentMode: mode,
      sessionDistance: newDistance,
    );

    // セッションを更新
    final updatedSession = state.currentSession!.copyWith(
      totalDistance: newDistance,
      durationSeconds: state.sessionDuration,
    );
    await _databaseService.updateSession(updatedSession);
  }

  Future<void> stopSession() async {
    _positionSubscription?.cancel();
    _durationTimer?.cancel();

    if (state.currentSession != null) {
      // 移動手段別の時間を計算
      int walkingSeconds = 0;
      int cyclingSeconds = 0;
      int vehicleSeconds = 0;

      for (int i = 1; i < state.trackPoints.length; i++) {
        final point = state.trackPoints[i];
        final prevPoint = state.trackPoints[i - 1];
        final seconds = point.timestamp.difference(prevPoint.timestamp).inSeconds;

        switch (point.mode) {
          case TransportMode.walking:
            walkingSeconds += seconds;
            break;
          case TransportMode.cycling:
            cyclingSeconds += seconds;
            break;
          case TransportMode.vehicle:
            vehicleSeconds += seconds;
            break;
          case TransportMode.stationary:
            break;
        }
      }

      // スコア計算
      final walkingScore = (walkingSeconds / 60) * TransportMode.walking.scoreMultiplier;
      final cyclingScore = (cyclingSeconds / 60) * TransportMode.cycling.scoreMultiplier;
      final vehicleScore = (vehicleSeconds / 60) * TransportMode.vehicle.scoreMultiplier;
      final totalScore = walkingScore + cyclingScore + vehicleScore;

      final completedSession = state.currentSession!.copyWith(
        endTime: DateTime.now(),
        status: TrackStatus.completed,
        totalDistance: state.sessionDistance,
        durationSeconds: state.sessionDuration,
        walkingSeconds: walkingSeconds,
        cyclingSeconds: cyclingSeconds,
        vehicleSeconds: vehicleSeconds,
        totalScore: totalScore,
      );

      await _databaseService.updateSession(completedSession);

      // 累計スコアを更新
      final currentSummary = await _databaseService.getScoreSummary();
      final newSummary = currentSummary.copyWith(
        totalScore: currentSummary.totalScore + totalScore,
        walkingScore: currentSummary.walkingScore + walkingScore,
        walkingSeconds: currentSummary.walkingSeconds + walkingSeconds,
        cyclingScore: currentSummary.cyclingScore + cyclingScore,
        cyclingSeconds: currentSummary.cyclingSeconds + cyclingSeconds,
        vehicleScore: currentSummary.vehicleScore + vehicleScore,
        vehicleSeconds: currentSummary.vehicleSeconds + vehicleSeconds,
        lastUpdated: DateTime.now(),
      );
      await _databaseService.updateScoreSummary(newSummary);

      // メダル判定
      final medalService = MedalService(_databaseService);
      final newMedals = await medalService.checkAndAwardMedals(
        session: completedSession,
        scoreSummary: newSummary,
      );

      if (newMedals.isNotEmpty) {
        state = state.copyWith(newlyEarnedMedals: newMedals);
      }
    }

    state = TrackingState();
  }

  /// 新しく獲得したメダルをクリア
  void clearNewMedals() {
    state = state.copyWith(newlyEarnedMedals: []);
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationTimer?.cancel();
    super.dispose();
  }
}

final trackingProvider = StateNotifierProvider<TrackingNotifier, TrackingState>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  final locationService = LocationService();
  return TrackingNotifier(databaseService, locationService);
});

final trackPointsAsLatLngProvider = Provider<List<LatLng>>((ref) {
  final state = ref.watch(trackingProvider);
  return state.trackPoints
      .map((p) => LatLng(p.latitude, p.longitude))
      .toList();
});
