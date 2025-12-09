import 'package:uuid/uuid.dart';
import '../models/medal.dart';
import '../models/score_summary.dart';
import '../models/track_session.dart';
import 'database_service.dart';

/// メダル判定と付与を行うサービス
class MedalService {
  final DatabaseService _databaseService;
  final Uuid _uuid = const Uuid();

  MedalService(this._databaseService);

  /// セッション終了時にメダルをチェックして付与
  /// 新しく獲得したメダルのリストを返す
  Future<List<MedalType>> checkAndAwardMedals({
    required TrackSession session,
    required ScoreSummary scoreSummary,
  }) async {
    final newMedals = <MedalType>[];
    final earnedTypes = await _databaseService.getEarnedMedalTypes();

    // 距離系メダルのチェック
    final totalDistance = await _databaseService.getTotalDistance();
    newMedals.addAll(await _checkDistanceMedals(totalDistance, earnedTypes));

    // スコア系メダルのチェック
    newMedals.addAll(_checkScoreMedals(scoreSummary.totalScore, earnedTypes));

    // 継続系メダルのチェック
    final streak = await _databaseService.getCurrentStreak();
    newMedals.addAll(_checkStreakMedals(streak, earnedTypes));

    // 特殊系メダルのチェック
    newMedals.addAll(_checkSpecialMedals(session, earnedTypes));

    // 新しいメダルをDBに保存
    for (final medalType in newMedals) {
      final medal = UserMedal(
        id: _uuid.v4(),
        medalType: medalType,
        earnedAt: DateTime.now(),
      );
      await _databaseService.insertMedal(medal);
    }

    return newMedals;
  }

  /// 距離系メダルのチェック
  Future<List<MedalType>> _checkDistanceMedals(
    double totalDistanceMeters,
    Set<MedalType> earnedTypes,
  ) async {
    final newMedals = <MedalType>[];
    final totalKm = totalDistanceMeters / 1000;

    if (totalKm >= 1 && !earnedTypes.contains(MedalType.firstStep)) {
      newMedals.add(MedalType.firstStep);
    }
    if (totalKm >= 10 && !earnedTypes.contains(MedalType.walker)) {
      newMedals.add(MedalType.walker);
    }
    if (totalKm >= 42.195 && !earnedTypes.contains(MedalType.marathoner)) {
      newMedals.add(MedalType.marathoner);
    }
    if (totalKm >= 100 && !earnedTypes.contains(MedalType.club100km)) {
      newMedals.add(MedalType.club100km);
    }

    return newMedals;
  }

  /// スコア系メダルのチェック
  List<MedalType> _checkScoreMedals(
    double totalScore,
    Set<MedalType> earnedTypes,
  ) {
    final newMedals = <MedalType>[];

    if (totalScore >= 100 && !earnedTypes.contains(MedalType.rookie)) {
      newMedals.add(MedalType.rookie);
    }
    if (totalScore >= 1000 && !earnedTypes.contains(MedalType.expert)) {
      newMedals.add(MedalType.expert);
    }
    if (totalScore >= 10000 && !earnedTypes.contains(MedalType.master)) {
      newMedals.add(MedalType.master);
    }

    return newMedals;
  }

  /// 継続系メダルのチェック
  List<MedalType> _checkStreakMedals(
    int streak,
    Set<MedalType> earnedTypes,
  ) {
    final newMedals = <MedalType>[];

    if (streak >= 3 && !earnedTypes.contains(MedalType.streak3days)) {
      newMedals.add(MedalType.streak3days);
    }
    if (streak >= 7 && !earnedTypes.contains(MedalType.streak7days)) {
      newMedals.add(MedalType.streak7days);
    }
    if (streak >= 30 && !earnedTypes.contains(MedalType.streak30days)) {
      newMedals.add(MedalType.streak30days);
    }

    return newMedals;
  }

  /// 特殊系メダルのチェック
  List<MedalType> _checkSpecialMedals(
    TrackSession session,
    Set<MedalType> earnedTypes,
  ) {
    final newMedals = <MedalType>[];
    final startHour = session.startTime.hour;

    // 早起き: 6時前に開始
    if (startHour < 6 && !earnedTypes.contains(MedalType.earlyBird)) {
      newMedals.add(MedalType.earlyBird);
    }

    // ナイトウォーカー: 22時以降に開始
    if (startHour >= 22 && !earnedTypes.contains(MedalType.nightWalker)) {
      newMedals.add(MedalType.nightWalker);
    }

    return newMedals;
  }
}
