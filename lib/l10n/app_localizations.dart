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
  /// In en, this message translates to:
  /// **'MoveTracker'**
  String get appTitle;

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

  /// No description provided for @tabScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get tabScore;

  /// No description provided for @tabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required'**
  String get locationPermissionRequired;

  /// No description provided for @requestPermission.
  ///
  /// In en, this message translates to:
  /// **'Request Permission'**
  String get requestPermission;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @enableLocationInSettings.
  ///
  /// In en, this message translates to:
  /// **'Please enable location permission in settings'**
  String get enableLocationInSettings;

  /// No description provided for @startTracking.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startTracking;

  /// No description provided for @stopTracking.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopTracking;

  /// No description provided for @stopTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop tracking?'**
  String get stopTrackingTitle;

  /// No description provided for @stopTrackingMessage.
  ///
  /// In en, this message translates to:
  /// **'This will end the current session and calculate your score.'**
  String get stopTrackingMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @transportMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get transportMode;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @dots.
  ///
  /// In en, this message translates to:
  /// **'Dots'**
  String get dots;

  /// No description provided for @stationary.
  ///
  /// In en, this message translates to:
  /// **'Stationary'**
  String get stationary;

  /// No description provided for @walking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get walking;

  /// No description provided for @cycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get cycling;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @totalScore.
  ///
  /// In en, this message translates to:
  /// **'Total Score'**
  String get totalScore;

  /// No description provided for @dotCollection.
  ///
  /// In en, this message translates to:
  /// **'Dot Collection'**
  String get dotCollection;

  /// No description provided for @bonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get bonus;

  /// No description provided for @scoreCalculation.
  ///
  /// In en, this message translates to:
  /// **'Score Calculation'**
  String get scoreCalculation;

  /// No description provided for @walkingScore.
  ///
  /// In en, this message translates to:
  /// **'Walking (3-6 km/h)'**
  String get walkingScore;

  /// No description provided for @cyclingScore.
  ///
  /// In en, this message translates to:
  /// **'Cycling (7-29 km/h)'**
  String get cyclingScore;

  /// No description provided for @vehicleScore.
  ///
  /// In en, this message translates to:
  /// **'Vehicle (30+ km/h)'**
  String get vehicleScore;

  /// No description provided for @scoreFormula.
  ///
  /// In en, this message translates to:
  /// **'Score = Duration (min) × Multiplier'**
  String get scoreFormula;

  /// No description provided for @dotCollectionBonus.
  ///
  /// In en, this message translates to:
  /// **'Dot Collection Bonus'**
  String get dotCollectionBonus;

  /// No description provided for @normalDot.
  ///
  /// In en, this message translates to:
  /// **'Normal Dot'**
  String get normalDot;

  /// No description provided for @silverDot.
  ///
  /// In en, this message translates to:
  /// **'Silver Dot'**
  String get silverDot;

  /// No description provided for @goldDot.
  ///
  /// In en, this message translates to:
  /// **'Gold Dot'**
  String get goldDot;

  /// No description provided for @dotCollectionNote.
  ///
  /// In en, this message translates to:
  /// **'* Collect at speed ≤30km/h within 30m'**
  String get dotCollectionNote;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No records'**
  String get noRecords;

  /// No description provided for @startTrackingFromMap.
  ///
  /// In en, this message translates to:
  /// **'Start tracking from the map screen'**
  String get startTrackingFromMap;

  /// No description provided for @switchToLightMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to Light Mode'**
  String get switchToLightMode;

  /// No description provided for @switchToDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to Dark Mode'**
  String get switchToDarkMode;

  /// No description provided for @enableAutoSleep.
  ///
  /// In en, this message translates to:
  /// **'Enable Auto Sleep'**
  String get enableAutoSleep;

  /// No description provided for @keepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep Screen On'**
  String get keepScreenOn;

  /// No description provided for @medals.
  ///
  /// In en, this message translates to:
  /// **'Medals'**
  String get medals;

  /// No description provided for @earned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earned;

  /// No description provided for @notEarned.
  ///
  /// In en, this message translates to:
  /// **'Not Earned'**
  String get notEarned;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @medalFirstStep.
  ///
  /// In en, this message translates to:
  /// **'First Step'**
  String get medalFirstStep;

  /// No description provided for @medalFirstStepDesc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 1km total'**
  String get medalFirstStepDesc;

  /// No description provided for @medalWalker.
  ///
  /// In en, this message translates to:
  /// **'Walker'**
  String get medalWalker;

  /// No description provided for @medalWalkerDesc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 10km total'**
  String get medalWalkerDesc;

  /// No description provided for @medalMarathoner.
  ///
  /// In en, this message translates to:
  /// **'Marathoner'**
  String get medalMarathoner;

  /// No description provided for @medalMarathonerDesc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 42.195km total'**
  String get medalMarathonerDesc;

  /// No description provided for @medal100kmClub.
  ///
  /// In en, this message translates to:
  /// **'100km Club'**
  String get medal100kmClub;

  /// No description provided for @medal100kmClubDesc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 100km total'**
  String get medal100kmClubDesc;

  /// No description provided for @medal3Days.
  ///
  /// In en, this message translates to:
  /// **'3-Day Streak'**
  String get medal3Days;

  /// No description provided for @medal3DaysDesc.
  ///
  /// In en, this message translates to:
  /// **'Record for 3 consecutive days'**
  String get medal3DaysDesc;

  /// No description provided for @medalWeeklyChampion.
  ///
  /// In en, this message translates to:
  /// **'Weekly Champion'**
  String get medalWeeklyChampion;

  /// No description provided for @medalWeeklyChampionDesc.
  ///
  /// In en, this message translates to:
  /// **'Record for 7 consecutive days'**
  String get medalWeeklyChampionDesc;

  /// No description provided for @medalMonthlyMaster.
  ///
  /// In en, this message translates to:
  /// **'Monthly Master'**
  String get medalMonthlyMaster;

  /// No description provided for @medalMonthlyMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Record for 30 consecutive days'**
  String get medalMonthlyMasterDesc;

  /// No description provided for @medalRookie.
  ///
  /// In en, this message translates to:
  /// **'Rookie'**
  String get medalRookie;

  /// No description provided for @medalRookieDesc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 100 points total'**
  String get medalRookieDesc;

  /// No description provided for @medalExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get medalExpert;

  /// No description provided for @medalExpertDesc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 1,000 points total'**
  String get medalExpertDesc;

  /// No description provided for @medalMaster.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get medalMaster;

  /// No description provided for @medalMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Achieve 10,000 points total'**
  String get medalMasterDesc;

  /// No description provided for @medalEarlyBird.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get medalEarlyBird;

  /// No description provided for @medalEarlyBirdDesc.
  ///
  /// In en, this message translates to:
  /// **'Start recording before 6am'**
  String get medalEarlyBirdDesc;

  /// No description provided for @medalNightWalker.
  ///
  /// In en, this message translates to:
  /// **'Night Walker'**
  String get medalNightWalker;

  /// No description provided for @medalNightWalkerDesc.
  ///
  /// In en, this message translates to:
  /// **'Record after 10pm'**
  String get medalNightWalkerDesc;

  /// No description provided for @dotsCollected.
  ///
  /// In en, this message translates to:
  /// **'{count} collected (+{score}pts)'**
  String dotsCollected(int count, int score);
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
