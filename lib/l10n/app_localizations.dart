import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ja, this message translates to:
  /// **'MoveTracker'**
  String get appTitle;

  /// No description provided for @tabMap.
  ///
  /// In ja, this message translates to:
  /// **'マップ'**
  String get tabMap;

  /// No description provided for @tabScore.
  ///
  /// In ja, this message translates to:
  /// **'スコア'**
  String get tabScore;

  /// No description provided for @tabHistory.
  ///
  /// In ja, this message translates to:
  /// **'履歴'**
  String get tabHistory;

  /// No description provided for @map.
  ///
  /// In ja, this message translates to:
  /// **'マップ'**
  String get map;

  /// No description provided for @score.
  ///
  /// In ja, this message translates to:
  /// **'スコア'**
  String get score;

  /// No description provided for @history.
  ///
  /// In ja, this message translates to:
  /// **'履歴'**
  String get history;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In ja, this message translates to:
  /// **'位置情報の権限が必要です'**
  String get locationPermissionRequired;

  /// No description provided for @requestPermission.
  ///
  /// In ja, this message translates to:
  /// **'権限をリクエスト'**
  String get requestPermission;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In ja, this message translates to:
  /// **'位置情報の権限が拒否されました'**
  String get locationPermissionDenied;

  /// No description provided for @enableLocationInSettings.
  ///
  /// In ja, this message translates to:
  /// **'設定から位置情報の権限を許可してください'**
  String get enableLocationInSettings;

  /// No description provided for @startTracking.
  ///
  /// In ja, this message translates to:
  /// **'記録開始'**
  String get startTracking;

  /// No description provided for @stopTracking.
  ///
  /// In ja, this message translates to:
  /// **'記録停止'**
  String get stopTracking;

  /// No description provided for @stopTrackingTitle.
  ///
  /// In ja, this message translates to:
  /// **'記録を停止しますか？'**
  String get stopTrackingTitle;

  /// No description provided for @stopTrackingMessage.
  ///
  /// In ja, this message translates to:
  /// **'現在のセッションを終了してスコアを計算します。'**
  String get stopTrackingMessage;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @stop.
  ///
  /// In ja, this message translates to:
  /// **'停止'**
  String get stop;

  /// No description provided for @speed.
  ///
  /// In ja, this message translates to:
  /// **'速度'**
  String get speed;

  /// No description provided for @transportMode.
  ///
  /// In ja, this message translates to:
  /// **'移動手段'**
  String get transportMode;

  /// No description provided for @distance.
  ///
  /// In ja, this message translates to:
  /// **'距離'**
  String get distance;

  /// No description provided for @time.
  ///
  /// In ja, this message translates to:
  /// **'時間'**
  String get time;

  /// No description provided for @dots.
  ///
  /// In ja, this message translates to:
  /// **'ドット'**
  String get dots;

  /// No description provided for @stationary.
  ///
  /// In ja, this message translates to:
  /// **'停止中'**
  String get stationary;

  /// No description provided for @walking.
  ///
  /// In ja, this message translates to:
  /// **'徒歩'**
  String get walking;

  /// No description provided for @cycling.
  ///
  /// In ja, this message translates to:
  /// **'自転車'**
  String get cycling;

  /// No description provided for @vehicle.
  ///
  /// In ja, this message translates to:
  /// **'車・列車'**
  String get vehicle;

  /// No description provided for @totalScore.
  ///
  /// In ja, this message translates to:
  /// **'合計スコア'**
  String get totalScore;

  /// No description provided for @dotCollection.
  ///
  /// In ja, this message translates to:
  /// **'ドット収集'**
  String get dotCollection;

  /// No description provided for @bonus.
  ///
  /// In ja, this message translates to:
  /// **'ボーナス'**
  String get bonus;

  /// No description provided for @scoreCalculation.
  ///
  /// In ja, this message translates to:
  /// **'スコアの計算方法'**
  String get scoreCalculation;

  /// No description provided for @walkingScore.
  ///
  /// In ja, this message translates to:
  /// **'徒歩 (3-6 km/h)'**
  String get walkingScore;

  /// No description provided for @cyclingScore.
  ///
  /// In ja, this message translates to:
  /// **'自転車 (7-29 km/h)'**
  String get cyclingScore;

  /// No description provided for @vehicleScore.
  ///
  /// In ja, this message translates to:
  /// **'車・列車 (30+ km/h)'**
  String get vehicleScore;

  /// No description provided for @scoreFormula.
  ///
  /// In ja, this message translates to:
  /// **'移動スコア = 移動時間(分) × 倍率'**
  String get scoreFormula;

  /// No description provided for @dotCollectionBonus.
  ///
  /// In ja, this message translates to:
  /// **'ドット収集ボーナス'**
  String get dotCollectionBonus;

  /// No description provided for @normalDot.
  ///
  /// In ja, this message translates to:
  /// **'通常ドット'**
  String get normalDot;

  /// No description provided for @silverDot.
  ///
  /// In ja, this message translates to:
  /// **'シルバードット'**
  String get silverDot;

  /// No description provided for @goldDot.
  ///
  /// In ja, this message translates to:
  /// **'ゴールドドット'**
  String get goldDot;

  /// No description provided for @dotCollectionNote.
  ///
  /// In ja, this message translates to:
  /// **'※ 速度30km/h以下、30m以内で収集可能'**
  String get dotCollectionNote;

  /// No description provided for @error.
  ///
  /// In ja, this message translates to:
  /// **'エラー: {message}'**
  String error(String message);

  /// No description provided for @reload.
  ///
  /// In ja, this message translates to:
  /// **'再読み込み'**
  String get reload;

  /// No description provided for @noRecords.
  ///
  /// In ja, this message translates to:
  /// **'記録がありません'**
  String get noRecords;

  /// No description provided for @startTrackingFromMap.
  ///
  /// In ja, this message translates to:
  /// **'地図画面から記録を開始してください'**
  String get startTrackingFromMap;

  /// No description provided for @switchToLightMode.
  ///
  /// In ja, this message translates to:
  /// **'ライトモードに切替'**
  String get switchToLightMode;

  /// No description provided for @switchToDarkMode.
  ///
  /// In ja, this message translates to:
  /// **'ダークモードに切替'**
  String get switchToDarkMode;

  /// No description provided for @enableAutoSleep.
  ///
  /// In ja, this message translates to:
  /// **'自動消灯を有効化'**
  String get enableAutoSleep;

  /// No description provided for @keepScreenOn.
  ///
  /// In ja, this message translates to:
  /// **'画面を常時点灯'**
  String get keepScreenOn;

  /// No description provided for @medals.
  ///
  /// In ja, this message translates to:
  /// **'メダル'**
  String get medals;

  /// No description provided for @earned.
  ///
  /// In ja, this message translates to:
  /// **'獲得済み'**
  String get earned;

  /// No description provided for @notEarned.
  ///
  /// In ja, this message translates to:
  /// **'未獲得'**
  String get notEarned;

  /// No description provided for @close.
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get close;

  /// No description provided for @medalFirstStep.
  ///
  /// In ja, this message translates to:
  /// **'ファーストステップ'**
  String get medalFirstStep;

  /// No description provided for @medalFirstStepDesc.
  ///
  /// In ja, this message translates to:
  /// **'累計1kmを達成'**
  String get medalFirstStepDesc;

  /// No description provided for @medalWalker.
  ///
  /// In ja, this message translates to:
  /// **'ウォーカー'**
  String get medalWalker;

  /// No description provided for @medalWalkerDesc.
  ///
  /// In ja, this message translates to:
  /// **'累計10kmを達成'**
  String get medalWalkerDesc;

  /// No description provided for @medalMarathoner.
  ///
  /// In ja, this message translates to:
  /// **'マラソナー'**
  String get medalMarathoner;

  /// No description provided for @medalMarathonerDesc.
  ///
  /// In ja, this message translates to:
  /// **'累計42.195kmを達成'**
  String get medalMarathonerDesc;

  /// No description provided for @medal100kmClub.
  ///
  /// In ja, this message translates to:
  /// **'100kmクラブ'**
  String get medal100kmClub;

  /// No description provided for @medal100kmClubDesc.
  ///
  /// In ja, this message translates to:
  /// **'累計100kmを達成'**
  String get medal100kmClubDesc;

  /// No description provided for @medal3Days.
  ///
  /// In ja, this message translates to:
  /// **'3日連続'**
  String get medal3Days;

  /// No description provided for @medal3DaysDesc.
  ///
  /// In ja, this message translates to:
  /// **'3日連続で記録'**
  String get medal3DaysDesc;

  /// No description provided for @medalWeeklyChampion.
  ///
  /// In ja, this message translates to:
  /// **'週間チャンピオン'**
  String get medalWeeklyChampion;

  /// No description provided for @medalWeeklyChampionDesc.
  ///
  /// In ja, this message translates to:
  /// **'7日連続で記録'**
  String get medalWeeklyChampionDesc;

  /// No description provided for @medalMonthlyMaster.
  ///
  /// In ja, this message translates to:
  /// **'月間マスター'**
  String get medalMonthlyMaster;

  /// No description provided for @medalMonthlyMasterDesc.
  ///
  /// In ja, this message translates to:
  /// **'30日連続で記録'**
  String get medalMonthlyMasterDesc;

  /// No description provided for @medalRookie.
  ///
  /// In ja, this message translates to:
  /// **'ルーキー'**
  String get medalRookie;

  /// No description provided for @medalRookieDesc.
  ///
  /// In ja, this message translates to:
  /// **'累計100ポイントを達成'**
  String get medalRookieDesc;

  /// No description provided for @medalExpert.
  ///
  /// In ja, this message translates to:
  /// **'エキスパート'**
  String get medalExpert;

  /// No description provided for @medalExpertDesc.
  ///
  /// In ja, this message translates to:
  /// **'累計1,000ポイントを達成'**
  String get medalExpertDesc;

  /// No description provided for @medalMaster.
  ///
  /// In ja, this message translates to:
  /// **'マスター'**
  String get medalMaster;

  /// No description provided for @medalMasterDesc.
  ///
  /// In ja, this message translates to:
  /// **'累計10,000ポイントを達成'**
  String get medalMasterDesc;

  /// No description provided for @medalEarlyBird.
  ///
  /// In ja, this message translates to:
  /// **'早起き'**
  String get medalEarlyBird;

  /// No description provided for @medalEarlyBirdDesc.
  ///
  /// In ja, this message translates to:
  /// **'朝6時前に記録を開始'**
  String get medalEarlyBirdDesc;

  /// No description provided for @medalNightWalker.
  ///
  /// In ja, this message translates to:
  /// **'ナイトウォーカー'**
  String get medalNightWalker;

  /// No description provided for @medalNightWalkerDesc.
  ///
  /// In ja, this message translates to:
  /// **'夜10時以降に記録'**
  String get medalNightWalkerDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
