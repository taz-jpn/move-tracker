import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

/// アプリ上部のステータスバー
class AppStatusBar extends ConsumerWidget {
  const AppStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDarkMode = settings.themeMode == ThemeMode.dark;
    final isWakeLockOn = settings.wakeLockEnabled;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ダークモード切り替え
          _StatusButton(
            icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
            label: isDarkMode ? 'ダーク' : 'ライト',
            isActive: isDarkMode,
            onTap: () {
              ref.read(settingsProvider.notifier).toggleTheme();
            },
          ),
          // WakeLock切り替え
          _StatusButton(
            icon: isWakeLockOn ? Icons.lightbulb : Icons.lightbulb_outline,
            label: isWakeLockOn ? '点灯' : '自動',
            isActive: isWakeLockOn,
            onTap: () {
              ref.read(settingsProvider.notifier).toggleWakeLock();
            },
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? activeColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? activeColor : inactiveColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
