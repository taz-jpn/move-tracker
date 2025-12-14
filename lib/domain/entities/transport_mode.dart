import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/speed_thresholds.dart';
import '../../l10n/app_localizations.dart';

enum TransportMode {
  stationary,
  walking,
  cycling,
  vehicle,
}

extension TransportModeExtension on TransportMode {
  String get displayName {
    switch (this) {
      case TransportMode.stationary:
        return '停止中';
      case TransportMode.walking:
        return '徒歩';
      case TransportMode.cycling:
        return '自転車';
      case TransportMode.vehicle:
        return '車・列車';
    }
  }

  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case TransportMode.stationary:
        return l10n.stationary;
      case TransportMode.walking:
        return l10n.walking;
      case TransportMode.cycling:
        return l10n.cycling;
      case TransportMode.vehicle:
        return l10n.vehicle;
    }
  }

  String get icon {
    switch (this) {
      case TransportMode.stationary:
        return '⏸';
      case TransportMode.walking:
        return '🚶';
      case TransportMode.cycling:
        return '🚴';
      case TransportMode.vehicle:
        return '🚗';
    }
  }

  Color get color {
    switch (this) {
      case TransportMode.stationary:
        return AppColors.stationary;
      case TransportMode.walking:
        return AppColors.walking;
      case TransportMode.cycling:
        return AppColors.cycling;
      case TransportMode.vehicle:
        return AppColors.vehicle;
    }
  }

  double get scoreMultiplier {
    switch (this) {
      case TransportMode.stationary:
        return SpeedThresholds.stationaryMultiplier;
      case TransportMode.walking:
        return SpeedThresholds.walkingMultiplier;
      case TransportMode.cycling:
        return SpeedThresholds.cyclingMultiplier;
      case TransportMode.vehicle:
        return SpeedThresholds.vehicleMultiplier;
    }
  }

  static TransportMode fromSpeed(double speedKmh) {
    if (speedKmh < SpeedThresholds.stationaryMax) {
      return TransportMode.stationary;
    } else if (speedKmh <= SpeedThresholds.walkingMax) {
      return TransportMode.walking;
    } else if (speedKmh <= SpeedThresholds.cyclingMax) {
      return TransportMode.cycling;
    } else {
      return TransportMode.vehicle;
    }
  }
}
