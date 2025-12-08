import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/score_summary.dart';
import '../../data/models/track_session.dart';
import 'tracking_provider.dart';

final scoreSummaryProvider = FutureProvider<ScoreSummary>((ref) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return await databaseService.getScoreSummary();
});

final sessionHistoryProvider = FutureProvider<List<TrackSession>>((ref) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return await databaseService.getAllSessions();
});
