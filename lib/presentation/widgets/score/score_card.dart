import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/transport_mode.dart';
import '../../../l10n/app_localizations.dart';

class ScoreCard extends StatelessWidget {
  final double totalScore;
  final double walkingScore;
  final int walkingSeconds;
  final double cyclingScore;
  final int cyclingSeconds;
  final double vehicleScore;
  final int vehicleSeconds;
  final int totalDotCount;
  final int totalDotScore;

  const ScoreCard({
    super.key,
    required this.totalScore,
    required this.walkingScore,
    required this.walkingSeconds,
    required this.cyclingScore,
    required this.cyclingSeconds,
    required this.vehicleScore,
    required this.vehicleSeconds,
    this.totalDotCount = 0,
    this.totalDotScore = 0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 合計スコア
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.totalScore,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Formatters.formatScore(totalScore),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'pts',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 移動手段別スコア
            _buildModeScore(
              mode: TransportMode.walking,
              score: walkingScore,
              seconds: walkingSeconds,
              l10n: l10n,
            ),
            const Divider(height: 24),
            _buildModeScore(
              mode: TransportMode.cycling,
              score: cyclingScore,
              seconds: cyclingSeconds,
              l10n: l10n,
            ),
            const Divider(height: 24),
            _buildModeScore(
              mode: TransportMode.vehicle,
              score: vehicleScore,
              seconds: vehicleSeconds,
              l10n: l10n,
            ),
            if (totalDotCount > 0) ...[
              const Divider(height: 24),
              _buildDotScore(l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModeScore({
    required TransportMode mode,
    required double score,
    required int seconds,
    required AppLocalizations l10n,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: mode.color.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getModeIcon(mode),
            color: mode.color,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mode.getDisplayName(l10n),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                Formatters.formatDuration(seconds),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Formatters.formatScore(score),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: mode.color,
              ),
            ),
            Text(
              'x${mode.scoreMultiplier.toStringAsFixed(1)}',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getModeIcon(TransportMode mode) {
    switch (mode) {
      case TransportMode.stationary:
        return Icons.pause;
      case TransportMode.walking:
        return Icons.directions_walk;
      case TransportMode.cycling:
        return Icons.directions_bike;
      case TransportMode.vehicle:
        return Icons.directions_car;
    }
  }

  Widget _buildDotScore(AppLocalizations l10n) {
    const dotColor = Color(0xFFFFD700);
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: dotColor.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.circle,
            color: dotColor,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.dotCollection,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '$totalDotCount',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Formatters.formatScore(totalDotScore.toDouble()),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: dotColor,
              ),
            ),
            Text(
              l10n.bonus,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
