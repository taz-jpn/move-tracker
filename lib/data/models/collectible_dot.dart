import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// ドットの種類
enum DotType {
  normal,  // 通常（黄色）
  silver,  // シルバー
  gold,    // ゴールド
}

extension DotTypeExtension on DotType {
  /// ドットのスコア
  int get score {
    switch (this) {
      case DotType.normal:
        return 10;
      case DotType.silver:
        return 30;
      case DotType.gold:
        return 100;
    }
  }

  /// ドットの色
  Color get color {
    switch (this) {
      case DotType.normal:
        return const Color(0xFFFFD700); // ゴールデンイエロー
      case DotType.silver:
        return const Color(0xFFC0C0C0); // シルバー
      case DotType.gold:
        return const Color(0xFFFF8C00); // ダークオレンジ（目立つ）
    }
  }

  /// ドットのサイズ
  double get size {
    switch (this) {
      case DotType.normal:
        return 12;
      case DotType.silver:
        return 14;
      case DotType.gold:
        return 18;
    }
  }
}

/// 収集可能なドット
class CollectibleDot {
  final String id;
  final LatLng position;
  final DotType type;
  final DateTime createdAt;
  bool collected;

  CollectibleDot({
    required this.id,
    required this.position,
    required this.type,
    required this.createdAt,
    this.collected = false,
  });

  /// スコアを取得
  int get score => type.score;

  /// 色を取得
  Color get color => type.color;

  /// サイズを取得
  double get size => type.size;
}
