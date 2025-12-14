import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/dot_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/tracking_provider.dart';

class TrackingControls extends ConsumerWidget {
  const TrackingControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingState = ref.watch(trackingProvider);
    final isTracking = trackingState.isTracking;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(30) : Colors.black.withAlpha(12),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isTracking)
            ElevatedButton.icon(
              onPressed: () {
                // トラッキング開始
                ref.read(trackingProvider.notifier).startSession();

                // ドット初期化
                final currentPosition = ref.read(currentLatLngProvider);
                if (currentPosition != null) {
                  ref.read(dotProvider.notifier).initializeDots(currentPosition);
                }

                // 位置更新時のドット収集コールバックを設定
                ref.read(trackingProvider.notifier).setPositionUpdateCallback(
                  (position, speedKmh) {
                    ref.read(dotProvider.notifier).onPositionUpdate(position, speedKmh);
                  },
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.startTracking),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () {
                _showStopConfirmation(context, ref, l10n);
              },
              icon: const Icon(Icons.stop),
              label: Text(l10n.stopTracking),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showStopConfirmation(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.stopTrackingTitle),
        content: Text(l10n.stopTrackingMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // コールバック解除
              ref.read(trackingProvider.notifier).setPositionUpdateCallback(null);
              // ドットデータを取得
              final dotState = ref.read(dotProvider);
              final dotCount = dotState.collectedCount;
              final dotScore = dotState.totalScore;
              // ドットリセット
              ref.read(dotProvider.notifier).reset();
              // セッション停止（ドットデータを渡す）
              ref.read(trackingProvider.notifier).stopSession(
                dotCount: dotCount,
                dotScore: dotScore,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.stop),
          ),
        ],
      ),
    );
  }
}
