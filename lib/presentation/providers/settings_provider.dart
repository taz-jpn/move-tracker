import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// 設定のキー
class SettingsKeys {
  static const String themeMode = 'theme_mode';
  static const String wakeLockEnabled = 'wake_lock_enabled';
}

/// アプリ設定の状態
class AppSettings {
  final ThemeMode themeMode;
  final bool wakeLockEnabled;

  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.wakeLockEnabled = false,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? wakeLockEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      wakeLockEnabled: wakeLockEnabled ?? this.wakeLockEnabled,
    );
  }
}

/// 設定を管理するNotifier
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // テーマモードを読み込み
    final themeModeIndex = prefs.getInt(SettingsKeys.themeMode) ?? 1; // default: light
    final themeMode = ThemeMode.values[themeModeIndex];

    // WakeLock設定を読み込み
    final wakeLockEnabled = prefs.getBool(SettingsKeys.wakeLockEnabled) ?? false;

    state = AppSettings(
      themeMode: themeMode,
      wakeLockEnabled: wakeLockEnabled,
    );

    // WakeLockを適用
    if (wakeLockEnabled) {
      await WakelockPlus.enable();
    }
  }

  /// テーマモードを切り替え
  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    state = state.copyWith(themeMode: newMode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SettingsKeys.themeMode, newMode.index);
  }

  /// WakeLockを切り替え
  Future<void> toggleWakeLock() async {
    final newValue = !state.wakeLockEnabled;

    if (newValue) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }

    state = state.copyWith(wakeLockEnabled: newValue);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SettingsKeys.wakeLockEnabled, newValue);
  }
}

/// 設定プロバイダー
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

/// テーマモードのみを取得するプロバイダー
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).themeMode;
});

/// WakeLock状態のみを取得するプロバイダー
final wakeLockEnabledProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).wakeLockEnabled;
});
