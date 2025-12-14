import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/transport_mode.dart';
import '../../../l10n/app_localizations.dart';

class SpeedIndicator extends StatelessWidget {
  final double speed;
  final TransportMode mode;
  final double distance;
  final int duration;
  final int dotCount;
  final int dotScore;

  const SpeedIndicator({
    super.key,
    required this.speed,
    required this.mode,
    required this.distance,
    required this.duration,
    this.dotCount = 0,
    this.dotScore = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.colorScheme.surface;
    final dividerColor = theme.dividerColor;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(50) : Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            context: context,
            icon: Icons.speed,
            label: l10n.speed,
            value: Formatters.formatSpeed(speed),
          ),
          Container(
            height: 40,
            width: 1,
            color: dividerColor,
          ),
          _buildItem(
            context: context,
            icon: _getModeIcon(mode),
            label: l10n.transportMode,
            value: mode.getDisplayName(l10n),
            color: mode.color,
          ),
          Container(
            height: 40,
            width: 1,
            color: dividerColor,
          ),
          _buildItem(
            context: context,
            icon: Icons.straighten,
            label: l10n.distance,
            value: Formatters.formatDistance(distance),
          ),
          Container(
            height: 40,
            width: 1,
            color: dividerColor,
          ),
          _buildItem(
            context: context,
            icon: Icons.timer,
            label: l10n.time,
            value: Formatters.formatDuration(duration),
          ),
          if (dotCount > 0) ...[
            Container(
              height: 40,
              width: 1,
              color: dividerColor,
            ),
            _buildItem(
              context: context,
              icon: Icons.circle,
              label: l10n.dots,
              value: '$dotCount (+$dotScore)',
              color: const Color(0xFFFFD700),
            ),
          ],
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
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.onSurface;
    final labelColor = theme.colorScheme.onSurfaceVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color ?? labelColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: color ?? defaultColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}
