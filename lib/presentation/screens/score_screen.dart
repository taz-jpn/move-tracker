import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/medal.dart';
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.score),
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
              Text(l10n.error(error.toString())),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(scoreSummaryProvider),
                child: Text(l10n.reload),
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
                  _buildScoreInfo(l10n),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreInfo(AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.scoreCalculation,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildScoreRule(l10n.walkingScore, '3.0x', Colors.green),
            const SizedBox(height: 8),
            _buildScoreRule(l10n.cyclingScore, '2.0x', Colors.blue),
            const SizedBox(height: 8),
            _buildScoreRule(l10n.vehicleScore, '1.0x', Colors.orange),
            const SizedBox(height: 12),
            Text(
              l10n.scoreFormula,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const Divider(height: 24),
            Text(
              l10n.dotCollectionBonus,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildScoreRule(l10n.normalDot, '+10pts', const Color(0xFFFFD700)),
            const SizedBox(height: 8),
            _buildScoreRule(l10n.silverDot, '+30pts', const Color(0xFFC0C0C0)),
            const SizedBox(height: 8),
            _buildScoreRule(l10n.goldDot, '+100pts', const Color(0xFFFF8C00)),
            const SizedBox(height: 12),
            Text(
              l10n.dotCollectionNote,
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
