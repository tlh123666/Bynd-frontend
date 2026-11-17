// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get exerciseDetailCountAs => 'Measured as';

  @override
  String get exerciseDetailSeconds => 'seconds';

  @override
  String get exerciseDetailMinutes => 'minutes';

  @override
  String get exerciseDetailRepsBody => 'repetitions (bodyweight)';

  @override
  String get exerciseDetailRepsWeight => 'repetitions × weight';

  @override
  String get exerciseDetailTitle => 'Exercise';

  @override
  String exerciseDetailHow(String name) {
    return 'How to do: $name';
  }

  @override
  String get exerciseDetailMark => 'Mark to add';

  @override
  String get exerciseDetailMuscles => 'Muscles';

  @override
  String get exerciseDetailEquipment => 'Equipment';

  @override
  String get exerciseDetailGroup => 'Group';

  @override
  String get exerciseDetailLevel => 'Level';

  @override
  String exerciseDetailAnimation(String name) {
    return 'Animation: $name';
  }

  @override
  String get exerciseDetailNoAnimation =>
      'Animation not available for this exercise.';

  @override
  String get exerciseConfirmEmpty => 'Confirm';

  @override
  String get exerciseSelectorTitle => 'Select exercises';

  @override
  String get exerciseSearch => 'Search exercise or muscle';

  @override
  String get exerciseAll => 'All';

  @override
  String get exerciseMark => 'Select exercises';

  @override
  String exerciseAdd(int count) {
    return 'Add ($count)';
  }

  @override
  String exerciseCount(int count) {
    return '$count exercises';
  }

  @override
  String get exerciseEmpty => 'No exercises found.';

  @override
  String get exerciseLoadError => 'Could not load exercises.';

  @override
  String get exerciseRetry => 'Try again';

  @override
  String exerciseSelectedCount(int count) {
    return '$count exercises selected · demo';
  }

  @override
  String get exerciseDraftNote => 'Local preview · saving is not connected yet';

  @override
  String get exerciseAddMore => 'Add exercise';

  @override
  String get workoutLocalNote => 'Stored on this device only · not synced';

  @override
  String get workoutDefaultsNote => 'Example starting values';

  @override
  String get workoutSaveError =>
      'Could not save on this device. Please try again.';

  @override
  String get workoutLoadError => 'Could not load local workouts.';

  @override
  String get workoutReplaceExercise => 'Replace exercise';

  @override
  String get workoutCloseSets => 'Close sets';

  @override
  String get workoutEditSets => 'Edit sets';

  @override
  String get workoutShowExercise => 'View exercise';

  @override
  String get workoutRemoveExercise => 'Remove';

  @override
  String get workoutDuplicateExercise => 'Duplicate';

  @override
  String get workoutRemoveSet => 'Remove set';

  @override
  String get workoutAddSet => 'Add set';

  @override
  String get workoutSet => 'Set';

  @override
  String get workoutAmount => 'Repetitions / time';

  @override
  String get workoutWeightKg => 'Weight (kg)';

  @override
  String get workoutDone => 'Done';

  @override
  String get workoutCancel => 'Cancel';

  @override
  String get workoutInvalidSet => 'Enter valid values.';

  @override
  String get workoutPlanPreview => 'Local plan · activity not started';

  @override
  String get workoutReorder => 'Reorder exercises';

  @override
  String get workoutMoveUp => 'Move up';

  @override
  String get workoutMoveDown => 'Move down';

  @override
  String workoutSuggestedName(String group) {
    return 'Workout: $group';
  }

  @override
  String get workoutMenuEdit => 'Edit';

  @override
  String get workoutMenuDelete => 'Delete';

  @override
  String get workoutDeleteTitle => 'Delete workout?';

  @override
  String workoutDeleteMessage(String name) {
    return '“$name” will be removed from local workouts.';
  }

  @override
  String get workoutActionError => 'Could not update local workouts.';

  @override
  String get workoutBuilderTitle => 'Build workout';

  @override
  String get workoutBuilderWeight => 'kg lifted';

  @override
  String get workoutBuilderEmptyCount => '0 EXERCISES · 0 SETS';

  @override
  String get workoutBuilderName => 'WORKOUT NAME';

  @override
  String get workoutBuilderNameHint => 'Strength workout';

  @override
  String get workoutBuilderEmptyTitle => 'Build your workout';

  @override
  String get workoutBuilderEmptyHint => 'Tap + to choose from 218 exercises.';

  @override
  String get workoutBuilderAdd => 'Add exercises';

  @override
  String get workoutBuilderUnavailable =>
      'The exercise catalog is not connected yet.';

  @override
  String get workoutBuilderStart => 'Start';

  @override
  String get strengthDemoNote => 'Demo templates · not saved workouts';

  @override
  String get strengthDemoUnavailable =>
      'Workout templates and the editor are not connected yet.';

  @override
  String get strengthDemoName1 => 'Demo';

  @override
  String get strengthDemoName2 => 'Legs and glutes';

  @override
  String get strengthDemoName3 => 'Upper body';

  @override
  String get strengthDemoName4 => 'Full body';

  @override
  String get strengthDemoName5 => 'Legs';

  @override
  String get strengthDemoName6 => 'Upper body and core';

  @override
  String get strengthDemoName7 => 'Light workout · mobility';

  @override
  String strengthExerciseCount(int exercises, int sets) {
    return '$exercises exercises · $sets sets';
  }

  @override
  String get strengthCreateHint => 'choose exercises, sets and weight';

  @override
  String strengthOptions(String name) {
    return 'Options for $name';
  }

  @override
  String get activityRegistrationPreview =>
      'Preview · simulated data · not saved';

  @override
  String get activityDetailHighIntensity => 'High intensity';

  @override
  String get activityDetailEffortPeaks => 'Effort peaks';

  @override
  String get registrationTitle => 'Log activity';

  @override
  String get registrationModality => 'ACTIVITY';

  @override
  String get registrationChange => 'Tap to change';

  @override
  String get registrationWhen => 'WHEN';

  @override
  String get registrationOtherDay => 'Another day';

  @override
  String get registrationStart => 'Started at';

  @override
  String get registrationDuration => 'Duration';

  @override
  String get registrationEffort => 'EFFORT YOU FELT';

  @override
  String get registrationOfTen => 'of 10';

  @override
  String get registrationEstimated => 'Estimated demo load';

  @override
  String get registrationSave => 'Save';

  @override
  String get registrationUnavailable =>
      'Demo only: activity saving is not connected yet.';

  @override
  String get registrationInvalid =>
      'The activity cannot end in the future or after midnight.';

  @override
  String get registrationDone => 'Done';

  @override
  String get registrationHigh => 'HIGH';

  @override
  String get registrationModerate => 'MODERATE';

  @override
  String get registrationLight => 'Light';

  @override
  String get registrationStrong => 'Strong';

  @override
  String get registrationMaximum => 'Maximum';

  @override
  String get registrationShortPhrases => 'short phrases';

  @override
  String get registrationEffortDescription => 'Effort from 1 to 10';

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
  String get historyNormalStatus => 'WITHIN YOUR NORMAL RANGE';

  @override
  String get historyAverage => 'your average';

  @override
  String get historyNormalRange => 'normal 35–58';

  @override
  String get historySevenDayAverage => '7-day average';

  @override
  String get historyDemoMonth => 'Nov';

  @override
  String historyDemoSummary(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count activities',
      one: '$count activity',
    );
    return '$_temp0 · $minutes min total';
  }

  @override
  String get historyDemoTime => 'today 07:50';

  @override
  String get activityDetailDemoSource => 'Example · illustrative data';

  @override
  String get activityDetailTimeTo => 'to';

  @override
  String get activityDetailDuration => 'Duration';

  @override
  String get activityDetailCalories => 'Calories';

  @override
  String get activityDetailAverageHeartRate => 'Average HR';

  @override
  String get activityDetailMaximumHeartRate => 'Maximum HR';

  @override
  String get activityDetailHeartZones => 'Heart rate zones';

  @override
  String activityDetailZoneMost(int zone) {
    return 'most time in zone $zone';
  }

  @override
  String get activityDetailZone => 'Zone';

  @override
  String get activityDetailZoneRest => 'rest';

  @override
  String get activityDetailZoneVeryLight => 'very light';

  @override
  String get activityDetailZoneLight => 'light';

  @override
  String get activityDetailZoneModerate => 'moderate';

  @override
  String get activityDetailZoneHard => 'hard';

  @override
  String get activityDetailZoneMaximum => 'maximum';

  @override
  String get activityDetailMin => 'Min';

  @override
  String get activityDetailMax => 'Max';

  @override
  String get activityDetailOptions => 'Options';

  @override
  String get activityDetailShare => 'Share';

  @override
  String get activityDetailEdit => 'Edit time and duration';

  @override
  String get activityDetailDelete => 'Delete activity';

  @override
  String get activityDetailStart => 'Start time (HH:mm)';

  @override
  String get activityDetailSave => 'Save';

  @override
  String get activityDetailCancel => 'Cancel';

  @override
  String get activityDetailInvalid =>
      'Enter a valid time and duration (1–720 minutes).';

  @override
  String get activityDetailDemoOnly =>
      'Demo only · changes last until you leave this page.';

  @override
  String get activityDetailCopied => 'Demo summary copied.';

  @override
  String get activityDetailCopyFailed => 'Could not copy the demo summary.';

  @override
  String get activityDetailDeleteConfirm => 'Delete this example?';

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
  String get activityTargetStatus => 'BELOW TARGET';

  @override
  String get activityTargetTitle => 'You\'re close to your target.';

  @override
  String get activityTargetDescription =>
      'Today: strength training, 35 min, load 28. With recovery at 57, today\'s target is 35–55: 7 points to go. A light 20–30 minute walk should get you there. Tomorrow\'s estimated recovery: around 66.';

  @override
  String get activityMetricActiveCalories => 'Active calories';

  @override
  String get activityMetricActiveMinutes => 'Active minutes';

  @override
  String get activityMetricSteps => 'Steps';

  @override
  String get activityMetricRestingTime => 'Resting time';

  @override
  String get activityMetricAbove25 => '↑ 25% above';

  @override
  String get activityMetricAbove28 => '↑ 28% above';

  @override
  String get activityMetricWithinNormal => 'within normal range';

  @override
  String get activityMetricNormalCalories => 'normal 256–383 kcal';

  @override
  String get activityMetricNormalMinutes => 'normal 35–53 min';

  @override
  String get activityMetricNormalSteps => 'normal 3,904–5,856';

  @override
  String get activityMetricNormalRest => 'normal 3h32–5h18';

  @override
  String get activityDemoStrength => 'Strength training';

  @override
  String get activityDemoRun => 'Running';

  @override
  String get activityDemoWalk => 'Walking';

  @override
  String get activityDemoSetsAndWeight => 'sets and weight';

  @override
  String get activityDemoWithGps => 'with GPS';

  @override
  String activityDemoSummary(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count workouts',
      one: '$count workout',
    );
    return '$_temp0 · $minutes min total';
  }

  @override
  String get activityDemoLoadLabel => 'load';

  @override
  String get activityDemoLabel =>
      'Illustrative demo data · not synced from a device';

  @override
  String get activityDemoStepsValue => '6,240';

  @override
  String get activityDemoRestingTimeValue => '4h44';

  @override
  String get dayInNumbers => 'Your day in numbers';

  @override
  String get dailyMetricsUnavailable => 'Daily metrics are not integrated yet.';

  @override
  String get modalities => 'Modalities';

  @override
  String get viewAll => 'View all';

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

  @override
  String get homeMorning => 'Good morning';

  @override
  String get homeAfternoon => 'Good afternoon';

  @override
  String get homeEvening => 'Good evening';

  @override
  String get homePastGreeting => 'How was your day';

  @override
  String get homeDirection => 'See full direction';

  @override
  String get homeSignals => 'Your signals';

  @override
  String get homeAllSignals => 'View all ›';

  @override
  String get homeCustomize => 'Customize Home';

  @override
  String get homeCustomizeHelp =>
      'Choose the 6 signals on your Home and drag the ≡ handle to reorder them.';

  @override
  String get homeOnHome => 'ON HOME';

  @override
  String get homeOtherSignals => 'OTHER SIGNALS';

  @override
  String get homeSixSlots =>
      'Home has 6 slots. Deselect one before choosing another.';

  @override
  String get homeSave => 'Save';

  @override
  String get homePreferenceFailed =>
      'Could not save your preference. Try again.';

  @override
  String get homePhoto => 'Change the header photo';

  @override
  String get homeShowMore => 'Show more';

  @override
  String get homeShowLess => 'Show less';

  @override
  String get homeRetry => 'Try again';

  @override
  String get homeUnavailable => 'Could not load Home.';

  @override
  String get homeSignIn => 'Sign in to see your data.';

  @override
  String get homeSignInAction => 'Sign in';

  @override
  String get homeNoMeasurement => 'No data for this day';

  @override
  String get homeSync => 'Connect and sync your band to see your signals.';

  @override
  String get homePartial => 'Some information could not be updated.';

  @override
  String get homeMapaTitle => 'What is your body revealing?';

  @override
  String get homeMapaBody =>
      'A relationship between your habits, sleep, activity and recovery has started to emerge.';

  @override
  String get homeMapaWaiting =>
      'Your Map is taking shape. Keep wearing your band to discover relationships between your habits and signals.';

  @override
  String get homeExploreMapa => 'Explore my Map →';

  @override
  String get homeDiaryKicker => 'YOUR DIARY';

  @override
  String get homeDiaryTitle => 'How was your day?';

  @override
  String get homeDiaryBody =>
      'Log meals, training, mood, coffee and anything else that happened.';

  @override
  String get homeAddEntry => 'Add an entry +';

  @override
  String get homePatterns => 'patterns';

  @override
  String get homeWaitingPatterns => 'Taking shape';

  @override
  String get homeNumbers => 'Your numbers';

  @override
  String get homeWeek => 'WEEK · ONE POINT PER DAY';

  @override
  String get homeMinimum => 'Minimum';

  @override
  String get homeAverage => 'Average';

  @override
  String get homeMaximum => 'Maximum';

  @override
  String get homeHistoryError => 'Could not load history.';

  @override
  String get homeHistoryEmpty => 'No measurements for this week yet.';

  @override
  String get homeRecommendation => 'For today';

  @override
  String get homeDiary => 'Diary';

  @override
  String get homeDiaryEmpty => 'Your day, your way. Add your first entry.';

  @override
  String get homeNewEntry => 'New entry';

  @override
  String get homeEntryLabel => 'What happened?';

  @override
  String get homeEntryNote => 'More details (optional)';

  @override
  String get homeEntryRequired => 'Describe the entry before saving.';

  @override
  String get homeEntrySaved => 'Entry saved.';

  @override
  String get homeEntryFailed => 'Could not save. Try again.';

  @override
  String get homeMeal => 'Meals';

  @override
  String get homeTraining => 'Training';

  @override
  String get homeMood => 'Mood';

  @override
  String get homeCaffeine => 'Coffee';

  @override
  String get homeOther => 'Other';

  @override
  String get homeUnknownDirection => 'Waiting for your signals.';

  @override
  String get homeDataOnly =>
      'Measurements from your band. Missing data is not estimated.';

  @override
  String get homeSelectedCount => 'of 6';

  @override
  String get homeOpenDevice => 'Connect band';

  @override
  String get homeRefresh => 'Refresh';

  @override
  String get homeDrag => 'Drag to reorder';

  @override
  String get homeNoDirection =>
      'Sync your band to follow your daily direction.';

  @override
  String get homeAccountChanged =>
      'Your account changed. Close this screen and reopen it to see current data.';

  @override
  String get authWelcome => 'WELCOME TO BYND';

  @override
  String get authHeadline => 'Your body.\nYour direction.';

  @override
  String get authSubtitle => 'Understand your signals. Live at your own pace.';

  @override
  String get authEmailContinue => 'Continue with email';

  @override
  String get authGoogleContinue => 'Continue with Google';

  @override
  String get authEmailTitle => 'What\'s your email?';

  @override
  String get authEmailBody =>
      'We\'ll send you a code to sign in. No password needed.';

  @override
  String get authAccountHint =>
      'First time here? You can create your account this way too.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'you@example.com';

  @override
  String get authSendCode => 'Send code';

  @override
  String get authCodeTitle => 'Check your email';

  @override
  String authCodeBody(String email) {
    return 'We sent a 6-digit code to $email.';
  }

  @override
  String get authCodeLabel => 'Verification code';

  @override
  String get authCodeHint => '000000';

  @override
  String get authEditEmail => 'Change email';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authCreateAccount => 'Create account and sign in';

  @override
  String get authResend => 'Resend code';

  @override
  String authResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get authSpamHint =>
      'Didn\'t arrive? Check your spam folder or request another code.';

  @override
  String get authCodeSent => 'Code sent. Please check your spam folder too.';

  @override
  String get authInvalidEmail => 'Enter a valid email address.';

  @override
  String get authInvalidCode => 'Enter all 6 digits of the code.';

  @override
  String get authCodeRejected =>
      'We couldn\'t verify that code. Check the digits or request another one.';

  @override
  String get authCodeExpired =>
      'That code has expired. Request a new one to continue.';

  @override
  String get authNetworkError =>
      'Couldn\'t connect. Check your connection and try again.';

  @override
  String get authServerError =>
      'Couldn\'t sign in right now. Please try again shortly.';

  @override
  String get authRateLimited => 'Please wait a little before trying again.';

  @override
  String get authStorageError =>
      'Couldn\'t save your access on this device. Please try again.';

  @override
  String get authGoogleError =>
      'Couldn\'t sign in with Google. Try again or use your email.';

  @override
  String get authSessionExpired =>
      'Your access expired. Sign in again to continue.';

  @override
  String get authConsentTitle => 'Your health data, your choice';

  @override
  String get authConsentBody =>
      'BYND uses health signals collected by your band, such as heart rate, HRV, sleep and activity, to generate personal information about your body. Creating your account requires your consent to this processing.';

  @override
  String get authConsentLabel =>
      'I agree to the processing of my health data to generate personal information, as described in Privacy.';

  @override
  String get authConsentRequired =>
      'To create your account, confirm your choice about health data.';

  @override
  String get authConsentAccept => 'Agree and continue';

  @override
  String get authConsentDecline => 'Not now';

  @override
  String get authPrivacy => 'Privacy';

  @override
  String get authPrivacyLink => 'How we use your data';

  @override
  String get authPrivacyTitle => 'Your data at BYND';

  @override
  String get authPrivacyPurposeTitle => 'To understand your signals';

  @override
  String get authPrivacyPurpose =>
      'Your band\'s health data and the entries you add help present information about sleep, activity and other signals from your body.';

  @override
  String get authPrivacyChoiceTitle => 'An explicit choice';

  @override
  String get authPrivacyChoice =>
      'Creating an account requires your consent to health-data processing. You can read this information and return without agreeing; in that case, this step will not create an account.';

  @override
  String get authPrivacyAccessTitle => 'Your access';

  @override
  String get authPrivacyAccess =>
      'Email sign-in uses a temporary code. Keep that code to yourself. Your session stays on this device until you sign out or access expires.';

  @override
  String get authLegalFootnote =>
      'Learn how BYND uses your data before continuing.';

  @override
  String get authRestore => 'Preparing your access…';

  @override
  String get authSignOutTitle => 'Sign out of your account?';

  @override
  String get authSignOutBody =>
      'You can sign in again with your email or Google.';

  @override
  String get authSignOutConfirm => 'Sign out';

  @override
  String get authCancel => 'Cancel';

  @override
  String get authSignOutFailed =>
      'You signed out, but some local data couldn\'t be cleared. Please restart the app.';

  @override
  String authBackground(int index, int total) {
    return 'Landscape $index of $total';
  }

  @override
  String get authChangeLanguage => 'Change language';

  @override
  String get communityMyGroups => 'My groups';

  @override
  String get communityEmptyGroups =>
      'No groups yet. Create one or join with an invitation.';

  @override
  String get communityToday => 'For today';

  @override
  String get communityMarkDone => 'Mark as done';

  @override
  String get communityMarkedDone => 'Day marked as done.';

  @override
  String get communityDoneToday => 'Done today';

  @override
  String get communityRetry => 'Try again';

  @override
  String get communityAccept => 'Accept';

  @override
  String get communityDecline => 'Decline';

  @override
  String communityMemberCount(Object count) {
    return '$count members';
  }

  @override
  String communityDaysTotal(Object days) {
    return '$days-day challenge';
  }

  @override
  String get communityEmptyChat => 'No messages yet. Say hi!';

  @override
  String get communityDayToday => 'Today';

  @override
  String get communityDayYesterday => 'Yesterday';

  @override
  String get communityMessageRecalled => 'Message removed';

  @override
  String get communitySendHint => 'Message the group';

  @override
  String communityInvitationFrom(Object group, Object inviter) {
    return '$inviter invited you to \"$group\"';
  }

  @override
  String get communityNewCover => 'Create a group\nor join with a code';

  @override
  String communityInviteFromShort(Object name) {
    return 'invite from $name';
  }

  @override
  String communityRankBadge(Object rank, Object total) {
    return '$rank of $total in the challenge';
  }

  @override
  String get communityParaHoje => 'For today';

  @override
  String get communityPickChallenge => 'Choose a challenge';

  @override
  String get communityPickChallengeSub => 'alone or with your group';

  @override
  String communityDayOfTotal(Object day, Object total) {
    return 'day $day of $total';
  }

  @override
  String get communityMuralToday => 'In the group today';

  @override
  String get communityMuralYesterday => 'In the group yesterday';

  @override
  String get communityMuralIntro => 'Newest first. Tap \"Cheer\" to support.';

  @override
  String get communityNoCheckinsToday =>
      'No check-ins today yet. Whoever posts one shows up here.';

  @override
  String get communityNoCheckinsYesterday => 'No check-ins yesterday.';

  @override
  String get communityAtlasKicker => 'ATLAS · GROUP SUMMARY';

  @override
  String get communityCheer => 'Cheer';

  @override
  String get communityCheerSoon => 'Cheering is coming soon.';

  @override
  String get communityRespond => 'Reply';

  @override
  String get communityOpenGroupChat => 'Open the group chat';

  @override
  String get communityCheckinText => '✓ Today\'s check-in';

  @override
  String get communityNewTitle => 'New';

  @override
  String get communityTabChallenges => 'Challenges';

  @override
  String get communityTabCreateGroup => 'Create group';

  @override
  String get communityTabCode => 'Code';

  @override
  String get communityChallengesIntro =>
      'Challenges created by BYND with specialists. Do it alone or bring it to your group.';

  @override
  String get communityDetailsOpen => 'View details';

  @override
  String get communityDetailsClose => 'Close';

  @override
  String get communityChallengeWhy => 'Why it works';

  @override
  String get communityChallengeDaily => 'Every day';

  @override
  String get communityEnrolledBadge => 'You are in this challenge';

  @override
  String get communityStartToday => 'Start today';

  @override
  String get communityChallengeLeave => 'Leave challenge';

  @override
  String get communityStepName => '1 · Group name';

  @override
  String get communityStepInvite => '2 · Who to invite (email)';

  @override
  String get communityCodeIntro =>
      'Received an invitation? Type the group code (it comes in the link or message).';

  @override
  String get communityCodeHint => 'BYND-0000';

  @override
  String get communityCodeGo => 'Join group';

  @override
  String get communityCodeSoon => 'Joining by code is coming soon.';

  @override
  String get communityAjustesTitle => 'Group';

  @override
  String get communityAjustesInvite => '+ Invite';

  @override
  String get communityPlacarTitle => 'Leaderboard';

  @override
  String get communityRoleAdmin => 'admin';

  @override
  String get communityNotifTitle => 'Notifications';

  @override
  String get communityNotifMessages => 'Messages';

  @override
  String get communityLeaveDoubleTap => 'Tap again to leave';

  @override
  String get communityInviteTitle => 'Invite to the group';

  @override
  String get communityInviteEmailHint => 'name@example.com';

  @override
  String get communityInviteSend => 'Send';

  @override
  String get communityInviteSuccess => 'Invitation sent.';

  @override
  String communityMembersTitle(Object count) {
    return 'Members · $count';
  }

  @override
  String get communityLeaveGroup => 'Leave group';

  @override
  String get communityGoalsTitle => 'Goals';

  @override
  String get communityNoGoals => 'No goals yet in this group.';

  @override
  String get communityCreateIntro =>
      'A group is for doing challenges together, comparing the numbers of the goal and chatting.';

  @override
  String get communityGroupName => 'Group name';

  @override
  String get communityGroupNameHint => 'e.g. 6am run, Family, Work';

  @override
  String get communityGroupDescription => 'Description';

  @override
  String get communityGroupDescriptionHint => 'What is this group about?';

  @override
  String get communityInviteEmails => 'Who to invite';

  @override
  String get communityInviteEmailsHint => 'emails separated by commas';

  @override
  String get communityGroupCreate => 'Create group';

  @override
  String get communityCreating => 'Creating...';

  @override
  String communityGroupCreated(Object count) {
    return 'Group created · $count invitation(s) sent.';
  }

  @override
  String get communityCreateNote =>
      'You can create it alone: right after, you can invite more people in the group settings.';

  @override
  String get communityPublicGroup => 'Public group';

  @override
  String get communityJoin => 'Join';

  @override
  String get communityJoinedGroup => 'Welcome to the group!';

  @override
  String get atlasInsights => 'Insights';

  @override
  String get atlasChat => 'Talk to ATLAS';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get insightsRefresh => 'Refresh';

  @override
  String get insightsError =>
      'Could not load insights. Pull down to try again.';

  @override
  String get insightsEmpty =>
      'No insights yet. Keep syncing your band — ATLAS will speak up when your data tells something worth knowing.';

  @override
  String get insightsFactors => 'What may be involved';

  @override
  String get insightsActions => 'What you can try';

  @override
  String get chatTitle => 'Atlas';

  @override
  String get chatNew => 'New conversation';

  @override
  String get chatEmptyHint =>
      'Ask about your sleep, recovery, stress or training readiness. ATLAS answers with your own data and explains what it means.';

  @override
  String get chatInputHint => 'Ask ATLAS';

  @override
  String get menuMapa => 'Mapa';

  @override
  String get chatSug1 => 'How am I doing?';

  @override
  String get chatSug2 => 'Summarize my day';

  @override
  String get chatSug3 => 'Why is my HRV not recovering?';

  @override
  String get chatHistoryTitle => 'Conversations';

  @override
  String get chatHistoryEmpty => 'No conversations yet.';

  @override
  String get chatHistoryUntitled => 'Untitled conversation';

  @override
  String get healthGroupSleep => 'Sleep';

  @override
  String get healthGroupEnergy => 'Energy';

  @override
  String get healthGroupMetabolism => 'Metabolism';

  @override
  String get healthGroupHeartBody => 'Heart & body';

  @override
  String get healthGroupBreathOxygen => 'Breathing & oxygen';

  @override
  String get healthGroupLongevity => 'Longevity';

  @override
  String get memoriaTitle => 'Memory';

  @override
  String get memoriaHeroTitle => 'What ATLAS knows about you';

  @override
  String get memoriaHeroSub => 'The more it knows, the better the answers.';

  @override
  String get memoriaKicker => 'What it stored';

  @override
  String get memoriaCurrent => 'Current';

  @override
  String get memoriaPast => 'Past';

  @override
  String get memoriaTold => 'You told';

  @override
  String get memoriaPerceived => 'ATLAS noticed';

  @override
  String get memoriaSince => 'since';

  @override
  String get diaryCatalogAguaLabel => 'Drink water';

  @override
  String get diaryCatalogAguaPrompt => 'Did you drink water?';

  @override
  String get diaryCatalogProtLabel => 'Eat protein';

  @override
  String get diaryCatalogProtPrompt => 'Did you eat protein with your meals?';

  @override
  String get diaryCatalogFrutLabel => 'Fruit and vegetables';

  @override
  String get diaryCatalogFrutPrompt => 'Did you eat fruit and vegetables?';

  @override
  String get diaryCatalogJantarLabel => 'Dinner by 8 pm';

  @override
  String get diaryCatalogJantarPrompt => 'Did you have dinner by 8 pm?';

  @override
  String get diaryCatalogDoceLabel => 'Sweets';

  @override
  String get diaryCatalogDocePrompt => 'Did you eat sweets?';

  @override
  String get diaryCatalogAlcLabel => 'Alcohol';

  @override
  String get diaryCatalogAlcPrompt => 'Did you drink alcohol?';

  @override
  String get diaryCatalogCafe15Label => 'Coffee after 3 pm';

  @override
  String get diaryCatalogCafe15Prompt => 'Did you have coffee after 3 pm?';

  @override
  String get diaryCatalogRefriLabel => 'Soft drinks';

  @override
  String get diaryCatalogRefriPrompt => 'Did you have a soft drink?';

  @override
  String get diaryCatalogCafeLabel => 'Coffee';

  @override
  String get diaryCatalogCafePrompt => 'Did you have coffee?';

  @override
  String get diaryCatalogTelaLabel => 'Phone in bed';

  @override
  String get diaryCatalogTelaPrompt => 'Did you use your phone in bed?';

  @override
  String get diaryCatalogLuzLabel => 'Morning sunlight';

  @override
  String get diaryCatalogLuzPrompt => 'Did you get sunlight in the morning?';

  @override
  String get diaryCatalogLerLabel => 'Read before bed';

  @override
  String get diaryCatalogLerPrompt => 'Did you read before going to sleep?';

  @override
  String get diaryCatalogRespLabel => 'Breathing exercise';

  @override
  String get diaryCatalogRespPrompt => 'Did you do a breathing exercise?';

  @override
  String get diaryCatalogMeditLabel => 'Meditation';

  @override
  String get diaryCatalogMeditPrompt => 'Did you meditate?';

  @override
  String get diaryCatalogGratLabel => 'Write three things you are grateful for';

  @override
  String get diaryCatalogGratPrompt =>
      'Did you write down what you are grateful for?';

  @override
  String get diaryCatalogGeloLabel => 'Cold shower';

  @override
  String get diaryCatalogGeloPrompt => 'Did you take a cold shower?';

  @override
  String get diaryCatalogAlongLabel => 'Stretching';

  @override
  String get diaryCatalogAlongPrompt => 'Did you stretch?';

  @override
  String get diaryCatalogDorLabel => 'Muscle soreness';

  @override
  String get diaryCatalogDorPrompt => 'Did you feel muscle soreness?';

  @override
  String get diaryCatalogRemedioLabel => 'Take medication';

  @override
  String get diaryCatalogRemedioPrompt => 'Did you take your medication?';

  @override
  String get diaryCatalogGlpLabel => 'GLP-1 injection';

  @override
  String get diaryCatalogGlpPrompt => 'Did you take your GLP-1 injection?';

  @override
  String get diaryCatalogCreatLabel => 'Creatine';

  @override
  String get diaryCatalogCreatPrompt => 'Did you take creatine?';

  @override
  String get diaryCatalogVitLabel => 'Vitamins';

  @override
  String get diaryCatalogVitPrompt => 'Did you take your vitamins?';

  @override
  String get diaryCatalogAcordouLabel => 'How you woke up';

  @override
  String get diaryCatalogAcordouPrompt => 'How did you feel when you woke up?';

  @override
  String get diaryCatalogHumorLabel => 'Mood';

  @override
  String get diaryCatalogHumorPrompt => 'How is your mood?';

  @override
  String get diaryCatalogEnergiaLabel => 'Energy';

  @override
  String get diaryCatalogEnergiaPrompt => 'How is your energy?';

  @override
  String get diaryCatalogEstresseLabel => 'Stress';

  @override
  String get diaryCatalogEstressePrompt =>
      'How much stress did you feel today?';

  @override
  String get diaryCatalogCafeMLabel => 'Breakfast';

  @override
  String get diaryCatalogCafeMPrompt => 'What did you eat?';

  @override
  String get diaryCatalogLancheMLabel => 'Morning snack';

  @override
  String get diaryCatalogLancheMPrompt => 'What did you eat?';

  @override
  String get diaryCatalogAlmocoLabel => 'Lunch';

  @override
  String get diaryCatalogAlmocoPrompt => 'What did you eat?';

  @override
  String get diaryCatalogLancheTLabel => 'Afternoon snack';

  @override
  String get diaryCatalogLancheTPrompt => 'What did you eat?';

  @override
  String get diaryCatalogJantarRLabel => 'Dinner';

  @override
  String get diaryCatalogJantarRPrompt => 'What did you eat?';

  @override
  String get diaryCatalogCeiaLabel => 'Late snack';

  @override
  String get diaryCatalogCeiaPrompt => 'What did you eat?';

  @override
  String get diaryCatalogWheyLabel => 'Whey protein';

  @override
  String get diaryCatalogWheyPrompt => 'What did you eat?';

  @override
  String get diaryCatalogGripeLabel => 'Flu symptoms';

  @override
  String get diaryCatalogGripePrompt => 'Did you notice flu symptoms?';

  @override
  String get diaryCatalogCAguaLabel => 'Water';

  @override
  String get diaryCatalogCAguaPrompt => 'Did you drink enough water?';

  @override
  String get diaryCatalogCExpressoLabel => 'Espresso';

  @override
  String get diaryCatalogCExpressoPrompt => 'Did you have an espresso?';

  @override
  String get diaryCatalogCCafeleiteLabel => 'Coffee with milk';

  @override
  String get diaryCatalogCCafeleitePrompt => 'Did you have coffee with milk?';

  @override
  String get diaryCatalogCChaLabel => 'Tea';

  @override
  String get diaryCatalogCChaPrompt => 'Did you have tea?';

  @override
  String get diaryCatalogCChapretoLabel => 'Black tea or mate';

  @override
  String get diaryCatalogCChapretoPrompt =>
      'Did you have caffeinated black tea or mate?';

  @override
  String get diaryCatalogCChimarraoLabel => 'Chimarrão';

  @override
  String get diaryCatalogCChimarraoPrompt => 'Did you have chimarrão?';

  @override
  String get diaryCatalogCTerereLabel => 'Tereré';

  @override
  String get diaryCatalogCTererePrompt => 'Did you have tereré?';

  @override
  String get diaryCatalogCEnergLabel => 'Energy drink';

  @override
  String get diaryCatalogCEnergPrompt => 'Did you have an energy drink?';

  @override
  String get diaryCatalogCSucoLabel => 'Fresh juice';

  @override
  String get diaryCatalogCSucoPrompt => 'Did you have fresh juice?';

  @override
  String get diaryCatalogCSucocxLabel => 'Packaged juice';

  @override
  String get diaryCatalogCSucocxPrompt =>
      'Did you have packaged or powdered juice?';

  @override
  String get diaryCatalogCCocoLabel => 'Coconut water';

  @override
  String get diaryCatalogCCocoPrompt => 'Did you have coconut water?';

  @override
  String get diaryCatalogCIsotLabel => 'Sports drink';

  @override
  String get diaryCatalogCIsotPrompt => 'Did you have a sports drink?';

  @override
  String get diaryCatalogCLeiteLabel => 'Milk';

  @override
  String get diaryCatalogCLeitePrompt => 'Did you have milk?';

  @override
  String get diaryCatalogCVegetalLabel => 'Plant-based drink';

  @override
  String get diaryCatalogCVegetalPrompt => 'Did you have plant-based milk?';

  @override
  String get diaryCatalogCKombuchaLabel => 'Kombucha';

  @override
  String get diaryCatalogCKombuchaPrompt => 'Did you have kombucha?';

  @override
  String get diaryCatalogCCervejaLabel => 'Beer';

  @override
  String get diaryCatalogCCervejaPrompt => 'Did you have beer?';

  @override
  String get diaryCatalogCVinhoLabel => 'Wine';

  @override
  String get diaryCatalogCVinhoPrompt => 'Did you have wine?';

  @override
  String get diaryCatalogCCaipirinhaLabel => 'Caipirinha';

  @override
  String get diaryCatalogCCaipirinhaPrompt => 'Did you have a caipirinha?';

  @override
  String get diaryCatalogCCachacaLabel => 'Cachaça';

  @override
  String get diaryCatalogCCachacaPrompt => 'Did you have cachaça?';

  @override
  String get diaryCatalogCDestiladoLabel => 'Spirits';

  @override
  String get diaryCatalogCDestiladoPrompt =>
      'Did you have vodka, whisky or gin?';

  @override
  String get diaryCatalogCDrinksLabel => 'Cocktails';

  @override
  String get diaryCatalogCDrinksPrompt => 'Did you have cocktails?';

  @override
  String get diaryCatalogCAlctardeLabel => 'Alcohol at night';

  @override
  String get diaryCatalogCAlctardePrompt =>
      'Did you drink alcohol close to bedtime?';

  @override
  String get diaryCatalogCRessacaLabel => 'Hangover';

  @override
  String get diaryCatalogCRessacaPrompt => 'Did you wake up with a hangover?';

  @override
  String get diaryCatalogCAguagasLabel => 'Sparkling water';

  @override
  String get diaryCatalogCAguagasPrompt => 'Did you have sparkling water?';

  @override
  String get diaryCatalogCChaverdeLabel => 'Green tea';

  @override
  String get diaryCatalogCChaverdePrompt => 'Did you have green tea?';

  @override
  String get diaryCatalogCCamomilaLabel => 'Calming tea';

  @override
  String get diaryCatalogCCamomilaPrompt =>
      'Did you have chamomile, lemongrass or lemon balm tea?';

  @override
  String get diaryCatalogCDescafLabel => 'Decaf coffee';

  @override
  String get diaryCatalogCDescafPrompt => 'Did you have decaf coffee?';

  @override
  String get diaryCatalogCSmoothieLabel => 'Fruit smoothie';

  @override
  String get diaryCatalogCSmoothiePrompt => 'Did you have a fruit smoothie?';

  @override
  String get diaryCatalogCShakeLabel => 'Protein shake';

  @override
  String get diaryCatalogCShakePrompt => 'Did you have a protein shake?';

  @override
  String get diaryCatalogCCaldocanaLabel => 'Sugarcane juice';

  @override
  String get diaryCatalogCCaldocanaPrompt => 'Did you have sugarcane juice?';

  @override
  String get diaryCatalogCAchocLabel => 'Chocolate drink';

  @override
  String get diaryCatalogCAchocPrompt => 'Did you have a chocolate drink?';

  @override
  String get diaryCatalogCSemalcLabel => 'Alcohol-free beer';

  @override
  String get diaryCatalogCSemalcPrompt => 'Did you have alcohol-free beer?';

  @override
  String get diaryCatalogCBebquenteLabel => 'Hot drink before bed';

  @override
  String get diaryCatalogCBebquentePrompt =>
      'Did you have a hot drink before going to sleep?';

  @override
  String get diaryCatalogCAguamanhaLabel => 'Water on waking';

  @override
  String get diaryCatalogCAguamanhaPrompt =>
      'Did you drink water as soon as you woke up?';

  @override
  String get diaryCatalogCCafemLabel => 'Breakfast';

  @override
  String get diaryCatalogCCafemPrompt => 'Did you have breakfast?';

  @override
  String get diaryCatalogCCafemanhaLabel => 'Breakfast';

  @override
  String get diaryCatalogCCafemanhaPrompt => 'Did you have breakfast?';

  @override
  String get diaryCatalogCAlmLabel => 'Lunch';

  @override
  String get diaryCatalogCAlmPrompt => 'Did you have lunch?';

  @override
  String get diaryCatalogCJantarLabel => 'Dinner';

  @override
  String get diaryCatalogCJantarPrompt => 'Did you have dinner?';

  @override
  String get diaryCatalogCLancheLabel => 'Afternoon snack';

  @override
  String get diaryCatalogCLanchePrompt => 'Did you have an afternoon snack?';

  @override
  String get diaryCatalogCBeliscouLabel => 'Snacking';

  @override
  String get diaryCatalogCBeliscouPrompt => 'Did you snack between meals?';

  @override
  String get diaryCatalogCPularefLabel => 'Skipped meal';

  @override
  String get diaryCatalogCPularefPrompt => 'Did you skip a meal?';

  @override
  String get diaryCatalogCTardeLabel => 'Ate late';

  @override
  String get diaryCatalogCTardePrompt => 'Did you eat close to bedtime?';

  @override
  String get diaryCatalogCJejumLabel => 'Fasting';

  @override
  String get diaryCatalogCJejumPrompt =>
      'Did you practice intermittent fasting?';

  @override
  String get diaryCatalogCComeudemaisLabel => 'Ate too much';

  @override
  String get diaryCatalogCComeudemaisPrompt =>
      'Did you eat past the point of fullness?';

  @override
  String get diaryCatalogCPesadaLabel => 'Heavy meal';

  @override
  String get diaryCatalogCPesadaPrompt => 'Did you have a heavy meal?';

  @override
  String get diaryCatalogCProtLabel => 'Protein';

  @override
  String get diaryCatalogCProtPrompt =>
      'Did you meet your protein goal for the day?';

  @override
  String get diaryCatalogCCaseiraLabel => 'Home-cooked food';

  @override
  String get diaryCatalogCCaseiraPrompt => 'Did you eat home-cooked food?';

  @override
  String get diaryCatalogCMarmitaLabel => 'Packed meal';

  @override
  String get diaryCatalogCMarmitaPrompt => 'Did you bring a packed meal?';

  @override
  String get diaryCatalogCForaLabel => 'Ate out';

  @override
  String get diaryCatalogCForaPrompt => 'Did you eat at a restaurant?';

  @override
  String get diaryCatalogCDeliveryLabel => 'Food delivery';

  @override
  String get diaryCatalogCDeliveryPrompt =>
      'Did you order food through an app?';

  @override
  String get diaryCatalogCFastfoodLabel => 'Fast food';

  @override
  String get diaryCatalogCFastfoodPrompt => 'Did you eat fast food?';

  @override
  String get diaryCatalogCPizzaLabel => 'Pizza';

  @override
  String get diaryCatalogCPizzaPrompt => 'Did you eat pizza?';

  @override
  String get diaryCatalogCProcLabel => 'Avoided processed food';

  @override
  String get diaryCatalogCProcPrompt => 'Did you avoid ultra-processed food?';

  @override
  String get diaryCatalogCSalgLabel => 'Packaged snacks';

  @override
  String get diaryCatalogCSalgPrompt =>
      'Did you eat packaged snacks or filled cookies?';

  @override
  String get diaryCatalogCFritoLabel => 'Fried food';

  @override
  String get diaryCatalogCFritoPrompt => 'Did you eat fried food?';

  @override
  String get diaryCatalogCPastelLabel => 'Pastel or coxinha';

  @override
  String get diaryCatalogCPastelPrompt =>
      'Did you eat pastel, coxinha or another fried savory snack?';

  @override
  String get diaryCatalogCChocoLabel => 'Chocolate';

  @override
  String get diaryCatalogCChocoPrompt => 'Did you eat chocolate?';

  @override
  String get diaryCatalogCSorveteLabel => 'Ice cream';

  @override
  String get diaryCatalogCSorvetePrompt => 'Did you have ice cream?';

  @override
  String get diaryCatalogCBrigadeiroLabel => 'Brigadeiro or cake';

  @override
  String get diaryCatalogCBrigadeiroPrompt => 'Did you eat brigadeiro or cake?';

  @override
  String get diaryCatalogCFrutaLabel => 'Fruit';

  @override
  String get diaryCatalogCFrutaPrompt => 'Did you eat fruit?';

  @override
  String get diaryCatalogCVerduraLabel => 'Salad and leafy greens';

  @override
  String get diaryCatalogCVerduraPrompt => 'Did you eat salad or leafy greens?';

  @override
  String get diaryCatalogCLegumeLabel => 'Vegetables';

  @override
  String get diaryCatalogCLegumePrompt => 'Did you eat vegetables?';

  @override
  String get diaryCatalogCFibraLabel => 'Fiber';

  @override
  String get diaryCatalogCFibraPrompt => 'Did you eat fiber?';

  @override
  String get diaryCatalogCFeijaoLabel => 'Beans';

  @override
  String get diaryCatalogCFeijaoPrompt => 'Did you eat beans?';

  @override
  String get diaryCatalogCArrozLabel => 'Brown rice';

  @override
  String get diaryCatalogCArrozPrompt => 'Did you eat brown rice?';

  @override
  String get diaryCatalogCOvoLabel => 'Eggs';

  @override
  String get diaryCatalogCOvoPrompt => 'Did you eat eggs?';

  @override
  String get diaryCatalogCCarnevLabel => 'Red meat';

  @override
  String get diaryCatalogCCarnevPrompt => 'Did you eat red meat?';

  @override
  String get diaryCatalogCFrangoLabel => 'Chicken';

  @override
  String get diaryCatalogCFrangoPrompt => 'Did you eat chicken?';

  @override
  String get diaryCatalogCPeixeLabel => 'Fish';

  @override
  String get diaryCatalogCPeixePrompt => 'Did you eat fish?';

  @override
  String get diaryCatalogCEmbutLabel => 'Processed meat';

  @override
  String get diaryCatalogCEmbutPrompt =>
      'Did you eat ham, hot dogs or sausages?';

  @override
  String get diaryCatalogCChurrascoLabel => 'Barbecue';

  @override
  String get diaryCatalogCChurrascoPrompt => 'Did you have barbecue?';

  @override
  String get diaryCatalogCFeijoadaLabel => 'Feijoada';

  @override
  String get diaryCatalogCFeijoadaPrompt => 'Did you eat feijoada?';

  @override
  String get diaryCatalogCAcaiLabel => 'Açaí';

  @override
  String get diaryCatalogCAcaiPrompt => 'Did you have açaí?';

  @override
  String get diaryCatalogCTapiocaLabel => 'Tapioca or cuscuz';

  @override
  String get diaryCatalogCTapiocaPrompt => 'Did you eat tapioca or cuscuz?';

  @override
  String get diaryCatalogCPaoqueijoLabel => 'Cheese bread';

  @override
  String get diaryCatalogCPaoqueijoPrompt => 'Did you eat pão de queijo?';

  @override
  String get diaryCatalogCPaobrancoLabel => 'White bread';

  @override
  String get diaryCatalogCPaobrancoPrompt =>
      'Did you eat white bread or a Brazilian bread roll?';

  @override
  String get diaryCatalogCMacarraoLabel => 'Pasta';

  @override
  String get diaryCatalogCMacarraoPrompt => 'Did you eat pasta?';

  @override
  String get diaryCatalogCLatLabel => 'Dairy-free day';

  @override
  String get diaryCatalogCLatPrompt => 'Did you avoid milk and dairy products?';

  @override
  String get diaryCatalogCGlutenLabel => 'Gluten-free day';

  @override
  String get diaryCatalogCGlutenPrompt => 'Did you avoid gluten?';

  @override
  String get diaryCatalogCVeganoLabel => 'Meat-free day';

  @override
  String get diaryCatalogCVeganoPrompt => 'Did you avoid meat today?';

  @override
  String get diaryCatalogCCarboLabel => 'Low carbohydrate intake';

  @override
  String get diaryCatalogCCarboPrompt => 'Did you eat few carbohydrates?';

  @override
  String get diaryCatalogCApimentadaLabel => 'Spicy food';

  @override
  String get diaryCatalogCApimentadaPrompt => 'Did you eat spicy food?';

  @override
  String get diaryCatalogCSalLabel => 'High salt intake';

  @override
  String get diaryCatalogCSalPrompt => 'Did you eat very salty food?';

  @override
  String get diaryCatalogCAdocanteLabel => 'Sweetener';

  @override
  String get diaryCatalogCAdocantePrompt => 'Did you use a sweetener?';

  @override
  String get diaryCatalogCProtcafeLabel => 'Protein at breakfast';

  @override
  String get diaryCatalogCProtcafePrompt => 'Did you eat protein at breakfast?';

  @override
  String get diaryCatalogCCarbonoiteLabel => 'Carbohydrates at dinner';

  @override
  String get diaryCatalogCCarbonoitePrompt =>
      'Did you eat carbohydrates at dinner?';

  @override
  String get diaryCatalogCJantarleveLabel => 'Light dinner';

  @override
  String get diaryCatalogCJantarlevePrompt => 'Did you have a light dinner?';

  @override
  String get diaryCatalogCAveiaLabel => 'Oats';

  @override
  String get diaryCatalogCAveiaPrompt => 'Did you eat oats?';

  @override
  String get diaryCatalogCIogurteLabel => 'Yogurt';

  @override
  String get diaryCatalogCIogurtePrompt => 'Did you eat yogurt?';

  @override
  String get diaryCatalogCQueijoLabel => 'Cheese';

  @override
  String get diaryCatalogCQueijoPrompt => 'Did you eat cheese?';

  @override
  String get diaryCatalogCCastanhaLabel => 'Nuts';

  @override
  String get diaryCatalogCCastanhaPrompt => 'Did you eat nuts?';

  @override
  String get diaryCatalogCAbacateLabel => 'Avocado';

  @override
  String get diaryCatalogCAbacatePrompt => 'Did you eat avocado?';

  @override
  String get diaryCatalogCTubercLabel => 'Sweet potato or cassava';

  @override
  String get diaryCatalogCTubercPrompt =>
      'Did you eat sweet potato, cassava or yam?';

  @override
  String get diaryCatalogCSopaLabel => 'Soup';

  @override
  String get diaryCatalogCSopaPrompt => 'Did you have soup?';

  @override
  String get diaryCatalogCJaponesLabel => 'Japanese food';

  @override
  String get diaryCatalogCJaponesPrompt => 'Did you eat Japanese food?';

  @override
  String get diaryCatalogCHamburguerLabel => 'Burger';

  @override
  String get diaryCatalogCHamburguerPrompt => 'Did you eat a burger?';

  @override
  String get diaryCatalogCCongeladoLabel => 'Frozen ready meal';

  @override
  String get diaryCatalogCCongeladoPrompt => 'Did you eat a frozen ready meal?';

  @override
  String get diaryCatalogCSobremesaLabel => 'Dessert';

  @override
  String get diaryCatalogCSobremesaPrompt => 'Did you eat dessert?';

  @override
  String get diaryCatalogCRapidoLabel => 'Ate quickly';

  @override
  String get diaryCatalogCRapidoPrompt => 'Did you eat in a hurry?';

  @override
  String get diaryCatalogCTela2Label => 'Screen during meals';

  @override
  String get diaryCatalogCTela2Prompt =>
      'Did you eat while watching TV or using your phone?';

  @override
  String get diaryCatalogCEmfamiliaLabel => 'Family meal';

  @override
  String get diaryCatalogCEmfamiliaPrompt => 'Did you eat with your family?';

  @override
  String get diaryCatalogCCozinhouLabel => 'Cooking';

  @override
  String get diaryCatalogCCozinhouPrompt => 'Did you cook your own food?';

  @override
  String get diaryCatalogCLivreLabel => 'Unrestricted meal';

  @override
  String get diaryCatalogCLivrePrompt =>
      'Did you have a meal without following your usual food plan?';

  @override
  String get diaryCatalogCFomeLabel => 'Long time without food';

  @override
  String get diaryCatalogCFomePrompt => 'Did you go many hours without eating?';

  @override
  String get diaryCatalogCCabecaLabel => 'Mental state';

  @override
  String get diaryCatalogCCabecaPrompt => 'How is your mental state?';

  @override
  String get diaryCatalogCDisposicaoLabel => 'Energy';

  @override
  String get diaryCatalogCDisposicaoPrompt => 'How is your energy?';

  @override
  String get diaryCatalogCAnsLabel => 'Anxiety';

  @override
  String get diaryCatalogCAnsPrompt => 'Did you feel nervous or anxious?';

  @override
  String get diaryCatalogCEstresLabel => 'Stress';

  @override
  String get diaryCatalogCEstresPrompt => 'Did you have a stressful day?';

  @override
  String get diaryCatalogCHumorLabel => 'Good mood';

  @override
  String get diaryCatalogCHumorPrompt => 'Were you in a good mood today?';

  @override
  String get diaryCatalogCIrritLabel => 'Irritability';

  @override
  String get diaryCatalogCIrritPrompt => 'Did you feel irritable?';

  @override
  String get diaryCatalogCTristeLabel => 'Sadness';

  @override
  String get diaryCatalogCTristePrompt => 'Did you feel sad?';

  @override
  String get diaryCatalogCDesanimoLabel => 'Low spirits';

  @override
  String get diaryCatalogCDesanimoPrompt =>
      'Did you feel low on energy or discouraged?';

  @override
  String get diaryCatalogCMotivLabel => 'Motivation';

  @override
  String get diaryCatalogCMotivPrompt => 'Did you feel motivated?';

  @override
  String get diaryCatalogCFocoLabel => 'Focus';

  @override
  String get diaryCatalogCFocoPrompt => 'Were you able to concentrate well?';

  @override
  String get diaryCatalogCProdLabel => 'Productive day';

  @override
  String get diaryCatalogCProdPrompt => 'Did you have a productive day?';

  @override
  String get diaryCatalogCSobrecLabel => 'Overwhelmed';

  @override
  String get diaryCatalogCSobrecPrompt => 'Did you feel overwhelmed?';

  @override
  String get diaryCatalogCPreocLabel => 'Worry';

  @override
  String get diaryCatalogCPreocPrompt => 'Were you worried about something?';

  @override
  String get diaryCatalogCDinheiroLabel => 'Money worries';

  @override
  String get diaryCatalogCDinheiroPrompt => 'Were you worried about money?';

  @override
  String get diaryCatalogCConflitoLabel => 'Argument';

  @override
  String get diaryCatalogCConflitoPrompt => 'Did you have an argument?';

  @override
  String get diaryCatalogCSozinhoLabel => 'Loneliness';

  @override
  String get diaryCatalogCSozinhoPrompt => 'Did you feel lonely?';

  @override
  String get diaryCatalogCRisadaLabel => 'Laughter';

  @override
  String get diaryCatalogCRisadaPrompt => 'Did you have a good laugh?';

  @override
  String get diaryCatalogCGratLabel => 'Gratitude';

  @override
  String get diaryCatalogCGratPrompt =>
      'Did you think or write about gratitude?';

  @override
  String get diaryCatalogCMeditLabel => 'Meditation';

  @override
  String get diaryCatalogCMeditPrompt => 'Did you meditate?';

  @override
  String get diaryCatalogCTerapiaLabel => 'Therapy';

  @override
  String get diaryCatalogCTerapiaPrompt => 'Did you have a therapy session?';

  @override
  String get diaryCatalogCFeLabel => 'Prayer or faith';

  @override
  String get diaryCatalogCFePrompt =>
      'Did you pray or attend a religious service?';

  @override
  String get diaryCatalogCEscritaLabel => 'Journaling';

  @override
  String get diaryCatalogCEscritaPrompt => 'Did you write in a diary?';

  @override
  String get diaryCatalogCLeituraLabel => 'Reading';

  @override
  String get diaryCatalogCLeituraPrompt => 'Did you read a book?';

  @override
  String get diaryCatalogCHobbyLabel => 'Hobby';

  @override
  String get diaryCatalogCHobbyPrompt =>
      'Did you do something just for enjoyment?';

  @override
  String get diaryCatalogCMusicaLabel => 'Music';

  @override
  String get diaryCatalogCMusicaPrompt => 'Did you listen to or play music?';

  @override
  String get diaryCatalogCSocialLabel => 'Friends';

  @override
  String get diaryCatalogCSocialPrompt => 'Did you meet friends?';

  @override
  String get diaryCatalogCFamiliaLabel => 'Family';

  @override
  String get diaryCatalogCFamiliaPrompt => 'Did you spend time with family?';

  @override
  String get diaryCatalogCNaturezaLabel => 'Nature';

  @override
  String get diaryCatalogCNaturezaPrompt => 'Did you spend time in nature?';

  @override
  String get diaryCatalogCRedesLabel => 'Social media';

  @override
  String get diaryCatalogCRedesPrompt =>
      'Did you spend a lot of time on social media?';

  @override
  String get diaryCatalogCNoticiasLabel => 'News';

  @override
  String get diaryCatalogCNoticiasPrompt => 'Did you consume a lot of news?';

  @override
  String get diaryCatalogCDesconectLabel => 'Time away from your phone';

  @override
  String get diaryCatalogCDesconectPrompt =>
      'Did you spend some time away from your phone?';

  @override
  String get diaryCatalogCTedioLabel => 'Boredom';

  @override
  String get diaryCatalogCTedioPrompt => 'Did you feel bored?';

  @override
  String get diaryCatalogCAceleradoLabel => 'Racing thoughts';

  @override
  String get diaryCatalogCAceleradoPrompt =>
      'Did your thoughts feel like they were racing?';

  @override
  String get diaryCatalogCPanicoLabel => 'Anxiety or panic attack';

  @override
  String get diaryCatalogCPanicoPrompt =>
      'Did you have an anxiety or panic attack?';

  @override
  String get diaryCatalogCLutoLabel => 'Grief';

  @override
  String get diaryCatalogCLutoPrompt => 'Are you experiencing grief?';

  @override
  String get diaryCatalogCAutoestLabel => 'Positive self-esteem';

  @override
  String get diaryCatalogCAutoestPrompt => 'Did you feel good about yourself?';

  @override
  String get diaryCatalogCArlivreLabel => 'Outdoors';

  @override
  String get diaryCatalogCArlivrePrompt => 'Did you spend time outdoors?';

  @override
  String get diaryCatalogCVoluntLabel => 'Helping someone';

  @override
  String get diaryCatalogCVoluntPrompt =>
      'Did you do something for someone today?';

  @override
  String get diaryCatalogCAprendeuLabel => 'Learning';

  @override
  String get diaryCatalogCAprendeuPrompt => 'Did you learn something new?';

  @override
  String get diaryCatalogCConversaLabel => 'Important conversation';

  @override
  String get diaryCatalogCConversaPrompt =>
      'Did you have a difficult or important conversation?';

  @override
  String get diaryCatalogCSemtempoLabel => 'No time for yourself';

  @override
  String get diaryCatalogCSemtempoPrompt =>
      'Did you have no time for yourself?';

  @override
  String get diaryCatalogCCalmaLabel => 'Calm day';

  @override
  String get diaryCatalogCCalmaPrompt => 'Did you have a calm day?';

  @override
  String get diaryCatalogCHomeoffLabel => 'Work from home';

  @override
  String get diaryCatalogCHomeoffPrompt => 'Did you work from home?';

  @override
  String get diaryCatalogCPresencialLabel => 'Work at the office';

  @override
  String get diaryCatalogCPresencialPrompt => 'Did you work at the office?';

  @override
  String get diaryCatalogCLongoLabel => 'Long workday';

  @override
  String get diaryCatalogCLongoPrompt => 'Did you work more than 10 hours?';

  @override
  String get diaryCatalogCReuniaoLabel => 'Evening work meeting';

  @override
  String get diaryCatalogCReuniaoPrompt =>
      'Did you work or attend a meeting at night?';

  @override
  String get diaryCatalogCPlantaoLabel => 'Night shift or on call';

  @override
  String get diaryCatalogCPlantaoPrompt =>
      'Did you work overnight or while on call?';

  @override
  String get diaryCatalogCTransitoLabel => 'Traffic';

  @override
  String get diaryCatalogCTransitoPrompt =>
      'Did you spend a long time in traffic?';

  @override
  String get diaryCatalogCDirigiuLabel => 'Long drive';

  @override
  String get diaryCatalogCDirigiuPrompt =>
      'Did you drive for more than an hour?';

  @override
  String get diaryCatalogCOnibusLabel => 'Public transport';

  @override
  String get diaryCatalogCOnibusPrompt =>
      'Did you take a crowded bus or train?';

  @override
  String get diaryCatalogCSentadoLabel => 'Prolonged sitting';

  @override
  String get diaryCatalogCSentadoPrompt =>
      'Did you spend much of the day sitting?';

  @override
  String get diaryCatalogCEmpeLabel => 'Standing';

  @override
  String get diaryCatalogCEmpePrompt => 'Did you spend a long time standing?';

  @override
  String get diaryCatalogCPassosLabel => 'Walking';

  @override
  String get diaryCatalogCPassosPrompt =>
      'Did you walk for more than 30 minutes?';

  @override
  String get diaryCatalogCEscadasLabel => 'Stairs';

  @override
  String get diaryCatalogCEscadasPrompt => 'Did you climb stairs?';

  @override
  String get diaryCatalogCCasa2Label => 'Housework';

  @override
  String get diaryCatalogCCasa2Prompt =>
      'Did you do cleaning or heavy housework?';

  @override
  String get diaryCatalogCFilhosLabel => 'Childcare';

  @override
  String get diaryCatalogCFilhosPrompt => 'Did you look after a child all day?';

  @override
  String get diaryCatalogCPetsLabel => 'Pet';

  @override
  String get diaryCatalogCPetsPrompt => 'Did you walk or play with your pet?';

  @override
  String get diaryCatalogCViagemLabel => 'Travel';

  @override
  String get diaryCatalogCViagemPrompt => 'Did you travel?';

  @override
  String get diaryCatalogCVooLabel => 'Flight';

  @override
  String get diaryCatalogCVooPrompt => 'Did you take a flight?';

  @override
  String get diaryCatalogCFusoLabel => 'Time zone change';

  @override
  String get diaryCatalogCFusoPrompt => 'Did you change time zones?';

  @override
  String get diaryCatalogCPraiaLabel => 'Beach';

  @override
  String get diaryCatalogCPraiaPrompt => 'Did you go to the beach?';

  @override
  String get diaryCatalogCPiscinaLabel => 'Swimming pool';

  @override
  String get diaryCatalogCPiscinaPrompt => 'Did you go in a swimming pool?';

  @override
  String get diaryCatalogCCalorLabel => 'Strong heat';

  @override
  String get diaryCatalogCCalorPrompt =>
      'Did you spend a long time in strong heat?';

  @override
  String get diaryCatalogCFrioLabel => 'Cold';

  @override
  String get diaryCatalogCFrioPrompt => 'Did you feel cold?';

  @override
  String get diaryCatalogCFestaLabel => 'Party or night out';

  @override
  String get diaryCatalogCFestaPrompt => 'Did you go out at night?';

  @override
  String get diaryCatalogCShowLabel => 'Concert or event';

  @override
  String get diaryCatalogCShowPrompt => 'Did you attend a concert or event?';

  @override
  String get diaryCatalogCFutebolLabel => 'Watched a match';

  @override
  String get diaryCatalogCFutebolPrompt => 'Did you watch a football match?';

  @override
  String get diaryCatalogCPeladaLabel => 'Casual football';

  @override
  String get diaryCatalogCPeladaPrompt => 'Did you play football with friends?';

  @override
  String get diaryCatalogCGamesLabel => 'Video games';

  @override
  String get diaryCatalogCGamesPrompt => 'Did you play video games?';

  @override
  String get diaryCatalogCSerieLabel => 'Binge-watching';

  @override
  String get diaryCatalogCSeriePrompt =>
      'Did you spend hours watching a series?';

  @override
  String get diaryCatalogCSexoLabel => 'Sexual activity';

  @override
  String get diaryCatalogCSexoPrompt => 'Did you have sexual activity?';

  @override
  String get diaryCatalogCCigarLabel => 'Smoking';

  @override
  String get diaryCatalogCCigarPrompt => 'Did you smoke?';

  @override
  String get diaryCatalogCVapeLabel => 'Vaping';

  @override
  String get diaryCatalogCVapePrompt => 'Did you use a vape or pod?';

  @override
  String get diaryCatalogCNarguileLabel => 'Hookah';

  @override
  String get diaryCatalogCNarguilePrompt => 'Did you smoke hookah?';

  @override
  String get diaryCatalogCCanabLabel => 'Cannabis';

  @override
  String get diaryCatalogCCanabPrompt => 'Did you use cannabis?';

  @override
  String get diaryCatalogCAcordoucedoLabel => 'Woke up early';

  @override
  String get diaryCatalogCAcordoucedoPrompt => 'Did you wake up before 6 am?';

  @override
  String get diaryCatalogCDormiuforaLabel => 'Slept away from home';

  @override
  String get diaryCatalogCDormiuforaPrompt => 'Did you sleep away from home?';

  @override
  String get diaryCatalogCViagemtrabLabel => 'Business trip';

  @override
  String get diaryCatalogCViagemtrabPrompt => 'Did you travel for work?';

  @override
  String get diaryCatalogCPrazoLabel => 'Deadline or exam';

  @override
  String get diaryCatalogCPrazoPrompt =>
      'Did you have an important deadline, exam or assignment?';

  @override
  String get diaryCatalogCPublicoLabel => 'Public speaking';

  @override
  String get diaryCatalogCPublicoPrompt =>
      'Did you give a presentation in public?';

  @override
  String get diaryCatalogCCuidadorLabel => 'Caregiving';

  @override
  String get diaryCatalogCCuidadorPrompt =>
      'Did you care for an ill or older family member?';

  @override
  String get diaryCatalogCMudancaLabel => 'Moving or renovation';

  @override
  String get diaryCatalogCMudancaPrompt => 'Are you moving home or renovating?';

  @override
  String get diaryCatalogCJardimLabel => 'Gardening';

  @override
  String get diaryCatalogCJardimPrompt => 'Did you spend time gardening?';

  @override
  String get diaryCatalogCChuvaLabel => 'Rainy day';

  @override
  String get diaryCatalogCChuvaPrompt => 'Did it rain all day?';

  @override
  String get diaryCatalogCSecoLabel => 'Dry weather';

  @override
  String get diaryCatalogCSecoPrompt => 'Was the air very dry?';

  @override
  String get diaryCatalogCFumacaLabel => 'Pollution or smoke';

  @override
  String get diaryCatalogCFumacaPrompt =>
      'Were you exposed to pollution or smoke?';

  @override
  String get diaryCatalogCFolgaLabel => 'Day off';

  @override
  String get diaryCatalogCFolgaPrompt => 'Was it a day off?';

  @override
  String get diaryCatalogCAcordouLabel => 'How you woke up';

  @override
  String get diaryCatalogCAcordouPrompt => 'How did you feel when you woke up?';

  @override
  String get diaryCatalogCAlongLabel => 'Stretching';

  @override
  String get diaryCatalogCAlongPrompt => 'Did you stretch?';

  @override
  String get diaryCatalogCMobilLabel => 'Mobility';

  @override
  String get diaryCatalogCMobilPrompt => 'Did you do mobility exercises?';

  @override
  String get diaryCatalogCSaunaLabel => 'Sauna';

  @override
  String get diaryCatalogCSaunaPrompt => 'Did you use a sauna?';

  @override
  String get diaryCatalogCBanhoqLabel => 'Hot shower';

  @override
  String get diaryCatalogCBanhoqPrompt =>
      'Did you take a hot shower before going to sleep?';

  @override
  String get diaryCatalogCMassaLabel => 'Massage';

  @override
  String get diaryCatalogCMassaPrompt => 'Did you have a massage?';

  @override
  String get diaryCatalogCRoloLabel => 'Foam rolling';

  @override
  String get diaryCatalogCRoloPrompt => 'Did you use a foam roller?';

  @override
  String get diaryCatalogCCompressLabel => 'Compression';

  @override
  String get diaryCatalogCCompressPrompt => 'Did you use compression boots?';

  @override
  String get diaryCatalogCFisioLabel => 'Physiotherapy';

  @override
  String get diaryCatalogCFisioPrompt => 'Did you have physiotherapy?';

  @override
  String get diaryCatalogCQuiroLabel => 'Chiropractic care';

  @override
  String get diaryCatalogCQuiroPrompt =>
      'Did you have chiropractic or osteopathic treatment?';

  @override
  String get diaryCatalogCAcupLabel => 'Acupuncture';

  @override
  String get diaryCatalogCAcupPrompt => 'Did you have acupuncture?';

  @override
  String get diaryCatalogCCochiloLabel => 'Nap';

  @override
  String get diaryCatalogCCochiloPrompt => 'Did you take a nap?';

  @override
  String get diaryCatalogCDescansoLabel => 'Rest day';

  @override
  String get diaryCatalogCDescansoPrompt => 'Was it a rest day?';

  @override
  String get diaryCatalogCYogaleveLabel => 'Gentle yoga';

  @override
  String get diaryCatalogCYogalevePrompt => 'Did you do restorative yoga?';

  @override
  String get diaryCatalogCPescocoLabel => 'Posture';

  @override
  String get diaryCatalogCPescocoPrompt =>
      'Did you pay attention to your posture at work?';

  @override
  String get diaryCatalogCBanheiraLabel => 'Ice bath';

  @override
  String get diaryCatalogCBanheiraPrompt => 'Did you take an ice bath?';

  @override
  String get diaryCatalogCCrioLabel => 'Cryotherapy';

  @override
  String get diaryCatalogCCrioPrompt => 'Did you have whole-body cryotherapy?';

  @override
  String get diaryCatalogCContrasteLabel => 'Contrast shower';

  @override
  String get diaryCatalogCContrastePrompt =>
      'Did you alternate between hot and cold water?';

  @override
  String get diaryCatalogCOfuroLabel => 'Soaking bath';

  @override
  String get diaryCatalogCOfuroPrompt => 'Did you take a soaking bath?';

  @override
  String get diaryCatalogCPistolaLabel => 'Massage gun';

  @override
  String get diaryCatalogCPistolaPrompt => 'Did you use a massage gun?';

  @override
  String get diaryCatalogCDrenagemLabel => 'Lymphatic drainage';

  @override
  String get diaryCatalogCDrenagemPrompt => 'Did you have lymphatic drainage?';

  @override
  String get diaryCatalogCLuzvermLabel => 'Red light';

  @override
  String get diaryCatalogCLuzvermPrompt => 'Did you have red light therapy?';

  @override
  String get diaryCatalogCHiperbLabel => 'Hyperbaric chamber';

  @override
  String get diaryCatalogCHiperbPrompt =>
      'Did you have a hyperbaric chamber session?';

  @override
  String get diaryCatalogCAlongnoiteLabel => 'Stretching before bed';

  @override
  String get diaryCatalogCAlongnoitePrompt =>
      'Did you stretch before going to sleep?';

  @override
  String get diaryCatalogCPernasLabel => 'Legs elevated';

  @override
  String get diaryCatalogCPernasPrompt =>
      'Did you rest with your legs elevated?';

  @override
  String get diaryCatalogCBolinhaLabel => 'Massage ball';

  @override
  String get diaryCatalogCBolinhaPrompt => 'Did you use a massage ball?';

  @override
  String get diaryCatalogCSolLabel => 'Morning sun';

  @override
  String get diaryCatalogCSolPrompt => 'Did you get morning sunlight?';

  @override
  String get diaryCatalogCLuzLabel => 'Bright light at night';

  @override
  String get diaryCatalogCLuzPrompt =>
      'Were you exposed to bright light after 9 pm?';

  @override
  String get diaryCatalogCTelaLabel => 'Screens in bed';

  @override
  String get diaryCatalogCTelaPrompt =>
      'Did you use your phone or watch TV in bed?';

  @override
  String get diaryCatalogCOculosLabel => 'Blue-light-blocking glasses';

  @override
  String get diaryCatalogCOculosPrompt =>
      'Did you wear blue-light-blocking glasses?';

  @override
  String get diaryCatalogCQuartoLabel => 'Dark bedroom';

  @override
  String get diaryCatalogCQuartoPrompt => 'Did you sleep in a dark bedroom?';

  @override
  String get diaryCatalogCFrescoLabel => 'Cool bedroom';

  @override
  String get diaryCatalogCFrescoPrompt => 'Did you sleep in a cool bedroom?';

  @override
  String get diaryCatalogCArcondLabel => 'Air conditioning';

  @override
  String get diaryCatalogCArcondPrompt =>
      'Did you sleep with air conditioning?';

  @override
  String get diaryCatalogCVentilLabel => 'Fan';

  @override
  String get diaryCatalogCVentilPrompt => 'Did you sleep with a fan?';

  @override
  String get diaryCatalogCTampaoLabel => 'Earplugs or sleep mask';

  @override
  String get diaryCatalogCTampaoPrompt =>
      'Did you use earplugs or a sleep mask?';

  @override
  String get diaryCatalogCLerCamaLabel => 'Reading before bed';

  @override
  String get diaryCatalogCLerCamaPrompt =>
      'Did you read before going to sleep?';

  @override
  String get diaryCatalogCDividiuLabel => 'Shared bed';

  @override
  String get diaryCatalogCDividiuPrompt =>
      'Did you share your bed with someone?';

  @override
  String get diaryCatalogCRoncoLabel => 'Partner snoring';

  @override
  String get diaryCatalogCRoncoPrompt =>
      'Did someone else\'s snoring disturb you?';

  @override
  String get diaryCatalogCPetcamaLabel => 'Pet in bed';

  @override
  String get diaryCatalogCPetcamaPrompt => 'Did your pet sleep in your bed?';

  @override
  String get diaryCatalogCFilhoLabel => 'Woken by a child';

  @override
  String get diaryCatalogCFilhoPrompt => 'Were you woken up by a child?';

  @override
  String get diaryCatalogCBarulhoLabel => 'Noise';

  @override
  String get diaryCatalogCBarulhoPrompt => 'Was there noise at night?';

  @override
  String get diaryCatalogCCalornoiteLabel => 'Feeling hot at night';

  @override
  String get diaryCatalogCCalornoitePrompt =>
      'Did you feel hot while sleeping?';

  @override
  String get diaryCatalogCHorarioLabel => 'Consistent bedtime';

  @override
  String get diaryCatalogCHorarioPrompt =>
      'Did you go to bed at your usual time?';

  @override
  String get diaryCatalogCTardouLabel => 'Late bedtime';

  @override
  String get diaryCatalogCTardouPrompt => 'Did you go to bed after midnight?';

  @override
  String get diaryCatalogCDespertLabel => 'Alarm clock';

  @override
  String get diaryCatalogCDespertPrompt => 'Did you wake up to an alarm?';

  @override
  String get diaryCatalogCSonecaLabel => 'Snooze';

  @override
  String get diaryCatalogCSonecaPrompt => 'Did you press snooze on your alarm?';

  @override
  String get diaryCatalogCMadrugadaLabel => 'Waking during the night';

  @override
  String get diaryCatalogCMadrugadaPrompt =>
      'Did you wake during the night and take a long time to fall asleep again?';

  @override
  String get diaryCatalogCPesadeloLabel => 'Restless dreams';

  @override
  String get diaryCatalogCPesadeloPrompt =>
      'Did you have nightmares or restless dreams?';

  @override
  String get diaryCatalogCBanhonoiteLabel => 'Shower before bed';

  @override
  String get diaryCatalogCBanhonoitePrompt =>
      'Did you take a shower before going to sleep?';

  @override
  String get diaryCatalogCRotinaLabel => 'Bedtime routine';

  @override
  String get diaryCatalogCRotinaPrompt =>
      'Did you follow your bedtime routine?';

  @override
  String get diaryCatalogCRuidoLabel => 'White noise';

  @override
  String get diaryCatalogCRuidoPrompt => 'Did you sleep with white noise?';

  @override
  String get diaryCatalogCMusicadormLabel => 'Sleep music';

  @override
  String get diaryCatalogCMusicadormPrompt =>
      'Did you listen to music to fall asleep?';

  @override
  String get diaryCatalogCCobertorLabel => 'Weighted blanket';

  @override
  String get diaryCatalogCCobertorPrompt => 'Did you use a weighted blanket?';

  @override
  String get diaryCatalogCFitabocaLabel => 'Mouth tape';

  @override
  String get diaryCatalogCFitabocaPrompt =>
      'Did you use mouth tape while sleeping?';

  @override
  String get diaryCatalogCSofaLabel => 'Slept on the sofa';

  @override
  String get diaryCatalogCSofaPrompt => 'Did you fall asleep on the sofa?';

  @override
  String get diaryCatalogCCelmadrLabel => 'Phone during the night';

  @override
  String get diaryCatalogCCelmadrPrompt =>
      'Did you check your phone during the night?';

  @override
  String get diaryCatalogCBanheiroLabel => 'Nighttime bathroom visit';

  @override
  String get diaryCatalogCBanheiroPrompt =>
      'Did you get up to use the bathroom at night?';

  @override
  String get diaryCatalogCCochilotardeLabel => 'Nap after 4 pm';

  @override
  String get diaryCatalogCCochilotardePrompt =>
      'Did you take a nap after 4 pm?';

  @override
  String get diaryCatalogCDorLabel => 'Headache';

  @override
  String get diaryCatalogCDorPrompt => 'Did you have a headache?';

  @override
  String get diaryCatalogCEnxaquecaLabel => 'Migraine';

  @override
  String get diaryCatalogCEnxaquecaPrompt => 'Did you have a migraine?';

  @override
  String get diaryCatalogCDoenteLabel => 'Feeling ill';

  @override
  String get diaryCatalogCDoentePrompt => 'Did you feel ill?';

  @override
  String get diaryCatalogCGripeLabel => 'Flu or cold';

  @override
  String get diaryCatalogCGripePrompt => 'Did you have flu or cold symptoms?';

  @override
  String get diaryCatalogCFebreLabel => 'Fever';

  @override
  String get diaryCatalogCFebrePrompt => 'Did you have a fever?';

  @override
  String get diaryCatalogCGargantaLabel => 'Sore throat';

  @override
  String get diaryCatalogCGargantaPrompt => 'Did you have a sore throat?';

  @override
  String get diaryCatalogCTosseLabel => 'Cough';

  @override
  String get diaryCatalogCTossePrompt => 'Did you have a cough?';

  @override
  String get diaryCatalogCCongestLabel => 'Blocked nose';

  @override
  String get diaryCatalogCCongestPrompt => 'Did you have a blocked nose?';

  @override
  String get diaryCatalogCRiniteLabel => 'Rhinitis or allergy';

  @override
  String get diaryCatalogCRinitePrompt =>
      'Did you have rhinitis or an allergy flare-up?';

  @override
  String get diaryCatalogCInchacoLabel => 'Bloating or swelling';

  @override
  String get diaryCatalogCInchacoPrompt => 'Did you feel bloated or swollen?';

  @override
  String get diaryCatalogCIntestinoLabel => 'Regular bowel movements';

  @override
  String get diaryCatalogCIntestinoPrompt =>
      'Were your bowel movements regular?';

  @override
  String get diaryCatalogCPresoLabel => 'Constipation';

  @override
  String get diaryCatalogCPresoPrompt => 'Were you constipated?';

  @override
  String get diaryCatalogCDiarreiaLabel => 'Diarrhea';

  @override
  String get diaryCatalogCDiarreiaPrompt => 'Did you have diarrhea?';

  @override
  String get diaryCatalogCAziaLabel => 'Heartburn or reflux';

  @override
  String get diaryCatalogCAziaPrompt => 'Did you have heartburn or reflux?';

  @override
  String get diaryCatalogCNauseaLabel => 'Nausea';

  @override
  String get diaryCatalogCNauseaPrompt => 'Did you feel nauseated?';

  @override
  String get diaryCatalogCCostasLabel => 'Back pain';

  @override
  String get diaryCatalogCCostasPrompt => 'Did you have back pain?';

  @override
  String get diaryCatalogCArticulLabel => 'Joint pain';

  @override
  String get diaryCatalogCArticulPrompt => 'Did you have joint pain?';

  @override
  String get diaryCatalogCLesaoLabel => 'Injury';

  @override
  String get diaryCatalogCLesaoPrompt => 'Do you have an injury?';

  @override
  String get diaryCatalogCDenteLabel => 'Toothache';

  @override
  String get diaryCatalogCDentePrompt => 'Did you have a toothache?';

  @override
  String get diaryCatalogCNevoaLabel => 'Brain fog';

  @override
  String get diaryCatalogCNevoaPrompt => 'Did you experience brain fog?';

  @override
  String get diaryCatalogCTonturaLabel => 'Dizziness';

  @override
  String get diaryCatalogCTonturaPrompt => 'Did you feel dizzy?';

  @override
  String get diaryCatalogCCansacoLabel => 'Extreme fatigue';

  @override
  String get diaryCatalogCCansacoPrompt => 'Did you feel unusually tired?';

  @override
  String get diaryCatalogCAcneLabel => 'Skin';

  @override
  String get diaryCatalogCAcnePrompt =>
      'Did you have pimples or irritated skin?';

  @override
  String get diaryCatalogCPalpitLabel => 'Palpitations';

  @override
  String get diaryCatalogCPalpitPrompt =>
      'Did your heart race while you were resting?';

  @override
  String get diaryCatalogCVacinaLabel => 'Vaccination';

  @override
  String get diaryCatalogCVacinaPrompt => 'Did you receive a vaccine?';

  @override
  String get diaryCatalogCConsultaLabel => 'Medical appointment';

  @override
  String get diaryCatalogCConsultaPrompt => 'Did you see a doctor?';

  @override
  String get diaryCatalogCExameLabel => 'Blood test';

  @override
  String get diaryCatalogCExamePrompt => 'Did you have a blood test?';

  @override
  String get diaryCatalogCPressaoaltaLabel => 'High blood pressure';

  @override
  String get diaryCatalogCPressaoaltaPrompt =>
      'Did you feel your blood pressure was high?';

  @override
  String get diaryCatalogCPressaobaixaLabel => 'Low blood pressure';

  @override
  String get diaryCatalogCPressaobaixaPrompt =>
      'Did you feel your blood pressure was low?';

  @override
  String get diaryCatalogCHipoglicLabel => 'Low blood sugar';

  @override
  String get diaryCatalogCHipoglicPrompt =>
      'Did you have a drop in blood sugar?';

  @override
  String get diaryCatalogCCaibraLabel => 'Muscle cramps';

  @override
  String get diaryCatalogCCaibraPrompt => 'Did you have muscle cramps?';

  @override
  String get diaryCatalogCOlhosLabel => 'Tired eyes';

  @override
  String get diaryCatalogCOlhosPrompt => 'Did your eyes feel tired?';

  @override
  String get diaryCatalogCOuvidoLabel => 'Earache';

  @override
  String get diaryCatalogCOuvidoPrompt => 'Did you have an earache?';

  @override
  String get diaryCatalogCSinusiteLabel => 'Sinusitis';

  @override
  String get diaryCatalogCSinusitePrompt =>
      'Did you have a sinusitis flare-up?';

  @override
  String get diaryCatalogCAsmaLabel => 'Asthma attack';

  @override
  String get diaryCatalogCAsmaPrompt => 'Did you have an asthma attack?';

  @override
  String get diaryCatalogCJoelhoLabel => 'Knee pain';

  @override
  String get diaryCatalogCJoelhoPrompt => 'Did you have knee pain?';

  @override
  String get diaryCatalogCOmbroLabel => 'Shoulder pain';

  @override
  String get diaryCatalogCOmbroPrompt => 'Did you have shoulder pain?';

  @override
  String get diaryCatalogCDentistaLabel => 'Dentist';

  @override
  String get diaryCatalogCDentistaPrompt => 'Did you see a dentist?';

  @override
  String get diaryCatalogCProcedimentoLabel => 'Medical procedure or surgery';

  @override
  String get diaryCatalogCProcedimentoPrompt =>
      'Did you have a medical procedure?';

  @override
  String get diaryCatalogCGasesLabel => 'Gas';

  @override
  String get diaryCatalogCGasesPrompt => 'Did you have gas or bloating?';

  @override
  String get diaryCatalogCMenstrLabel => 'Menstruation';

  @override
  String get diaryCatalogCMenstrPrompt => 'Are you menstruating?';

  @override
  String get diaryCatalogCFluxoLabel => 'Heavy menstrual flow';

  @override
  String get diaryCatalogCFluxoPrompt => 'Is your menstrual flow heavy?';

  @override
  String get diaryCatalogCColicaLabel => 'Cramps';

  @override
  String get diaryCatalogCColicaPrompt => 'Did you have cramps?';

  @override
  String get diaryCatalogCTpmLabel => 'PMS';

  @override
  String get diaryCatalogCTpmPrompt => 'Did you have PMS symptoms?';

  @override
  String get diaryCatalogCOvulLabel => 'Ovulation';

  @override
  String get diaryCatalogCOvulPrompt => 'Are you ovulating?';

  @override
  String get diaryCatalogCAnticonLabel => 'Contraceptive pill';

  @override
  String get diaryCatalogCAnticonPrompt =>
      'Did you take your contraceptive pill?';

  @override
  String get diaryCatalogCCaloraoLabel => 'Hot flashes';

  @override
  String get diaryCatalogCCaloraoPrompt => 'Did you have hot flashes?';

  @override
  String get diaryCatalogCSuornoiteLabel => 'Night sweats';

  @override
  String get diaryCatalogCSuornoitePrompt => 'Did you sweat at night?';

  @override
  String get diaryCatalogCLibidoLabel => 'Libido';

  @override
  String get diaryCatalogCLibidoPrompt => 'Did you feel your libido was high?';

  @override
  String get diaryCatalogCSeiosLabel => 'Breast tenderness';

  @override
  String get diaryCatalogCSeiosPrompt => 'Did your breasts feel tender?';

  @override
  String get diaryCatalogCRetencaoLabel => 'Fluid retention';

  @override
  String get diaryCatalogCRetencaoPrompt =>
      'Did you experience fluid retention?';

  @override
  String get diaryCatalogCGravidezLabel => 'Pregnancy';

  @override
  String get diaryCatalogCGravidezPrompt => 'Are you pregnant?';

  @override
  String get diaryCatalogCAmamentLabel => 'Breastfeeding';

  @override
  String get diaryCatalogCAmamentPrompt => 'Are you breastfeeding?';

  @override
  String get diaryCatalogCReposicaoLabel => 'Hormone replacement';

  @override
  String get diaryCatalogCReposicaoPrompt =>
      'Did you have hormone replacement therapy?';

  @override
  String get diaryCatalogCTestoLabel => 'Testosterone';

  @override
  String get diaryCatalogCTestoPrompt =>
      'Did you take a testosterone injection?';

  @override
  String get diaryCatalogCEscapeLabel => 'Spotting';

  @override
  String get diaryCatalogCEscapePrompt =>
      'Did you have spotting outside your period?';

  @override
  String get diaryCatalogCAcnehormLabel => 'Hormonal acne';

  @override
  String get diaryCatalogCAcnehormPrompt =>
      'Did you have acne related to your cycle?';

  @override
  String get diaryCatalogCHumorcicloLabel => 'Cycle-related mood changes';

  @override
  String get diaryCatalogCHumorcicloPrompt =>
      'Did your mood change with your cycle?';

  @override
  String get diaryCatalogCMenopausaLabel => 'Menopause';

  @override
  String get diaryCatalogCMenopausaPrompt =>
      'Did you experience menopause symptoms?';

  @override
  String get diaryCatalogCTesteovulLabel => 'Ovulation test';

  @override
  String get diaryCatalogCTesteovulPrompt => 'Did you take an ovulation test?';

  @override
  String get diaryCatalogCTentandoLabel => 'Trying to conceive';

  @override
  String get diaryCatalogCTentandoPrompt => 'Are you trying to conceive?';

  @override
  String get diaryCatalogCPospartoLabel => 'Postpartum';

  @override
  String get diaryCatalogCPospartoPrompt => 'Are you in the postpartum period?';

  @override
  String get diaryCatalogCMagLabel => 'Magnesium';

  @override
  String get diaryCatalogCMagPrompt => 'Did you take magnesium?';

  @override
  String get diaryCatalogCWheyLabel => 'Whey protein';

  @override
  String get diaryCatalogCWheyPrompt => 'Did you take whey protein?';

  @override
  String get diaryCatalogCVitdLabel => 'Vitamin D';

  @override
  String get diaryCatalogCVitdPrompt => 'Did you take vitamin D?';

  @override
  String get diaryCatalogCOmegaLabel => 'Omega-3';

  @override
  String get diaryCatalogCOmegaPrompt => 'Did you take omega-3?';

  @override
  String get diaryCatalogCColagLabel => 'Collagen';

  @override
  String get diaryCatalogCColagPrompt => 'Did you take collagen?';

  @override
  String get diaryCatalogCAshwaLabel => 'Ashwagandha';

  @override
  String get diaryCatalogCAshwaPrompt => 'Did you take ashwagandha?';

  @override
  String get diaryCatalogCZincoLabel => 'Zinc';

  @override
  String get diaryCatalogCZincoPrompt => 'Did you take zinc?';

  @override
  String get diaryCatalogCFerroLabel => 'Iron';

  @override
  String get diaryCatalogCFerroPrompt => 'Did you take iron?';

  @override
  String get diaryCatalogCB12Label => 'Vitamin B12';

  @override
  String get diaryCatalogCB12Prompt => 'Did you take vitamin B12?';

  @override
  String get diaryCatalogCComplexobLabel => 'B-complex vitamins';

  @override
  String get diaryCatalogCComplexobPrompt => 'Did you take B-complex vitamins?';

  @override
  String get diaryCatalogCVitcLabel => 'Vitamin C';

  @override
  String get diaryCatalogCVitcPrompt => 'Did you take vitamin C?';

  @override
  String get diaryCatalogCK2Label => 'Vitamin K2';

  @override
  String get diaryCatalogCK2Prompt => 'Did you take vitamin K2?';

  @override
  String get diaryCatalogCMultiLabel => 'Multivitamin';

  @override
  String get diaryCatalogCMultiPrompt => 'Did you take a multivitamin?';

  @override
  String get diaryCatalogCProbioLabel => 'Probiotic';

  @override
  String get diaryCatalogCProbioPrompt => 'Did you take a probiotic?';

  @override
  String get diaryCatalogCPsylliumLabel => 'Fiber (psyllium)';

  @override
  String get diaryCatalogCPsylliumPrompt => 'Did you take powdered fiber?';

  @override
  String get diaryCatalogCGlicinaLabel => 'Glycine';

  @override
  String get diaryCatalogCGlicinaPrompt => 'Did you take glycine?';

  @override
  String get diaryCatalogCTeaninaLabel => 'L-theanine';

  @override
  String get diaryCatalogCTeaninaPrompt => 'Did you take L-theanine?';

  @override
  String get diaryCatalogCCafcapLabel => 'Caffeine capsules';

  @override
  String get diaryCatalogCCafcapPrompt => 'Did you take caffeine capsules?';

  @override
  String get diaryCatalogCPretreinoLabel => 'Pre-workout supplement';

  @override
  String get diaryCatalogCPretreinoPrompt =>
      'Did you take a pre-workout supplement?';

  @override
  String get diaryCatalogCBetaLabel => 'Beta-alanine';

  @override
  String get diaryCatalogCBetaPrompt => 'Did you take beta-alanine?';

  @override
  String get diaryCatalogCEletroLabel => 'Electrolytes';

  @override
  String get diaryCatalogCEletroPrompt => 'Did you take electrolytes?';

  @override
  String get diaryCatalogCCurcumaLabel => 'Turmeric';

  @override
  String get diaryCatalogCCurcumaPrompt => 'Did you take turmeric?';

  @override
  String get diaryCatalogCPropolisLabel => 'Propolis';

  @override
  String get diaryCatalogCPropolisPrompt => 'Did you take propolis?';

  @override
  String get diaryCatalogCMacaLabel => 'Maca';

  @override
  String get diaryCatalogCMacaPrompt => 'Did you take maca?';

  @override
  String get diaryCatalogCSpirulLabel => 'Spirulina';

  @override
  String get diaryCatalogCSpirulPrompt => 'Did you take spirulina?';

  @override
  String get diaryCatalogCCogumLabel => 'Mushroom supplements';

  @override
  String get diaryCatalogCCogumPrompt =>
      'Did you take adaptogenic mushroom supplements?';

  @override
  String get diaryCatalogCBiotinaLabel => 'Biotin';

  @override
  String get diaryCatalogCBiotinaPrompt => 'Did you take biotin?';

  @override
  String get diaryCatalogCCalcioLabel => 'Calcium';

  @override
  String get diaryCatalogCCalcioPrompt => 'Did you take calcium?';

  @override
  String get diaryCatalogCSelenioLabel => 'Selenium';

  @override
  String get diaryCatalogCSelenioPrompt => 'Did you take selenium?';

  @override
  String get diaryCatalogCCoq10Label => 'Coenzyme Q10';

  @override
  String get diaryCatalogCCoq10Prompt => 'Did you take coenzyme Q10?';

  @override
  String get diaryCatalogCNacLabel => 'NAC';

  @override
  String get diaryCatalogCNacPrompt => 'Did you take NAC (N-acetylcysteine)?';

  @override
  String get diaryCatalogCCitrulinaLabel => 'Citrulline';

  @override
  String get diaryCatalogCCitrulinaPrompt => 'Did you take citrulline?';

  @override
  String get diaryCatalogCGlutaminaLabel => 'Glutamine';

  @override
  String get diaryCatalogCGlutaminaPrompt => 'Did you take glutamine?';

  @override
  String get diaryCatalogCBcaaLabel => 'BCAA';

  @override
  String get diaryCatalogCBcaaPrompt => 'Did you take BCAA?';

  @override
  String get diaryCatalogCTaurinaLabel => 'Taurine';

  @override
  String get diaryCatalogCTaurinaPrompt => 'Did you take taurine?';

  @override
  String get diaryCatalogCCarnitinaLabel => 'Carnitine';

  @override
  String get diaryCatalogCCarnitinaPrompt => 'Did you take carnitine?';

  @override
  String get diaryCatalogCTriptofanoLabel => 'Tryptophan';

  @override
  String get diaryCatalogCTriptofanoPrompt => 'Did you take tryptophan?';

  @override
  String get diaryCatalogCGabaLabel => 'GABA';

  @override
  String get diaryCatalogCGabaPrompt => 'Did you take GABA?';

  @override
  String get diaryCatalogCValerianaLabel => 'Valerian or passionflower';

  @override
  String get diaryCatalogCValerianaPrompt =>
      'Did you take valerian or passionflower?';

  @override
  String get diaryCatalogCFolicoLabel => 'Folic acid';

  @override
  String get diaryCatalogCFolicoPrompt => 'Did you take folic acid?';

  @override
  String get diaryCatalogCViteLabel => 'Vitamin E';

  @override
  String get diaryCatalogCVitePrompt => 'Did you take vitamin E?';

  @override
  String get diaryCatalogCResverLabel => 'Resveratrol';

  @override
  String get diaryCatalogCResverPrompt => 'Did you take resveratrol?';

  @override
  String get diaryCatalogCBerberLabel => 'Berberine';

  @override
  String get diaryCatalogCBerberPrompt => 'Did you take berberine?';

  @override
  String get diaryCatalogCInositolLabel => 'Inositol';

  @override
  String get diaryCatalogCInositolPrompt => 'Did you take inositol?';

  @override
  String get diaryCatalogCMelatLabel => 'Melatonin';

  @override
  String get diaryCatalogCMelatPrompt => 'Did you take melatonin?';

  @override
  String get diaryCatalogCRemedLabel => 'Sleep medication';

  @override
  String get diaryCatalogCRemedPrompt => 'Did you take sleep medication?';

  @override
  String get diaryCatalogCAnalgLabel => 'Pain relief medication';

  @override
  String get diaryCatalogCAnalgPrompt =>
      'Did you take pain relief medication such as dipyrone or paracetamol?';

  @override
  String get diaryCatalogCAntiinfLabel => 'Anti-inflammatory medication';

  @override
  String get diaryCatalogCAntiinfPrompt =>
      'Did you take anti-inflammatory medication?';

  @override
  String get diaryCatalogCAntialLabel => 'Antihistamine';

  @override
  String get diaryCatalogCAntialPrompt => 'Did you take an antihistamine?';

  @override
  String get diaryCatalogCDescongLabel => 'Decongestant';

  @override
  String get diaryCatalogCDescongPrompt => 'Did you use a nasal decongestant?';

  @override
  String get diaryCatalogCAntibLabel => 'Antibiotic';

  @override
  String get diaryCatalogCAntibPrompt => 'Did you take an antibiotic?';

  @override
  String get diaryCatalogCCorticLabel => 'Corticosteroid';

  @override
  String get diaryCatalogCCorticPrompt => 'Did you take a corticosteroid?';

  @override
  String get diaryCatalogCRelaxmuscLabel => 'Muscle relaxant';

  @override
  String get diaryCatalogCRelaxmuscPrompt => 'Did you take a muscle relaxant?';

  @override
  String get diaryCatalogCEnjooLabel => 'Nausea medication';

  @override
  String get diaryCatalogCEnjooPrompt => 'Did you take nausea medication?';

  @override
  String get diaryCatalogCAnsiolLabel => 'Anxiety medication';

  @override
  String get diaryCatalogCAnsiolPrompt => 'Did you take anxiety medication?';

  @override
  String get diaryCatalogCAntidepLabel => 'Antidepressant';

  @override
  String get diaryCatalogCAntidepPrompt => 'Did you take an antidepressant?';

  @override
  String get diaryCatalogCEstimLabel => 'ADHD medication';

  @override
  String get diaryCatalogCEstimPrompt => 'Did you take ADHD medication?';

  @override
  String get diaryCatalogCPressaoLabel => 'Blood pressure medication';

  @override
  String get diaryCatalogCPressaoPrompt =>
      'Did you take blood pressure medication?';

  @override
  String get diaryCatalogCTireoideLabel => 'Thyroid medication';

  @override
  String get diaryCatalogCTireoidePrompt => 'Did you take thyroid medication?';

  @override
  String get diaryCatalogCDiabetesLabel => 'Diabetes medication';

  @override
  String get diaryCatalogCDiabetesPrompt =>
      'Did you take diabetes medication or insulin?';

  @override
  String get diaryCatalogCGlp1Label => 'GLP-1 medication';

  @override
  String get diaryCatalogCGlp1Prompt =>
      'Did you take injectable medication for weight management or diabetes (semaglutide or tirzepatide)?';

  @override
  String get diaryCatalogCAnticoncep2Label => 'Hormone medication';

  @override
  String get diaryCatalogCAnticoncep2Prompt =>
      'Did you take hormone medication?';

  @override
  String get diaryCatalogCIsotretLabel => 'Isotretinoin';

  @override
  String get diaryCatalogCIsotretPrompt =>
      'Did you take isotretinoin for acne?';

  @override
  String get diaryCatalogCMinoxLabel => 'Minoxidil';

  @override
  String get diaryCatalogCMinoxPrompt => 'Did you use minoxidil?';

  @override
  String get diaryCatalogCFinastLabel => 'Finasteride';

  @override
  String get diaryCatalogCFinastPrompt => 'Did you take finasteride?';

  @override
  String get diaryCatalogCNotempoLabel => 'Medication on time';

  @override
  String get diaryCatalogCNotempoPrompt =>
      'Did you take your medication on time?';

  @override
  String get diaryCatalogCEsqueceuLabel => 'Missed medication';

  @override
  String get diaryCatalogCEsqueceuPrompt =>
      'Did you forget to take any medication?';

  @override
  String get diaryCatalogCProtgastLabel => 'Stomach protection medication';

  @override
  String get diaryCatalogCProtgastPrompt =>
      'Did you take omeprazole or stomach protection medication?';

  @override
  String get diaryCatalogCAntiacidoLabel => 'Antacid';

  @override
  String get diaryCatalogCAntiacidoPrompt => 'Did you take an antacid?';

  @override
  String get diaryCatalogCLaxanteLabel => 'Laxative';

  @override
  String get diaryCatalogCLaxantePrompt => 'Did you take a laxative?';

  @override
  String get diaryCatalogCAntidiarLabel => 'Diarrhea medication';

  @override
  String get diaryCatalogCAntidiarPrompt => 'Did you take diarrhea medication?';

  @override
  String get diaryCatalogCColicaremLabel => 'Cramp medication';

  @override
  String get diaryCatalogCColicaremPrompt =>
      'Did you take medication for cramps?';

  @override
  String get diaryCatalogCEnxaqremLabel => 'Migraine medication';

  @override
  String get diaryCatalogCEnxaqremPrompt => 'Did you take migraine medication?';

  @override
  String get diaryCatalogCAntitermicoLabel => 'Fever medication';

  @override
  String get diaryCatalogCAntitermicoPrompt => 'Did you take fever medication?';

  @override
  String get diaryCatalogCXaropeLabel => 'Cough syrup';

  @override
  String get diaryCatalogCXaropePrompt => 'Did you take cough syrup?';

  @override
  String get diaryCatalogCBombinhaLabel => 'Asthma inhaler';

  @override
  String get diaryCatalogCBombinhaPrompt => 'Did you use an asthma inhaler?';

  @override
  String get diaryCatalogCSpraynasalLabel => 'Steroid nasal spray';

  @override
  String get diaryCatalogCSpraynasalPrompt =>
      'Did you use a steroid nasal spray?';

  @override
  String get diaryCatalogCColirioLabel => 'Eye drops';

  @override
  String get diaryCatalogCColirioPrompt => 'Did you use eye drops?';

  @override
  String get diaryCatalogCPomadaLabel => 'Topical medication';

  @override
  String get diaryCatalogCPomadaPrompt =>
      'Did you use a medicated cream or ointment?';

  @override
  String get diaryCatalogCAntifungLabel => 'Antifungal medication';

  @override
  String get diaryCatalogCAntifungPrompt =>
      'Did you take antifungal medication?';

  @override
  String get diaryCatalogCAntiviralLabel => 'Antiviral medication';

  @override
  String get diaryCatalogCAntiviralPrompt =>
      'Did you take antiviral medication?';

  @override
  String get diaryCatalogCEstatinaLabel => 'Cholesterol medication';

  @override
  String get diaryCatalogCEstatinaPrompt =>
      'Did you take cholesterol medication?';

  @override
  String get diaryCatalogCAnticoagLabel => 'Anticoagulant';

  @override
  String get diaryCatalogCAnticoagPrompt => 'Did you take an anticoagulant?';

  @override
  String get diaryCatalogCMetformLabel => 'Metformin';

  @override
  String get diaryCatalogCMetformPrompt => 'Did you take metformin?';

  @override
  String get diaryCatalogCAnticonvLabel => 'Anticonvulsant';

  @override
  String get diaryCatalogCAnticonvPrompt => 'Did you take an anticonvulsant?';

  @override
  String get diaryCatalogCEstabilLabel => 'Mood stabilizer';

  @override
  String get diaryCatalogCEstabilPrompt => 'Did you take a mood stabilizer?';

  @override
  String get diaryCatalogCInjecaoLabel => 'Vitamin injection';

  @override
  String get diaryCatalogCInjecaoPrompt =>
      'Did you receive a vitamin injection?';

  @override
  String get diaryCatalogCProtetorLabel => 'Sunscreen';

  @override
  String get diaryCatalogCProtetorPrompt => 'Did you apply sunscreen?';

  @override
  String get diaryCatalogCSkincareLabel => 'Skincare';

  @override
  String get diaryCatalogCSkincarePrompt =>
      'Did you follow your skincare routine?';

  @override
  String get diaryCatalogCHidratLabel => 'Skin moisturizer';

  @override
  String get diaryCatalogCHidratPrompt => 'Did you apply moisturizer?';

  @override
  String get diaryCatalogCFiodentalLabel => 'Flossing';

  @override
  String get diaryCatalogCFiodentalPrompt => 'Did you floss your teeth?';

  @override
  String get diaryCatalogCPausaLabel => 'Work breaks';

  @override
  String get diaryCatalogCPausaPrompt => 'Did you take breaks at work?';

  @override
  String get diaryCatalogCPostura2Label => 'Ergonomics';

  @override
  String get diaryCatalogCPostura2Prompt =>
      'Did you work in a comfortable position?';

  @override
  String get diaryCatalogCCelnoiteLabel => 'Night mode';

  @override
  String get diaryCatalogCCelnoitePrompt =>
      'Did you put your phone in night mode?';

  @override
  String get diaryCatalogCOrganizouLabel => 'Planned the day';

  @override
  String get diaryCatalogCOrganizouPrompt =>
      'Did you plan your day in advance?';

  @override
  String get diaryCatalogCNatureza2Label => 'Contact with nature';

  @override
  String get diaryCatalogCNatureza2Prompt =>
      'Did you touch grass or spend time in contact with nature?';

  @override
  String get diaryCatalogCR130Label => 'Stood up every hour';

  @override
  String get diaryCatalogCR130Prompt =>
      'Did you get up from your chair every hour?';

  @override
  String get diaryCatalogCR131Label => 'Stairs instead of the lift';

  @override
  String get diaryCatalogCR131Prompt =>
      'Did you take the stairs instead of the lift?';

  @override
  String get diaryCatalogCR132Label => 'Movement breaks at work';

  @override
  String get diaryCatalogCR132Prompt => 'Did you take movement breaks at work?';

  @override
  String get diaryCatalogCR133Label => 'Everyday lifting';

  @override
  String get diaryCatalogCR133Prompt =>
      'Did you carry heavy items such as groceries or a child?';

  @override
  String get diaryCatalogCR134Label => 'Played with children';

  @override
  String get diaryCatalogCR134Prompt => 'Did you play actively with children?';

  @override
  String get diaryCatalogCR136Label => 'Phone on waking';

  @override
  String get diaryCatalogCR136Prompt =>
      'Did you pick up your phone as soon as you woke up?';

  @override
  String get diaryCatalogCR137Label => 'Phone during meals';

  @override
  String get diaryCatalogCR137Prompt => 'Did you use your phone during meals?';

  @override
  String get diaryCatalogCR138Label => 'Work messages after hours';

  @override
  String get diaryCatalogCR138Prompt =>
      'Did you respond to work messages after hours?';

  @override
  String get diaryCatalogCR139Label => 'Short videos';

  @override
  String get diaryCatalogCR139Prompt =>
      'Did you scroll through short videos such as Reels or TikTok?';

  @override
  String get diaryCatalogCR1310Label => 'Mobile games';

  @override
  String get diaryCatalogCR1310Prompt => 'Did you play mobile games?';

  @override
  String get diaryCatalogCR1311Label => 'Online betting';

  @override
  String get diaryCatalogCR1311Prompt => 'Did you bet online?';

  @override
  String get diaryCatalogCR1312Label => 'Eye breaks';

  @override
  String get diaryCatalogCR1312Prompt =>
      'Did you take breaks to rest your eyes?';

  @override
  String get diaryCatalogCR1313Label => 'Focus mode';

  @override
  String get diaryCatalogCR1313Prompt => 'Did you use focus mode?';

  @override
  String get diaryCatalogCR1314Label => 'Notifications off';

  @override
  String get diaryCatalogCR1314Prompt => 'Did you turn off notifications?';

  @override
  String get diaryCatalogCR1315Label => 'Uninterrupted work';

  @override
  String get diaryCatalogCR1315Prompt =>
      'Did you have a period of uninterrupted work?';

  @override
  String get diaryCatalogCR1316Label => 'Phone outside the bedroom';

  @override
  String get diaryCatalogCR1316Prompt =>
      'Did you leave your phone outside the bedroom?';

  @override
  String get diaryCatalogCR1317Label => 'Brushed teeth three times';

  @override
  String get diaryCatalogCR1317Prompt =>
      'Did you brush your teeth three times?';

  @override
  String get diaryCatalogCR1318Label => 'Removed makeup';

  @override
  String get diaryCatalogCR1318Prompt =>
      'Did you remove your makeup before bed?';

  @override
  String get diaryCatalogCR1319Label => 'Hair care';

  @override
  String get diaryCatalogCR1319Prompt =>
      'Did you moisturize or care for your hair?';

  @override
  String get diaryCatalogCR1320Label => 'Nail care';

  @override
  String get diaryCatalogCR1320Prompt => 'Did you do your nails?';

  @override
  String get diaryCatalogCR1321Label => 'Shaving';

  @override
  String get diaryCatalogCR1321Prompt => 'Did you shave?';

  @override
  String get diaryCatalogCR1322Label => 'Insect repellent';

  @override
  String get diaryCatalogCR1322Prompt => 'Did you apply insect repellent?';

  @override
  String get diaryCatalogCR1323Label => 'Lip care';

  @override
  String get diaryCatalogCR1323Prompt => 'Did you moisturize your lips?';

  @override
  String get diaryCatalogCR1324Label => 'Time for yourself';

  @override
  String get diaryCatalogCR1324Prompt =>
      'Did you have some time just for yourself?';

  @override
  String get diaryCatalogCR1325Label => 'Dipyrone';

  @override
  String get diaryCatalogCR1325Prompt => 'Did you take dipyrone?';

  @override
  String get diaryCatalogCR1326Label => 'Paracetamol';

  @override
  String get diaryCatalogCR1326Prompt => 'Did you take paracetamol?';

  @override
  String get diaryCatalogCR1327Label => 'Ibuprofen';

  @override
  String get diaryCatalogCR1327Prompt => 'Did you take ibuprofen?';

  @override
  String get diaryCatalogCR1328Label => 'Nimesulide';

  @override
  String get diaryCatalogCR1328Prompt => 'Did you take nimesulide?';

  @override
  String get diaryCatalogCR1329Label => 'Muscle relaxant with pain relief';

  @override
  String get diaryCatalogCR1329Prompt =>
      'Did you take a muscle relaxant with pain relief medication?';

  @override
  String get diaryCatalogCR1330Label => 'Omeprazole';

  @override
  String get diaryCatalogCR1330Prompt => 'Did you take omeprazole?';

  @override
  String get diaryCatalogCR1331Label => 'Gas relief medication';

  @override
  String get diaryCatalogCR1331Prompt => 'Did you take medication for gas?';

  @override
  String get diaryCatalogCR1332Label => 'Losartan';

  @override
  String get diaryCatalogCR1332Prompt => 'Did you take losartan?';

  @override
  String get diaryCatalogCR1333Label => 'Levothyroxine';

  @override
  String get diaryCatalogCR1333Prompt => 'Did you take levothyroxine?';

  @override
  String get diaryCatalogCR1334Label => 'Sertraline or escitalopram';

  @override
  String get diaryCatalogCR1334Prompt => 'Did you take your antidepressant?';

  @override
  String get diaryCatalogCR1335Label => 'Clonazepam';

  @override
  String get diaryCatalogCR1335Prompt => 'Did you take clonazepam?';

  @override
  String get diaryCatalogCR1336Label => 'Zolpidem';

  @override
  String get diaryCatalogCR1336Prompt => 'Did you take zolpidem?';

  @override
  String get diaryCatalogCR1337Label => 'Loratadine';

  @override
  String get diaryCatalogCR1337Prompt => 'Did you take loratadine?';

  @override
  String get diaryCatalogCR1338Label => 'Insulin';

  @override
  String get diaryCatalogCR1338Prompt => 'Did you take an insulin injection?';

  @override
  String get diaryCatalogCR1339Label => 'Sildenafil or tadalafil';

  @override
  String get diaryCatalogCR1339Prompt =>
      'Did you take sildenafil or tadalafil?';

  @override
  String get diaryCatalogCR1340Label => 'Saline nasal rinse';

  @override
  String get diaryCatalogCR1340Prompt => 'Did you use a saline nasal rinse?';

  @override
  String get diaryCatalogCR1341Label => 'Urinary tract infection medication';

  @override
  String get diaryCatalogCR1341Prompt =>
      'Did you take medication for a urinary tract infection?';

  @override
  String get diaryCatalogCR1342Label => 'Thermogenic supplement';

  @override
  String get diaryCatalogCR1342Prompt =>
      'Did you take a thermogenic supplement?';

  @override
  String get diaryCatalogCR1343Label => 'Mass gainer';

  @override
  String get diaryCatalogCR1343Prompt => 'Did you take a mass gainer?';

  @override
  String get diaryCatalogCR1344Label => 'Chromium picolinate';

  @override
  String get diaryCatalogCR1344Prompt => 'Did you take chromium picolinate?';

  @override
  String get diaryCatalogCR1345Label => 'Evening primrose oil';

  @override
  String get diaryCatalogCR1345Prompt => 'Did you take evening primrose oil?';

  @override
  String get diaryCatalogCR1346Label => 'Brewer\'s yeast';

  @override
  String get diaryCatalogCR1346Prompt => 'Did you take brewer\'s yeast?';

  @override
  String get diaryCatalogCR1347Label => 'Apple cider vinegar capsules';

  @override
  String get diaryCatalogCR1347Prompt =>
      'Did you take apple cider vinegar capsules?';

  @override
  String get diaryCatalogCR1348Label => 'Cranberry';

  @override
  String get diaryCatalogCR1348Prompt => 'Did you take cranberry?';

  @override
  String get diaryCatalogCR1349Label => 'Children\'s multivitamin';

  @override
  String get diaryCatalogCR1349Prompt => 'Did you give a child a multivitamin?';

  @override
  String get diaryCatalogCR1350Label => 'IUD';

  @override
  String get diaryCatalogCR1350Prompt => 'Do you use an IUD?';

  @override
  String get diaryCatalogCR1351Label => 'Contraceptive implant';

  @override
  String get diaryCatalogCR1351Prompt => 'Do you use a contraceptive implant?';

  @override
  String get diaryCatalogCR1352Label => 'Contraceptive injection';

  @override
  String get diaryCatalogCR1352Prompt =>
      'Did you receive a contraceptive injection?';

  @override
  String get diaryCatalogCR1353Label => 'Emergency contraception';

  @override
  String get diaryCatalogCR1353Prompt =>
      'Did you take emergency contraception?';

  @override
  String get diaryCatalogCR1354Label => 'Missed contraceptive pill';

  @override
  String get diaryCatalogCR1354Prompt =>
      'Did you miss your contraceptive pill?';

  @override
  String get diaryCatalogCR1355Label => 'Endometriosis';

  @override
  String get diaryCatalogCR1355Prompt => 'Did you have endometriosis pain?';

  @override
  String get diaryCatalogCR1356Label => 'Polycystic ovary syndrome (PCOS)';

  @override
  String get diaryCatalogCR1356Prompt => 'Did you have PCOS symptoms?';

  @override
  String get diaryCatalogCR1357Label => 'Yeast infection';

  @override
  String get diaryCatalogCR1357Prompt => 'Did you have a yeast infection?';

  @override
  String get diaryCatalogCR1358Label => 'Urinary tract infection';

  @override
  String get diaryCatalogCR1358Prompt =>
      'Did you have a urinary tract infection?';

  @override
  String get diaryCatalogCR1359Label => 'Vaginal dryness';

  @override
  String get diaryCatalogCR1359Prompt => 'Did you experience vaginal dryness?';

  @override
  String get diaryCatalogCR1360Label => 'Hair loss';

  @override
  String get diaryCatalogCR1360Prompt => 'Did you notice hair loss?';

  @override
  String get diaryCatalogCR1361Label => 'Erectile difficulty';

  @override
  String get diaryCatalogCR1361Prompt =>
      'Did you have difficulty getting or maintaining an erection?';

  @override
  String get diaryCatalogCWDesafioLabel => 'Saw pressure as a challenge';

  @override
  String get diaryCatalogCWDesafioPrompt =>
      'Did you see the day\'s pressure as a challenge?';

  @override
  String get diaryCatalogCWAmeacaLabel => 'Saw pressure as a threat';

  @override
  String get diaryCatalogCWAmeacaPrompt =>
      'Did you see the day\'s pressure as a threat?';

  @override
  String get diaryCatalogCWControleLabel => 'In control';

  @override
  String get diaryCatalogCWControlePrompt =>
      'Did you feel in control of your day?';

  @override
  String get diaryCatalogCWEficaciaLabel => 'Self-confidence';

  @override
  String get diaryCatalogCWEficaciaPrompt =>
      'Did you feel able to handle what you needed to do?';

  @override
  String get diaryCatalogCWFluxoLabel => 'Flow state';

  @override
  String get diaryCatalogCWFluxoPrompt =>
      'Were you so absorbed in something that you lost track of time?';

  @override
  String get diaryCatalogCWConcentraLabel => 'Difficulty concentrating';

  @override
  String get diaryCatalogCWConcentraPrompt =>
      'Did you have difficulty concentrating?';

  @override
  String get diaryCatalogCWProgressoLabel => 'Made meaningful progress';

  @override
  String get diaryCatalogCWProgressoPrompt =>
      'Did you make progress on something that matters to you?';

  @override
  String get diaryCatalogCWRealizacaoLabel => 'Sense of achievement';

  @override
  String get diaryCatalogCWRealizacaoPrompt =>
      'Did you end the day with a sense of achievement?';

  @override
  String get diaryCatalogCWPropositoLabel => 'Sense of purpose';

  @override
  String get diaryCatalogCWPropositoPrompt => 'Did your day feel purposeful?';

  @override
  String get diaryCatalogCWOtimismoLabel => 'Optimism';

  @override
  String get diaryCatalogCWOtimismoPrompt =>
      'Did you feel optimistic and positive?';

  @override
  String get diaryCatalogCWDepressaoLabel => 'Depression symptoms';

  @override
  String get diaryCatalogCWDepressaoPrompt =>
      'Did you experience symptoms of depression, such as emptiness or loss of enjoyment?';

  @override
  String get diaryCatalogCWRelacaoLabel => 'Relationship';

  @override
  String get diaryCatalogCWRelacaoPrompt =>
      'Did you share a good moment with someone you love?';

  @override
  String get diaryCatalogCWEsgotadoLabel => 'Social exhaustion';

  @override
  String get diaryCatalogCWEsgotadoPrompt =>
      'Did you feel tired from social interaction?';

  @override
  String get diaryCatalogCWIsoladoLabel => 'Isolation';

  @override
  String get diaryCatalogCWIsoladoPrompt =>
      'Did you spend the day without contact with other people?';

  @override
  String get diaryUiCouldNotHearYouYouCanTypeBelow =>
      'Could not hear you. You can type below.';

  @override
  String get diaryUiSpeechIsUnavailableOrPermissionWasDeniedYouCanType =>
      'Speech is unavailable or permission was denied. You can type.';

  @override
  String get diaryUiCouldNotStartSpeechYouCanType =>
      'Could not start speech. You can type.';

  @override
  String get diaryUiCouldNotInterpretThisTryAgainYourTextIsStillHere =>
      'Could not interpret this. Try again. Your text is still here.';

  @override
  String get diaryUiRecordWithAI => 'Record with AI';

  @override
  String get diaryUiTellUsAboutYourDay => 'Tell us about your day.';

  @override
  String get diaryUiReviewBeforeAdding => 'Review before adding.';

  @override
  String
  get diaryUiAICanMakeMistakesReviewTheEntriesAndRemoveAnythingThatDidNotHappen =>
      'AI can make mistakes. Review the entries and remove anything that did not happen.';

  @override
  String get diaryUiIHad2CoffeesAndWalkedFor20Minutes =>
      'I had 2 coffees and walked for 20 minutes…';

  @override
  String get diaryUiStopListening => 'Stop listening';

  @override
  String get diaryUiSpeak => 'Speak';

  @override
  String get diaryUiNoEntriesIdentifiedTryDescribingItDifferently =>
      'No entries identified. Try describing it differently.';

  @override
  String get diaryUiRemove => 'Remove';

  @override
  String get diaryUiReviewEntries => 'Review entries';

  @override
  String get diaryUiAddToDay => 'Add to day';

  @override
  String get diaryUiCouldNotSaveTryAgain => 'Could not save. Try again.';

  @override
  String get diaryUiWhatToTrack => 'What to track';

  @override
  String get diaryUiRetry => 'Retry';

  @override
  String get diaryUiAll => 'All';

  @override
  String get diaryUiCreateYourHabit => 'Create your habit';

  @override
  String get diaryUiSave => 'Save';

  @override
  String get diaryUiCouldNotCreateThisHabitTryAgain =>
      'Could not create this habit. Try again.';

  @override
  String get diaryUiWhatWouldYouLikeToTrack => 'What would you like to track?';

  @override
  String get diaryUiHabitName => 'Habit name';

  @override
  String get diaryUiResponseType => 'Response type';

  @override
  String get diaryUiYesOrNo => 'Yes or no';

  @override
  String get diaryUiQuantity => 'Quantity';

  @override
  String get diaryUiUnitMlMinTimes => 'Unit (ml, min, times…)';

  @override
  String get diaryUiCreateHabit => 'Create habit';

  @override
  String get diaryUiYourChapters => 'Your chapters';

  @override
  String get diaryUiYourChaptersWillAppearAsYouRecordYourDays =>
      'Your chapters will appear as you record your days.';

  @override
  String get diaryUiChapter => 'Chapter';

  @override
  String get diaryUiByTheNumbers => 'By the numbers';

  @override
  String get diaryUiRecordedDays => 'Recorded days';

  @override
  String get diaryUiMoments => 'Moments';

  @override
  String get diaryUiAchievements => 'Achievements';

  @override
  String get diaryUiCouldNotAttachThePhotoUseAJPGPNGUpTo2MB =>
      'Could not attach the photo. Use a JPG/PNG up to 2 MB.';

  @override
  String get diaryUiEnterAName => 'Enter a name.';

  @override
  String get diaryUiCheckTheNutritionValues => 'Check the nutrition values.';

  @override
  String get diaryUiDeleteEntry => 'Delete entry';

  @override
  String get diaryUiWhatDidYouEat => 'What did you eat?';

  @override
  String get diaryUiFindAMeal => 'Find a meal';

  @override
  String get diaryUiFoodsAndAmounts => 'Foods and amounts';

  @override
  String get diaryUiNutrition => 'Nutrition';

  @override
  String
  get diaryUiValuesEnteredByYouOrFromTheSelectedMealAdjustForYourPortion =>
      'Values entered by you or from the selected meal. Adjust for your portion.';

  @override
  String get diaryUiProteinG => 'Protein (g)';

  @override
  String get diaryUiCarbsG => 'Carbs (g)';

  @override
  String get diaryUiFatG => 'Fat (g)';

  @override
  String get diaryUiRemovePhoto => 'Remove photo';

  @override
  String get diaryUiTakeAPhoto => 'Take a photo';

  @override
  String get diaryUiGallery => 'Gallery';

  @override
  String get diaryUiEntry => 'Entry';

  @override
  String get diaryUiDetails => 'Details';

  @override
  String get diaryUiTime => 'Time';

  @override
  String get diaryUiDone => 'Done';

  @override
  String get diaryUiSearchFoods => 'Search foods';

  @override
  String get diaryUiYourAccountChangedReopenTheDiary =>
      'Your account changed. Reopen the diary.';

  @override
  String get diaryUiDaySaved => 'Day saved';

  @override
  String get diaryUiTimeline => 'Timeline';

  @override
  String get diaryUiDiary => 'Diary';

  @override
  String get diaryUiWhatHappenedToday => 'What happened today?';

  @override
  String get diaryUiWhatHappenedYesterday => 'What happened yesterday?';

  @override
  String get diaryUiToday => 'Today';

  @override
  String get diaryUiYesterday => 'Yesterday';

  @override
  String get diaryUiMoments2 => 'moments';

  @override
  String get diaryUiYourDayBeginsWithAnEntry =>
      'Your day begins with an entry.';

  @override
  String get diaryUiNotes => 'Notes';

  @override
  String get diaryUiYouCanEditThePast7Days => 'You can edit the past 7 days.';

  @override
  String get diaryUiCouldNotSavePleaseTryAgain =>
      'Could not save. Please try again.';

  @override
  String get diaryUiYourDiary => 'Your diary';

  @override
  String get diaryUiThisDayIsReadOnly => 'This day is read only.';

  @override
  String get diaryUiThisDayChangedElsewhereCloseAndRefreshBeforeSaving =>
      'This day changed elsewhere. Close and refresh before saving.';

  @override
  String get diaryUiCouldNotSaveYourDraftIsStillHere =>
      'Could not save. Your draft is still here.';

  @override
  String get diaryUiYourHabits => 'Your habits';

  @override
  String get diaryUiOf => 'of';

  @override
  String get diaryUiAddHabit => 'Add habit';

  @override
  String get diaryUiHowWasYourDay => 'How was your day';

  @override
  String get diaryUiHowWasYourDay2 => 'How was your day';

  @override
  String get diaryUiMoodEnergyStressAndASentence =>
      'Mood, energy, stress and a sentence';

  @override
  String get diaryUiThisDayIsClosedYouCanEditUpTo7DaysLater =>
      'This day is closed. You can edit up to 7 days later.';

  @override
  String get diaryUiRecord => 'Record';

  @override
  String get diaryUiCouldNotSaveYourChangesAreKeptHereRetryOrDiscardToLeave =>
      'Could not save. Your changes are kept here. Retry or discard to leave.';

  @override
  String get diaryUiDiscard => 'Discard';

  @override
  String get diaryUiNo => 'No';

  @override
  String get diaryUiYes => 'Yes';

  @override
  String get diaryUiAnswer => 'Answer';

  @override
  String get diaryUiASentenceAboutYourDay => 'A sentence about your day';

  @override
  String get diaryUiOnlyYouCanSeeThisHowWasYourDay =>
      'Only you can see this. How was your day?';

  @override
  String get diaryUiTellUsAboutYourDayReviewBeforeSaving =>
      'Tell us about your day. Review before saving.';

  @override
  String get diaryUiWrite => 'Write';

  @override
  String get diaryUiDidNotHappen => 'Did not happen';

  @override
  String get diaryValueRecorded => 'Recorded';

  @override
  String get diaryValueDidNotHappen => 'Did not happen';

  @override
  String get diaryValueTimes => 'times';

  @override
  String get diaryValueCups => 'cups';

  @override
  String get diaryValueMeals => 'meals';

  @override
  String get diaryValueOutOfTen => 'out of 10';

  @override
  String get diaryPortionLight => 'Light';

  @override
  String get diaryPortionNormal => 'Normal';

  @override
  String get diaryPortionHeavy => 'Heavy';

  @override
  String get diaryLoadFailed => 'Could not load your diary. Please retry.';

  @override
  String get diaryFatAbbreviation => 'F';

  @override
  String diaryDateRange(String start, String end) {
    return '$start to $end';
  }

  @override
  String diaryCatalogSearch(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Search $count behaviors',
      one: 'Search 1 behavior',
    );
    return '$_temp0';
  }

  @override
  String diaryChooseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Choose from $count behaviors',
      one: 'Choose from 1 behavior',
    );
    return '$_temp0';
  }

  @override
  String get diaryGroupFood => 'Food';

  @override
  String get diaryGroupSelfCare => 'Self-care';

  @override
  String get diaryGroupDrinks => 'Drinks';

  @override
  String get diaryGroupMentalWellBeing => 'Mental well-being';

  @override
  String get diaryGroupSubstancesAndMedication => 'Substances and medication';

  @override
  String get diaryGroupMovement => 'Movement';

  @override
  String get diaryGroupRecovery => 'Recovery';

  @override
  String get diaryGroupMeals => 'Meals';

  @override
  String get diaryGroupRoutineAndLeisure => 'Routine and leisure';

  @override
  String get diaryGroupHealth => 'Health';

  @override
  String get diaryGroupHealthAndSymptoms => 'Health and symptoms';

  @override
  String get diaryGroupHormonalHealth => 'Hormonal health';

  @override
  String get diaryGroupSleepAndRhythm => 'Sleep and rhythm';

  @override
  String get diaryGroupSupplements => 'Supplements';

  @override
  String get diaryGroupScreensAndFocus => 'Screens and focus';

  @override
  String get diaryGroupYourHabits => 'Your habits';

  @override
  String get diaryScaleAcordou0 => 'Very tired';

  @override
  String get diaryScaleAcordou1 => 'Tired';

  @override
  String get diaryScaleAcordou2 => 'OK';

  @override
  String get diaryScaleAcordou3 => 'Good';

  @override
  String get diaryScaleAcordou4 => 'Great';

  @override
  String get diaryScaleHumor0 => 'Very bad';

  @override
  String get diaryScaleHumor1 => 'Bad';

  @override
  String get diaryScaleHumor2 => 'Neutral';

  @override
  String get diaryScaleHumor3 => 'Good';

  @override
  String get diaryScaleHumor4 => 'Very good';

  @override
  String get diaryScaleEnergia0 => 'No energy';

  @override
  String get diaryScaleEnergia1 => 'Low';

  @override
  String get diaryScaleEnergia2 => 'OK';

  @override
  String get diaryScaleEnergia3 => 'Good';

  @override
  String get diaryScaleEnergia4 => 'High';

  @override
  String get diaryScaleEstresse0 => 'Very high';

  @override
  String get diaryScaleEstresse1 => 'High';

  @override
  String get diaryScaleEstresse2 => 'Moderate';

  @override
  String get diaryScaleEstresse3 => 'Low';

  @override
  String get diaryScaleEstresse4 => 'None';

  @override
  String get diaryReferenceLettuce => 'Lettuce';

  @override
  String get diaryReferenceRice => 'Rice';

  @override
  String get diaryReferenceWhiteRice => 'White rice';

  @override
  String get diaryReferenceFries => 'Fries';

  @override
  String get diaryReferenceShoestringPotatoes => 'Shoestring potatoes';

  @override
  String get diaryReferenceSweetPotato => 'Sweet potato';

  @override
  String get diaryReferenceSteakWithOnions => 'Steak with onions';

  @override
  String get diaryReferenceCarrotCakeWithFrosting =>
      'Carrot cake with frosting';

  @override
  String get diaryReferenceBroccoli => 'Broccoli';

  @override
  String get diaryReferenceCoffee => 'Coffee';

  @override
  String get diaryReferenceCoffeeWithMilk => 'Coffee with milk';

  @override
  String get diaryReferenceUnsweetenedCoffee => 'Unsweetened coffee';

  @override
  String get diaryReferenceSautedCollardGreens => 'Sautéed collard greens';

  @override
  String get diaryReferenceCouscousWithButter => 'Couscous with butter';

  @override
  String get diaryReferenceToastedCassavaFlour => 'Toasted cassava flour';

  @override
  String get diaryReferenceBeans => 'Beans';

  @override
  String get diaryReferenceBlackBeans => 'Black beans';

  @override
  String get diaryReferenceGrilledChicken => 'Grilled chicken';

  @override
  String get diaryReferenceBerries => 'Berries';

  @override
  String get diaryReferenceGinger => 'Ginger';

  @override
  String get diaryReferenceBurger => 'Burger';

  @override
  String get diaryReferencePlainYogurt => 'Plain yogurt';

  @override
  String get diaryReferenceOrange => 'Orange';

  @override
  String get diaryReferenceVegetables => 'Vegetables';

  @override
  String get diaryReferenceLemon => 'Lemon';

  @override
  String get diaryReferencePasta => 'Pasta';

  @override
  String get diaryReferencePapaya => 'Papaya';

  @override
  String get diaryReferenceApple => 'Apple';

  @override
  String get diaryReferenceSauce => 'Sauce';

  @override
  String get diaryReferenceMeatSauce => 'Meat sauce';

  @override
  String get diaryReferenceStrawberry => 'Strawberry';

  @override
  String get diaryReferenceOmelet => 'Omelet';

  @override
  String get diaryReferenceBoiledEgg => 'Boiled egg';

  @override
  String get diaryReferenceFriedEgg => 'Fried egg';

  @override
  String get diaryReferenceScrambledEggs => 'Scrambled eggs';

  @override
  String get diaryReferenceCucumber => 'Cucumber';

  @override
  String get diaryReferenceCalabreseSausagePizza => 'Calabrese sausage pizza';

  @override
  String get diaryReferenceBrazilianCheeseBread => 'Brazilian cheese bread';

  @override
  String get diaryReferenceBreadRollWithButter => 'Bread roll with butter';

  @override
  String get diaryReferenceWholeWheatBread => 'Whole wheat bread';

  @override
  String get diaryReferenceFreshWhiteCheese => 'Fresh white cheese';

  @override
  String get diaryReferenceCoalhoCheese => 'Coalho cheese';

  @override
  String get diaryReferenceGratedCheese => 'Grated cheese';

  @override
  String get diaryReferenceTomatoSalad => 'Tomato salad';

  @override
  String get diaryReferenceGreenSalad => 'Green salad';

  @override
  String get diaryReferenceGrilledSalmon => 'Grilled salmon';

  @override
  String get diaryReferenceFreshSandwich => 'Fresh sandwich';

  @override
  String get diaryReferenceSoySauce => 'Soy sauce';

  @override
  String get diaryReferencePumpkinSoup => 'Pumpkin soup';

  @override
  String get diaryReferenceBeefStroganoff => 'Beef stroganoff';

  @override
  String get diaryReferenceJuice => 'Juice';

  @override
  String get diaryReferenceAssortedSushi => 'Assorted sushi';

  @override
  String get diaryReferenceTapiocaWithEgg => 'Tapioca with egg';

  @override
  String get diaryReferenceToast => 'Toast';

  @override
  String get diaryReferenceGrapes => 'Grapes';

  @override
  String get diaryReference1Spoonful => '1 spoonful';

  @override
  String get diaryReference1Slice => '1 slice';

  @override
  String get diaryReference1Egg => '1 egg';

  @override
  String get diaryReference1Piece => '1 piece';

  @override
  String get diaryReference1Cup => '1 cup';

  @override
  String get diaryReference10Pieces => '10 pieces';

  @override
  String get diaryReference2Slices => '2 slices';

  @override
  String get diaryReference2Eggs => '2 eggs';

  @override
  String get diaryReference2Pieces => '2 pieces';

  @override
  String get diaryReference3Slices => '3 slices';

  @override
  String get diaryReference3Eggs => '3 eggs';

  @override
  String get diaryReference3Pieces => '3 pieces';

  @override
  String get diaryReference4Segments => '4 segments';

  @override
  String get diaryReference4Pieces => '4 pieces';

  @override
  String get diaryReferenceTheBeginning => 'The beginning';

  @override
  String
  get diaryReferenceTheBandLearnsWhoYouAreOver11DaysHrvRangedFrom54To66MsThatIsWhereYourBaselineBegins =>
      'The band learns who you are. Over 11 days, HRV ranged from 54 to 66 ms. That is where your baseline begins.';

  @override
  String get diaryReferenceSep11ToSep2111Days => 'Sep 11 to Sep 21 · 11 days';

  @override
  String get diaryReferenceAverageHrv => 'Average HRV';

  @override
  String get diaryReferenceWorkouts => 'Workouts';

  @override
  String get diaryReferenceSleep => 'Sleep';

  @override
  String get diaryReferenceYouSleepBetterAround11Pm =>
      'You sleep better around 11 pm';

  @override
  String get diaryReferenceSep18ByndLearned => 'Sep 18 · BYND learned';

  @override
  String get diaryReferenceDay1StartedWithTheBand =>
      'Day 1: started with the band';

  @override
  String get diaryReferenceSep11Milestone => 'Sep 11 · Milestone';

  @override
  String get diaryReferenceTheCold => 'The cold';

  @override
  String
  get diaryReferenceYourBodyGaveAWarningTwoDaysEarlierBreathingRoseOnTheNightsOfSep23And24YourThroatOnlyF =>
      'Your body gave a warning two days earlier. Breathing rose on the nights of Sep 23 and 24; your throat only felt scratchy on Sep 25. Five days without training.';

  @override
  String get diaryReferenceSep22ToSep298Days => 'Sep 22 to Sep 29 · 8 days';

  @override
  String get diaryReferenceBreathing => 'Breathing';

  @override
  String get diaryReference164Rpm => '16.4 rpm';

  @override
  String get diaryReferenceRecovery => 'Recovery';

  @override
  String get diaryReferenceNoTraining => 'No training';

  @override
  String get diaryReference5Days => '5 days';

  @override
  String get diaryReferenceBestNight => 'Best night';

  @override
  String get diaryReferenceSep28 => 'Sep 28';

  @override
  String get diaryReferenceColdSpotted2DaysEarlier =>
      'Cold, spotted 2 days earlier';

  @override
  String get diaryReferenceSep23ToSep29Event => 'Sep 23 to Sep 29 · Event';

  @override
  String get diaryReferenceBackStronger => 'Back, stronger';

  @override
  String
  get diaryReferenceTheBestStretchOfTheTwoMonthsRecoveryReached91OnOct1ItOnlyFellOnAThursdayAfterWineThat =>
      'The best stretch of the two months. Recovery reached 91 on Oct 1. It only fell on a Thursday after wine: that was when BYND found this pattern.';

  @override
  String get diaryReferenceSep30ToOct1516Days => 'Sep 30 to Oct 15 · 16 days';

  @override
  String get diaryReferenceBest => 'Best';

  @override
  String get diaryReferenceRuns => 'Runs';

  @override
  String get diaryReferenceNewPattern => 'New pattern';

  @override
  String get diaryReferenceWine => 'wine';

  @override
  String get diaryReferenceBestRecovery => 'Best recovery';

  @override
  String get diaryReferenceOct1 => 'Oct 1';

  @override
  String get diaryReference30DaysByndLearnedYourBaseline =>
      '30 days: BYND learned your baseline';

  @override
  String get diaryReferenceOct10Milestone => 'Oct 10 · Milestone';

  @override
  String get diaryReferenceWednesdayWineTakesItsTollOnThursday =>
      'Wednesday wine takes its toll on Thursday';

  @override
  String get diaryReferenceOct8ByndLearned => 'Oct 8 · BYND learned';

  @override
  String get diaryReferenceDeadlineWeek => 'Deadline week';

  @override
  String
  get diaryReferenceLittleSleepLotsOfCoffeeFourNightsPastMidnightAnd4CoffeesADayStressDoubledAndRecoveryF =>
      'Little sleep, lots of coffee. Four nights past midnight and 4 coffees a day. Stress doubled and recovery fell to 53.';

  @override
  String get diaryReferenceOct16ToOct227Days => 'Oct 16 to Oct 22 · 7 days';

  @override
  String get diaryReferenceStress => 'Stress';

  @override
  String get diaryReferenceYourCycleIsRegularAt28Days =>
      'Your cycle is regular, at 28 days';

  @override
  String get diaryReferenceOct20ByndLearned => 'Oct 20 · BYND learned';

  @override
  String get diaryReferenceDeadlineWeekAtWork => 'Deadline week at work';

  @override
  String get diaryReferenceOct16ToOct20Event => 'Oct 16 to Oct 20 · Event';

  @override
  String get diaryReferenceThe14Km => 'The 14 km';

  @override
  String
  get diaryReferenceRecordHrvAndYourLongestRunHrvReached73MsOnOct28ThenCameThreeHardWorkoutsInARowAndThe1 =>
      'Record HRV and your longest run. HRV reached 73 ms on Oct 28. Then came three hard workouts in a row and the 14 km, and HRV fell to 46 on Thursday.';

  @override
  String get diaryReferenceOct23ToNov514Days => 'Oct 23 to Nov 5 · 14 days';

  @override
  String get diaryReferenceRecordHrv => 'Record HRV';

  @override
  String get diaryReferenceRun => 'Run';

  @override
  String get diaryReferenceOct28 => 'Oct 28';

  @override
  String get diaryReferenceLongestRun => 'Longest run';

  @override
  String get diaryReferenceNov4 => 'Nov 4';

  @override
  String get diaryReferenceMostActiveDay => 'Most active day';

  @override
  String get diaryReference21950Steps => '21,950 steps';

  @override
  String get diaryReferenceNightsOnSchedule => 'Nights on schedule';

  @override
  String get diaryReferenceNov1 => 'Nov 1';

  @override
  String get diaryReference4Of8 => '4 of 8';

  @override
  String get diaryReferenceThreeHardWorkoutsInARow =>
      'Three hard workouts in a row';

  @override
  String get diaryReferenceNov3ToNov5Event => 'Nov 3 to Nov 5 · Event';

  @override
  String get diaryReferenceJoinedTheBedBy11PmChallenge =>
      'Joined the “Bed by 11 pm” challenge';

  @override
  String get diaryReferenceNov1Milestone => 'Nov 1 · Milestone';

  @override
  String get diaryReferenceStressRisesWithShortSleep =>
      'Stress rises with short sleep';

  @override
  String get diaryReferenceOct23ByndLearned => 'Oct 23 · BYND learned';

  @override
  String get diaryReferenceWokeUp => 'Woke up';

  @override
  String get diaryReference7H42OfSleepScore82MeasuredByTheBand =>
      '7h42 of sleep · score 82 · measured by the band';

  @override
  String get diaryReferenceLightWorkoutMobilityAndStrength =>
      'Light workout · mobility and strength';

  @override
  String get diaryReference35MinLoad28MeasuredByTheBand =>
      '35 min · load 28 · measured by the band';

  @override
  String get diaryReference74OutOf100ReadyToTrainMeasuredByTheBand =>
      '74 out of 100 · ready to train · measured by the band';

  @override
  String get diaryReferenceHalfwayToYourStepGoal => 'Halfway to your step goal';

  @override
  String get diaryReference5000StepsMeasuredByTheBand =>
      '5,000 steps · measured by the band';

  @override
  String get diaryReferenceStressPeak => 'Stress peak';

  @override
  String get diaryReference57OutOf100After2HSittingMeasuredByTheBand =>
      '57 out of 100 · after 2 h sitting · measured by the band';

  @override
  String get diaryReferenceMomentOfCalm => 'Moment of calm';

  @override
  String get diaryReference12MinLowStressMeasuredByTheBand =>
      '12 min · low stress · measured by the band';

  @override
  String get diaryReferenceWalk => 'Walk';

  @override
  String get diaryReference24Min21KmMeasuredByTheBand =>
      '24 min · 2.1 km · measured by the band';

  @override
  String get diaryReferenceBodyReadyForSleep => 'Body ready for sleep';

  @override
  String get diaryReference364CTemperatureDroppingMeasuredByTheBand =>
      '36.4 °C · temperature dropping · measured by the band';

  @override
  String get diaryReference6H10OfSleepScore64MeasuredByTheBand =>
      '6h10 of sleep · score 64 · measured by the band';

  @override
  String get diaryReference42MinLoad61MeasuredByTheBand =>
      '42 min · load 61 · measured by the band';

  @override
  String get diaryReferenceWentToBed => 'Went to bed';

  @override
  String get diaryReference2240MeasuredByTheBand =>
      '22:40  · measured by the band';

  @override
  String get diaryAutomaticWokeUp => 'Woke up';

  @override
  String get diaryAutomaticActivity => 'Activity';

  @override
  String diaryChapterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'of $count chapters',
      one: 'of 1 chapter',
    );
    return '$_temp0';
  }

  @override
  String diaryDidNotHappenAction(String title) {
    return 'Did not happen: $title';
  }

  @override
  String diaryToggleAction(String title) {
    return 'Toggle $title';
  }

  @override
  String diaryBandAndEntries(int bandCount, int entryCount) {
    String _temp0 = intl.Intl.pluralLogic(
      bandCount,
      locale: localeName,
      other: '$bandCount from your band',
      one: '1 from your band',
    );
    String _temp1 = intl.Intl.pluralLogic(
      entryCount,
      locale: localeName,
      other: '$entryCount of your entries',
      one: '1 of your entries',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String diaryHowWasDate(String date) {
    return 'How was $date?';
  }

  @override
  String get diarySpeechLanguageUnavailable =>
      'Speech recognition in this language is unavailable on this device. You can type instead.';

  @override
  String get diaryWhatHappenedOnThisDay => 'What happened on this day?';
}
