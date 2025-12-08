import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../domain/entities/transport_mode.dart';
import '../../providers/location_provider.dart';
import '../../providers/tracking_provider.dart';

class MapWidget extends ConsumerStatefulWidget {
  const MapWidget({super.key});

  @override
  ConsumerState<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  final MapController _mapController = MapController();
  bool _followUser = true;

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(currentLatLngProvider);
    final trackingState = ref.watch(trackingProvider);

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
            // CartoDB Voyager タイル（シンプルで見やすい）
            TileLayer(
              urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.example.move_tracker',
              maxZoom: 19,
            ),

            // 軌跡ポリライン
            if (trackingState.trackPoints.isNotEmpty)
              PolylineLayer(
                polylines: _buildColoredPolylines(trackingState),
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

  List<Polyline> _buildColoredPolylines(TrackingState state) {
    if (state.trackPoints.isEmpty) return [];

    final polylines = <Polyline>[];
    var currentMode = state.trackPoints.first.mode;
    var currentSegmentPoints = <LatLng>[
      LatLng(state.trackPoints.first.latitude, state.trackPoints.first.longitude)
    ];

    for (int i = 1; i < state.trackPoints.length; i++) {
      final point = state.trackPoints[i];
      final latLng = LatLng(point.latitude, point.longitude);

      if (point.mode == currentMode) {
        currentSegmentPoints.add(latLng);
      } else {
        // セグメントを追加
        if (currentSegmentPoints.length >= 2) {
          polylines.add(Polyline(
            points: List.from(currentSegmentPoints),
            color: currentMode.color,
            strokeWidth: 5,
          ));
        }
        // 新しいセグメント開始
        currentMode = point.mode;
        currentSegmentPoints = [
          LatLng(
            state.trackPoints[i - 1].latitude,
            state.trackPoints[i - 1].longitude,
          ),
          latLng
        ];
      }
    }

    // 最後のセグメントを追加
    if (currentSegmentPoints.length >= 2) {
      polylines.add(Polyline(
        points: currentSegmentPoints,
        color: currentMode.color,
        strokeWidth: 5,
      ));
    }

    return polylines;
  }
}
