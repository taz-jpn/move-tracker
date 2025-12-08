import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/transport_mode.dart';

class SpeedIndicator extends StatelessWidget {
  final double speed;
  final TransportMode mode;
  final double distance;
  final int duration;

  const SpeedIndicator({
    super.key,
    required this.speed,
    required this.mode,
    required this.distance,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            icon: Icons.speed,
            label: '速度',
            value: Formatters.formatSpeed(speed),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ),
          _buildItem(
            icon: _getModeIcon(mode),
            label: '移動手段',
            value: mode.displayName,
            color: mode.color,
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ),
          _buildItem(
            icon: Icons.straighten,
            label: '距離',
            value: Formatters.formatDistance(distance),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ),
          _buildItem(
            icon: Icons.timer,
            label: '時間',
            value: Formatters.formatDuration(duration),
          ),
        ],
      ),
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

  Widget _buildItem({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color ?? Colors.grey[600], size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: color ?? Colors.black87,
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
}
