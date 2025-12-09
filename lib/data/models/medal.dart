import 'package:flutter/material.dart';

/// メダルの種類
enum MedalType {
  // 距離系
  firstStep,      // 累計1km
  walker,         // 累計10km
  marathoner,     // 累計42.195km
  club100km,      // 累計100km

  // 継続系
  streak3days,    // 3日連続
  streak7days,    // 7日連続
  streak30days,   // 30日連続

  // スコア系
  rookie,         // 累計100pt
  expert,         // 累計1,000pt
  master,         // 累計10,000pt

  // 特殊系
  earlyBird,      // 朝6時前に記録開始
  nightWalker,    // 夜10時以降に記録
}

/// メダルの定義
class MedalDefinition {
  final MedalType type;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const MedalDefinition({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

/// 全メダルの定義
class MedalDefinitions {
  static const Map<MedalType, MedalDefinition> all = {
    // 距離系
    MedalType.firstStep: MedalDefinition(
      type: MedalType.firstStep,
      name: 'ファーストステップ',
      description: '累計1kmを達成',
      icon: Icons.directions_walk,
      color: Color(0xFFCD7F32), // ブロンズ
    ),
    MedalType.walker: MedalDefinition(
      type: MedalType.walker,
      name: 'ウォーカー',
      description: '累計10kmを達成',
      icon: Icons.hiking,
      color: Color(0xFFC0C0C0), // シルバー
    ),
    MedalType.marathoner: MedalDefinition(
      type: MedalType.marathoner,
      name: 'マラソナー',
      description: '累計42.195kmを達成',
      icon: Icons.directions_run,
      color: Color(0xFFFFD700), // ゴールド
    ),
    MedalType.club100km: MedalDefinition(
      type: MedalType.club100km,
      name: '100kmクラブ',
      description: '累計100kmを達成',
      icon: Icons.military_tech,
      color: Color(0xFFE5E4E2), // プラチナ
    ),

    // 継続系
    MedalType.streak3days: MedalDefinition(
      type: MedalType.streak3days,
      name: '3日連続',
      description: '3日連続で記録',
      icon: Icons.local_fire_department,
      color: Color(0xFFFF6B35),
    ),
    MedalType.streak7days: MedalDefinition(
      type: MedalType.streak7days,
      name: '週間チャンピオン',
      description: '7日連続で記録',
      icon: Icons.emoji_events,
      color: Color(0xFFFFD700),
    ),
    MedalType.streak30days: MedalDefinition(
      type: MedalType.streak30days,
      name: '月間マスター',
      description: '30日連続で記録',
      icon: Icons.workspace_premium,
      color: Color(0xFFE5E4E2),
    ),

    // スコア系
    MedalType.rookie: MedalDefinition(
      type: MedalType.rookie,
      name: 'ルーキー',
      description: '累計100ポイントを達成',
      icon: Icons.star_outline,
      color: Color(0xFFCD7F32),
    ),
    MedalType.expert: MedalDefinition(
      type: MedalType.expert,
      name: 'エキスパート',
      description: '累計1,000ポイントを達成',
      icon: Icons.star_half,
      color: Color(0xFFC0C0C0),
    ),
    MedalType.master: MedalDefinition(
      type: MedalType.master,
      name: 'マスター',
      description: '累計10,000ポイントを達成',
      icon: Icons.star,
      color: Color(0xFFFFD700),
    ),

    // 特殊系
    MedalType.earlyBird: MedalDefinition(
      type: MedalType.earlyBird,
      name: '早起き',
      description: '朝6時前に記録を開始',
      icon: Icons.wb_sunny,
      color: Color(0xFFFF9800),
    ),
    MedalType.nightWalker: MedalDefinition(
      type: MedalType.nightWalker,
      name: 'ナイトウォーカー',
      description: '夜10時以降に記録',
      icon: Icons.nightlight_round,
      color: Color(0xFF3F51B5),
    ),
  };

  static MedalDefinition get(MedalType type) => all[type]!;
}

/// ユーザーが獲得したメダル
class UserMedal {
  final String id;
  final MedalType medalType;
  final DateTime earnedAt;

  UserMedal({
    required this.id,
    required this.medalType,
    required this.earnedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medal_type': medalType.index,
      'earned_at': earnedAt.millisecondsSinceEpoch,
    };
  }

  factory UserMedal.fromMap(Map<String, dynamic> map) {
    return UserMedal(
      id: map['id'] as String,
      medalType: MedalType.values[map['medal_type'] as int],
      earnedAt: DateTime.fromMillisecondsSinceEpoch(map['earned_at'] as int),
    );
  }

  MedalDefinition get definition => MedalDefinitions.get(medalType);
}
