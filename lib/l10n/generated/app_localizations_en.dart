// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
}
