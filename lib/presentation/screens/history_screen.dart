import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/track_session.dart';
import '../providers/score_provider.dart';
import '../widgets/common/app_status_bar.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('履歴'),
        centerTitle: true,
        elevation: 0,
        actions: const [AppBarSettingsActions()],
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('エラー: $error'),
            ],
          ),
        ),
        data: (sessions) {
          final completedSessions = sessions
              .where((s) => s.status == TrackStatus.completed)
              .toList();

          if (completedSessions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '記録がありません',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '地図画面から記録を開始してください',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(sessionHistoryProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: completedSessions.length,
              itemBuilder: (context, index) {
                final session = completedSessions[index];
                return _buildSessionCard(session);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionCard(TrackSession session) {
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 日時
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  dateFormat.format(session.startTime),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 統計情報
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  icon: Icons.straighten,
                  label: '距離',
                  value: Formatters.formatDistance(session.totalDistance),
                ),
                _buildStat(
                  icon: Icons.timer,
                  label: '時間',
                  value: Formatters.formatDuration(session.durationSeconds),
                ),
                _buildStat(
                  icon: Icons.star,
                  label: 'スコア',
                  value: Formatters.formatScore(session.totalScore),
                  valueColor: Colors.amber,
                ),
              ],
            ),

            const Divider(height: 24),

            // 移動手段別時間
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildModeTime(
                  Icons.directions_walk,
                  Colors.green,
                  session.walkingSeconds,
                ),
                _buildModeTime(
                  Icons.directions_bike,
                  Colors.blue,
                  session.cyclingSeconds,
                ),
                _buildModeTime(
                  Icons.directions_car,
                  Colors.orange,
                  session.vehicleSeconds,
                ),
              ],
            ),

            // ドット収集（ある場合のみ）
            if (session.dotCount > 0) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.circle, color: Color(0xFFFFD700), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${session.dotCount}個収集 (+${session.dotScore}pts)',
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: valueColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildModeTime(IconData icon, Color color, int seconds) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          Formatters.formatDuration(seconds),
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
