import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dot_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/tracking_provider.dart';

class TrackingControls extends ConsumerWidget {
  const TrackingControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingState = ref.watch(trackingProvider);
    final isTracking = trackingState.isTracking;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
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
                ref.read(trackingProvider.notifier).startSession();
                // ドット初期化
                final currentPosition = ref.read(currentLatLngProvider);
                if (currentPosition != null) {
                  ref.read(dotProvider.notifier).initializeDots(currentPosition);
                }
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('記録開始'),
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
                _showStopConfirmation(context, ref);
              },
              icon: const Icon(Icons.stop),
              label: const Text('記録停止'),
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

  void _showStopConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('記録を停止しますか？'),
        content: const Text('現在のセッションを終了してスコアを計算します。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(trackingProvider.notifier).stopSession();
              ref.read(dotProvider.notifier).reset();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('停止'),
          ),
        ],
      ),
    );
  }
}
