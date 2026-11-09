// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortugueseBrazil => 'Português (Brasil)';

  @override
  String get languagePreferenceNotSaved =>
      'Language changed for this session, but the preference could not be saved.';

  @override
  String get menu => 'Menu';

  @override
  String get youGroup => 'YOU';

  @override
  String get appGroup => 'APP';

  @override
  String get settings => 'Settings';

  @override
  String get languageMenu => 'Language';

  @override
  String get integrations => 'Integrations';

  @override
  String get privacy => 'Privacy';

  @override
  String get help => 'Help';

  @override
  String get signOut => 'Sign out';

  @override
  String get deviceConnected => 'Connected · 5 min ago';

  @override
  String get diary => 'Diary';

  @override
  String get journey => 'Journey';

  @override
  String get activities => 'Activities';

  @override
  String get community => 'Community';

  @override
  String get goals => 'Goals';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get atlas => 'Atlas';

  @override
  String get health => 'Health';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get loading => 'Loading';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get history => 'History';

  @override
  String get quickActionsHeading => 'QUICK ACTIONS';

  @override
  String get quickActionsSuggestion =>
      'For this morning, BYND suggests 15 minutes of sunlight before work.';

  @override
  String get quickActionsSuggestionAfternoon =>
      'For this afternoon, BYND suggests taking a pause to breathe.';

  @override
  String get quickActionsSuggestionEvening =>
      'For tonight, BYND suggests taking a moment to breathe before bed.';

  @override
  String get breatheFiveMinutes => 'Breathe\n5 min';

  @override
  String get logMeal => 'Log\nmeal';

  @override
  String get startActivity => 'Start\nactivity';

  @override
  String get reviewDay => 'How was\nyour day';

  @override
  String get logActivity => 'Log\nactivity';

  @override
  String get doEcg => 'Take an\nECG';

  @override
  String comingSoon(Object feature) {
    return '$feature: coming soon.';
  }

  @override
  String get activityRegisterComingSoon => 'Activity logging: coming soon.';

  @override
  String get sectionComingSoon => 'This section will be available soon.';

  @override
  String get activityHistoryComingSoon => 'Activity history: coming soon.';

  @override
  String get activityUnavailableHeading => 'DATA UNAVAILABLE';

  @override
  String get activityUnavailableTitle => 'Your activity data will appear here.';

  @override
  String get activityUnavailableDescription =>
      'Data integration and load calculation are not available yet.';

  @override
  String get dayInNumbers => 'Your day in numbers';

  @override
  String get dailyMetricsUnavailable => 'Daily metrics are not integrated yet.';

  @override
  String get modalities => 'Activities';

  @override
  String get recentModalitiesUnavailable =>
      'Your recent activities will appear here.';

  @override
  String get todayActivities => 'Today\'s activities';

  @override
  String get noSyncedActivity => 'No synced activity.';

  @override
  String get todayPlanPrompt => 'What are we doing today?';

  @override
  String get register => 'Log activity';

  @override
  String get startActivityTitle => 'Start activity';

  @override
  String searchActivities(Object count) {
    return 'Search $count activities';
  }

  @override
  String get recent => 'Recent';

  @override
  String get categoryCardio => 'Cardio';

  @override
  String get categoryStrength => 'Strength';

  @override
  String get categorySports => 'Sports';

  @override
  String get categoryCombat => 'Combat';

  @override
  String get categoryAquatic => 'Aquatic';

  @override
  String get categoryMindBody => 'Mind & body';

  @override
  String get categoryRecovery => 'Recovery';

  @override
  String get categoryOther => 'Other';

  @override
  String get activityHintHyrox => '16 race stations';

  @override
  String get activityHintRaceStages => '5 race stages';

  @override
  String get activityHintPoolPace => 'pool and pace';

  @override
  String get activityHintGps => 'with GPS';

  @override
  String get activityHintSetsWeight => 'sets and weight';

  @override
  String get activityHintRounds => 'rounds';

  @override
  String get activityHintGameTime => 'game time';

  @override
  String get activityHintHeartRateNoMovement => 'heart rate, no movement';

  @override
  String get activityHintBreathingCalm => 'breathing and calm';

  @override
  String get activityHintStepsMovement => 'steps and movement';

  @override
  String get activityHintMachineDistance => 'machine distance';

  @override
  String get activityHintTimeHeartRate => 'time and heart rate';

  @override
  String noActivityMatches(Object query) {
    return 'No activity matches “$query”. Try “Other”.';
  }

  @override
  String get closeCalendar => 'Close calendar';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get goodRecovery => 'good recovery';

  @override
  String get mediumRecovery => 'moderate recovery';

  @override
  String get lowRecovery => 'low recovery';

  @override
  String get preparationClose => 'Close preparation';

  @override
  String get watchNotIntegrated => 'Wristband not connected';

  @override
  String get heartRateBatteryUnavailable =>
      'Heart rate and battery unavailable';

  @override
  String get routeRecording => 'Record route';

  @override
  String get gpsUnavailable => 'GPS is unavailable; no route will be recorded';

  @override
  String get startActivityButton => 'Start activity';

  @override
  String get waitingForSensors => 'Waiting for sensor and session integration';

  @override
  String get weatherUnavailable => 'Weather unavailable';

  @override
  String get weatherNotIntegrated =>
      'Location and weather service are not integrated';

  @override
  String get suggestedLoadUnavailable => 'Suggested load unavailable';

  @override
  String get loadNotIntegrated =>
      'Load data and calculation are not integrated yet';

  @override
  String get howToStart => 'How would you like to start?';

  @override
  String get startWithoutPlan => 'Start without a plan';

  @override
  String get exercisesCanBeAddedLater => 'Exercises can be added later';

  @override
  String get yourWorkouts => 'Your workouts';

  @override
  String get savedWorkoutsUnavailable => 'Saved workouts are not available yet';

  @override
  String get savedWorkoutsNotConnected =>
      'Saved workouts are not connected in this app';

  @override
  String get otherWays => 'Other options';

  @override
  String get buildWorkout => 'Build a new workout';

  @override
  String get workoutEditorNotIntegrated =>
      'Exercise, set, and weight editor is not integrated';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get profile => 'Profile';

  @override
  String get profileMembership => 'Brasília · with BYND for 2 months';

  @override
  String get birthDateValue => 'Apr 17, 1992';

  @override
  String get profileEditComingSoon => 'Profile editing: coming soon.';

  @override
  String get age => 'Age';

  @override
  String get years => 'years';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get yourData => 'YOUR DATA';

  @override
  String get birthDate => 'Date of birth';

  @override
  String get biologicalSex => 'Biological sex';

  @override
  String get female => 'Female';

  @override
  String get city => 'City';

  @override
  String get goal => 'Goal';

  @override
  String get loseFatKeepMuscle => 'Lose fat while maintaining muscle';

  @override
  String get units => 'Units';

  @override
  String get metric => 'Metric';

  @override
  String get account => 'ACCOUNT';

  @override
  String get wristband => 'Wristband';

  @override
  String get wristbandConnectedSince =>
      'BYND ONE · connected since Sep 9, 2026';

  @override
  String connectedDeviceComingSoon(Object device) {
    return '$device: coming soon.';
  }

  @override
  String get calendarWeekdayMon => 'Mon';

  @override
  String get calendarWeekdayTue => 'Tue';

  @override
  String get calendarWeekdayWed => 'Wed';

  @override
  String get calendarWeekdayThu => 'Thu';

  @override
  String get calendarWeekdayFri => 'Fri';

  @override
  String get calendarWeekdaySat => 'Sat';

  @override
  String get calendarWeekdaySun => 'Sun';
}
