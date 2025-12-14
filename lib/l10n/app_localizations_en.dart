// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MoveTracker';

  @override
  String get tabMap => 'Map';

  @override
  String get tabScore => 'Score';

  @override
  String get tabHistory => 'History';

  @override
  String get map => 'Map';

  @override
  String get score => 'Score';

  @override
  String get history => 'History';

  @override
  String get locationPermissionRequired => 'Location permission is required';

  @override
  String get requestPermission => 'Request Permission';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get enableLocationInSettings =>
      'Please enable location permission in settings';

  @override
  String get startTracking => 'Start';

  @override
  String get stopTracking => 'Stop';

  @override
  String get stopTrackingTitle => 'Stop tracking?';

  @override
  String get stopTrackingMessage =>
      'This will end the current session and calculate your score.';

  @override
  String get cancel => 'Cancel';

  @override
  String get stop => 'Stop';

  @override
  String get speed => 'Speed';

  @override
  String get transportMode => 'Mode';

  @override
  String get distance => 'Distance';

  @override
  String get time => 'Time';

  @override
  String get dots => 'Dots';

  @override
  String get stationary => 'Stationary';

  @override
  String get walking => 'Walking';

  @override
  String get cycling => 'Cycling';

  @override
  String get vehicle => 'Vehicle';

  @override
  String get totalScore => 'Total Score';

  @override
  String get dotCollection => 'Dot Collection';

  @override
  String get bonus => 'Bonus';

  @override
  String get scoreCalculation => 'Score Calculation';

  @override
  String get walkingScore => 'Walking (3-6 km/h)';

  @override
  String get cyclingScore => 'Cycling (7-29 km/h)';

  @override
  String get vehicleScore => 'Vehicle (30+ km/h)';

  @override
  String get scoreFormula => 'Score = Duration (min) × Multiplier';

  @override
  String get dotCollectionBonus => 'Dot Collection Bonus';

  @override
  String get normalDot => 'Normal Dot';

  @override
  String get silverDot => 'Silver Dot';

  @override
  String get goldDot => 'Gold Dot';

  @override
  String get dotCollectionNote => '* Collect at speed ≤30km/h within 30m';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get reload => 'Reload';

  @override
  String get noRecords => 'No records';

  @override
  String get startTrackingFromMap => 'Start tracking from the map screen';

  @override
  String get switchToLightMode => 'Switch to Light Mode';

  @override
  String get switchToDarkMode => 'Switch to Dark Mode';

  @override
  String get enableAutoSleep => 'Enable Auto Sleep';

  @override
  String get keepScreenOn => 'Keep Screen On';

  @override
  String get medals => 'Medals';

  @override
  String get earned => 'Earned';

  @override
  String get notEarned => 'Not Earned';

  @override
  String get close => 'Close';

  @override
  String get medalFirstStep => 'First Step';

  @override
  String get medalFirstStepDesc => 'Achieve 1km total';

  @override
  String get medalWalker => 'Walker';

  @override
  String get medalWalkerDesc => 'Achieve 10km total';

  @override
  String get medalMarathoner => 'Marathoner';

  @override
  String get medalMarathonerDesc => 'Achieve 42.195km total';

  @override
  String get medal100kmClub => '100km Club';

  @override
  String get medal100kmClubDesc => 'Achieve 100km total';

  @override
  String get medal3Days => '3-Day Streak';

  @override
  String get medal3DaysDesc => 'Record for 3 consecutive days';

  @override
  String get medalWeeklyChampion => 'Weekly Champion';

  @override
  String get medalWeeklyChampionDesc => 'Record for 7 consecutive days';

  @override
  String get medalMonthlyMaster => 'Monthly Master';

  @override
  String get medalMonthlyMasterDesc => 'Record for 30 consecutive days';

  @override
  String get medalRookie => 'Rookie';

  @override
  String get medalRookieDesc => 'Achieve 100 points total';

  @override
  String get medalExpert => 'Expert';

  @override
  String get medalExpertDesc => 'Achieve 1,000 points total';

  @override
  String get medalMaster => 'Master';

  @override
  String get medalMasterDesc => 'Achieve 10,000 points total';

  @override
  String get medalEarlyBird => 'Early Bird';

  @override
  String get medalEarlyBirdDesc => 'Start recording before 6am';

  @override
  String get medalNightWalker => 'Night Walker';

  @override
  String get medalNightWalkerDesc => 'Record after 10pm';

  @override
  String dotsCollected(int count, int score) {
    return '$count collected (+${score}pts)';
  }
}
