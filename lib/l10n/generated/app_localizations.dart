import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// No description provided for @language.
  ///
  /// In pt_BR, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @chooseLanguage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha o idioma'**
  String get chooseLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In pt_BR, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePortugueseBrazil.
  ///
  /// In pt_BR, this message translates to:
  /// **'Português (Brasil)'**
  String get languagePortugueseBrazil;

  /// No description provided for @languagePreferenceNotSaved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Idioma alterado nesta sessão, mas não foi possível salvar a preferência.'**
  String get languagePreferenceNotSaved;

  /// No description provided for @menu.
  ///
  /// In pt_BR, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @youGroup.
  ///
  /// In pt_BR, this message translates to:
  /// **'VOCÊ'**
  String get youGroup;

  /// No description provided for @appGroup.
  ///
  /// In pt_BR, this message translates to:
  /// **'APP'**
  String get appGroup;

  /// No description provided for @settings.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @languageMenu.
  ///
  /// In pt_BR, this message translates to:
  /// **'Idioma'**
  String get languageMenu;

  /// No description provided for @integrations.
  ///
  /// In pt_BR, this message translates to:
  /// **'Integrações'**
  String get integrations;

  /// No description provided for @privacy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Privacidade'**
  String get privacy;

  /// No description provided for @help.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajuda'**
  String get help;

  /// No description provided for @signOut.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair'**
  String get signOut;

  /// No description provided for @deviceConnected.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conectada · há 5 min'**
  String get deviceConnected;

  /// No description provided for @diary.
  ///
  /// In pt_BR, this message translates to:
  /// **'Diário'**
  String get diary;

  /// No description provided for @journey.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jornada'**
  String get journey;

  /// No description provided for @activities.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atividades'**
  String get activities;

  /// No description provided for @community.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comunidade'**
  String get community;

  /// No description provided for @goals.
  ///
  /// In pt_BR, this message translates to:
  /// **'Objetivos'**
  String get goals;

  /// No description provided for @today.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hoje'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ontem'**
  String get yesterday;

  /// No description provided for @atlas.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atlas'**
  String get atlas;

  /// No description provided for @health.
  ///
  /// In pt_BR, this message translates to:
  /// **'Saúde'**
  String get health;

  /// No description provided for @quickActions.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ações rápidas'**
  String get quickActions;

  /// No description provided for @loading.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carregando'**
  String get loading;

  /// No description provided for @close.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fechar'**
  String get close;

  /// No description provided for @back.
  ///
  /// In pt_BR, this message translates to:
  /// **'Voltar'**
  String get back;

  /// No description provided for @history.
  ///
  /// In pt_BR, this message translates to:
  /// **'Histórico'**
  String get history;

  /// No description provided for @quickActionsHeading.
  ///
  /// In pt_BR, this message translates to:
  /// **'AÇÕES RÁPIDAS'**
  String get quickActionsHeading;

  /// No description provided for @quickActionsSuggestion.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para esta manhã, a BYND sugere 15 minutos de sol antes do trabalho.'**
  String get quickActionsSuggestion;

  /// No description provided for @quickActionsSuggestionAfternoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para esta tarde, a BYND sugere uma pausa para respirar.'**
  String get quickActionsSuggestionAfternoon;

  /// No description provided for @quickActionsSuggestionEvening.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para esta noite, a BYND sugere respirar antes de dormir.'**
  String get quickActionsSuggestionEvening;

  /// No description provided for @breatheFiveMinutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respirar\n5 min'**
  String get breatheFiveMinutes;

  /// No description provided for @logMeal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registrar\nrefeição'**
  String get logMeal;

  /// No description provided for @startActivity.
  ///
  /// In pt_BR, this message translates to:
  /// **'Iniciar\natividade'**
  String get startActivity;

  /// No description provided for @reviewDay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como foi\no dia'**
  String get reviewDay;

  /// No description provided for @logActivity.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registrar\natividade'**
  String get logActivity;

  /// No description provided for @doEcg.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fazer\nECG'**
  String get doEcg;

  /// No description provided for @comingSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'{feature}: em breve.'**
  String comingSoon(Object feature);

  /// No description provided for @activityRegisterComingSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registro de atividade: em breve.'**
  String get activityRegisterComingSoon;

  /// No description provided for @sectionComingSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esta seção estará disponível em breve.'**
  String get sectionComingSoon;

  /// No description provided for @activityHistoryComingSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Histórico de atividades: em breve.'**
  String get activityHistoryComingSoon;

  /// No description provided for @activityUnavailableHeading.
  ///
  /// In pt_BR, this message translates to:
  /// **'DADOS INDISPONÍVEIS'**
  String get activityUnavailableHeading;

  /// No description provided for @activityUnavailableTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus dados de atividade aparecerão aqui.'**
  String get activityUnavailableTitle;

  /// No description provided for @activityUnavailableDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'A integração de dados e o cálculo da carga ainda não estão disponíveis.'**
  String get activityUnavailableDescription;

  /// No description provided for @dayInNumbers.
  ///
  /// In pt_BR, this message translates to:
  /// **'O dia em números'**
  String get dayInNumbers;

  /// No description provided for @dailyMetricsUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Métricas diárias ainda não integradas.'**
  String get dailyMetricsUnavailable;

  /// No description provided for @modalities.
  ///
  /// In pt_BR, this message translates to:
  /// **'Modalidades'**
  String get modalities;

  /// No description provided for @recentModalitiesUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'As modalidades recentes aparecerão aqui.'**
  String get recentModalitiesUnavailable;

  /// No description provided for @todayActivities.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atividades de hoje'**
  String get todayActivities;

  /// No description provided for @noSyncedActivity.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma atividade sincronizada.'**
  String get noSyncedActivity;

  /// No description provided for @todayPlanPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que vamos fazer hoje?'**
  String get todayPlanPrompt;

  /// No description provided for @register.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registrar'**
  String get register;

  /// No description provided for @startActivityTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Iniciar atividade'**
  String get startActivityTitle;

  /// No description provided for @searchActivities.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar entre {count} modalidades'**
  String searchActivities(Object count);

  /// No description provided for @recent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recentes'**
  String get recent;

  /// No description provided for @categoryCardio.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cardio'**
  String get categoryCardio;

  /// No description provided for @categoryStrength.
  ///
  /// In pt_BR, this message translates to:
  /// **'Força'**
  String get categoryStrength;

  /// No description provided for @categorySports.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esportes'**
  String get categorySports;

  /// No description provided for @categoryCombat.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lutas'**
  String get categoryCombat;

  /// No description provided for @categoryAquatic.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aquáticos'**
  String get categoryAquatic;

  /// No description provided for @categoryMindBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mente e corpo'**
  String get categoryMindBody;

  /// No description provided for @categoryRecovery.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recuperação'**
  String get categoryRecovery;

  /// No description provided for @categoryOther.
  ///
  /// In pt_BR, this message translates to:
  /// **'Outros'**
  String get categoryOther;

  /// No description provided for @activityHintHyrox.
  ///
  /// In pt_BR, this message translates to:
  /// **'16 etapas da prova'**
  String get activityHintHyrox;

  /// No description provided for @activityHintRaceStages.
  ///
  /// In pt_BR, this message translates to:
  /// **'5 etapas da prova'**
  String get activityHintRaceStages;

  /// No description provided for @activityHintPoolPace.
  ///
  /// In pt_BR, this message translates to:
  /// **'piscina e ritmo'**
  String get activityHintPoolPace;

  /// No description provided for @activityHintGps.
  ///
  /// In pt_BR, this message translates to:
  /// **'com GPS'**
  String get activityHintGps;

  /// No description provided for @activityHintSetsWeight.
  ///
  /// In pt_BR, this message translates to:
  /// **'séries e peso'**
  String get activityHintSetsWeight;

  /// No description provided for @activityHintRounds.
  ///
  /// In pt_BR, this message translates to:
  /// **'rounds'**
  String get activityHintRounds;

  /// No description provided for @activityHintGameTime.
  ///
  /// In pt_BR, this message translates to:
  /// **'tempo de jogo'**
  String get activityHintGameTime;

  /// No description provided for @activityHintHeartRateNoMovement.
  ///
  /// In pt_BR, this message translates to:
  /// **'coração sem movimento'**
  String get activityHintHeartRateNoMovement;

  /// No description provided for @activityHintBreathingCalm.
  ///
  /// In pt_BR, this message translates to:
  /// **'respiração e calma'**
  String get activityHintBreathingCalm;

  /// No description provided for @activityHintStepsMovement.
  ///
  /// In pt_BR, this message translates to:
  /// **'passos e movimento'**
  String get activityHintStepsMovement;

  /// No description provided for @activityHintMachineDistance.
  ///
  /// In pt_BR, this message translates to:
  /// **'distância da máquina'**
  String get activityHintMachineDistance;

  /// No description provided for @activityHintTimeHeartRate.
  ///
  /// In pt_BR, this message translates to:
  /// **'tempo e coração'**
  String get activityHintTimeHeartRate;

  /// No description provided for @noActivityMatches.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma modalidade com “{query}”. Use “Outro”.'**
  String noActivityMatches(Object query);

  /// No description provided for @closeCalendar.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fechar calendário'**
  String get closeCalendar;

  /// No description provided for @previousMonth.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mês anterior'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In pt_BR, this message translates to:
  /// **'Próximo mês'**
  String get nextMonth;

  /// No description provided for @goodRecovery.
  ///
  /// In pt_BR, this message translates to:
  /// **'recuperação boa'**
  String get goodRecovery;

  /// No description provided for @mediumRecovery.
  ///
  /// In pt_BR, this message translates to:
  /// **'recuperação média'**
  String get mediumRecovery;

  /// No description provided for @lowRecovery.
  ///
  /// In pt_BR, this message translates to:
  /// **'recuperação baixa'**
  String get lowRecovery;

  /// No description provided for @preparationClose.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fechar preparação'**
  String get preparationClose;

  /// No description provided for @watchNotIntegrated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pulseira não integrada'**
  String get watchNotIntegrated;

  /// No description provided for @heartRateBatteryUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Frequência cardíaca e bateria indisponíveis'**
  String get heartRateBatteryUnavailable;

  /// No description provided for @routeRecording.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registrar o percurso'**
  String get routeRecording;

  /// No description provided for @gpsUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'GPS indisponível; nenhum percurso será gravado'**
  String get gpsUnavailable;

  /// No description provided for @startActivityButton.
  ///
  /// In pt_BR, this message translates to:
  /// **'Iniciar atividade'**
  String get startActivityButton;

  /// No description provided for @waitingForSensors.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aguardando integração de sensores e sessão'**
  String get waitingForSensors;

  /// No description provided for @weatherUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Clima indisponível'**
  String get weatherUnavailable;

  /// No description provided for @weatherNotIntegrated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Localização e serviço meteorológico não integrados'**
  String get weatherNotIntegrated;

  /// No description provided for @suggestedLoadUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carga sugerida indisponível'**
  String get suggestedLoadUnavailable;

  /// No description provided for @loadNotIntegrated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dados e cálculo da carga ainda não integrados'**
  String get loadNotIntegrated;

  /// No description provided for @howToStart.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como deseja começar?'**
  String get howToStart;

  /// No description provided for @startWithoutPlan.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar sem plano'**
  String get startWithoutPlan;

  /// No description provided for @exercisesCanBeAddedLater.
  ///
  /// In pt_BR, this message translates to:
  /// **'Os exercícios podem entrar depois'**
  String get exercisesCanBeAddedLater;

  /// No description provided for @yourWorkouts.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus treinos'**
  String get yourWorkouts;

  /// No description provided for @savedWorkoutsUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treinos salvos ainda não disponíveis'**
  String get savedWorkoutsUnavailable;

  /// No description provided for @savedWorkoutsNotConnected.
  ///
  /// In pt_BR, this message translates to:
  /// **'Os treinos salvos não estão conectados neste app'**
  String get savedWorkoutsNotConnected;

  /// No description provided for @otherWays.
  ///
  /// In pt_BR, this message translates to:
  /// **'Outras formas'**
  String get otherWays;

  /// No description provided for @buildWorkout.
  ///
  /// In pt_BR, this message translates to:
  /// **'Montar treino novo'**
  String get buildWorkout;

  /// No description provided for @workoutEditorNotIntegrated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editor de exercícios, séries e carga não integrado'**
  String get workoutEditorNotIntegrated;

  /// No description provided for @editProfile.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar perfil'**
  String get editProfile;

  /// No description provided for @profile.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @profileMembership.
  ///
  /// In pt_BR, this message translates to:
  /// **'Brasília · com a BYND há 2 meses'**
  String get profileMembership;

  /// No description provided for @birthDateValue.
  ///
  /// In pt_BR, this message translates to:
  /// **'17 abr 1992'**
  String get birthDateValue;

  /// No description provided for @profileEditComingSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Edição de perfil em breve.'**
  String get profileEditComingSoon;

  /// No description provided for @age.
  ///
  /// In pt_BR, this message translates to:
  /// **'Idade'**
  String get age;

  /// No description provided for @years.
  ///
  /// In pt_BR, this message translates to:
  /// **'anos'**
  String get years;

  /// No description provided for @height.
  ///
  /// In pt_BR, this message translates to:
  /// **'Altura'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In pt_BR, this message translates to:
  /// **'Peso'**
  String get weight;

  /// No description provided for @yourData.
  ///
  /// In pt_BR, this message translates to:
  /// **'SEUS DADOS'**
  String get yourData;

  /// No description provided for @birthDate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data de nascimento'**
  String get birthDate;

  /// No description provided for @biologicalSex.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sexo biológico'**
  String get biologicalSex;

  /// No description provided for @female.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feminino'**
  String get female;

  /// No description provided for @city.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cidade'**
  String get city;

  /// No description provided for @goal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Objetivo'**
  String get goal;

  /// No description provided for @loseFatKeepMuscle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perder gordura sem perder massa magra'**
  String get loseFatKeepMuscle;

  /// No description provided for @units.
  ///
  /// In pt_BR, this message translates to:
  /// **'Unidades'**
  String get units;

  /// No description provided for @metric.
  ///
  /// In pt_BR, this message translates to:
  /// **'Métrico'**
  String get metric;

  /// No description provided for @account.
  ///
  /// In pt_BR, this message translates to:
  /// **'CONTA'**
  String get account;

  /// No description provided for @wristband.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pulseira'**
  String get wristband;

  /// No description provided for @wristbandConnectedSince.
  ///
  /// In pt_BR, this message translates to:
  /// **'BYND ONE · conectada desde 9 set 2026'**
  String get wristbandConnectedSince;

  /// No description provided for @connectedDeviceComingSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'{device}: em breve.'**
  String connectedDeviceComingSoon(Object device);

  /// No description provided for @calendarWeekdayMon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seg'**
  String get calendarWeekdayMon;

  /// No description provided for @calendarWeekdayTue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ter'**
  String get calendarWeekdayTue;

  /// No description provided for @calendarWeekdayWed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Qua'**
  String get calendarWeekdayWed;

  /// No description provided for @calendarWeekdayThu.
  ///
  /// In pt_BR, this message translates to:
  /// **'Qui'**
  String get calendarWeekdayThu;

  /// No description provided for @calendarWeekdayFri.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sex'**
  String get calendarWeekdayFri;

  /// No description provided for @calendarWeekdaySat.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sáb'**
  String get calendarWeekdaySat;

  /// No description provided for @calendarWeekdaySun.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dom'**
  String get calendarWeekdaySun;

  /// No description provided for @homeMorning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bom dia'**
  String get homeMorning;

  /// No description provided for @homeAfternoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Boa tarde'**
  String get homeAfternoon;

  /// No description provided for @homeEvening.
  ///
  /// In pt_BR, this message translates to:
  /// **'Boa noite'**
  String get homeEvening;

  /// No description provided for @homePastGreeting.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como foi o seu dia'**
  String get homePastGreeting;

  /// No description provided for @homeDirection.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver direção completa'**
  String get homeDirection;

  /// No description provided for @homeSignals.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus sinais'**
  String get homeSignals;

  /// No description provided for @homeAllSignals.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver todos ›'**
  String get homeAllSignals;

  /// No description provided for @homeCustomize.
  ///
  /// In pt_BR, this message translates to:
  /// **'Personalizar a Home'**
  String get homeCustomize;

  /// No description provided for @homeCustomizeHelp.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha os 6 sinais que ficam na sua Home e arraste pela alça ≡ para mudar a ordem.'**
  String get homeCustomizeHelp;

  /// No description provided for @homeOnHome.
  ///
  /// In pt_BR, this message translates to:
  /// **'NA HOME'**
  String get homeOnHome;

  /// No description provided for @homeOtherSignals.
  ///
  /// In pt_BR, this message translates to:
  /// **'OUTROS SINAIS'**
  String get homeOtherSignals;

  /// No description provided for @homeSixSlots.
  ///
  /// In pt_BR, this message translates to:
  /// **'A Home tem 6 lugares. Desmarque um antes de escolher outro.'**
  String get homeSixSlots;

  /// No description provided for @homeSave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvar'**
  String get homeSave;

  /// No description provided for @homePreferenceFailed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível salvar sua preferência. Tente novamente.'**
  String get homePreferenceFailed;

  /// No description provided for @homePhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trocar a foto do topo'**
  String get homePhoto;

  /// No description provided for @homeShowMore.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mostrar mais'**
  String get homeShowMore;

  /// No description provided for @homeShowLess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mostrar menos'**
  String get homeShowLess;

  /// No description provided for @homeRetry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tentar novamente'**
  String get homeRetry;

  /// No description provided for @homeUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível carregar a Home.'**
  String get homeUnavailable;

  /// No description provided for @homeSignIn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entre na sua conta para ver seus dados.'**
  String get homeSignIn;

  /// No description provided for @homeSignInAction.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar na conta'**
  String get homeSignInAction;

  /// No description provided for @homeNoMeasurement.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem dados neste dia'**
  String get homeNoMeasurement;

  /// No description provided for @homeSync.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conecte e sincronize sua pulseira para ver seus sinais.'**
  String get homeSync;

  /// No description provided for @homePartial.
  ///
  /// In pt_BR, this message translates to:
  /// **'Algumas informações não foram atualizadas.'**
  String get homePartial;

  /// No description provided for @homeMapaTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que o seu corpo está revelando?'**
  String get homeMapaTitle;

  /// No description provided for @homeMapaBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma relação entre seus hábitos, sono, atividade e recuperação começou a aparecer.'**
  String get homeMapaBody;

  /// No description provided for @homeMapaWaiting.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu Mapa está se formando. Continue usando a pulseira para descobrir relações entre seus hábitos e seus sinais.'**
  String get homeMapaWaiting;

  /// No description provided for @homeExploreMapa.
  ///
  /// In pt_BR, this message translates to:
  /// **'Explorar meu Mapa →'**
  String get homeExploreMapa;

  /// No description provided for @homeDiaryKicker.
  ///
  /// In pt_BR, this message translates to:
  /// **'SEU DIÁRIO'**
  String get homeDiaryKicker;

  /// No description provided for @homeDiaryTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como foi o seu dia?'**
  String get homeDiaryTitle;

  /// No description provided for @homeDiaryBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registre alimentação, treino, humor, café e o que mais aconteceu.'**
  String get homeDiaryBody;

  /// No description provided for @homeAddEntry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar registro +'**
  String get homeAddEntry;

  /// No description provided for @homePatterns.
  ///
  /// In pt_BR, this message translates to:
  /// **'padrões'**
  String get homePatterns;

  /// No description provided for @homeWaitingPatterns.
  ///
  /// In pt_BR, this message translates to:
  /// **'Em formação'**
  String get homeWaitingPatterns;

  /// No description provided for @homeNumbers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus números'**
  String get homeNumbers;

  /// No description provided for @homeWeek.
  ///
  /// In pt_BR, this message translates to:
  /// **'SEMANA · UM PONTO POR DIA'**
  String get homeWeek;

  /// No description provided for @homeMinimum.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mínima'**
  String get homeMinimum;

  /// No description provided for @homeAverage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Média'**
  String get homeAverage;

  /// No description provided for @homeMaximum.
  ///
  /// In pt_BR, this message translates to:
  /// **'Máxima'**
  String get homeMaximum;

  /// No description provided for @homeHistoryError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível carregar o histórico.'**
  String get homeHistoryError;

  /// No description provided for @homeHistoryEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ainda não há medições nesta semana.'**
  String get homeHistoryEmpty;

  /// No description provided for @homeRecommendation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para hoje'**
  String get homeRecommendation;

  /// No description provided for @homeDiary.
  ///
  /// In pt_BR, this message translates to:
  /// **'Diário'**
  String get homeDiary;

  /// No description provided for @homeDiaryEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu dia, do seu jeito. Adicione o primeiro registro.'**
  String get homeDiaryEmpty;

  /// No description provided for @homeNewEntry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Novo registro'**
  String get homeNewEntry;

  /// No description provided for @homeEntryLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que aconteceu?'**
  String get homeEntryLabel;

  /// No description provided for @homeEntryNote.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mais detalhes (opcional)'**
  String get homeEntryNote;

  /// No description provided for @homeEntryRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Descreva o registro antes de salvar.'**
  String get homeEntryRequired;

  /// No description provided for @homeEntrySaved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registro salvo.'**
  String get homeEntrySaved;

  /// No description provided for @homeEntryFailed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível salvar. Tente novamente.'**
  String get homeEntryFailed;

  /// No description provided for @homeMeal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alimentação'**
  String get homeMeal;

  /// No description provided for @homeTraining.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino'**
  String get homeTraining;

  /// No description provided for @homeMood.
  ///
  /// In pt_BR, this message translates to:
  /// **'Humor'**
  String get homeMood;

  /// No description provided for @homeCaffeine.
  ///
  /// In pt_BR, this message translates to:
  /// **'Café'**
  String get homeCaffeine;

  /// No description provided for @homeOther.
  ///
  /// In pt_BR, this message translates to:
  /// **'Outro'**
  String get homeOther;

  /// No description provided for @homeUnknownDirection.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aguardando seus sinais.'**
  String get homeUnknownDirection;

  /// No description provided for @homeDataOnly.
  ///
  /// In pt_BR, this message translates to:
  /// **'Medições da sua pulseira. Os dados ausentes não são estimados.'**
  String get homeDataOnly;

  /// No description provided for @homeSelectedCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'de 6'**
  String get homeSelectedCount;

  /// No description provided for @homeOpenDevice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conectar pulseira'**
  String get homeOpenDevice;

  /// No description provided for @homeRefresh.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualizar'**
  String get homeRefresh;

  /// No description provided for @homeDrag.
  ///
  /// In pt_BR, this message translates to:
  /// **'Arrastar para mudar a ordem'**
  String get homeDrag;

  /// No description provided for @homeNoDirection.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sincronize a pulseira para acompanhar a direção do seu dia.'**
  String get homeNoDirection;

  /// No description provided for @homeAccountChanged.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua conta mudou. Feche esta tela e abra novamente para ver os dados atuais.'**
  String get homeAccountChanged;
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
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
