import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/medal.dart';
import '../../data/models/score_summary.dart';
import '../../data/models/track_session.dart';
import 'tracking_provider.dart';

// autoDisposeで画面を離れたらキャッシュを破棄し、再表示時に最新データを取得
final scoreSummaryProvider = FutureProvider.autoDispose<ScoreSummary>((ref) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return await databaseService.getScoreSummary();
});

final sessionHistoryProvider = FutureProvider.autoDispose<List<TrackSession>>((ref) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return await databaseService.getAllSessions();
});

// メダル一覧
final userMedalsProvider = FutureProvider.autoDispose<List<UserMedal>>((ref) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return await databaseService.getAllMedals();
});

// 獲得済みメダルタイプのセット
final earnedMedalTypesProvider = FutureProvider.autoDispose<Set<MedalType>>((ref) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return await databaseService.getEarnedMedalTypes();
});
