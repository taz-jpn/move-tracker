import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/models/collectible_dot.dart';
import '../../providers/dot_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/tracking_provider.dart';

class MapWidget extends ConsumerStatefulWidget {
  const MapWidget({super.key});

  @override
  ConsumerState<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  final MapController _mapController = MapController();
  bool _followUser = true;

  Marker _buildDotMarker(CollectibleDot dot) {
    return Marker(
      point: dot.position,
      width: dot.size + 8,
      height: dot.size + 8,
      child: Container(
        decoration: BoxDecoration(
          color: dot.color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: dot.color.withAlpha(128),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(currentLatLngProvider);
    final trackingState = ref.watch(trackingProvider);
    final dotState = ref.watch(dotProvider);
    final settings = ref.watch(settingsProvider);
    final isDarkMode = settings.themeMode == ThemeMode.dark;

    // ダークモード時は暗い地図タイルを使用
    final tileUrl = isDarkMode
        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
        : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';

    // ユーザー追従
    if (_followUser && currentPosition != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          _mapController.move(currentPosition, _mapController.camera.zoom);
        } catch (_) {}
      });
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: currentPosition ?? const LatLng(35.6812, 139.7671),
            initialZoom: 16.0,
            maxZoom: 18.0,
            minZoom: 3.0,
            onPositionChanged: (position, hasGesture) {
              if (hasGesture) {
                setState(() => _followUser = false);
              }
            },
          ),
          children: [
            // CartoDB タイル（ダークモード対応）
            TileLayer(
              urlTemplate: tileUrl,
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.example.move_tracker',
              maxZoom: 19,
              retinaMode: RetinaMode.isHighDensity(context),
            ),

            // ドットマーカー（トラッキング中のみ表示）
            if (trackingState.isTracking && dotState.uncollectedDots.isNotEmpty)
              MarkerLayer(
                markers: dotState.uncollectedDots.map((dot) => _buildDotMarker(dot)).toList(),
              ),

            // 現在地マーカー
            if (currentPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentPosition,
                    width: 30,
                    height: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(76),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),

        // 現在地ボタン
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              setState(() => _followUser = true);
              if (currentPosition != null) {
                _mapController.move(currentPosition, 16.0);
              }
            },
            backgroundColor: _followUser ? Colors.blue : Colors.white,
            child: Icon(
              Icons.my_location,
              color: _followUser ? Colors.white : Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
