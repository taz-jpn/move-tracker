import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';

/// AppBarのactionsに配置する設定アイコンボタン群
class AppBarSettingsActions extends ConsumerWidget {
  const AppBarSettingsActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDarkMode = settings.themeMode == ThemeMode.dark;
    final isWakeLockOn = settings.wakeLockEnabled;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ダークモード切り替え
        IconButton(
          icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
          tooltip: isDarkMode ? l10n.switchToLightMode : l10n.switchToDarkMode,
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
          tooltip: isWakeLockOn ? l10n.enableAutoSleep : l10n.keepScreenOn,
          onPressed: () {
            ref.read(settingsProvider.notifier).toggleWakeLock();
          },
        ),
      ],
    );
  }
}
