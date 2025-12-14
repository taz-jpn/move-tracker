// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'MoveTracker';

  @override
  String get tabMap => 'マップ';

  @override
  String get tabScore => 'スコア';

  @override
  String get tabHistory => '履歴';

  @override
  String get map => 'マップ';

  @override
  String get score => 'スコア';

  @override
  String get history => '履歴';

  @override
  String get locationPermissionRequired => '位置情報の権限が必要です';

  @override
  String get requestPermission => '権限をリクエスト';

  @override
  String get locationPermissionDenied => '位置情報の権限が拒否されました';

  @override
  String get enableLocationInSettings => '設定から位置情報の権限を許可してください';

  @override
  String get startTracking => '記録開始';

  @override
  String get stopTracking => '記録停止';

  @override
  String get stopTrackingTitle => '記録を停止しますか？';

  @override
  String get stopTrackingMessage => '現在のセッションを終了してスコアを計算します。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get stop => '停止';

  @override
  String get speed => '速度';

  @override
  String get transportMode => '移動手段';

  @override
  String get distance => '距離';

  @override
  String get time => '時間';

  @override
  String get dots => 'ドット';

  @override
  String get stationary => '停止中';

  @override
  String get walking => '徒歩';

  @override
  String get cycling => '自転車';

  @override
  String get vehicle => '車・列車';

  @override
  String get totalScore => '合計スコア';

  @override
  String get dotCollection => 'ドット収集';

  @override
  String get bonus => 'ボーナス';

  @override
  String get scoreCalculation => 'スコアの計算方法';

  @override
  String get walkingScore => '徒歩 (3-6 km/h)';

  @override
  String get cyclingScore => '自転車 (7-29 km/h)';

  @override
  String get vehicleScore => '車・列車 (30+ km/h)';

  @override
  String get scoreFormula => '移動スコア = 移動時間(分) × 倍率';

  @override
  String get dotCollectionBonus => 'ドット収集ボーナス';

  @override
  String get normalDot => '通常ドット';

  @override
  String get silverDot => 'シルバードット';

  @override
  String get goldDot => 'ゴールドドット';

  @override
  String get dotCollectionNote => '※ 速度30km/h以下、30m以内で収集可能';

  @override
  String error(String message) {
    return 'エラー: $message';
  }

  @override
  String get reload => '再読み込み';

  @override
  String get noRecords => '記録がありません';

  @override
  String get startTrackingFromMap => '地図画面から記録を開始してください';

  @override
  String get switchToLightMode => 'ライトモードに切替';

  @override
  String get switchToDarkMode => 'ダークモードに切替';

  @override
  String get enableAutoSleep => '自動消灯を有効化';

  @override
  String get keepScreenOn => '画面を常時点灯';

  @override
  String get medals => 'メダル';

  @override
  String get earned => '獲得済み';

  @override
  String get notEarned => '未獲得';

  @override
  String get close => '閉じる';

  @override
  String get medalFirstStep => 'ファーストステップ';

  @override
  String get medalFirstStepDesc => '累計1kmを達成';

  @override
  String get medalWalker => 'ウォーカー';

  @override
  String get medalWalkerDesc => '累計10kmを達成';

  @override
  String get medalMarathoner => 'マラソナー';

  @override
  String get medalMarathonerDesc => '累計42.195kmを達成';

  @override
  String get medal100kmClub => '100kmクラブ';

  @override
  String get medal100kmClubDesc => '累計100kmを達成';

  @override
  String get medal3Days => '3日連続';

  @override
  String get medal3DaysDesc => '3日連続で記録';

  @override
  String get medalWeeklyChampion => '週間チャンピオン';

  @override
  String get medalWeeklyChampionDesc => '7日連続で記録';

  @override
  String get medalMonthlyMaster => '月間マスター';

  @override
  String get medalMonthlyMasterDesc => '30日連続で記録';

  @override
  String get medalRookie => 'ルーキー';

  @override
  String get medalRookieDesc => '累計100ポイントを達成';

  @override
  String get medalExpert => 'エキスパート';

  @override
  String get medalExpertDesc => '累計1,000ポイントを達成';

  @override
  String get medalMaster => 'マスター';

  @override
  String get medalMasterDesc => '累計10,000ポイントを達成';

  @override
  String get medalEarlyBird => '早起き';

  @override
  String get medalEarlyBirdDesc => '朝6時前に記録を開始';

  @override
  String get medalNightWalker => 'ナイトウォーカー';

  @override
  String get medalNightWalkerDesc => '夜10時以降に記録';

  @override
  String dotsCollected(int count, int score) {
    return '$count個収集 (+${score}pts)';
  }
}
