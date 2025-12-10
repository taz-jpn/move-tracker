import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

/// AppBarのactionsに配置する設定アイコンボタン群
class AppBarSettingsActions extends ConsumerWidget {
  const AppBarSettingsActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDarkMode = settings.themeMode == ThemeMode.dark;
    final isWakeLockOn = settings.wakeLockEnabled;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ダークモード切り替え
        IconButton(
          icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
          tooltip: isDarkMode ? 'ライトモードに切替' : 'ダークモードに切替',
          onPressed: () {
            ref.read(settingsProvider.notifier).toggleTheme();
          },
        ),
        // WakeLock切り替え
        IconButton(
          icon: Icon(
            isWakeLockOn ? Icons.lightbulb : Icons.lightbulb_outline,
            color: isWakeLockOn ? Colors.amber : null,
          ),
          tooltip: isWakeLockOn ? '自動消灯を有効化' : '画面を常時点灯',
          onPressed: () {
            ref.read(settingsProvider.notifier).toggleWakeLock();
          },
        ),
      ],
    );
  }
}
