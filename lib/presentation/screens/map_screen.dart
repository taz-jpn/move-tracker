import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dot_provider.dart';
import '../providers/location_provider.dart';
import '../providers/tracking_provider.dart';
import '../widgets/map/map_widget.dart';
import '../widgets/common/speed_indicator.dart';
import '../widgets/common/tracking_controls.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionAsync = ref.watch(locationPermissionProvider);
    final trackingState = ref.watch(trackingProvider);
    final dotState = ref.watch(dotProvider);

    // 位置更新時にドット収集をチェック
    ref.listen(currentLatLngProvider, (previous, next) {
      if (next != null && trackingState.isTracking) {
        ref.read(dotProvider.notifier).onPositionUpdate(
          next,
          trackingState.currentSpeed,
        );
      }
    });

    return Scaffold(
      body: permissionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('位置情報の権限が必要です'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(locationPermissionProvider),
                child: const Text('権限をリクエスト'),
              ),
            ],
          ),
        ),
        data: (hasPermission) {
          if (!hasPermission) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('位置情報の権限が拒否されました'),
                  const SizedBox(height: 8),
                  const Text(
                    '設定から位置情報の権限を許可してください',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                // 地図
                const Expanded(
                  child: MapWidget(),
                ),

                // 速度/移動手段インジケーター（トラッキング中のみ表示）
                if (trackingState.isTracking)
                  SpeedIndicator(
                    speed: trackingState.currentSpeed,
                    mode: trackingState.currentMode,
                    distance: trackingState.sessionDistance,
                    duration: trackingState.sessionDuration,
                    dotCount: dotState.collectedCount,
                    dotScore: dotState.totalScore,
                  ),

                // トラッキングコントロール
                const TrackingControls(),
              ],
            ),
          );
        },
      ),
    );
  }
}
