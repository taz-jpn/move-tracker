import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/medal.dart';
import '../providers/score_provider.dart';
import '../widgets/medal/medal_grid.dart';
import '../widgets/score/score_card.dart';
import '../widgets/common/app_status_bar.dart';

class ScoreScreen extends ConsumerWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreSummaryAsync = ref.watch(scoreSummaryProvider);
    final earnedMedalsAsync = ref.watch(earnedMedalTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('スコア'),
        centerTitle: true,
        elevation: 0,
        actions: const [AppBarSettingsActions()],
      ),
      body: scoreSummaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('エラー: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(scoreSummaryProvider),
                child: const Text('再読み込み'),
              ),
            ],
          ),
        ),
        data: (summary) {
          final earnedMedals = earnedMedalsAsync.valueOrNull ?? <MedalType>{};

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(scoreSummaryProvider);
              ref.invalidate(earnedMedalTypesProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ScoreCard(
                    totalScore: summary.totalScore,
                    walkingScore: summary.walkingScore,
                    walkingSeconds: summary.walkingSeconds,
                    cyclingScore: summary.cyclingScore,
                    cyclingSeconds: summary.cyclingSeconds,
                    vehicleScore: summary.vehicleScore,
                    vehicleSeconds: summary.vehicleSeconds,
                    totalDotCount: summary.totalDotCount,
                    totalDotScore: summary.totalDotScore,
                  ),
                  const SizedBox(height: 16),
                  MedalGrid(earnedMedals: earnedMedals),
                  const SizedBox(height: 16),
                  _buildScoreInfo(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreInfo() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'スコアの計算方法',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildScoreRule('徒歩 (3-6 km/h)', '3.0x', Colors.green),
            const SizedBox(height: 8),
            _buildScoreRule('自転車 (7-29 km/h)', '2.0x', Colors.blue),
            const SizedBox(height: 8),
            _buildScoreRule('車・列車 (30+ km/h)', '1.0x', Colors.orange),
            const SizedBox(height: 12),
            Text(
              '移動スコア = 移動時間(分) × 倍率',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const Divider(height: 24),
            const Text(
              'ドット収集ボーナス',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildScoreRule('通常ドット', '+10pts', const Color(0xFFFFD700)),
            const SizedBox(height: 8),
            _buildScoreRule('シルバードット', '+30pts', const Color(0xFFC0C0C0)),
            const SizedBox(height: 8),
            _buildScoreRule('ゴールドドット', '+100pts', const Color(0xFFFF8C00)),
            const SizedBox(height: 12),
            Text(
              '※ 速度30km/h以下、30m以内で収集可能',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRule(String mode, String multiplier, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(mode),
        ),
        Text(
          multiplier,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
