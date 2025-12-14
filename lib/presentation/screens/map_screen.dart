import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../providers/location_provider.dart';
import '../providers/tracking_provider.dart';
import '../widgets/map/map_widget.dart';
import '../widgets/common/speed_indicator.dart';
import '../widgets/common/tracking_controls.dart';
import '../widgets/common/app_status_bar.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionAsync = ref.watch(locationPermissionProvider);
    final trackingState = ref.watch(trackingProvider);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.map),
        centerTitle: true,
        elevation: 0,
        actions: const [AppBarSettingsActions()],
      ),
      body: permissionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(l10n.locationPermissionRequired),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(locationPermissionProvider),
                child: Text(l10n.requestPermission),
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
                  Text(l10n.locationPermissionDenied),
                  const SizedBox(height: 8),
                  Text(
                    l10n.enableLocationInSettings,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
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
                ),

              // トラッキングコントロール
              const TrackingControls(),
            ],
          );
        },
      ),
    );
  }
}
