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

  /// No description provided for @exerciseDetailCountAs.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta como'**
  String get exerciseDetailCountAs;

  /// No description provided for @exerciseDetailSeconds.
  ///
  /// In pt_BR, this message translates to:
  /// **'segundos'**
  String get exerciseDetailSeconds;

  /// No description provided for @exerciseDetailMinutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'minutos'**
  String get exerciseDetailMinutes;

  /// No description provided for @exerciseDetailRepsBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'repetições (peso do corpo)'**
  String get exerciseDetailRepsBody;

  /// No description provided for @exerciseDetailRepsWeight.
  ///
  /// In pt_BR, this message translates to:
  /// **'repetições × carga'**
  String get exerciseDetailRepsWeight;

  /// No description provided for @exerciseDetailTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exercício'**
  String get exerciseDetailTitle;

  /// No description provided for @exerciseDetailHow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como fazer: {name}'**
  String exerciseDetailHow(String name);

  /// No description provided for @exerciseDetailMark.
  ///
  /// In pt_BR, this message translates to:
  /// **'Marcar para adicionar'**
  String get exerciseDetailMark;

  /// No description provided for @exerciseDetailMuscles.
  ///
  /// In pt_BR, this message translates to:
  /// **'Músculos'**
  String get exerciseDetailMuscles;

  /// No description provided for @exerciseDetailEquipment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Equipamento'**
  String get exerciseDetailEquipment;

  /// No description provided for @exerciseDetailGroup.
  ///
  /// In pt_BR, this message translates to:
  /// **'Grupo'**
  String get exerciseDetailGroup;

  /// No description provided for @exerciseDetailLevel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nível'**
  String get exerciseDetailLevel;

  /// No description provided for @exerciseDetailAnimation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Animação: {name}'**
  String exerciseDetailAnimation(String name);

  /// No description provided for @exerciseDetailNoAnimation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Animação não disponível para este exercício.'**
  String get exerciseDetailNoAnimation;

  /// No description provided for @exerciseConfirmEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar'**
  String get exerciseConfirmEmpty;

  /// No description provided for @exerciseSelectorTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecionar exercícios'**
  String get exerciseSelectorTitle;

  /// No description provided for @exerciseSearch.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar exercício ou músculo'**
  String get exerciseSearch;

  /// No description provided for @exerciseAll.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todos'**
  String get exerciseAll;

  /// No description provided for @exerciseMark.
  ///
  /// In pt_BR, this message translates to:
  /// **'Marque os exercícios'**
  String get exerciseMark;

  /// No description provided for @exerciseAdd.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar ({count})'**
  String exerciseAdd(int count);

  /// No description provided for @exerciseCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} exercícios'**
  String exerciseCount(int count);

  /// No description provided for @exerciseEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum exercício encontrado.'**
  String get exerciseEmpty;

  /// No description provided for @exerciseLoadError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível carregar os exercícios.'**
  String get exerciseLoadError;

  /// No description provided for @exerciseRetry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tentar novamente'**
  String get exerciseRetry;

  /// No description provided for @exerciseSelectedCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} exercícios selecionados · demonstração'**
  String exerciseSelectedCount(int count);

  /// No description provided for @exerciseDraftNote.
  ///
  /// In pt_BR, this message translates to:
  /// **'Prévia local · ainda não é possível salvar o treino'**
  String get exerciseDraftNote;

  /// No description provided for @exerciseAddMore.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar exercício'**
  String get exerciseAddMore;

  /// No description provided for @workoutLocalNote.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvo apenas neste dispositivo · não sincronizado'**
  String get workoutLocalNote;

  /// No description provided for @workoutDefaultsNote.
  ///
  /// In pt_BR, this message translates to:
  /// **'Valores iniciais de exemplo'**
  String get workoutDefaultsNote;

  /// No description provided for @workoutSaveError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível salvar neste dispositivo. Tente novamente.'**
  String get workoutSaveError;

  /// No description provided for @workoutLoadError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível carregar os treinos locais.'**
  String get workoutLoadError;

  /// No description provided for @workoutReplaceExercise.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trocar exercício'**
  String get workoutReplaceExercise;

  /// No description provided for @workoutCloseSets.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fechar séries'**
  String get workoutCloseSets;

  /// No description provided for @workoutEditSets.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar séries'**
  String get workoutEditSets;

  /// No description provided for @workoutShowExercise.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver como fazer'**
  String get workoutShowExercise;

  /// No description provided for @workoutRemoveExercise.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remover'**
  String get workoutRemoveExercise;

  /// No description provided for @workoutDuplicateExercise.
  ///
  /// In pt_BR, this message translates to:
  /// **'Duplicar'**
  String get workoutDuplicateExercise;

  /// No description provided for @workoutRemoveSet.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remover série'**
  String get workoutRemoveSet;

  /// No description provided for @workoutAddSet.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar série'**
  String get workoutAddSet;

  /// No description provided for @workoutSet.
  ///
  /// In pt_BR, this message translates to:
  /// **'Série'**
  String get workoutSet;

  /// No description provided for @workoutAmount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Repetições / tempo'**
  String get workoutAmount;

  /// No description provided for @workoutWeightKg.
  ///
  /// In pt_BR, this message translates to:
  /// **'Peso (kg)'**
  String get workoutWeightKg;

  /// No description provided for @workoutDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Concluir'**
  String get workoutDone;

  /// No description provided for @workoutCancel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cancelar'**
  String get workoutCancel;

  /// No description provided for @workoutInvalidSet.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe valores válidos.'**
  String get workoutInvalidSet;

  /// No description provided for @workoutPlanPreview.
  ///
  /// In pt_BR, this message translates to:
  /// **'Plano local · atividade ainda não iniciada'**
  String get workoutPlanPreview;

  /// No description provided for @workoutReorder.
  ///
  /// In pt_BR, this message translates to:
  /// **'Reordenar exercícios'**
  String get workoutReorder;

  /// No description provided for @workoutMoveUp.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mover para cima'**
  String get workoutMoveUp;

  /// No description provided for @workoutMoveDown.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mover para baixo'**
  String get workoutMoveDown;

  /// No description provided for @workoutSuggestedName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino de {group}'**
  String workoutSuggestedName(String group);

  /// No description provided for @workoutMenuEdit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar'**
  String get workoutMenuEdit;

  /// No description provided for @workoutMenuDelete.
  ///
  /// In pt_BR, this message translates to:
  /// **'Apagar'**
  String get workoutMenuDelete;

  /// No description provided for @workoutDeleteTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Apagar treino?'**
  String get workoutDeleteTitle;

  /// No description provided for @workoutDeleteMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'“{name}” será removido dos treinos locais.'**
  String workoutDeleteMessage(String name);

  /// No description provided for @workoutActionError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível atualizar os treinos locais.'**
  String get workoutActionError;

  /// No description provided for @workoutBuilderTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Montar treino'**
  String get workoutBuilderTitle;

  /// No description provided for @workoutBuilderWeight.
  ///
  /// In pt_BR, this message translates to:
  /// **'kg levantados'**
  String get workoutBuilderWeight;

  /// No description provided for @workoutBuilderEmptyCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'0 EXERCÍCIOS · 0 SÉRIES'**
  String get workoutBuilderEmptyCount;

  /// No description provided for @workoutBuilderName.
  ///
  /// In pt_BR, this message translates to:
  /// **'NOME DO TREINO'**
  String get workoutBuilderName;

  /// No description provided for @workoutBuilderNameHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino de força'**
  String get workoutBuilderNameHint;

  /// No description provided for @workoutBuilderEmptyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Monte o seu treino'**
  String get workoutBuilderEmptyTitle;

  /// No description provided for @workoutBuilderEmptyHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque no + e escolha entre 218 exercícios.'**
  String get workoutBuilderEmptyHint;

  /// No description provided for @workoutBuilderAdd.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar exercícios'**
  String get workoutBuilderAdd;

  /// No description provided for @workoutBuilderUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'O catálogo de exercícios ainda não está conectado.'**
  String get workoutBuilderUnavailable;

  /// No description provided for @workoutBuilderStart.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar'**
  String get workoutBuilderStart;

  /// No description provided for @strengthDemoNote.
  ///
  /// In pt_BR, this message translates to:
  /// **'Modelos de demonstração · não são treinos salvos'**
  String get strengthDemoNote;

  /// No description provided for @strengthDemoUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Os modelos e o editor ainda não estão conectados.'**
  String get strengthDemoUnavailable;

  /// No description provided for @strengthDemoName1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Demonstração'**
  String get strengthDemoName1;

  /// No description provided for @strengthDemoName2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pernas e glúteos'**
  String get strengthDemoName2;

  /// No description provided for @strengthDemoName3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Superiores'**
  String get strengthDemoName3;

  /// No description provided for @strengthDemoName4.
  ///
  /// In pt_BR, this message translates to:
  /// **'Corpo todo'**
  String get strengthDemoName4;

  /// No description provided for @strengthDemoName5.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pernas'**
  String get strengthDemoName5;

  /// No description provided for @strengthDemoName6.
  ///
  /// In pt_BR, this message translates to:
  /// **'Superiores e core'**
  String get strengthDemoName6;

  /// No description provided for @strengthDemoName7.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino leve · mobilidade'**
  String get strengthDemoName7;

  /// No description provided for @strengthExerciseCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'{exercises} exercícios · {sets} séries'**
  String strengthExerciseCount(int exercises, int sets);

  /// No description provided for @strengthCreateHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'escolher exercícios, séries e carga'**
  String get strengthCreateHint;

  /// No description provided for @strengthOptions.
  ///
  /// In pt_BR, this message translates to:
  /// **'Opções de {name}'**
  String strengthOptions(String name);

  /// No description provided for @activityRegistrationPreview.
  ///
  /// In pt_BR, this message translates to:
  /// **'Prévia · dados simulados · não salvo'**
  String get activityRegistrationPreview;

  /// No description provided for @activityDetailHighIntensity.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alta intensidade'**
  String get activityDetailHighIntensity;

  /// No description provided for @activityDetailEffortPeaks.
  ///
  /// In pt_BR, this message translates to:
  /// **'Picos de esforço'**
  String get activityDetailEffortPeaks;

  /// No description provided for @registrationTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registrar atividade'**
  String get registrationTitle;

  /// No description provided for @registrationModality.
  ///
  /// In pt_BR, this message translates to:
  /// **'MODALIDADE'**
  String get registrationModality;

  /// No description provided for @registrationChange.
  ///
  /// In pt_BR, this message translates to:
  /// **'tocar para trocar'**
  String get registrationChange;

  /// No description provided for @registrationWhen.
  ///
  /// In pt_BR, this message translates to:
  /// **'QUANDO'**
  String get registrationWhen;

  /// No description provided for @registrationOtherDay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Outro dia'**
  String get registrationOtherDay;

  /// No description provided for @registrationStart.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começou às'**
  String get registrationStart;

  /// No description provided for @registrationDuration.
  ///
  /// In pt_BR, this message translates to:
  /// **'Duração'**
  String get registrationDuration;

  /// No description provided for @registrationEffort.
  ///
  /// In pt_BR, this message translates to:
  /// **'ESFORÇO QUE VOCÊ SENTIU'**
  String get registrationEffort;

  /// No description provided for @registrationOfTen.
  ///
  /// In pt_BR, this message translates to:
  /// **'de 10'**
  String get registrationOfTen;

  /// No description provided for @registrationEstimated.
  ///
  /// In pt_BR, this message translates to:
  /// **'carga estimada de exemplo'**
  String get registrationEstimated;

  /// No description provided for @registrationSave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvar'**
  String get registrationSave;

  /// No description provided for @registrationUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Demonstração: o registro de atividades ainda não está conectado.'**
  String get registrationUnavailable;

  /// No description provided for @registrationInvalid.
  ///
  /// In pt_BR, this message translates to:
  /// **'A atividade não pode terminar no futuro ou depois da meia-noite.'**
  String get registrationInvalid;

  /// No description provided for @registrationDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Concluído'**
  String get registrationDone;

  /// No description provided for @registrationHigh.
  ///
  /// In pt_BR, this message translates to:
  /// **'ALTA'**
  String get registrationHigh;

  /// No description provided for @registrationModerate.
  ///
  /// In pt_BR, this message translates to:
  /// **'MODERADA'**
  String get registrationModerate;

  /// No description provided for @registrationLight.
  ///
  /// In pt_BR, this message translates to:
  /// **'Leve'**
  String get registrationLight;

  /// No description provided for @registrationStrong.
  ///
  /// In pt_BR, this message translates to:
  /// **'Forte'**
  String get registrationStrong;

  /// No description provided for @registrationMaximum.
  ///
  /// In pt_BR, this message translates to:
  /// **'Máximo'**
  String get registrationMaximum;

  /// No description provided for @registrationShortPhrases.
  ///
  /// In pt_BR, this message translates to:
  /// **'frases curtas'**
  String get registrationShortPhrases;

  /// No description provided for @registrationEffortDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esforço de 1 a 10'**
  String get registrationEffortDescription;

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

  /// No description provided for @historyNormalStatus.
  ///
  /// In pt_BR, this message translates to:
  /// **'DENTRO DO SEU NORMAL'**
  String get historyNormalStatus;

  /// No description provided for @historyAverage.
  ///
  /// In pt_BR, this message translates to:
  /// **'sua média'**
  String get historyAverage;

  /// No description provided for @historyNormalRange.
  ///
  /// In pt_BR, this message translates to:
  /// **'normal 35–58'**
  String get historyNormalRange;

  /// No description provided for @historySevenDayAverage.
  ///
  /// In pt_BR, this message translates to:
  /// **'média de 7 dias'**
  String get historySevenDayAverage;

  /// No description provided for @historyDemoMonth.
  ///
  /// In pt_BR, this message translates to:
  /// **'nov'**
  String get historyDemoMonth;

  /// No description provided for @historyDemoSummary.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count, plural, one{{count} atividade} other{{count} atividades}} · {minutes} min no total'**
  String historyDemoSummary(int count, int minutes);

  /// No description provided for @historyDemoTime.
  ///
  /// In pt_BR, this message translates to:
  /// **'hoje 07:50'**
  String get historyDemoTime;

  /// No description provided for @activityDetailDemoSource.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exemplo · dados ilustrativos'**
  String get activityDetailDemoSource;

  /// No description provided for @activityDetailTimeTo.
  ///
  /// In pt_BR, this message translates to:
  /// **'a'**
  String get activityDetailTimeTo;

  /// No description provided for @activityDetailDuration.
  ///
  /// In pt_BR, this message translates to:
  /// **'Duração'**
  String get activityDetailDuration;

  /// No description provided for @activityDetailCalories.
  ///
  /// In pt_BR, this message translates to:
  /// **'Calorias'**
  String get activityDetailCalories;

  /// No description provided for @activityDetailAverageHeartRate.
  ///
  /// In pt_BR, this message translates to:
  /// **'FC média'**
  String get activityDetailAverageHeartRate;

  /// No description provided for @activityDetailMaximumHeartRate.
  ///
  /// In pt_BR, this message translates to:
  /// **'FC máxima'**
  String get activityDetailMaximumHeartRate;

  /// No description provided for @activityDetailHeartZones.
  ///
  /// In pt_BR, this message translates to:
  /// **'Zonas da FC'**
  String get activityDetailHeartZones;

  /// No description provided for @activityDetailZoneMost.
  ///
  /// In pt_BR, this message translates to:
  /// **'mais tempo na zona {zone}'**
  String activityDetailZoneMost(int zone);

  /// No description provided for @activityDetailZone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Zona'**
  String get activityDetailZone;

  /// No description provided for @activityDetailZoneRest.
  ///
  /// In pt_BR, this message translates to:
  /// **'repouso'**
  String get activityDetailZoneRest;

  /// No description provided for @activityDetailZoneVeryLight.
  ///
  /// In pt_BR, this message translates to:
  /// **'muito leve'**
  String get activityDetailZoneVeryLight;

  /// No description provided for @activityDetailZoneLight.
  ///
  /// In pt_BR, this message translates to:
  /// **'leve'**
  String get activityDetailZoneLight;

  /// No description provided for @activityDetailZoneModerate.
  ///
  /// In pt_BR, this message translates to:
  /// **'moderada'**
  String get activityDetailZoneModerate;

  /// No description provided for @activityDetailZoneHard.
  ///
  /// In pt_BR, this message translates to:
  /// **'intensa'**
  String get activityDetailZoneHard;

  /// No description provided for @activityDetailZoneMaximum.
  ///
  /// In pt_BR, this message translates to:
  /// **'máxima'**
  String get activityDetailZoneMaximum;

  /// No description provided for @activityDetailMin.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mín'**
  String get activityDetailMin;

  /// No description provided for @activityDetailMax.
  ///
  /// In pt_BR, this message translates to:
  /// **'Máx'**
  String get activityDetailMax;

  /// No description provided for @activityDetailOptions.
  ///
  /// In pt_BR, this message translates to:
  /// **'Opções'**
  String get activityDetailOptions;

  /// No description provided for @activityDetailShare.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhar'**
  String get activityDetailShare;

  /// No description provided for @activityDetailEdit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar horário e duração'**
  String get activityDetailEdit;

  /// No description provided for @activityDetailDelete.
  ///
  /// In pt_BR, this message translates to:
  /// **'Apagar atividade'**
  String get activityDetailDelete;

  /// No description provided for @activityDetailStart.
  ///
  /// In pt_BR, this message translates to:
  /// **'Horário de início (HH:mm)'**
  String get activityDetailStart;

  /// No description provided for @activityDetailSave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvar'**
  String get activityDetailSave;

  /// No description provided for @activityDetailCancel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cancelar'**
  String get activityDetailCancel;

  /// No description provided for @activityDetailInvalid.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe um horário válido e uma duração de 1 a 720 minutos.'**
  String get activityDetailInvalid;

  /// No description provided for @activityDetailDemoOnly.
  ///
  /// In pt_BR, this message translates to:
  /// **'Apenas demonstração · alterações duram até você sair desta página.'**
  String get activityDetailDemoOnly;

  /// No description provided for @activityDetailCopied.
  ///
  /// In pt_BR, this message translates to:
  /// **'Resumo de exemplo copiado.'**
  String get activityDetailCopied;

  /// No description provided for @activityDetailCopyFailed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível copiar o resumo de exemplo.'**
  String get activityDetailCopyFailed;

  /// No description provided for @activityDetailDeleteConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Apagar este exemplo?'**
  String get activityDetailDeleteConfirm;

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

  /// No description provided for @activityTargetStatus.
  ///
  /// In pt_BR, this message translates to:
  /// **'ABAIXO DO ALVO'**
  String get activityTargetStatus;

  /// No description provided for @activityTargetTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Falta pouco para o alvo.'**
  String get activityTargetTitle;

  /// No description provided for @activityTargetDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hoje: musculação, 35 min, carga 28. Com recuperação em 57, a meta do dia é 35–55: faltam 7. Uma caminhada leve de 20 a 30 minutos deve completar a meta. Estimativa de recuperação para amanhã: perto de 66.'**
  String get activityTargetDescription;

  /// No description provided for @activityMetricActiveCalories.
  ///
  /// In pt_BR, this message translates to:
  /// **'Calorias ativas'**
  String get activityMetricActiveCalories;

  /// No description provided for @activityMetricActiveMinutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Minutos ativos'**
  String get activityMetricActiveMinutes;

  /// No description provided for @activityMetricSteps.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passos'**
  String get activityMetricSteps;

  /// No description provided for @activityMetricRestingTime.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tempo parado'**
  String get activityMetricRestingTime;

  /// No description provided for @activityMetricAbove25.
  ///
  /// In pt_BR, this message translates to:
  /// **'↑ 25% acima'**
  String get activityMetricAbove25;

  /// No description provided for @activityMetricAbove28.
  ///
  /// In pt_BR, this message translates to:
  /// **'↑ 28% acima'**
  String get activityMetricAbove28;

  /// No description provided for @activityMetricWithinNormal.
  ///
  /// In pt_BR, this message translates to:
  /// **'dentro do normal'**
  String get activityMetricWithinNormal;

  /// No description provided for @activityMetricNormalCalories.
  ///
  /// In pt_BR, this message translates to:
  /// **'normal 256–383 kcal'**
  String get activityMetricNormalCalories;

  /// No description provided for @activityMetricNormalMinutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'normal 35–53 min'**
  String get activityMetricNormalMinutes;

  /// No description provided for @activityMetricNormalSteps.
  ///
  /// In pt_BR, this message translates to:
  /// **'normal 3.904–5.856'**
  String get activityMetricNormalSteps;

  /// No description provided for @activityMetricNormalRest.
  ///
  /// In pt_BR, this message translates to:
  /// **'normal 3h32–5h18'**
  String get activityMetricNormalRest;

  /// No description provided for @activityDemoStrength.
  ///
  /// In pt_BR, this message translates to:
  /// **'Musculação'**
  String get activityDemoStrength;

  /// No description provided for @activityDemoRun.
  ///
  /// In pt_BR, this message translates to:
  /// **'Corrida'**
  String get activityDemoRun;

  /// No description provided for @activityDemoWalk.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caminhada'**
  String get activityDemoWalk;

  /// No description provided for @activityDemoSetsAndWeight.
  ///
  /// In pt_BR, this message translates to:
  /// **'séries e peso'**
  String get activityDemoSetsAndWeight;

  /// No description provided for @activityDemoWithGps.
  ///
  /// In pt_BR, this message translates to:
  /// **'com GPS'**
  String get activityDemoWithGps;

  /// No description provided for @activityDemoSummary.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count, plural, one{{count} treino} other{{count} treinos}} · {minutes} min no total'**
  String activityDemoSummary(int count, int minutes);

  /// No description provided for @activityDemoLoadLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'carga'**
  String get activityDemoLoadLabel;

  /// No description provided for @activityDemoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dados ilustrativos de demonstração · não sincronizados'**
  String get activityDemoLabel;

  /// No description provided for @activityDemoStepsValue.
  ///
  /// In pt_BR, this message translates to:
  /// **'6.240'**
  String get activityDemoStepsValue;

  /// No description provided for @activityDemoRestingTimeValue.
  ///
  /// In pt_BR, this message translates to:
  /// **'4h44'**
  String get activityDemoRestingTimeValue;

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

  /// No description provided for @viewAll.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver todas'**
  String get viewAll;

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

  /// No description provided for @authWelcome.
  ///
  /// In pt_BR, this message translates to:
  /// **'BEM-VINDO À BYND'**
  String get authWelcome;

  /// No description provided for @authHeadline.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu corpo.\nSua direção.'**
  String get authHeadline;

  /// No description provided for @authSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entenda seus sinais. Viva no seu ritmo.'**
  String get authSubtitle;

  /// No description provided for @authEmailContinue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Continuar com e-mail'**
  String get authEmailContinue;

  /// No description provided for @authGoogleContinue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Continuar com Google'**
  String get authGoogleContinue;

  /// No description provided for @authEmailTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Qual é o seu e-mail?'**
  String get authEmailTitle;

  /// No description provided for @authEmailBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vamos enviar um código para você entrar. Sem senha.'**
  String get authEmailBody;

  /// No description provided for @authAccountHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'No primeiro acesso, você pode criar sua conta por aqui.'**
  String get authAccountHint;

  /// No description provided for @authEmailLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'voce@exemplo.com'**
  String get authEmailHint;

  /// No description provided for @authSendCode.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar código'**
  String get authSendCode;

  /// No description provided for @authCodeTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confira seu e-mail'**
  String get authCodeTitle;

  /// No description provided for @authCodeBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviamos um código de 6 dígitos para {email}.'**
  String authCodeBody(String email);

  /// No description provided for @authCodeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Código de verificação'**
  String get authCodeLabel;

  /// No description provided for @authCodeHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'000000'**
  String get authCodeHint;

  /// No description provided for @authEditEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alterar e-mail'**
  String get authEditEmail;

  /// No description provided for @authSignIn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get authSignIn;

  /// No description provided for @authCreateAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar conta e entrar'**
  String get authCreateAccount;

  /// No description provided for @authResend.
  ///
  /// In pt_BR, this message translates to:
  /// **'Reenviar código'**
  String get authResend;

  /// No description provided for @authResendIn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Reenviar em {seconds}s'**
  String authResendIn(int seconds);

  /// No description provided for @authSpamHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não chegou? Confira a caixa de spam ou peça um novo código.'**
  String get authSpamHint;

  /// No description provided for @authCodeSent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Código enviado. Confira também a caixa de spam.'**
  String get authCodeSent;

  /// No description provided for @authInvalidEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe um e-mail válido.'**
  String get authInvalidEmail;

  /// No description provided for @authInvalidCode.
  ///
  /// In pt_BR, this message translates to:
  /// **'Digite os 6 números do código.'**
  String get authInvalidCode;

  /// No description provided for @authCodeRejected.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível validar o código. Confira os números ou peça outro.'**
  String get authCodeRejected;

  /// No description provided for @authCodeExpired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esse código expirou. Peça um novo para continuar.'**
  String get authCodeExpired;

  /// No description provided for @authNetworkError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível conectar. Confira sua conexão e tente novamente.'**
  String get authNetworkError;

  /// No description provided for @authServerError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível entrar agora. Tente novamente em instantes.'**
  String get authServerError;

  /// No description provided for @authRateLimited.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aguarde um pouco antes de tentar novamente.'**
  String get authRateLimited;

  /// No description provided for @authStorageError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível salvar seu acesso neste dispositivo. Tente novamente.'**
  String get authStorageError;

  /// No description provided for @authGoogleError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível entrar com Google. Tente novamente ou use seu e-mail.'**
  String get authGoogleError;

  /// No description provided for @authSessionExpired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu acesso expirou. Entre novamente para continuar.'**
  String get authSessionExpired;

  /// No description provided for @authConsentTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus dados de saúde, sua escolha'**
  String get authConsentTitle;

  /// No description provided for @authConsentBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'A BYND usa os sinais de saúde coletados pela sua pulseira, como frequência cardíaca, VFC, sono e atividade, para gerar informações pessoais sobre o seu corpo. Para criar sua conta, precisamos do seu consentimento para esse tratamento.'**
  String get authConsentBody;

  /// No description provided for @authConsentLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Concordo com o tratamento dos meus dados de saúde para gerar informações pessoais, conforme descrito em Privacidade.'**
  String get authConsentLabel;

  /// No description provided for @authConsentRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para criar sua conta, confirme sua escolha sobre os dados de saúde.'**
  String get authConsentRequired;

  /// No description provided for @authConsentAccept.
  ///
  /// In pt_BR, this message translates to:
  /// **'Concordar e continuar'**
  String get authConsentAccept;

  /// No description provided for @authConsentDecline.
  ///
  /// In pt_BR, this message translates to:
  /// **'Agora não'**
  String get authConsentDecline;

  /// No description provided for @authPrivacy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Privacidade'**
  String get authPrivacy;

  /// No description provided for @authPrivacyLink.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como usamos seus dados'**
  String get authPrivacyLink;

  /// No description provided for @authPrivacyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus dados na BYND'**
  String get authPrivacyTitle;

  /// No description provided for @authPrivacyPurposeTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para entender seus sinais'**
  String get authPrivacyPurposeTitle;

  /// No description provided for @authPrivacyPurpose.
  ///
  /// In pt_BR, this message translates to:
  /// **'Os dados de saúde da pulseira e os registros que você adiciona permitem apresentar informações sobre sono, atividade e outros sinais do seu corpo.'**
  String get authPrivacyPurpose;

  /// No description provided for @authPrivacyChoiceTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma escolha explícita'**
  String get authPrivacyChoiceTitle;

  /// No description provided for @authPrivacyChoice.
  ///
  /// In pt_BR, this message translates to:
  /// **'A criação da conta exige seu consentimento para o tratamento dos dados de saúde. Você pode ler estas informações e voltar sem concordar; nesse caso, nenhuma conta será criada por esta etapa.'**
  String get authPrivacyChoice;

  /// No description provided for @authPrivacyAccessTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu acesso'**
  String get authPrivacyAccessTitle;

  /// No description provided for @authPrivacyAccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'O acesso por e-mail usa um código temporário. Guarde esse código só para você. A sessão permanece no dispositivo até você sair ou o acesso expirar.'**
  String get authPrivacyAccess;

  /// No description provided for @authLegalFootnote.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conheça como a BYND utiliza seus dados antes de continuar.'**
  String get authLegalFootnote;

  /// No description provided for @authRestore.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preparando seu acesso…'**
  String get authRestore;

  /// No description provided for @authSignOutTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair da sua conta?'**
  String get authSignOutTitle;

  /// No description provided for @authSignOutBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você poderá entrar novamente com seu e-mail ou com Google.'**
  String get authSignOutBody;

  /// No description provided for @authSignOutConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair'**
  String get authSignOutConfirm;

  /// No description provided for @authCancel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cancelar'**
  String get authCancel;

  /// No description provided for @authSignOutFailed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você saiu, mas não foi possível limpar todos os dados locais. Tente reiniciar o app.'**
  String get authSignOutFailed;

  /// No description provided for @authBackground.
  ///
  /// In pt_BR, this message translates to:
  /// **'Paisagem {index} de {total}'**
  String authBackground(int index, int total);

  /// No description provided for @authChangeLanguage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alterar idioma'**
  String get authChangeLanguage;

  /// No description provided for @communityMyGroups.
  ///
  /// In pt_BR, this message translates to:
  /// **'Meus grupos'**
  String get communityMyGroups;

  /// No description provided for @communityEmptyGroups.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum grupo ainda. Crie um ou entre com um convite.'**
  String get communityEmptyGroups;

  /// No description provided for @communityToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para hoje'**
  String get communityToday;

  /// No description provided for @communityMarkDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Marcar como feito'**
  String get communityMarkDone;

  /// No description provided for @communityMarkedDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dia marcado como feito.'**
  String get communityMarkedDone;

  /// No description provided for @communityDoneToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feito hoje'**
  String get communityDoneToday;

  /// No description provided for @communityRetry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tentar novamente'**
  String get communityRetry;

  /// No description provided for @communityAccept.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aceitar'**
  String get communityAccept;

  /// No description provided for @communityDecline.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recusar'**
  String get communityDecline;

  /// No description provided for @communityMemberCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} pessoas'**
  String communityMemberCount(Object count);

  /// No description provided for @communityCheckinLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'check-in'**
  String get communityCheckinLabel;

  /// No description provided for @communityRankOf.
  ///
  /// In pt_BR, this message translates to:
  /// **'de {total}'**
  String communityRankOf(Object total);

  /// No description provided for @communityDaysTotal.
  ///
  /// In pt_BR, this message translates to:
  /// **'desafio de {days} dias'**
  String communityDaysTotal(Object days);

  /// No description provided for @communityEmptyChat.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma mensagem ainda. Diga oi!'**
  String get communityEmptyChat;

  /// No description provided for @communityDayToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hoje'**
  String get communityDayToday;

  /// No description provided for @communityDayYesterday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ontem'**
  String get communityDayYesterday;

  /// No description provided for @communityMessageRecalled.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mensagem removida'**
  String get communityMessageRecalled;

  /// No description provided for @communitySendHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mensagem para o grupo'**
  String get communitySendHint;

  /// No description provided for @communityInvitationFrom.
  ///
  /// In pt_BR, this message translates to:
  /// **'{inviter} convidou você para \"{group}\"'**
  String communityInvitationFrom(Object group, Object inviter);

  /// No description provided for @communityNewCover.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar grupo\nou entrar com código'**
  String get communityNewCover;

  /// No description provided for @communityInviteFromShort.
  ///
  /// In pt_BR, this message translates to:
  /// **'convite de {name}'**
  String communityInviteFromShort(Object name);

  /// No description provided for @communityRankBadge.
  ///
  /// In pt_BR, this message translates to:
  /// **'{rank}º no desafio de {total}'**
  String communityRankBadge(Object rank, Object total);

  /// No description provided for @communityParaHoje.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para hoje'**
  String get communityParaHoje;

  /// No description provided for @communityPickChallenge.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolher um desafio'**
  String get communityPickChallenge;

  /// No description provided for @communityPickChallengeSub.
  ///
  /// In pt_BR, this message translates to:
  /// **'sozinho ou com o seu grupo'**
  String get communityPickChallengeSub;

  /// No description provided for @communityDayOfTotal.
  ///
  /// In pt_BR, this message translates to:
  /// **'dia {day} de {total}'**
  String communityDayOfTotal(Object day, Object total);

  /// No description provided for @communityMuralToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'No grupo hoje'**
  String get communityMuralToday;

  /// No description provided for @communityMuralYesterday.
  ///
  /// In pt_BR, this message translates to:
  /// **'No grupo ontem'**
  String get communityMuralYesterday;

  /// No description provided for @communityMuralIntro.
  ///
  /// In pt_BR, this message translates to:
  /// **'Do mais novo para o mais antigo. Toque em \"Dar força\" para apoiar.'**
  String get communityMuralIntro;

  /// No description provided for @communityNoCheckinsToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum check-in hoje ainda. Quem fizer aparece aqui.'**
  String get communityNoCheckinsToday;

  /// No description provided for @communityNoCheckinsYesterday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum check-in ontem.'**
  String get communityNoCheckinsYesterday;

  /// No description provided for @communityAtlasKicker.
  ///
  /// In pt_BR, this message translates to:
  /// **'ATLAS · RESUMO DO GRUPO'**
  String get communityAtlasKicker;

  /// No description provided for @communityCheer.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dar força'**
  String get communityCheer;

  /// No description provided for @communityCheerSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dar força chega em breve.'**
  String get communityCheerSoon;

  /// No description provided for @communityRespond.
  ///
  /// In pt_BR, this message translates to:
  /// **'Responder'**
  String get communityRespond;

  /// No description provided for @communityOpenGroupChat.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abrir a conversa do grupo'**
  String get communityOpenGroupChat;

  /// No description provided for @communityCheckinText.
  ///
  /// In pt_BR, this message translates to:
  /// **'✓ Check-in de hoje'**
  String get communityCheckinText;

  /// No description provided for @communityNewTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Novo'**
  String get communityNewTitle;

  /// No description provided for @communityTabChallenges.
  ///
  /// In pt_BR, this message translates to:
  /// **'Desafios'**
  String get communityTabChallenges;

  /// No description provided for @communityTabCreateGroup.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar grupo'**
  String get communityTabCreateGroup;

  /// No description provided for @communityTabCode.
  ///
  /// In pt_BR, this message translates to:
  /// **'Código'**
  String get communityTabCode;

  /// No description provided for @communityChallengesIntro.
  ///
  /// In pt_BR, this message translates to:
  /// **'Desafios criados pela BYND com especialistas. Faça sozinho ou leve para o seu grupo.'**
  String get communityChallengesIntro;

  /// No description provided for @communityDetailsOpen.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver detalhes'**
  String get communityDetailsOpen;

  /// No description provided for @communityDetailsClose.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fechar'**
  String get communityDetailsClose;

  /// No description provided for @communityChallengeWhy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Por que funciona'**
  String get communityChallengeWhy;

  /// No description provided for @communityChallengeDaily.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todo dia'**
  String get communityChallengeDaily;

  /// No description provided for @communityEnrolledBadge.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você está neste desafio'**
  String get communityEnrolledBadge;

  /// No description provided for @communityStartToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar hoje'**
  String get communityStartToday;

  /// No description provided for @communityChallengeLeave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair do desafio'**
  String get communityChallengeLeave;

  /// No description provided for @communityStepName.
  ///
  /// In pt_BR, this message translates to:
  /// **'1 · Nome do grupo'**
  String get communityStepName;

  /// No description provided for @communityStepInvite.
  ///
  /// In pt_BR, this message translates to:
  /// **'2 · Quem você quer chamar (e-mail)'**
  String get communityStepInvite;

  /// No description provided for @communityCodeIntro.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recebeu um convite? Digite o código do grupo (ele vem no link ou na mensagem de quem te chamou).'**
  String get communityCodeIntro;

  /// No description provided for @communityCodeHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'BYND-0000'**
  String get communityCodeHint;

  /// No description provided for @communityCodeGo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar no grupo'**
  String get communityCodeGo;

  /// No description provided for @communityCodeSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar por código chega em breve.'**
  String get communityCodeSoon;

  /// No description provided for @communityAjustesTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Grupo'**
  String get communityAjustesTitle;

  /// No description provided for @communityAjustesInvite.
  ///
  /// In pt_BR, this message translates to:
  /// **'+ Convidar'**
  String get communityAjustesInvite;

  /// No description provided for @communityPlacarTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Placar'**
  String get communityPlacarTitle;

  /// No description provided for @communityRoleAdmin.
  ///
  /// In pt_BR, this message translates to:
  /// **'admin'**
  String get communityRoleAdmin;

  /// No description provided for @communityNotifTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Avisos'**
  String get communityNotifTitle;

  /// No description provided for @communityNotifMessages.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mensagens'**
  String get communityNotifMessages;

  /// No description provided for @communityLeaveDoubleTap.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque de novo para sair'**
  String get communityLeaveDoubleTap;

  /// No description provided for @communityInviteTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Convidar para o grupo'**
  String get communityInviteTitle;

  /// No description provided for @communityInviteEmailHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'nome@exemplo.com'**
  String get communityInviteEmailHint;

  /// No description provided for @communityInviteSend.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar'**
  String get communityInviteSend;

  /// No description provided for @communityInviteSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Convite enviado.'**
  String get communityInviteSuccess;

  /// No description provided for @communityMembersTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pessoas · {count}'**
  String communityMembersTitle(Object count);

  /// No description provided for @communityLeaveGroup.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair do grupo'**
  String get communityLeaveGroup;

  /// No description provided for @communityGoalsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Objetivos'**
  String get communityGoalsTitle;

  /// No description provided for @communityNoGoals.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum objetivo neste grupo ainda.'**
  String get communityNoGoals;

  /// No description provided for @communityCreateIntro.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um grupo é para fazer desafios juntos, comparar os números do objetivo e conversar.'**
  String get communityCreateIntro;

  /// No description provided for @communityGroupName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome do grupo'**
  String get communityGroupName;

  /// No description provided for @communityGroupNameHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ex.: Corrida das 6h, Família, Trabalho'**
  String get communityGroupNameHint;

  /// No description provided for @communityGroupDescription.
  ///
  /// In pt_BR, this message translates to:
  /// **'Descrição'**
  String get communityGroupDescription;

  /// No description provided for @communityGroupDescriptionHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sobre o que é o grupo?'**
  String get communityGroupDescriptionHint;

  /// No description provided for @communityInviteEmails.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quem você quer chamar'**
  String get communityInviteEmails;

  /// No description provided for @communityInviteEmailsHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'e-mails separados por vírgula'**
  String get communityInviteEmailsHint;

  /// No description provided for @communityGroupCreate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar grupo'**
  String get communityGroupCreate;

  /// No description provided for @communityCreating.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criando...'**
  String get communityCreating;

  /// No description provided for @communityGroupCreated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Grupo criado · {count} convite(s) enviado(s).'**
  String communityGroupCreated(Object count);

  /// No description provided for @communityCreateNote.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pode criar sem ninguém: depois de criar, você chama mais gente nos ajustes do grupo.'**
  String get communityCreateNote;

  /// No description provided for @communityPublicGroup.
  ///
  /// In pt_BR, this message translates to:
  /// **'Grupo público'**
  String get communityPublicGroup;

  /// No description provided for @communityJoin.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get communityJoin;

  /// No description provided for @communityJoinedGroup.
  ///
  /// In pt_BR, this message translates to:
  /// **'Boas-vindas ao grupo!'**
  String get communityJoinedGroup;

  /// No description provided for @atlasInsights.
  ///
  /// In pt_BR, this message translates to:
  /// **'Insights'**
  String get atlasInsights;

  /// No description provided for @atlasChat.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conversar com o ATLAS'**
  String get atlasChat;

  /// No description provided for @insightsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Insights'**
  String get insightsTitle;

  /// No description provided for @insightsRefresh.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualizar'**
  String get insightsRefresh;

  /// No description provided for @insightsError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível carregar os insights. Puxe para baixo e tente novamente.'**
  String get insightsError;

  /// No description provided for @insightsEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum insight ainda. Continue sincronizando a pulseira — o ATLAS fala quando seus dados contam algo que vale a pena saber.'**
  String get insightsEmpty;

  /// No description provided for @insightsFactors.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que pode estar envolvido'**
  String get insightsFactors;

  /// No description provided for @insightsActions.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você pode experimentar'**
  String get insightsActions;

  /// No description provided for @chatTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atlas'**
  String get chatTitle;

  /// No description provided for @chatNew.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nova conversa'**
  String get chatNew;

  /// No description provided for @chatEmptyHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pergunte sobre sono, recuperação, estresse ou prontidão para treinar. O ATLAS responde com os seus dados e explica o que significam.'**
  String get chatEmptyHint;

  /// No description provided for @chatInputHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pergunte ao Atlas'**
  String get chatInputHint;

  /// No description provided for @menuMapa.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mapa'**
  String get menuMapa;

  /// No description provided for @chatSug1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como estou?'**
  String get chatSug1;

  /// No description provided for @chatSug2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Me dá um resumo do meu dia'**
  String get chatSug2;

  /// No description provided for @chatSug3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Por que a VFC não volta?'**
  String get chatSug3;

  /// No description provided for @chatHistoryTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conversas'**
  String get chatHistoryTitle;

  /// No description provided for @chatHistoryEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma conversa ainda.'**
  String get chatHistoryEmpty;

  /// No description provided for @chatHistoryUntitled.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conversa sem título'**
  String get chatHistoryUntitled;

  /// No description provided for @chatContinueLast.
  ///
  /// In pt_BR, this message translates to:
  /// **'Continuar última conversa'**
  String get chatContinueLast;

  /// No description provided for @healthGroupSleep.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sono'**
  String get healthGroupSleep;

  /// No description provided for @healthGroupEnergy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Energia'**
  String get healthGroupEnergy;

  /// No description provided for @healthGroupMetabolism.
  ///
  /// In pt_BR, this message translates to:
  /// **'Metabolismo'**
  String get healthGroupMetabolism;

  /// No description provided for @healthGroupHeartBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Coração e corpo'**
  String get healthGroupHeartBody;

  /// No description provided for @healthGroupBreathOxygen.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respiração e oxigênio'**
  String get healthGroupBreathOxygen;

  /// No description provided for @healthGroupLongevity.
  ///
  /// In pt_BR, this message translates to:
  /// **'Longevidade'**
  String get healthGroupLongevity;

  /// No description provided for @memoriaTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memória'**
  String get memoriaTitle;

  /// No description provided for @memoriaHeroTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que o Atlas sabe de você'**
  String get memoriaHeroTitle;

  /// No description provided for @memoriaHeroSub.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quanto mais ele sabe, melhores as respostas.'**
  String get memoriaHeroSub;

  /// No description provided for @memoriaKicker.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que ele guardou'**
  String get memoriaKicker;

  /// No description provided for @memoriaCurrent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atual'**
  String get memoriaCurrent;

  /// No description provided for @memoriaPast.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou'**
  String get memoriaPast;

  /// No description provided for @memoriaTold.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você contou'**
  String get memoriaTold;

  /// No description provided for @memoriaPerceived.
  ///
  /// In pt_BR, this message translates to:
  /// **'O Atlas percebeu'**
  String get memoriaPerceived;

  /// No description provided for @memoriaSince.
  ///
  /// In pt_BR, this message translates to:
  /// **'desde'**
  String get memoriaSince;

  /// No description provided for @diaryCatalogAguaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Beber água'**
  String get diaryCatalogAguaLabel;

  /// No description provided for @diaryCatalogAguaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bebeu água?'**
  String get diaryCatalogAguaPrompt;

  /// No description provided for @diaryCatalogProtLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comer proteína'**
  String get diaryCatalogProtLabel;

  /// No description provided for @diaryCatalogProtPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu proteína nas refeições?'**
  String get diaryCatalogProtPrompt;

  /// No description provided for @diaryCatalogFrutLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fruta e verdura'**
  String get diaryCatalogFrutLabel;

  /// No description provided for @diaryCatalogFrutPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu fruta e verdura?'**
  String get diaryCatalogFrutPrompt;

  /// No description provided for @diaryCatalogJantarLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jantar até as 20h'**
  String get diaryCatalogJantarLabel;

  /// No description provided for @diaryCatalogJantarPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jantou até as 20h?'**
  String get diaryCatalogJantarPrompt;

  /// No description provided for @diaryCatalogDoceLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Doce'**
  String get diaryCatalogDoceLabel;

  /// No description provided for @diaryCatalogDocePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu doce?'**
  String get diaryCatalogDocePrompt;

  /// No description provided for @diaryCatalogAlcLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Álcool'**
  String get diaryCatalogAlcLabel;

  /// No description provided for @diaryCatalogAlcPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bebeu álcool?'**
  String get diaryCatalogAlcPrompt;

  /// No description provided for @diaryCatalogCafe15Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Café depois das 15h'**
  String get diaryCatalogCafe15Label;

  /// No description provided for @diaryCatalogCafe15Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou café depois das 15h?'**
  String get diaryCatalogCafe15Prompt;

  /// No description provided for @diaryCatalogRefriLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Refrigerante'**
  String get diaryCatalogRefriLabel;

  /// No description provided for @diaryCatalogRefriPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou refrigerante?'**
  String get diaryCatalogRefriPrompt;

  /// No description provided for @diaryCatalogCafeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Café'**
  String get diaryCatalogCafeLabel;

  /// No description provided for @diaryCatalogCafePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou café?'**
  String get diaryCatalogCafePrompt;

  /// No description provided for @diaryCatalogTelaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Celular na cama'**
  String get diaryCatalogTelaLabel;

  /// No description provided for @diaryCatalogTelaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou o celular na cama?'**
  String get diaryCatalogTelaPrompt;

  /// No description provided for @diaryCatalogLuzLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sol pela manhã'**
  String get diaryCatalogLuzLabel;

  /// No description provided for @diaryCatalogLuzPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pegou sol de manhã?'**
  String get diaryCatalogLuzPrompt;

  /// No description provided for @diaryCatalogLerLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ler antes de dormir'**
  String get diaryCatalogLerLabel;

  /// No description provided for @diaryCatalogLerPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Leu antes de dormir?'**
  String get diaryCatalogLerPrompt;

  /// No description provided for @diaryCatalogRespLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respiração'**
  String get diaryCatalogRespLabel;

  /// No description provided for @diaryCatalogRespPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez a respiração?'**
  String get diaryCatalogRespPrompt;

  /// No description provided for @diaryCatalogMeditLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Meditar'**
  String get diaryCatalogMeditLabel;

  /// No description provided for @diaryCatalogMeditPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Meditou?'**
  String get diaryCatalogMeditPrompt;

  /// No description provided for @diaryCatalogGratLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escrever 3 gratidões'**
  String get diaryCatalogGratLabel;

  /// No description provided for @diaryCatalogGratPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreveu as gratidões?'**
  String get diaryCatalogGratPrompt;

  /// No description provided for @diaryCatalogGeloLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Banho gelado'**
  String get diaryCatalogGeloLabel;

  /// No description provided for @diaryCatalogGeloPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou banho gelado?'**
  String get diaryCatalogGeloPrompt;

  /// No description provided for @diaryCatalogAlongLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alongar'**
  String get diaryCatalogAlongLabel;

  /// No description provided for @diaryCatalogAlongPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alongou?'**
  String get diaryCatalogAlongPrompt;

  /// No description provided for @diaryCatalogDorLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor muscular'**
  String get diaryCatalogDorLabel;

  /// No description provided for @diaryCatalogDorPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu dor muscular?'**
  String get diaryCatalogDorPrompt;

  /// No description provided for @diaryCatalogRemedioLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomar o remédio'**
  String get diaryCatalogRemedioLabel;

  /// No description provided for @diaryCatalogRemedioPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou o remédio?'**
  String get diaryCatalogRemedioPrompt;

  /// No description provided for @diaryCatalogGlpLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aplicar o GLP-1'**
  String get diaryCatalogGlpLabel;

  /// No description provided for @diaryCatalogGlpPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aplicou o GLP-1?'**
  String get diaryCatalogGlpPrompt;

  /// No description provided for @diaryCatalogCreatLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Creatina'**
  String get diaryCatalogCreatLabel;

  /// No description provided for @diaryCatalogCreatPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou creatina?'**
  String get diaryCatalogCreatPrompt;

  /// No description provided for @diaryCatalogVitLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vitaminas'**
  String get diaryCatalogVitLabel;

  /// No description provided for @diaryCatalogVitPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou as vitaminas?'**
  String get diaryCatalogVitPrompt;

  /// No description provided for @diaryCatalogAcordouLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como acordou'**
  String get diaryCatalogAcordouLabel;

  /// No description provided for @diaryCatalogAcordouPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como acordou?'**
  String get diaryCatalogAcordouPrompt;

  /// No description provided for @diaryCatalogHumorLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Humor'**
  String get diaryCatalogHumorLabel;

  /// No description provided for @diaryCatalogHumorPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como está o humor?'**
  String get diaryCatalogHumorPrompt;

  /// No description provided for @diaryCatalogEnergiaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Disposição'**
  String get diaryCatalogEnergiaLabel;

  /// No description provided for @diaryCatalogEnergiaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como está a disposição?'**
  String get diaryCatalogEnergiaPrompt;

  /// No description provided for @diaryCatalogEstresseLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estresse'**
  String get diaryCatalogEstresseLabel;

  /// No description provided for @diaryCatalogEstressePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quanto estresse hoje?'**
  String get diaryCatalogEstressePrompt;

  /// No description provided for @diaryCatalogCafeMLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Café da manhã'**
  String get diaryCatalogCafeMLabel;

  /// No description provided for @diaryCatalogCafeMPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você comeu?'**
  String get diaryCatalogCafeMPrompt;

  /// No description provided for @diaryCatalogLancheMLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lanche da manhã'**
  String get diaryCatalogLancheMLabel;

  /// No description provided for @diaryCatalogLancheMPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você comeu?'**
  String get diaryCatalogLancheMPrompt;

  /// No description provided for @diaryCatalogAlmocoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Almoço'**
  String get diaryCatalogAlmocoLabel;

  /// No description provided for @diaryCatalogAlmocoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você comeu?'**
  String get diaryCatalogAlmocoPrompt;

  /// No description provided for @diaryCatalogLancheTLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lanche da tarde'**
  String get diaryCatalogLancheTLabel;

  /// No description provided for @diaryCatalogLancheTPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você comeu?'**
  String get diaryCatalogLancheTPrompt;

  /// No description provided for @diaryCatalogJantarRLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jantar'**
  String get diaryCatalogJantarRLabel;

  /// No description provided for @diaryCatalogJantarRPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você comeu?'**
  String get diaryCatalogJantarRPrompt;

  /// No description provided for @diaryCatalogCeiaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ceia'**
  String get diaryCatalogCeiaLabel;

  /// No description provided for @diaryCatalogCeiaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você comeu?'**
  String get diaryCatalogCeiaPrompt;

  /// No description provided for @diaryCatalogWheyLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Whey'**
  String get diaryCatalogWheyLabel;

  /// No description provided for @diaryCatalogWheyPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você comeu?'**
  String get diaryCatalogWheyPrompt;

  /// No description provided for @diaryCatalogGripeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sinal de gripe'**
  String get diaryCatalogGripeLabel;

  /// No description provided for @diaryCatalogGripePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu sinal de gripe?'**
  String get diaryCatalogGripePrompt;

  /// No description provided for @diaryCatalogCAguaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Água'**
  String get diaryCatalogCAguaLabel;

  /// No description provided for @diaryCatalogCAguaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bebeu água suficiente?'**
  String get diaryCatalogCAguaPrompt;

  /// No description provided for @diaryCatalogCExpressoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Café expresso'**
  String get diaryCatalogCExpressoLabel;

  /// No description provided for @diaryCatalogCExpressoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou expresso?'**
  String get diaryCatalogCExpressoPrompt;

  /// No description provided for @diaryCatalogCCafeleiteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Café com leite'**
  String get diaryCatalogCCafeleiteLabel;

  /// No description provided for @diaryCatalogCCafeleitePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou café com leite?'**
  String get diaryCatalogCCafeleitePrompt;

  /// No description provided for @diaryCatalogCChaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Chá'**
  String get diaryCatalogCChaLabel;

  /// No description provided for @diaryCatalogCChaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou chá?'**
  String get diaryCatalogCChaPrompt;

  /// No description provided for @diaryCatalogCChapretoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Chá preto ou mate'**
  String get diaryCatalogCChapretoLabel;

  /// No description provided for @diaryCatalogCChapretoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou chá preto ou mate (com cafeína)?'**
  String get diaryCatalogCChapretoPrompt;

  /// No description provided for @diaryCatalogCChimarraoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Chimarrão'**
  String get diaryCatalogCChimarraoLabel;

  /// No description provided for @diaryCatalogCChimarraoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou chimarrão?'**
  String get diaryCatalogCChimarraoPrompt;

  /// No description provided for @diaryCatalogCTerereLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tereré'**
  String get diaryCatalogCTerereLabel;

  /// No description provided for @diaryCatalogCTererePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou tereré?'**
  String get diaryCatalogCTererePrompt;

  /// No description provided for @diaryCatalogCEnergLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Energético'**
  String get diaryCatalogCEnergLabel;

  /// No description provided for @diaryCatalogCEnergPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou energético?'**
  String get diaryCatalogCEnergPrompt;

  /// No description provided for @diaryCatalogCSucoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suco natural'**
  String get diaryCatalogCSucoLabel;

  /// No description provided for @diaryCatalogCSucoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou suco natural?'**
  String get diaryCatalogCSucoPrompt;

  /// No description provided for @diaryCatalogCSucocxLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suco de caixinha'**
  String get diaryCatalogCSucocxLabel;

  /// No description provided for @diaryCatalogCSucocxPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou suco de caixinha ou em pó?'**
  String get diaryCatalogCSucocxPrompt;

  /// No description provided for @diaryCatalogCCocoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Água de coco'**
  String get diaryCatalogCCocoLabel;

  /// No description provided for @diaryCatalogCCocoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou água de coco?'**
  String get diaryCatalogCCocoPrompt;

  /// No description provided for @diaryCatalogCIsotLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Isotônico'**
  String get diaryCatalogCIsotLabel;

  /// No description provided for @diaryCatalogCIsotPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou isotônico?'**
  String get diaryCatalogCIsotPrompt;

  /// No description provided for @diaryCatalogCLeiteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Leite'**
  String get diaryCatalogCLeiteLabel;

  /// No description provided for @diaryCatalogCLeitePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou leite?'**
  String get diaryCatalogCLeitePrompt;

  /// No description provided for @diaryCatalogCVegetalLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bebida vegetal'**
  String get diaryCatalogCVegetalLabel;

  /// No description provided for @diaryCatalogCVegetalPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou leite vegetal?'**
  String get diaryCatalogCVegetalPrompt;

  /// No description provided for @diaryCatalogCKombuchaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Kombucha'**
  String get diaryCatalogCKombuchaLabel;

  /// No description provided for @diaryCatalogCKombuchaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou kombucha?'**
  String get diaryCatalogCKombuchaPrompt;

  /// No description provided for @diaryCatalogCCervejaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cerveja'**
  String get diaryCatalogCCervejaLabel;

  /// No description provided for @diaryCatalogCCervejaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou cerveja?'**
  String get diaryCatalogCCervejaPrompt;

  /// No description provided for @diaryCatalogCVinhoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vinho'**
  String get diaryCatalogCVinhoLabel;

  /// No description provided for @diaryCatalogCVinhoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou vinho?'**
  String get diaryCatalogCVinhoPrompt;

  /// No description provided for @diaryCatalogCCaipirinhaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caipirinha'**
  String get diaryCatalogCCaipirinhaLabel;

  /// No description provided for @diaryCatalogCCaipirinhaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou caipirinha?'**
  String get diaryCatalogCCaipirinhaPrompt;

  /// No description provided for @diaryCatalogCCachacaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cachaça'**
  String get diaryCatalogCCachacaLabel;

  /// No description provided for @diaryCatalogCCachacaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou cachaça?'**
  String get diaryCatalogCCachacaPrompt;

  /// No description provided for @diaryCatalogCDestiladoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Destilado'**
  String get diaryCatalogCDestiladoLabel;

  /// No description provided for @diaryCatalogCDestiladoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou vodka, whisky ou gin?'**
  String get diaryCatalogCDestiladoPrompt;

  /// No description provided for @diaryCatalogCDrinksLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Drinks'**
  String get diaryCatalogCDrinksLabel;

  /// No description provided for @diaryCatalogCDrinksPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou drinks?'**
  String get diaryCatalogCDrinksPrompt;

  /// No description provided for @diaryCatalogCAlctardeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Álcool à noite'**
  String get diaryCatalogCAlctardeLabel;

  /// No description provided for @diaryCatalogCAlctardePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bebeu perto da hora de dormir?'**
  String get diaryCatalogCAlctardePrompt;

  /// No description provided for @diaryCatalogCRessacaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ressaca'**
  String get diaryCatalogCRessacaLabel;

  /// No description provided for @diaryCatalogCRessacaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acordou de ressaca?'**
  String get diaryCatalogCRessacaPrompt;

  /// No description provided for @diaryCatalogCAguagasLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Água com gás'**
  String get diaryCatalogCAguagasLabel;

  /// No description provided for @diaryCatalogCAguagasPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou água com gás?'**
  String get diaryCatalogCAguagasPrompt;

  /// No description provided for @diaryCatalogCChaverdeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Chá verde'**
  String get diaryCatalogCChaverdeLabel;

  /// No description provided for @diaryCatalogCChaverdePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou chá verde?'**
  String get diaryCatalogCChaverdePrompt;

  /// No description provided for @diaryCatalogCCamomilaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Chá calmante'**
  String get diaryCatalogCCamomilaLabel;

  /// No description provided for @diaryCatalogCCamomilaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou chá de camomila, erva-cidreira ou melissa?'**
  String get diaryCatalogCCamomilaPrompt;

  /// No description provided for @diaryCatalogCDescafLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Café descafeinado'**
  String get diaryCatalogCDescafLabel;

  /// No description provided for @diaryCatalogCDescafPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou café descafeinado?'**
  String get diaryCatalogCDescafPrompt;

  /// No description provided for @diaryCatalogCSmoothieLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vitamina ou smoothie'**
  String get diaryCatalogCSmoothieLabel;

  /// No description provided for @diaryCatalogCSmoothiePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou vitamina de frutas?'**
  String get diaryCatalogCSmoothiePrompt;

  /// No description provided for @diaryCatalogCShakeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Shake de proteína'**
  String get diaryCatalogCShakeLabel;

  /// No description provided for @diaryCatalogCShakePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou shake de proteína?'**
  String get diaryCatalogCShakePrompt;

  /// No description provided for @diaryCatalogCCaldocanaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caldo de cana'**
  String get diaryCatalogCCaldocanaLabel;

  /// No description provided for @diaryCatalogCCaldocanaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou caldo de cana?'**
  String get diaryCatalogCCaldocanaPrompt;

  /// No description provided for @diaryCatalogCAchocLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Achocolatado'**
  String get diaryCatalogCAchocLabel;

  /// No description provided for @diaryCatalogCAchocPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou achocolatado?'**
  String get diaryCatalogCAchocPrompt;

  /// No description provided for @diaryCatalogCSemalcLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cerveja sem álcool'**
  String get diaryCatalogCSemalcLabel;

  /// No description provided for @diaryCatalogCSemalcPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou cerveja sem álcool?'**
  String get diaryCatalogCSemalcPrompt;

  /// No description provided for @diaryCatalogCBebquenteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bebida quente à noite'**
  String get diaryCatalogCBebquenteLabel;

  /// No description provided for @diaryCatalogCBebquentePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou algo quente antes de dormir?'**
  String get diaryCatalogCBebquentePrompt;

  /// No description provided for @diaryCatalogCAguamanhaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Água ao acordar'**
  String get diaryCatalogCAguamanhaLabel;

  /// No description provided for @diaryCatalogCAguamanhaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bebeu água logo ao acordar?'**
  String get diaryCatalogCAguamanhaPrompt;

  /// No description provided for @diaryCatalogCCafemLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Café da manhã'**
  String get diaryCatalogCCafemLabel;

  /// No description provided for @diaryCatalogCCafemPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou café da manhã?'**
  String get diaryCatalogCCafemPrompt;

  /// No description provided for @diaryCatalogCCafemanhaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Café da manhã'**
  String get diaryCatalogCCafemanhaLabel;

  /// No description provided for @diaryCatalogCCafemanhaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou café da manhã?'**
  String get diaryCatalogCCafemanhaPrompt;

  /// No description provided for @diaryCatalogCAlmLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Almoço'**
  String get diaryCatalogCAlmLabel;

  /// No description provided for @diaryCatalogCAlmPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Almoçou?'**
  String get diaryCatalogCAlmPrompt;

  /// No description provided for @diaryCatalogCJantarLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jantar'**
  String get diaryCatalogCJantarLabel;

  /// No description provided for @diaryCatalogCJantarPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jantou?'**
  String get diaryCatalogCJantarPrompt;

  /// No description provided for @diaryCatalogCLancheLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lanche da tarde'**
  String get diaryCatalogCLancheLabel;

  /// No description provided for @diaryCatalogCLanchePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez lanche da tarde?'**
  String get diaryCatalogCLanchePrompt;

  /// No description provided for @diaryCatalogCBeliscouLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Beliscou'**
  String get diaryCatalogCBeliscouLabel;

  /// No description provided for @diaryCatalogCBeliscouPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Beliscou entre as refeições?'**
  String get diaryCatalogCBeliscouPrompt;

  /// No description provided for @diaryCatalogCPularefLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pulou refeição'**
  String get diaryCatalogCPularefLabel;

  /// No description provided for @diaryCatalogCPularefPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pulou alguma refeição?'**
  String get diaryCatalogCPularefPrompt;

  /// No description provided for @diaryCatalogCTardeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu tarde'**
  String get diaryCatalogCTardeLabel;

  /// No description provided for @diaryCatalogCTardePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu perto da hora de dormir?'**
  String get diaryCatalogCTardePrompt;

  /// No description provided for @diaryCatalogCJejumLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jejum'**
  String get diaryCatalogCJejumLabel;

  /// No description provided for @diaryCatalogCJejumPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez jejum intermitente?'**
  String get diaryCatalogCJejumPrompt;

  /// No description provided for @diaryCatalogCComeudemaisLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu demais'**
  String get diaryCatalogCComeudemaisLabel;

  /// No description provided for @diaryCatalogCComeudemaisPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu além do ponto?'**
  String get diaryCatalogCComeudemaisPrompt;

  /// No description provided for @diaryCatalogCPesadaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Refeição pesada'**
  String get diaryCatalogCPesadaLabel;

  /// No description provided for @diaryCatalogCPesadaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez uma refeição pesada?'**
  String get diaryCatalogCPesadaPrompt;

  /// No description provided for @diaryCatalogCProtLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Proteína'**
  String get diaryCatalogCProtLabel;

  /// No description provided for @diaryCatalogCProtPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bateu a proteína do dia?'**
  String get diaryCatalogCProtPrompt;

  /// No description provided for @diaryCatalogCCaseiraLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comida caseira'**
  String get diaryCatalogCCaseiraLabel;

  /// No description provided for @diaryCatalogCCaseiraPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu comida feita em casa?'**
  String get diaryCatalogCCaseiraPrompt;

  /// No description provided for @diaryCatalogCMarmitaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Marmita'**
  String get diaryCatalogCMarmitaLabel;

  /// No description provided for @diaryCatalogCMarmitaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Levou marmita?'**
  String get diaryCatalogCMarmitaPrompt;

  /// No description provided for @diaryCatalogCForaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu fora'**
  String get diaryCatalogCForaLabel;

  /// No description provided for @diaryCatalogCForaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu em restaurante?'**
  String get diaryCatalogCForaPrompt;

  /// No description provided for @diaryCatalogCDeliveryLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Delivery'**
  String get diaryCatalogCDeliveryLabel;

  /// No description provided for @diaryCatalogCDeliveryPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pediu comida por aplicativo?'**
  String get diaryCatalogCDeliveryPrompt;

  /// No description provided for @diaryCatalogCFastfoodLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fast food'**
  String get diaryCatalogCFastfoodLabel;

  /// No description provided for @diaryCatalogCFastfoodPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu fast food?'**
  String get diaryCatalogCFastfoodPrompt;

  /// No description provided for @diaryCatalogCPizzaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pizza'**
  String get diaryCatalogCPizzaLabel;

  /// No description provided for @diaryCatalogCPizzaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu pizza?'**
  String get diaryCatalogCPizzaPrompt;

  /// No description provided for @diaryCatalogCProcLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem processados'**
  String get diaryCatalogCProcLabel;

  /// No description provided for @diaryCatalogCProcPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Evitou ultraprocessados?'**
  String get diaryCatalogCProcPrompt;

  /// No description provided for @diaryCatalogCSalgLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salgadinho'**
  String get diaryCatalogCSalgLabel;

  /// No description provided for @diaryCatalogCSalgPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu salgadinho ou biscoito recheado?'**
  String get diaryCatalogCSalgPrompt;

  /// No description provided for @diaryCatalogCFritoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fritura'**
  String get diaryCatalogCFritoLabel;

  /// No description provided for @diaryCatalogCFritoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu fritura?'**
  String get diaryCatalogCFritoPrompt;

  /// No description provided for @diaryCatalogCPastelLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pastel ou coxinha'**
  String get diaryCatalogCPastelLabel;

  /// No description provided for @diaryCatalogCPastelPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu pastel, coxinha ou salgado frito?'**
  String get diaryCatalogCPastelPrompt;

  /// No description provided for @diaryCatalogCChocoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Chocolate'**
  String get diaryCatalogCChocoLabel;

  /// No description provided for @diaryCatalogCChocoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu chocolate?'**
  String get diaryCatalogCChocoPrompt;

  /// No description provided for @diaryCatalogCSorveteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sorvete'**
  String get diaryCatalogCSorveteLabel;

  /// No description provided for @diaryCatalogCSorvetePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou sorvete?'**
  String get diaryCatalogCSorvetePrompt;

  /// No description provided for @diaryCatalogCBrigadeiroLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Brigadeiro ou bolo'**
  String get diaryCatalogCBrigadeiroLabel;

  /// No description provided for @diaryCatalogCBrigadeiroPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu brigadeiro ou bolo?'**
  String get diaryCatalogCBrigadeiroPrompt;

  /// No description provided for @diaryCatalogCFrutaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Frutas'**
  String get diaryCatalogCFrutaLabel;

  /// No description provided for @diaryCatalogCFrutaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu frutas?'**
  String get diaryCatalogCFrutaPrompt;

  /// No description provided for @diaryCatalogCVerduraLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salada e verduras'**
  String get diaryCatalogCVerduraLabel;

  /// No description provided for @diaryCatalogCVerduraPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu salada ou verduras?'**
  String get diaryCatalogCVerduraPrompt;

  /// No description provided for @diaryCatalogCLegumeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Legumes'**
  String get diaryCatalogCLegumeLabel;

  /// No description provided for @diaryCatalogCLegumePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu legumes?'**
  String get diaryCatalogCLegumePrompt;

  /// No description provided for @diaryCatalogCFibraLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fibras'**
  String get diaryCatalogCFibraLabel;

  /// No description provided for @diaryCatalogCFibraPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu fibras?'**
  String get diaryCatalogCFibraPrompt;

  /// No description provided for @diaryCatalogCFeijaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feijão'**
  String get diaryCatalogCFeijaoLabel;

  /// No description provided for @diaryCatalogCFeijaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu feijão?'**
  String get diaryCatalogCFeijaoPrompt;

  /// No description provided for @diaryCatalogCArrozLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Arroz integral'**
  String get diaryCatalogCArrozLabel;

  /// No description provided for @diaryCatalogCArrozPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu arroz integral?'**
  String get diaryCatalogCArrozPrompt;

  /// No description provided for @diaryCatalogCOvoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ovos'**
  String get diaryCatalogCOvoLabel;

  /// No description provided for @diaryCatalogCOvoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu ovos?'**
  String get diaryCatalogCOvoPrompt;

  /// No description provided for @diaryCatalogCCarnevLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carne vermelha'**
  String get diaryCatalogCCarnevLabel;

  /// No description provided for @diaryCatalogCCarnevPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu carne vermelha?'**
  String get diaryCatalogCCarnevPrompt;

  /// No description provided for @diaryCatalogCFrangoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Frango'**
  String get diaryCatalogCFrangoLabel;

  /// No description provided for @diaryCatalogCFrangoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu frango?'**
  String get diaryCatalogCFrangoPrompt;

  /// No description provided for @diaryCatalogCPeixeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Peixe'**
  String get diaryCatalogCPeixeLabel;

  /// No description provided for @diaryCatalogCPeixePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu peixe?'**
  String get diaryCatalogCPeixePrompt;

  /// No description provided for @diaryCatalogCEmbutLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Embutidos'**
  String get diaryCatalogCEmbutLabel;

  /// No description provided for @diaryCatalogCEmbutPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu presunto, salsicha ou linguiça?'**
  String get diaryCatalogCEmbutPrompt;

  /// No description provided for @diaryCatalogCChurrascoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Churrasco'**
  String get diaryCatalogCChurrascoLabel;

  /// No description provided for @diaryCatalogCChurrascoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu churrasco?'**
  String get diaryCatalogCChurrascoPrompt;

  /// No description provided for @diaryCatalogCFeijoadaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feijoada'**
  String get diaryCatalogCFeijoadaLabel;

  /// No description provided for @diaryCatalogCFeijoadaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu feijoada?'**
  String get diaryCatalogCFeijoadaPrompt;

  /// No description provided for @diaryCatalogCAcaiLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Açaí'**
  String get diaryCatalogCAcaiLabel;

  /// No description provided for @diaryCatalogCAcaiPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou açaí?'**
  String get diaryCatalogCAcaiPrompt;

  /// No description provided for @diaryCatalogCTapiocaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tapioca ou cuscuz'**
  String get diaryCatalogCTapiocaLabel;

  /// No description provided for @diaryCatalogCTapiocaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu tapioca ou cuscuz?'**
  String get diaryCatalogCTapiocaPrompt;

  /// No description provided for @diaryCatalogCPaoqueijoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pão de queijo'**
  String get diaryCatalogCPaoqueijoLabel;

  /// No description provided for @diaryCatalogCPaoqueijoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu pão de queijo?'**
  String get diaryCatalogCPaoqueijoPrompt;

  /// No description provided for @diaryCatalogCPaobrancoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pão branco'**
  String get diaryCatalogCPaobrancoLabel;

  /// No description provided for @diaryCatalogCPaobrancoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu pão francês ou pão branco?'**
  String get diaryCatalogCPaobrancoPrompt;

  /// No description provided for @diaryCatalogCMacarraoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Massa'**
  String get diaryCatalogCMacarraoLabel;

  /// No description provided for @diaryCatalogCMacarraoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu macarrão ou massa?'**
  String get diaryCatalogCMacarraoPrompt;

  /// No description provided for @diaryCatalogCLatLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem laticínios'**
  String get diaryCatalogCLatLabel;

  /// No description provided for @diaryCatalogCLatPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou sem leite e derivados?'**
  String get diaryCatalogCLatPrompt;

  /// No description provided for @diaryCatalogCGlutenLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem glúten'**
  String get diaryCatalogCGlutenLabel;

  /// No description provided for @diaryCatalogCGlutenPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou sem glúten?'**
  String get diaryCatalogCGlutenPrompt;

  /// No description provided for @diaryCatalogCVeganoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem carne'**
  String get diaryCatalogCVeganoLabel;

  /// No description provided for @diaryCatalogCVeganoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou sem carne no dia?'**
  String get diaryCatalogCVeganoPrompt;

  /// No description provided for @diaryCatalogCCarboLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pouco carboidrato'**
  String get diaryCatalogCCarboLabel;

  /// No description provided for @diaryCatalogCCarboPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu pouco carboidrato?'**
  String get diaryCatalogCCarboPrompt;

  /// No description provided for @diaryCatalogCApimentadaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comida apimentada'**
  String get diaryCatalogCApimentadaLabel;

  /// No description provided for @diaryCatalogCApimentadaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu comida apimentada?'**
  String get diaryCatalogCApimentadaPrompt;

  /// No description provided for @diaryCatalogCSalLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Muito sal'**
  String get diaryCatalogCSalLabel;

  /// No description provided for @diaryCatalogCSalPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu comida muito salgada?'**
  String get diaryCatalogCSalPrompt;

  /// No description provided for @diaryCatalogCAdocanteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adoçante'**
  String get diaryCatalogCAdocanteLabel;

  /// No description provided for @diaryCatalogCAdocantePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou adoçante?'**
  String get diaryCatalogCAdocantePrompt;

  /// No description provided for @diaryCatalogCProtcafeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Proteína no café'**
  String get diaryCatalogCProtcafeLabel;

  /// No description provided for @diaryCatalogCProtcafePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu proteína no café da manhã?'**
  String get diaryCatalogCProtcafePrompt;

  /// No description provided for @diaryCatalogCCarbonoiteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carboidrato à noite'**
  String get diaryCatalogCCarbonoiteLabel;

  /// No description provided for @diaryCatalogCCarbonoitePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu carboidrato no jantar?'**
  String get diaryCatalogCCarbonoitePrompt;

  /// No description provided for @diaryCatalogCJantarleveLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jantar leve'**
  String get diaryCatalogCJantarleveLabel;

  /// No description provided for @diaryCatalogCJantarlevePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jantou leve?'**
  String get diaryCatalogCJantarlevePrompt;

  /// No description provided for @diaryCatalogCAveiaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aveia'**
  String get diaryCatalogCAveiaLabel;

  /// No description provided for @diaryCatalogCAveiaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu aveia?'**
  String get diaryCatalogCAveiaPrompt;

  /// No description provided for @diaryCatalogCIogurteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Iogurte'**
  String get diaryCatalogCIogurteLabel;

  /// No description provided for @diaryCatalogCIogurtePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu iogurte?'**
  String get diaryCatalogCIogurtePrompt;

  /// No description provided for @diaryCatalogCQueijoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Queijo'**
  String get diaryCatalogCQueijoLabel;

  /// No description provided for @diaryCatalogCQueijoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu queijo?'**
  String get diaryCatalogCQueijoPrompt;

  /// No description provided for @diaryCatalogCCastanhaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Castanhas'**
  String get diaryCatalogCCastanhaLabel;

  /// No description provided for @diaryCatalogCCastanhaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu castanhas ou nozes?'**
  String get diaryCatalogCCastanhaPrompt;

  /// No description provided for @diaryCatalogCAbacateLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abacate'**
  String get diaryCatalogCAbacateLabel;

  /// No description provided for @diaryCatalogCAbacatePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu abacate?'**
  String get diaryCatalogCAbacatePrompt;

  /// No description provided for @diaryCatalogCTubercLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Batata-doce ou mandioca'**
  String get diaryCatalogCTubercLabel;

  /// No description provided for @diaryCatalogCTubercPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu batata-doce, mandioca ou inhame?'**
  String get diaryCatalogCTubercPrompt;

  /// No description provided for @diaryCatalogCSopaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sopa'**
  String get diaryCatalogCSopaLabel;

  /// No description provided for @diaryCatalogCSopaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou sopa?'**
  String get diaryCatalogCSopaPrompt;

  /// No description provided for @diaryCatalogCJaponesLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comida japonesa'**
  String get diaryCatalogCJaponesLabel;

  /// No description provided for @diaryCatalogCJaponesPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu comida japonesa?'**
  String get diaryCatalogCJaponesPrompt;

  /// No description provided for @diaryCatalogCHamburguerLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hambúrguer'**
  String get diaryCatalogCHamburguerLabel;

  /// No description provided for @diaryCatalogCHamburguerPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu hambúrguer?'**
  String get diaryCatalogCHamburguerPrompt;

  /// No description provided for @diaryCatalogCCongeladoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comida congelada'**
  String get diaryCatalogCCongeladoLabel;

  /// No description provided for @diaryCatalogCCongeladoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu comida pronta congelada?'**
  String get diaryCatalogCCongeladoPrompt;

  /// No description provided for @diaryCatalogCSobremesaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sobremesa'**
  String get diaryCatalogCSobremesaLabel;

  /// No description provided for @diaryCatalogCSobremesaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu sobremesa?'**
  String get diaryCatalogCSobremesaPrompt;

  /// No description provided for @diaryCatalogCRapidoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu rápido'**
  String get diaryCatalogCRapidoLabel;

  /// No description provided for @diaryCatalogCRapidoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu com pressa?'**
  String get diaryCatalogCRapidoPrompt;

  /// No description provided for @diaryCatalogCTela2Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu vendo tela'**
  String get diaryCatalogCTela2Label;

  /// No description provided for @diaryCatalogCTela2Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu assistindo TV ou celular?'**
  String get diaryCatalogCTela2Prompt;

  /// No description provided for @diaryCatalogCEmfamiliaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Refeição em família'**
  String get diaryCatalogCEmfamiliaLabel;

  /// No description provided for @diaryCatalogCEmfamiliaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comeu junto com a família?'**
  String get diaryCatalogCEmfamiliaPrompt;

  /// No description provided for @diaryCatalogCCozinhouLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cozinhou'**
  String get diaryCatalogCCozinhouLabel;

  /// No description provided for @diaryCatalogCCozinhouPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cozinhou a própria comida?'**
  String get diaryCatalogCCozinhouPrompt;

  /// No description provided for @diaryCatalogCLivreLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Refeição livre'**
  String get diaryCatalogCLivreLabel;

  /// No description provided for @diaryCatalogCLivrePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez uma refeição livre?'**
  String get diaryCatalogCLivrePrompt;

  /// No description provided for @diaryCatalogCFomeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou fome'**
  String get diaryCatalogCFomeLabel;

  /// No description provided for @diaryCatalogCFomePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou muitas horas sem comer?'**
  String get diaryCatalogCFomePrompt;

  /// No description provided for @diaryCatalogCCabecaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cabeça'**
  String get diaryCatalogCCabecaLabel;

  /// No description provided for @diaryCatalogCCabecaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como está sua cabeça?'**
  String get diaryCatalogCCabecaPrompt;

  /// No description provided for @diaryCatalogCDisposicaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Disposição'**
  String get diaryCatalogCDisposicaoLabel;

  /// No description provided for @diaryCatalogCDisposicaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como está sua disposição?'**
  String get diaryCatalogCDisposicaoPrompt;

  /// No description provided for @diaryCatalogCAnsLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ansiedade'**
  String get diaryCatalogCAnsLabel;

  /// No description provided for @diaryCatalogCAnsPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu nervoso ou ansioso?'**
  String get diaryCatalogCAnsPrompt;

  /// No description provided for @diaryCatalogCEstresLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estresse'**
  String get diaryCatalogCEstresLabel;

  /// No description provided for @diaryCatalogCEstresPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve um dia estressante?'**
  String get diaryCatalogCEstresPrompt;

  /// No description provided for @diaryCatalogCHumorLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bom humor'**
  String get diaryCatalogCHumorLabel;

  /// No description provided for @diaryCatalogCHumorPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve um dia de bom humor?'**
  String get diaryCatalogCHumorPrompt;

  /// No description provided for @diaryCatalogCIrritLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Irritação'**
  String get diaryCatalogCIrritLabel;

  /// No description provided for @diaryCatalogCIrritPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu irritado?'**
  String get diaryCatalogCIrritPrompt;

  /// No description provided for @diaryCatalogCTristeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tristeza'**
  String get diaryCatalogCTristeLabel;

  /// No description provided for @diaryCatalogCTristePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu triste?'**
  String get diaryCatalogCTristePrompt;

  /// No description provided for @diaryCatalogCDesanimoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Desânimo'**
  String get diaryCatalogCDesanimoLabel;

  /// No description provided for @diaryCatalogCDesanimoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu sem energia ou desanimado?'**
  String get diaryCatalogCDesanimoPrompt;

  /// No description provided for @diaryCatalogCMotivLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Motivação'**
  String get diaryCatalogCMotivLabel;

  /// No description provided for @diaryCatalogCMotivPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu motivado?'**
  String get diaryCatalogCMotivPrompt;

  /// No description provided for @diaryCatalogCFocoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foco'**
  String get diaryCatalogCFocoLabel;

  /// No description provided for @diaryCatalogCFocoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conseguiu se concentrar bem?'**
  String get diaryCatalogCFocoPrompt;

  /// No description provided for @diaryCatalogCProdLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Produtivo'**
  String get diaryCatalogCProdLabel;

  /// No description provided for @diaryCatalogCProdPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve um dia produtivo?'**
  String get diaryCatalogCProdPrompt;

  /// No description provided for @diaryCatalogCSobrecLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sobrecarga'**
  String get diaryCatalogCSobrecLabel;

  /// No description provided for @diaryCatalogCSobrecPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu sobrecarregado?'**
  String get diaryCatalogCSobrecPrompt;

  /// No description provided for @diaryCatalogCPreocLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preocupação'**
  String get diaryCatalogCPreocLabel;

  /// No description provided for @diaryCatalogCPreocPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou preocupado com algo?'**
  String get diaryCatalogCPreocPrompt;

  /// No description provided for @diaryCatalogCDinheiroLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dinheiro'**
  String get diaryCatalogCDinheiroLabel;

  /// No description provided for @diaryCatalogCDinheiroPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se preocupou com dinheiro?'**
  String get diaryCatalogCDinheiroPrompt;

  /// No description provided for @diaryCatalogCConflitoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Discussão'**
  String get diaryCatalogCConflitoLabel;

  /// No description provided for @diaryCatalogCConflitoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve alguma discussão?'**
  String get diaryCatalogCConflitoPrompt;

  /// No description provided for @diaryCatalogCSozinhoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Solidão'**
  String get diaryCatalogCSozinhoLabel;

  /// No description provided for @diaryCatalogCSozinhoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu sozinho?'**
  String get diaryCatalogCSozinhoPrompt;

  /// No description provided for @diaryCatalogCRisadaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Risadas'**
  String get diaryCatalogCRisadaLabel;

  /// No description provided for @diaryCatalogCRisadaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deu boas risadas?'**
  String get diaryCatalogCRisadaPrompt;

  /// No description provided for @diaryCatalogCGratLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gratidão'**
  String get diaryCatalogCGratLabel;

  /// No description provided for @diaryCatalogCGratPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pensou ou escreveu sobre gratidão?'**
  String get diaryCatalogCGratPrompt;

  /// No description provided for @diaryCatalogCMeditLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Meditação'**
  String get diaryCatalogCMeditLabel;

  /// No description provided for @diaryCatalogCMeditPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Meditou?'**
  String get diaryCatalogCMeditPrompt;

  /// No description provided for @diaryCatalogCTerapiaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Terapia'**
  String get diaryCatalogCTerapiaLabel;

  /// No description provided for @diaryCatalogCTerapiaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve sessão de terapia?'**
  String get diaryCatalogCTerapiaPrompt;

  /// No description provided for @diaryCatalogCFeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Oração ou fé'**
  String get diaryCatalogCFeLabel;

  /// No description provided for @diaryCatalogCFePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Rezou, orou ou foi à igreja?'**
  String get diaryCatalogCFePrompt;

  /// No description provided for @diaryCatalogCEscritaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreveu'**
  String get diaryCatalogCEscritaLabel;

  /// No description provided for @diaryCatalogCEscritaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreveu num diário?'**
  String get diaryCatalogCEscritaPrompt;

  /// No description provided for @diaryCatalogCLeituraLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Leitura'**
  String get diaryCatalogCLeituraLabel;

  /// No description provided for @diaryCatalogCLeituraPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Leu um livro?'**
  String get diaryCatalogCLeituraPrompt;

  /// No description provided for @diaryCatalogCHobbyLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hobby'**
  String get diaryCatalogCHobbyLabel;

  /// No description provided for @diaryCatalogCHobbyPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez algo que gosta só por prazer?'**
  String get diaryCatalogCHobbyPrompt;

  /// No description provided for @diaryCatalogCMusicaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Música'**
  String get diaryCatalogCMusicaLabel;

  /// No description provided for @diaryCatalogCMusicaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ouviu ou tocou música?'**
  String get diaryCatalogCMusicaPrompt;

  /// No description provided for @diaryCatalogCSocialLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Amigos'**
  String get diaryCatalogCSocialLabel;

  /// No description provided for @diaryCatalogCSocialPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Encontrou amigos?'**
  String get diaryCatalogCSocialPrompt;

  /// No description provided for @diaryCatalogCFamiliaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Família'**
  String get diaryCatalogCFamiliaLabel;

  /// No description provided for @diaryCatalogCFamiliaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou tempo com a família?'**
  String get diaryCatalogCFamiliaPrompt;

  /// No description provided for @diaryCatalogCNaturezaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Natureza'**
  String get diaryCatalogCNaturezaLabel;

  /// No description provided for @diaryCatalogCNaturezaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou tempo na natureza?'**
  String get diaryCatalogCNaturezaPrompt;

  /// No description provided for @diaryCatalogCRedesLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Redes sociais'**
  String get diaryCatalogCRedesLabel;

  /// No description provided for @diaryCatalogCRedesPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou muito tempo nas redes sociais?'**
  String get diaryCatalogCRedesPrompt;

  /// No description provided for @diaryCatalogCNoticiasLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Notícias'**
  String get diaryCatalogCNoticiasLabel;

  /// No description provided for @diaryCatalogCNoticiasPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Consumiu muita notícia?'**
  String get diaryCatalogCNoticiasPrompt;

  /// No description provided for @diaryCatalogCDesconectLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Desconectou'**
  String get diaryCatalogCDesconectLabel;

  /// No description provided for @diaryCatalogCDesconectPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou um tempo longe do celular?'**
  String get diaryCatalogCDesconectPrompt;

  /// No description provided for @diaryCatalogCTedioLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tédio'**
  String get diaryCatalogCTedioLabel;

  /// No description provided for @diaryCatalogCTedioPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu tédio?'**
  String get diaryCatalogCTedioPrompt;

  /// No description provided for @diaryCatalogCAceleradoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pensamento acelerado'**
  String get diaryCatalogCAceleradoLabel;

  /// No description provided for @diaryCatalogCAceleradoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou com a cabeça a mil?'**
  String get diaryCatalogCAceleradoPrompt;

  /// No description provided for @diaryCatalogCPanicoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crise de ansiedade'**
  String get diaryCatalogCPanicoLabel;

  /// No description provided for @diaryCatalogCPanicoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve crise de ansiedade ou pânico?'**
  String get diaryCatalogCPanicoPrompt;

  /// No description provided for @diaryCatalogCLutoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Luto'**
  String get diaryCatalogCLutoLabel;

  /// No description provided for @diaryCatalogCLutoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Está passando por um luto?'**
  String get diaryCatalogCLutoPrompt;

  /// No description provided for @diaryCatalogCAutoestLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Autoestima boa'**
  String get diaryCatalogCAutoestLabel;

  /// No description provided for @diaryCatalogCAutoestPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu bem consigo mesmo?'**
  String get diaryCatalogCAutoestPrompt;

  /// No description provided for @diaryCatalogCArlivreLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ar livre'**
  String get diaryCatalogCArlivreLabel;

  /// No description provided for @diaryCatalogCArlivrePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou tempo ao ar livre?'**
  String get diaryCatalogCArlivrePrompt;

  /// No description provided for @diaryCatalogCVoluntLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajudou alguém'**
  String get diaryCatalogCVoluntLabel;

  /// No description provided for @diaryCatalogCVoluntPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez algo por alguém hoje?'**
  String get diaryCatalogCVoluntPrompt;

  /// No description provided for @diaryCatalogCAprendeuLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aprendeu algo'**
  String get diaryCatalogCAprendeuLabel;

  /// No description provided for @diaryCatalogCAprendeuPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aprendeu algo novo?'**
  String get diaryCatalogCAprendeuPrompt;

  /// No description provided for @diaryCatalogCConversaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conversa importante'**
  String get diaryCatalogCConversaLabel;

  /// No description provided for @diaryCatalogCConversaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve uma conversa difícil ou importante?'**
  String get diaryCatalogCConversaPrompt;

  /// No description provided for @diaryCatalogCSemtempoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem tempo para si'**
  String get diaryCatalogCSemtempoLabel;

  /// No description provided for @diaryCatalogCSemtempoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou sem nenhum tempo para você?'**
  String get diaryCatalogCSemtempoPrompt;

  /// No description provided for @diaryCatalogCCalmaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dia tranquilo'**
  String get diaryCatalogCCalmaLabel;

  /// No description provided for @diaryCatalogCCalmaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve um dia tranquilo?'**
  String get diaryCatalogCCalmaPrompt;

  /// No description provided for @diaryCatalogCHomeoffLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Home office'**
  String get diaryCatalogCHomeoffLabel;

  /// No description provided for @diaryCatalogCHomeoffPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trabalhou de casa?'**
  String get diaryCatalogCHomeoffPrompt;

  /// No description provided for @diaryCatalogCPresencialLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trabalho presencial'**
  String get diaryCatalogCPresencialLabel;

  /// No description provided for @diaryCatalogCPresencialPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trabalhou no escritório?'**
  String get diaryCatalogCPresencialPrompt;

  /// No description provided for @diaryCatalogCLongoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Expediente longo'**
  String get diaryCatalogCLongoLabel;

  /// No description provided for @diaryCatalogCLongoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trabalhou mais de 10 horas?'**
  String get diaryCatalogCLongoPrompt;

  /// No description provided for @diaryCatalogCReuniaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Reunião à noite'**
  String get diaryCatalogCReuniaoLabel;

  /// No description provided for @diaryCatalogCReuniaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trabalhou ou fez reunião à noite?'**
  String get diaryCatalogCReuniaoPrompt;

  /// No description provided for @diaryCatalogCPlantaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Plantão'**
  String get diaryCatalogCPlantaoLabel;

  /// No description provided for @diaryCatalogCPlantaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trabalhou de madrugada ou de plantão?'**
  String get diaryCatalogCPlantaoPrompt;

  /// No description provided for @diaryCatalogCTransitoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trânsito'**
  String get diaryCatalogCTransitoLabel;

  /// No description provided for @diaryCatalogCTransitoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pegou muito trânsito?'**
  String get diaryCatalogCTransitoPrompt;

  /// No description provided for @diaryCatalogCDirigiuLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dirigiu muito'**
  String get diaryCatalogCDirigiuLabel;

  /// No description provided for @diaryCatalogCDirigiuPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dirigiu por mais de 1 hora?'**
  String get diaryCatalogCDirigiuPrompt;

  /// No description provided for @diaryCatalogCOnibusLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Transporte público'**
  String get diaryCatalogCOnibusLabel;

  /// No description provided for @diaryCatalogCOnibusPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pegou ônibus ou metrô lotado?'**
  String get diaryCatalogCOnibusPrompt;

  /// No description provided for @diaryCatalogCSentadoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Muito sentado'**
  String get diaryCatalogCSentadoLabel;

  /// No description provided for @diaryCatalogCSentadoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou o dia muito sentado?'**
  String get diaryCatalogCSentadoPrompt;

  /// No description provided for @diaryCatalogCEmpeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Em pé'**
  String get diaryCatalogCEmpeLabel;

  /// No description provided for @diaryCatalogCEmpePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou muito tempo em pé?'**
  String get diaryCatalogCEmpePrompt;

  /// No description provided for @diaryCatalogCPassosLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caminhada'**
  String get diaryCatalogCPassosLabel;

  /// No description provided for @diaryCatalogCPassosPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caminhou mais de 30 minutos?'**
  String get diaryCatalogCPassosPrompt;

  /// No description provided for @diaryCatalogCEscadasLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escadas'**
  String get diaryCatalogCEscadasLabel;

  /// No description provided for @diaryCatalogCEscadasPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Subiu escadas?'**
  String get diaryCatalogCEscadasPrompt;

  /// No description provided for @diaryCatalogCCasa2Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tarefas de casa'**
  String get diaryCatalogCCasa2Label;

  /// No description provided for @diaryCatalogCCasa2Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez faxina ou tarefas pesadas de casa?'**
  String get diaryCatalogCCasa2Prompt;

  /// No description provided for @diaryCatalogCFilhosLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cuidou de criança'**
  String get diaryCatalogCFilhosLabel;

  /// No description provided for @diaryCatalogCFilhosPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cuidou de criança o dia todo?'**
  String get diaryCatalogCFilhosPrompt;

  /// No description provided for @diaryCatalogCPetsLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pet'**
  String get diaryCatalogCPetsLabel;

  /// No description provided for @diaryCatalogCPetsPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passeou ou brincou com o pet?'**
  String get diaryCatalogCPetsPrompt;

  /// No description provided for @diaryCatalogCViagemLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Viagem'**
  String get diaryCatalogCViagemLabel;

  /// No description provided for @diaryCatalogCViagemPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Viajou?'**
  String get diaryCatalogCViagemPrompt;

  /// No description provided for @diaryCatalogCVooLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Voo'**
  String get diaryCatalogCVooLabel;

  /// No description provided for @diaryCatalogCVooPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pegou avião?'**
  String get diaryCatalogCVooPrompt;

  /// No description provided for @diaryCatalogCFusoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fuso horário'**
  String get diaryCatalogCFusoLabel;

  /// No description provided for @diaryCatalogCFusoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mudou de fuso horário?'**
  String get diaryCatalogCFusoPrompt;

  /// No description provided for @diaryCatalogCPraiaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Praia'**
  String get diaryCatalogCPraiaLabel;

  /// No description provided for @diaryCatalogCPraiaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foi à praia?'**
  String get diaryCatalogCPraiaPrompt;

  /// No description provided for @diaryCatalogCPiscinaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Piscina'**
  String get diaryCatalogCPiscinaLabel;

  /// No description provided for @diaryCatalogCPiscinaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrou na piscina?'**
  String get diaryCatalogCPiscinaPrompt;

  /// No description provided for @diaryCatalogCCalorLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Calor forte'**
  String get diaryCatalogCCalorLabel;

  /// No description provided for @diaryCatalogCCalorPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou muito tempo no calor?'**
  String get diaryCatalogCCalorPrompt;

  /// No description provided for @diaryCatalogCFrioLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Frio'**
  String get diaryCatalogCFrioLabel;

  /// No description provided for @diaryCatalogCFrioPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou frio?'**
  String get diaryCatalogCFrioPrompt;

  /// No description provided for @diaryCatalogCFestaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Festa ou balada'**
  String get diaryCatalogCFestaLabel;

  /// No description provided for @diaryCatalogCFestaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Saiu à noite?'**
  String get diaryCatalogCFestaPrompt;

  /// No description provided for @diaryCatalogCShowLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Show'**
  String get diaryCatalogCShowLabel;

  /// No description provided for @diaryCatalogCShowPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foi a um show ou evento?'**
  String get diaryCatalogCShowPrompt;

  /// No description provided for @diaryCatalogCFutebolLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assistiu ao jogo'**
  String get diaryCatalogCFutebolLabel;

  /// No description provided for @diaryCatalogCFutebolPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assistiu a jogo de futebol?'**
  String get diaryCatalogCFutebolPrompt;

  /// No description provided for @diaryCatalogCPeladaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pelada'**
  String get diaryCatalogCPeladaLabel;

  /// No description provided for @diaryCatalogCPeladaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jogou bola com os amigos?'**
  String get diaryCatalogCPeladaPrompt;

  /// No description provided for @diaryCatalogCGamesLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Videogame'**
  String get diaryCatalogCGamesLabel;

  /// No description provided for @diaryCatalogCGamesPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jogou videogame?'**
  String get diaryCatalogCGamesPrompt;

  /// No description provided for @diaryCatalogCSerieLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Maratonou série'**
  String get diaryCatalogCSerieLabel;

  /// No description provided for @diaryCatalogCSeriePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou horas vendo série?'**
  String get diaryCatalogCSeriePrompt;

  /// No description provided for @diaryCatalogCSexoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atividade sexual'**
  String get diaryCatalogCSexoLabel;

  /// No description provided for @diaryCatalogCSexoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve atividade sexual?'**
  String get diaryCatalogCSexoPrompt;

  /// No description provided for @diaryCatalogCCigarLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cigarro'**
  String get diaryCatalogCCigarLabel;

  /// No description provided for @diaryCatalogCCigarPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fumou?'**
  String get diaryCatalogCCigarPrompt;

  /// No description provided for @diaryCatalogCVapeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vape'**
  String get diaryCatalogCVapeLabel;

  /// No description provided for @diaryCatalogCVapePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou vape ou pod?'**
  String get diaryCatalogCVapePrompt;

  /// No description provided for @diaryCatalogCNarguileLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Narguilé'**
  String get diaryCatalogCNarguileLabel;

  /// No description provided for @diaryCatalogCNarguilePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fumou narguilé?'**
  String get diaryCatalogCNarguilePrompt;

  /// No description provided for @diaryCatalogCCanabLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cannabis'**
  String get diaryCatalogCCanabLabel;

  /// No description provided for @diaryCatalogCCanabPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou cannabis?'**
  String get diaryCatalogCCanabPrompt;

  /// No description provided for @diaryCatalogCAcordoucedoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acordou cedo'**
  String get diaryCatalogCAcordoucedoLabel;

  /// No description provided for @diaryCatalogCAcordoucedoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acordou antes das 6h?'**
  String get diaryCatalogCAcordoucedoPrompt;

  /// No description provided for @diaryCatalogCDormiuforaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dormiu fora de casa'**
  String get diaryCatalogCDormiuforaLabel;

  /// No description provided for @diaryCatalogCDormiuforaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dormiu fora de casa?'**
  String get diaryCatalogCDormiuforaPrompt;

  /// No description provided for @diaryCatalogCViagemtrabLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Viagem a trabalho'**
  String get diaryCatalogCViagemtrabLabel;

  /// No description provided for @diaryCatalogCViagemtrabPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Viajou a trabalho?'**
  String get diaryCatalogCViagemtrabPrompt;

  /// No description provided for @diaryCatalogCPrazoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Prazo ou prova'**
  String get diaryCatalogCPrazoLabel;

  /// No description provided for @diaryCatalogCPrazoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve prazo, prova ou entrega importante?'**
  String get diaryCatalogCPrazoPrompt;

  /// No description provided for @diaryCatalogCPublicoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Falou em público'**
  String get diaryCatalogCPublicoLabel;

  /// No description provided for @diaryCatalogCPublicoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez apresentação em público?'**
  String get diaryCatalogCPublicoPrompt;

  /// No description provided for @diaryCatalogCCuidadorLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cuidou de alguém'**
  String get diaryCatalogCCuidadorLabel;

  /// No description provided for @diaryCatalogCCuidadorPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cuidou de um familiar doente ou idoso?'**
  String get diaryCatalogCCuidadorPrompt;

  /// No description provided for @diaryCatalogCMudancaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mudança'**
  String get diaryCatalogCMudancaLabel;

  /// No description provided for @diaryCatalogCMudancaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Está de mudança ou em obra?'**
  String get diaryCatalogCMudancaPrompt;

  /// No description provided for @diaryCatalogCJardimLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jardinagem'**
  String get diaryCatalogCJardimLabel;

  /// No description provided for @diaryCatalogCJardimPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mexeu com plantas?'**
  String get diaryCatalogCJardimPrompt;

  /// No description provided for @diaryCatalogCChuvaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dia de chuva'**
  String get diaryCatalogCChuvaLabel;

  /// No description provided for @diaryCatalogCChuvaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Choveu o dia todo?'**
  String get diaryCatalogCChuvaPrompt;

  /// No description provided for @diaryCatalogCSecoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tempo seco'**
  String get diaryCatalogCSecoLabel;

  /// No description provided for @diaryCatalogCSecoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'O ar estava muito seco?'**
  String get diaryCatalogCSecoPrompt;

  /// No description provided for @diaryCatalogCFumacaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Poluição ou fumaça'**
  String get diaryCatalogCFumacaLabel;

  /// No description provided for @diaryCatalogCFumacaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou exposto a poluição ou fumaça?'**
  String get diaryCatalogCFumacaPrompt;

  /// No description provided for @diaryCatalogCFolgaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dia de folga'**
  String get diaryCatalogCFolgaLabel;

  /// No description provided for @diaryCatalogCFolgaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foi um dia de folga?'**
  String get diaryCatalogCFolgaPrompt;

  /// No description provided for @diaryCatalogCAcordouLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como acordou'**
  String get diaryCatalogCAcordouLabel;

  /// No description provided for @diaryCatalogCAcordouPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como você acordou?'**
  String get diaryCatalogCAcordouPrompt;

  /// No description provided for @diaryCatalogCAlongLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alongamento'**
  String get diaryCatalogCAlongLabel;

  /// No description provided for @diaryCatalogCAlongPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alongou?'**
  String get diaryCatalogCAlongPrompt;

  /// No description provided for @diaryCatalogCMobilLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mobilidade'**
  String get diaryCatalogCMobilLabel;

  /// No description provided for @diaryCatalogCMobilPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez mobilidade?'**
  String get diaryCatalogCMobilPrompt;

  /// No description provided for @diaryCatalogCSaunaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sauna'**
  String get diaryCatalogCSaunaLabel;

  /// No description provided for @diaryCatalogCSaunaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez sauna?'**
  String get diaryCatalogCSaunaPrompt;

  /// No description provided for @diaryCatalogCBanhoqLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Banho quente'**
  String get diaryCatalogCBanhoqLabel;

  /// No description provided for @diaryCatalogCBanhoqPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou banho quente antes de dormir?'**
  String get diaryCatalogCBanhoqPrompt;

  /// No description provided for @diaryCatalogCMassaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Massagem'**
  String get diaryCatalogCMassaLabel;

  /// No description provided for @diaryCatalogCMassaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez massagem?'**
  String get diaryCatalogCMassaPrompt;

  /// No description provided for @diaryCatalogCRoloLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Rolo'**
  String get diaryCatalogCRoloLabel;

  /// No description provided for @diaryCatalogCRoloPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou rolo de liberação?'**
  String get diaryCatalogCRoloPrompt;

  /// No description provided for @diaryCatalogCCompressLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compressão'**
  String get diaryCatalogCCompressLabel;

  /// No description provided for @diaryCatalogCCompressPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou botas de compressão?'**
  String get diaryCatalogCCompressPrompt;

  /// No description provided for @diaryCatalogCFisioLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fisioterapia'**
  String get diaryCatalogCFisioLabel;

  /// No description provided for @diaryCatalogCFisioPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve fisioterapia?'**
  String get diaryCatalogCFisioPrompt;

  /// No description provided for @diaryCatalogCQuiroLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quiropraxia'**
  String get diaryCatalogCQuiroLabel;

  /// No description provided for @diaryCatalogCQuiroPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve quiropraxia ou osteopatia?'**
  String get diaryCatalogCQuiroPrompt;

  /// No description provided for @diaryCatalogCAcupLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acupuntura'**
  String get diaryCatalogCAcupLabel;

  /// No description provided for @diaryCatalogCAcupPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez acupuntura?'**
  String get diaryCatalogCAcupPrompt;

  /// No description provided for @diaryCatalogCCochiloLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cochilo'**
  String get diaryCatalogCCochiloLabel;

  /// No description provided for @diaryCatalogCCochiloPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cochilou?'**
  String get diaryCatalogCCochiloPrompt;

  /// No description provided for @diaryCatalogCDescansoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dia de descanso'**
  String get diaryCatalogCDescansoLabel;

  /// No description provided for @diaryCatalogCDescansoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foi um dia de descanso?'**
  String get diaryCatalogCDescansoPrompt;

  /// No description provided for @diaryCatalogCYogaleveLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Yoga leve'**
  String get diaryCatalogCYogaleveLabel;

  /// No description provided for @diaryCatalogCYogalevePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez yoga restaurativa?'**
  String get diaryCatalogCYogalevePrompt;

  /// No description provided for @diaryCatalogCPescocoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Postura'**
  String get diaryCatalogCPescocoLabel;

  /// No description provided for @diaryCatalogCPescocoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cuidou da postura no trabalho?'**
  String get diaryCatalogCPescocoPrompt;

  /// No description provided for @diaryCatalogCBanheiraLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Banheira de gelo'**
  String get diaryCatalogCBanheiraLabel;

  /// No description provided for @diaryCatalogCBanheiraPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrou na banheira de gelo?'**
  String get diaryCatalogCBanheiraPrompt;

  /// No description provided for @diaryCatalogCCrioLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crioterapia'**
  String get diaryCatalogCCrioLabel;

  /// No description provided for @diaryCatalogCCrioPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez crioterapia de corpo inteiro?'**
  String get diaryCatalogCCrioPrompt;

  /// No description provided for @diaryCatalogCContrasteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Banho de contraste'**
  String get diaryCatalogCContrasteLabel;

  /// No description provided for @diaryCatalogCContrastePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alternou água quente e fria?'**
  String get diaryCatalogCContrastePrompt;

  /// No description provided for @diaryCatalogCOfuroLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Banho de imersão'**
  String get diaryCatalogCOfuroLabel;

  /// No description provided for @diaryCatalogCOfuroPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou banho de imersão ou ofurô?'**
  String get diaryCatalogCOfuroPrompt;

  /// No description provided for @diaryCatalogCPistolaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pistola de massagem'**
  String get diaryCatalogCPistolaLabel;

  /// No description provided for @diaryCatalogCPistolaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou pistola de massagem?'**
  String get diaryCatalogCPistolaPrompt;

  /// No description provided for @diaryCatalogCDrenagemLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Drenagem linfática'**
  String get diaryCatalogCDrenagemLabel;

  /// No description provided for @diaryCatalogCDrenagemPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez drenagem linfática?'**
  String get diaryCatalogCDrenagemPrompt;

  /// No description provided for @diaryCatalogCLuzvermLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Luz vermelha'**
  String get diaryCatalogCLuzvermLabel;

  /// No description provided for @diaryCatalogCLuzvermPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez terapia de luz vermelha?'**
  String get diaryCatalogCLuzvermPrompt;

  /// No description provided for @diaryCatalogCHiperbLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Câmara hiperbárica'**
  String get diaryCatalogCHiperbLabel;

  /// No description provided for @diaryCatalogCHiperbPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez sessão na câmara hiperbárica?'**
  String get diaryCatalogCHiperbPrompt;

  /// No description provided for @diaryCatalogCAlongnoiteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alongou antes de dormir'**
  String get diaryCatalogCAlongnoiteLabel;

  /// No description provided for @diaryCatalogCAlongnoitePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alongou antes de dormir?'**
  String get diaryCatalogCAlongnoitePrompt;

  /// No description provided for @diaryCatalogCPernasLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pernas para cima'**
  String get diaryCatalogCPernasLabel;

  /// No description provided for @diaryCatalogCPernasPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou com as pernas para cima?'**
  String get diaryCatalogCPernasPrompt;

  /// No description provided for @diaryCatalogCBolinhaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bolinha de liberação'**
  String get diaryCatalogCBolinhaLabel;

  /// No description provided for @diaryCatalogCBolinhaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou bolinha para soltar o músculo?'**
  String get diaryCatalogCBolinhaPrompt;

  /// No description provided for @diaryCatalogCSolLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sol da manhã'**
  String get diaryCatalogCSolLabel;

  /// No description provided for @diaryCatalogCSolPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pegou sol pela manhã?'**
  String get diaryCatalogCSolPrompt;

  /// No description provided for @diaryCatalogCLuzLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Luz forte à noite'**
  String get diaryCatalogCLuzLabel;

  /// No description provided for @diaryCatalogCLuzPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou em luz forte depois das 21h?'**
  String get diaryCatalogCLuzPrompt;

  /// No description provided for @diaryCatalogCTelaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tela na cama'**
  String get diaryCatalogCTelaLabel;

  /// No description provided for @diaryCatalogCTelaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou celular ou TV na cama?'**
  String get diaryCatalogCTelaPrompt;

  /// No description provided for @diaryCatalogCOculosLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Óculos bloqueador'**
  String get diaryCatalogCOculosLabel;

  /// No description provided for @diaryCatalogCOculosPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou óculos contra luz azul?'**
  String get diaryCatalogCOculosPrompt;

  /// No description provided for @diaryCatalogCQuartoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quarto escuro'**
  String get diaryCatalogCQuartoLabel;

  /// No description provided for @diaryCatalogCQuartoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dormiu em quarto escuro?'**
  String get diaryCatalogCQuartoPrompt;

  /// No description provided for @diaryCatalogCFrescoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quarto fresco'**
  String get diaryCatalogCFrescoLabel;

  /// No description provided for @diaryCatalogCFrescoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dormiu em quarto fresco?'**
  String get diaryCatalogCFrescoPrompt;

  /// No description provided for @diaryCatalogCArcondLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ar-condicionado'**
  String get diaryCatalogCArcondLabel;

  /// No description provided for @diaryCatalogCArcondPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dormiu com ar-condicionado?'**
  String get diaryCatalogCArcondPrompt;

  /// No description provided for @diaryCatalogCVentilLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ventilador'**
  String get diaryCatalogCVentilLabel;

  /// No description provided for @diaryCatalogCVentilPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dormiu com ventilador?'**
  String get diaryCatalogCVentilPrompt;

  /// No description provided for @diaryCatalogCTampaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tampão ou máscara'**
  String get diaryCatalogCTampaoLabel;

  /// No description provided for @diaryCatalogCTampaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou tampão de ouvido ou máscara?'**
  String get diaryCatalogCTampaoPrompt;

  /// No description provided for @diaryCatalogCLerCamaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Leu antes de dormir'**
  String get diaryCatalogCLerCamaLabel;

  /// No description provided for @diaryCatalogCLerCamaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Leu antes de dormir?'**
  String get diaryCatalogCLerCamaPrompt;

  /// No description provided for @diaryCatalogCDividiuLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dividiu a cama'**
  String get diaryCatalogCDividiuLabel;

  /// No description provided for @diaryCatalogCDividiuPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dividiu a cama com alguém?'**
  String get diaryCatalogCDividiuPrompt;

  /// No description provided for @diaryCatalogCRoncoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ronco do parceiro'**
  String get diaryCatalogCRoncoLabel;

  /// No description provided for @diaryCatalogCRoncoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'O ronco de alguém atrapalhou?'**
  String get diaryCatalogCRoncoPrompt;

  /// No description provided for @diaryCatalogCPetcamaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pet na cama'**
  String get diaryCatalogCPetcamaLabel;

  /// No description provided for @diaryCatalogCPetcamaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dormiu com o pet?'**
  String get diaryCatalogCPetcamaPrompt;

  /// No description provided for @diaryCatalogCFilhoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criança acordou'**
  String get diaryCatalogCFilhoLabel;

  /// No description provided for @diaryCatalogCFilhoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foi acordado por criança?'**
  String get diaryCatalogCFilhoPrompt;

  /// No description provided for @diaryCatalogCBarulhoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Barulho'**
  String get diaryCatalogCBarulhoLabel;

  /// No description provided for @diaryCatalogCBarulhoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve barulho à noite?'**
  String get diaryCatalogCBarulhoPrompt;

  /// No description provided for @diaryCatalogCCalornoiteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Calor à noite'**
  String get diaryCatalogCCalornoiteLabel;

  /// No description provided for @diaryCatalogCCalornoitePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou calor dormindo?'**
  String get diaryCatalogCCalornoitePrompt;

  /// No description provided for @diaryCatalogCHorarioLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mesmo horário'**
  String get diaryCatalogCHorarioLabel;

  /// No description provided for @diaryCatalogCHorarioPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deitou no horário de sempre?'**
  String get diaryCatalogCHorarioPrompt;

  /// No description provided for @diaryCatalogCTardouLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deitou tarde'**
  String get diaryCatalogCTardouLabel;

  /// No description provided for @diaryCatalogCTardouPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deitou depois da meia-noite?'**
  String get diaryCatalogCTardouPrompt;

  /// No description provided for @diaryCatalogCDespertLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Despertador'**
  String get diaryCatalogCDespertLabel;

  /// No description provided for @diaryCatalogCDespertPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acordou com despertador?'**
  String get diaryCatalogCDespertPrompt;

  /// No description provided for @diaryCatalogCSonecaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Soneca'**
  String get diaryCatalogCSonecaLabel;

  /// No description provided for @diaryCatalogCSonecaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Apertou soneca no despertador?'**
  String get diaryCatalogCSonecaPrompt;

  /// No description provided for @diaryCatalogCMadrugadaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acordou de madrugada'**
  String get diaryCatalogCMadrugadaLabel;

  /// No description provided for @diaryCatalogCMadrugadaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acordou de madrugada e demorou a dormir?'**
  String get diaryCatalogCMadrugadaPrompt;

  /// No description provided for @diaryCatalogCPesadeloLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sonhos agitados'**
  String get diaryCatalogCPesadeloLabel;

  /// No description provided for @diaryCatalogCPesadeloPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve pesadelos ou sonhos agitados?'**
  String get diaryCatalogCPesadeloPrompt;

  /// No description provided for @diaryCatalogCBanhonoiteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Banho antes de dormir'**
  String get diaryCatalogCBanhonoiteLabel;

  /// No description provided for @diaryCatalogCBanhonoitePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou banho antes de dormir?'**
  String get diaryCatalogCBanhonoitePrompt;

  /// No description provided for @diaryCatalogCRotinaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Rotina de sono'**
  String get diaryCatalogCRotinaLabel;

  /// No description provided for @diaryCatalogCRotinaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez a sua rotina antes de dormir?'**
  String get diaryCatalogCRotinaPrompt;

  /// No description provided for @diaryCatalogCRuidoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ruído branco'**
  String get diaryCatalogCRuidoLabel;

  /// No description provided for @diaryCatalogCRuidoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dormiu com ruído branco?'**
  String get diaryCatalogCRuidoPrompt;

  /// No description provided for @diaryCatalogCMusicadormLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Música para dormir'**
  String get diaryCatalogCMusicadormLabel;

  /// No description provided for @diaryCatalogCMusicadormPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ouviu música para dormir?'**
  String get diaryCatalogCMusicadormPrompt;

  /// No description provided for @diaryCatalogCCobertorLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cobertor pesado'**
  String get diaryCatalogCCobertorLabel;

  /// No description provided for @diaryCatalogCCobertorPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou cobertor pesado?'**
  String get diaryCatalogCCobertorPrompt;

  /// No description provided for @diaryCatalogCFitabocaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fita na boca'**
  String get diaryCatalogCFitabocaLabel;

  /// No description provided for @diaryCatalogCFitabocaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou fita na boca para dormir?'**
  String get diaryCatalogCFitabocaPrompt;

  /// No description provided for @diaryCatalogCSofaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dormiu no sofá'**
  String get diaryCatalogCSofaLabel;

  /// No description provided for @diaryCatalogCSofaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pegou no sono no sofá?'**
  String get diaryCatalogCSofaPrompt;

  /// No description provided for @diaryCatalogCCelmadrLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Celular de madrugada'**
  String get diaryCatalogCCelmadrLabel;

  /// No description provided for @diaryCatalogCCelmadrPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Olhou o celular de madrugada?'**
  String get diaryCatalogCCelmadrPrompt;

  /// No description provided for @diaryCatalogCBanheiroLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Levantou para o banheiro'**
  String get diaryCatalogCBanheiroLabel;

  /// No description provided for @diaryCatalogCBanheiroPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Levantou para ir ao banheiro à noite?'**
  String get diaryCatalogCBanheiroPrompt;

  /// No description provided for @diaryCatalogCCochilotardeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cochilo depois das 16h'**
  String get diaryCatalogCCochilotardeLabel;

  /// No description provided for @diaryCatalogCCochilotardePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cochilou depois das 16h?'**
  String get diaryCatalogCCochilotardePrompt;

  /// No description provided for @diaryCatalogCDorLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor de cabeça'**
  String get diaryCatalogCDorLabel;

  /// No description provided for @diaryCatalogCDorPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu dor de cabeça?'**
  String get diaryCatalogCDorPrompt;

  /// No description provided for @diaryCatalogCEnxaquecaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enxaqueca'**
  String get diaryCatalogCEnxaquecaLabel;

  /// No description provided for @diaryCatalogCEnxaquecaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve enxaqueca?'**
  String get diaryCatalogCEnxaquecaPrompt;

  /// No description provided for @diaryCatalogCDoenteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Doente'**
  String get diaryCatalogCDoenteLabel;

  /// No description provided for @diaryCatalogCDoentePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu doente?'**
  String get diaryCatalogCDoentePrompt;

  /// No description provided for @diaryCatalogCGripeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gripe ou resfriado'**
  String get diaryCatalogCGripeLabel;

  /// No description provided for @diaryCatalogCGripePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve sintomas de gripe ou resfriado?'**
  String get diaryCatalogCGripePrompt;

  /// No description provided for @diaryCatalogCFebreLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Febre'**
  String get diaryCatalogCFebreLabel;

  /// No description provided for @diaryCatalogCFebrePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve febre?'**
  String get diaryCatalogCFebrePrompt;

  /// No description provided for @diaryCatalogCGargantaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor de garganta'**
  String get diaryCatalogCGargantaLabel;

  /// No description provided for @diaryCatalogCGargantaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve dor de garganta?'**
  String get diaryCatalogCGargantaPrompt;

  /// No description provided for @diaryCatalogCTosseLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tosse'**
  String get diaryCatalogCTosseLabel;

  /// No description provided for @diaryCatalogCTossePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve tosse?'**
  String get diaryCatalogCTossePrompt;

  /// No description provided for @diaryCatalogCCongestLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nariz entupido'**
  String get diaryCatalogCCongestLabel;

  /// No description provided for @diaryCatalogCCongestPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou com o nariz entupido?'**
  String get diaryCatalogCCongestPrompt;

  /// No description provided for @diaryCatalogCRiniteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Rinite ou alergia'**
  String get diaryCatalogCRiniteLabel;

  /// No description provided for @diaryCatalogCRinitePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve crise de rinite ou alergia?'**
  String get diaryCatalogCRinitePrompt;

  /// No description provided for @diaryCatalogCInchacoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Inchaço'**
  String get diaryCatalogCInchacoLabel;

  /// No description provided for @diaryCatalogCInchacoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu inchado?'**
  String get diaryCatalogCInchacoPrompt;

  /// No description provided for @diaryCatalogCIntestinoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Intestino em dia'**
  String get diaryCatalogCIntestinoLabel;

  /// No description provided for @diaryCatalogCIntestinoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'O intestino funcionou bem?'**
  String get diaryCatalogCIntestinoPrompt;

  /// No description provided for @diaryCatalogCPresoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Intestino preso'**
  String get diaryCatalogCPresoLabel;

  /// No description provided for @diaryCatalogCPresoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou com o intestino preso?'**
  String get diaryCatalogCPresoPrompt;

  /// No description provided for @diaryCatalogCDiarreiaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Diarreia'**
  String get diaryCatalogCDiarreiaLabel;

  /// No description provided for @diaryCatalogCDiarreiaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve diarreia?'**
  String get diaryCatalogCDiarreiaPrompt;

  /// No description provided for @diaryCatalogCAziaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Azia ou refluxo'**
  String get diaryCatalogCAziaLabel;

  /// No description provided for @diaryCatalogCAziaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve azia ou refluxo?'**
  String get diaryCatalogCAziaPrompt;

  /// No description provided for @diaryCatalogCNauseaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enjoo'**
  String get diaryCatalogCNauseaLabel;

  /// No description provided for @diaryCatalogCNauseaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu enjoo?'**
  String get diaryCatalogCNauseaPrompt;

  /// No description provided for @diaryCatalogCCostasLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor nas costas'**
  String get diaryCatalogCCostasLabel;

  /// No description provided for @diaryCatalogCCostasPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu dor nas costas?'**
  String get diaryCatalogCCostasPrompt;

  /// No description provided for @diaryCatalogCArticulLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor nas articulações'**
  String get diaryCatalogCArticulLabel;

  /// No description provided for @diaryCatalogCArticulPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu dor nas articulações?'**
  String get diaryCatalogCArticulPrompt;

  /// No description provided for @diaryCatalogCLesaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lesão'**
  String get diaryCatalogCLesaoLabel;

  /// No description provided for @diaryCatalogCLesaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Está com alguma lesão?'**
  String get diaryCatalogCLesaoPrompt;

  /// No description provided for @diaryCatalogCDenteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor de dente'**
  String get diaryCatalogCDenteLabel;

  /// No description provided for @diaryCatalogCDentePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve dor de dente?'**
  String get diaryCatalogCDentePrompt;

  /// No description provided for @diaryCatalogCNevoaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mente nublada'**
  String get diaryCatalogCNevoaLabel;

  /// No description provided for @diaryCatalogCNevoaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu a mente nublada?'**
  String get diaryCatalogCNevoaPrompt;

  /// No description provided for @diaryCatalogCTonturaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tontura'**
  String get diaryCatalogCTonturaLabel;

  /// No description provided for @diaryCatalogCTonturaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu tontura?'**
  String get diaryCatalogCTonturaPrompt;

  /// No description provided for @diaryCatalogCCansacoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cansaço extremo'**
  String get diaryCatalogCCansacoLabel;

  /// No description provided for @diaryCatalogCCansacoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu um cansaço fora do normal?'**
  String get diaryCatalogCCansacoPrompt;

  /// No description provided for @diaryCatalogCAcneLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pele'**
  String get diaryCatalogCAcneLabel;

  /// No description provided for @diaryCatalogCAcnePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve espinhas ou pele irritada?'**
  String get diaryCatalogCAcnePrompt;

  /// No description provided for @diaryCatalogCPalpitLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Palpitação'**
  String get diaryCatalogCPalpitLabel;

  /// No description provided for @diaryCatalogCPalpitPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu o coração acelerar parado?'**
  String get diaryCatalogCPalpitPrompt;

  /// No description provided for @diaryCatalogCVacinaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vacina'**
  String get diaryCatalogCVacinaLabel;

  /// No description provided for @diaryCatalogCVacinaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou vacina?'**
  String get diaryCatalogCVacinaPrompt;

  /// No description provided for @diaryCatalogCConsultaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Consulta médica'**
  String get diaryCatalogCConsultaLabel;

  /// No description provided for @diaryCatalogCConsultaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foi ao médico?'**
  String get diaryCatalogCConsultaPrompt;

  /// No description provided for @diaryCatalogCExameLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exame de sangue'**
  String get diaryCatalogCExameLabel;

  /// No description provided for @diaryCatalogCExamePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez exame de sangue?'**
  String get diaryCatalogCExamePrompt;

  /// No description provided for @diaryCatalogCPressaoaltaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pressão alta'**
  String get diaryCatalogCPressaoaltaLabel;

  /// No description provided for @diaryCatalogCPressaoaltaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu a pressão alta?'**
  String get diaryCatalogCPressaoaltaPrompt;

  /// No description provided for @diaryCatalogCPressaobaixaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pressão baixa'**
  String get diaryCatalogCPressaobaixaLabel;

  /// No description provided for @diaryCatalogCPressaobaixaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu a pressão baixa?'**
  String get diaryCatalogCPressaobaixaPrompt;

  /// No description provided for @diaryCatalogCHipoglicLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hipoglicemia'**
  String get diaryCatalogCHipoglicLabel;

  /// No description provided for @diaryCatalogCHipoglicPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve queda de açúcar no sangue?'**
  String get diaryCatalogCHipoglicPrompt;

  /// No description provided for @diaryCatalogCCaibraLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cãibra'**
  String get diaryCatalogCCaibraLabel;

  /// No description provided for @diaryCatalogCCaibraPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve cãibra?'**
  String get diaryCatalogCCaibraPrompt;

  /// No description provided for @diaryCatalogCOlhosLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Olhos cansados'**
  String get diaryCatalogCOlhosLabel;

  /// No description provided for @diaryCatalogCOlhosPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou com os olhos cansados?'**
  String get diaryCatalogCOlhosPrompt;

  /// No description provided for @diaryCatalogCOuvidoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor de ouvido'**
  String get diaryCatalogCOuvidoLabel;

  /// No description provided for @diaryCatalogCOuvidoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve dor de ouvido?'**
  String get diaryCatalogCOuvidoPrompt;

  /// No description provided for @diaryCatalogCSinusiteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sinusite'**
  String get diaryCatalogCSinusiteLabel;

  /// No description provided for @diaryCatalogCSinusitePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve crise de sinusite?'**
  String get diaryCatalogCSinusitePrompt;

  /// No description provided for @diaryCatalogCAsmaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crise de asma'**
  String get diaryCatalogCAsmaLabel;

  /// No description provided for @diaryCatalogCAsmaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve crise de asma?'**
  String get diaryCatalogCAsmaPrompt;

  /// No description provided for @diaryCatalogCJoelhoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor no joelho'**
  String get diaryCatalogCJoelhoLabel;

  /// No description provided for @diaryCatalogCJoelhoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu dor no joelho?'**
  String get diaryCatalogCJoelhoPrompt;

  /// No description provided for @diaryCatalogCOmbroLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dor no ombro'**
  String get diaryCatalogCOmbroLabel;

  /// No description provided for @diaryCatalogCOmbroPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu dor no ombro?'**
  String get diaryCatalogCOmbroPrompt;

  /// No description provided for @diaryCatalogCDentistaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dentista'**
  String get diaryCatalogCDentistaLabel;

  /// No description provided for @diaryCatalogCDentistaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foi ao dentista?'**
  String get diaryCatalogCDentistaPrompt;

  /// No description provided for @diaryCatalogCProcedimentoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Procedimento ou cirurgia'**
  String get diaryCatalogCProcedimentoLabel;

  /// No description provided for @diaryCatalogCProcedimentoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez algum procedimento médico?'**
  String get diaryCatalogCProcedimentoPrompt;

  /// No description provided for @diaryCatalogCGasesLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gases'**
  String get diaryCatalogCGasesLabel;

  /// No description provided for @diaryCatalogCGasesPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve gases ou estufamento?'**
  String get diaryCatalogCGasesPrompt;

  /// No description provided for @diaryCatalogCMenstrLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Menstruação'**
  String get diaryCatalogCMenstrLabel;

  /// No description provided for @diaryCatalogCMenstrPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Está menstruada?'**
  String get diaryCatalogCMenstrPrompt;

  /// No description provided for @diaryCatalogCFluxoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fluxo intenso'**
  String get diaryCatalogCFluxoLabel;

  /// No description provided for @diaryCatalogCFluxoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'O fluxo está intenso?'**
  String get diaryCatalogCFluxoPrompt;

  /// No description provided for @diaryCatalogCColicaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cólica'**
  String get diaryCatalogCColicaLabel;

  /// No description provided for @diaryCatalogCColicaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve cólica?'**
  String get diaryCatalogCColicaPrompt;

  /// No description provided for @diaryCatalogCTpmLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'TPM'**
  String get diaryCatalogCTpmLabel;

  /// No description provided for @diaryCatalogCTpmPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu sintomas de TPM?'**
  String get diaryCatalogCTpmPrompt;

  /// No description provided for @diaryCatalogCOvulLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ovulação'**
  String get diaryCatalogCOvulLabel;

  /// No description provided for @diaryCatalogCOvulPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Está ovulando?'**
  String get diaryCatalogCOvulPrompt;

  /// No description provided for @diaryCatalogCAnticonLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Anticoncepcional'**
  String get diaryCatalogCAnticonLabel;

  /// No description provided for @diaryCatalogCAnticonPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou anticoncepcional?'**
  String get diaryCatalogCAnticonPrompt;

  /// No description provided for @diaryCatalogCCaloraoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ondas de calor'**
  String get diaryCatalogCCaloraoLabel;

  /// No description provided for @diaryCatalogCCaloraoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve ondas de calor?'**
  String get diaryCatalogCCaloraoPrompt;

  /// No description provided for @diaryCatalogCSuornoiteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suor noturno'**
  String get diaryCatalogCSuornoiteLabel;

  /// No description provided for @diaryCatalogCSuornoitePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suou à noite?'**
  String get diaryCatalogCSuornoitePrompt;

  /// No description provided for @diaryCatalogCLibidoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Libido'**
  String get diaryCatalogCLibidoLabel;

  /// No description provided for @diaryCatalogCLibidoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu a libido alta?'**
  String get diaryCatalogCLibidoPrompt;

  /// No description provided for @diaryCatalogCSeiosLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seios sensíveis'**
  String get diaryCatalogCSeiosLabel;

  /// No description provided for @diaryCatalogCSeiosPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu os seios sensíveis?'**
  String get diaryCatalogCSeiosPrompt;

  /// No description provided for @diaryCatalogCRetencaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Retenção de líquido'**
  String get diaryCatalogCRetencaoLabel;

  /// No description provided for @diaryCatalogCRetencaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu retenção de líquido?'**
  String get diaryCatalogCRetencaoPrompt;

  /// No description provided for @diaryCatalogCGravidezLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gravidez'**
  String get diaryCatalogCGravidezLabel;

  /// No description provided for @diaryCatalogCGravidezPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Está grávida?'**
  String get diaryCatalogCGravidezPrompt;

  /// No description provided for @diaryCatalogCAmamentLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Amamentação'**
  String get diaryCatalogCAmamentLabel;

  /// No description provided for @diaryCatalogCAmamentPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Está amamentando?'**
  String get diaryCatalogCAmamentPrompt;

  /// No description provided for @diaryCatalogCReposicaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Reposição hormonal'**
  String get diaryCatalogCReposicaoLabel;

  /// No description provided for @diaryCatalogCReposicaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez reposição hormonal?'**
  String get diaryCatalogCReposicaoPrompt;

  /// No description provided for @diaryCatalogCTestoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Testosterona'**
  String get diaryCatalogCTestoLabel;

  /// No description provided for @diaryCatalogCTestoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aplicou testosterona?'**
  String get diaryCatalogCTestoPrompt;

  /// No description provided for @diaryCatalogCEscapeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escape'**
  String get diaryCatalogCEscapeLabel;

  /// No description provided for @diaryCatalogCEscapePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve escape fora da menstruação?'**
  String get diaryCatalogCEscapePrompt;

  /// No description provided for @diaryCatalogCAcnehormLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acne hormonal'**
  String get diaryCatalogCAcnehormLabel;

  /// No description provided for @diaryCatalogCAcnehormPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve espinhas do ciclo?'**
  String get diaryCatalogCAcnehormPrompt;

  /// No description provided for @diaryCatalogCHumorcicloLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Humor do ciclo'**
  String get diaryCatalogCHumorcicloLabel;

  /// No description provided for @diaryCatalogCHumorcicloPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu o humor mudar com o ciclo?'**
  String get diaryCatalogCHumorcicloPrompt;

  /// No description provided for @diaryCatalogCMenopausaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Menopausa'**
  String get diaryCatalogCMenopausaLabel;

  /// No description provided for @diaryCatalogCMenopausaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu sintomas da menopausa?'**
  String get diaryCatalogCMenopausaPrompt;

  /// No description provided for @diaryCatalogCTesteovulLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teste de ovulação'**
  String get diaryCatalogCTesteovulLabel;

  /// No description provided for @diaryCatalogCTesteovulPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez teste de ovulação?'**
  String get diaryCatalogCTesteovulPrompt;

  /// No description provided for @diaryCatalogCTentandoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tentando engravidar'**
  String get diaryCatalogCTentandoLabel;

  /// No description provided for @diaryCatalogCTentandoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Está tentando engravidar?'**
  String get diaryCatalogCTentandoPrompt;

  /// No description provided for @diaryCatalogCPospartoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pós-parto'**
  String get diaryCatalogCPospartoLabel;

  /// No description provided for @diaryCatalogCPospartoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Está no pós-parto?'**
  String get diaryCatalogCPospartoPrompt;

  /// No description provided for @diaryCatalogCMagLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Magnésio'**
  String get diaryCatalogCMagLabel;

  /// No description provided for @diaryCatalogCMagPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou magnésio?'**
  String get diaryCatalogCMagPrompt;

  /// No description provided for @diaryCatalogCWheyLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Whey'**
  String get diaryCatalogCWheyLabel;

  /// No description provided for @diaryCatalogCWheyPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou whey?'**
  String get diaryCatalogCWheyPrompt;

  /// No description provided for @diaryCatalogCVitdLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vitamina D'**
  String get diaryCatalogCVitdLabel;

  /// No description provided for @diaryCatalogCVitdPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou vitamina D?'**
  String get diaryCatalogCVitdPrompt;

  /// No description provided for @diaryCatalogCOmegaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ômega 3'**
  String get diaryCatalogCOmegaLabel;

  /// No description provided for @diaryCatalogCOmegaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou ômega 3?'**
  String get diaryCatalogCOmegaPrompt;

  /// No description provided for @diaryCatalogCColagLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Colágeno'**
  String get diaryCatalogCColagLabel;

  /// No description provided for @diaryCatalogCColagPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou colágeno?'**
  String get diaryCatalogCColagPrompt;

  /// No description provided for @diaryCatalogCAshwaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ashwagandha'**
  String get diaryCatalogCAshwaLabel;

  /// No description provided for @diaryCatalogCAshwaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou ashwagandha?'**
  String get diaryCatalogCAshwaPrompt;

  /// No description provided for @diaryCatalogCZincoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Zinco'**
  String get diaryCatalogCZincoLabel;

  /// No description provided for @diaryCatalogCZincoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou zinco?'**
  String get diaryCatalogCZincoPrompt;

  /// No description provided for @diaryCatalogCFerroLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ferro'**
  String get diaryCatalogCFerroLabel;

  /// No description provided for @diaryCatalogCFerroPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou ferro?'**
  String get diaryCatalogCFerroPrompt;

  /// No description provided for @diaryCatalogCB12Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vitamina B12'**
  String get diaryCatalogCB12Label;

  /// No description provided for @diaryCatalogCB12Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou vitamina B12?'**
  String get diaryCatalogCB12Prompt;

  /// No description provided for @diaryCatalogCComplexobLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Complexo B'**
  String get diaryCatalogCComplexobLabel;

  /// No description provided for @diaryCatalogCComplexobPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou complexo B?'**
  String get diaryCatalogCComplexobPrompt;

  /// No description provided for @diaryCatalogCVitcLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vitamina C'**
  String get diaryCatalogCVitcLabel;

  /// No description provided for @diaryCatalogCVitcPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou vitamina C?'**
  String get diaryCatalogCVitcPrompt;

  /// No description provided for @diaryCatalogCK2Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vitamina K2'**
  String get diaryCatalogCK2Label;

  /// No description provided for @diaryCatalogCK2Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou vitamina K2?'**
  String get diaryCatalogCK2Prompt;

  /// No description provided for @diaryCatalogCMultiLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Multivitamínico'**
  String get diaryCatalogCMultiLabel;

  /// No description provided for @diaryCatalogCMultiPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou multivitamínico?'**
  String get diaryCatalogCMultiPrompt;

  /// No description provided for @diaryCatalogCProbioLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Probiótico'**
  String get diaryCatalogCProbioLabel;

  /// No description provided for @diaryCatalogCProbioPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou probiótico?'**
  String get diaryCatalogCProbioPrompt;

  /// No description provided for @diaryCatalogCPsylliumLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fibras (psyllium)'**
  String get diaryCatalogCPsylliumLabel;

  /// No description provided for @diaryCatalogCPsylliumPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou fibra em pó?'**
  String get diaryCatalogCPsylliumPrompt;

  /// No description provided for @diaryCatalogCGlicinaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Glicina'**
  String get diaryCatalogCGlicinaLabel;

  /// No description provided for @diaryCatalogCGlicinaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou glicina?'**
  String get diaryCatalogCGlicinaPrompt;

  /// No description provided for @diaryCatalogCTeaninaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'L-teanina'**
  String get diaryCatalogCTeaninaLabel;

  /// No description provided for @diaryCatalogCTeaninaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou L-teanina?'**
  String get diaryCatalogCTeaninaPrompt;

  /// No description provided for @diaryCatalogCCafcapLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cafeína em cápsula'**
  String get diaryCatalogCCafcapLabel;

  /// No description provided for @diaryCatalogCCafcapPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou cafeína em cápsula?'**
  String get diaryCatalogCCafcapPrompt;

  /// No description provided for @diaryCatalogCPretreinoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pré-treino'**
  String get diaryCatalogCPretreinoLabel;

  /// No description provided for @diaryCatalogCPretreinoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou pré-treino?'**
  String get diaryCatalogCPretreinoPrompt;

  /// No description provided for @diaryCatalogCBetaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Beta-alanina'**
  String get diaryCatalogCBetaLabel;

  /// No description provided for @diaryCatalogCBetaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou beta-alanina?'**
  String get diaryCatalogCBetaPrompt;

  /// No description provided for @diaryCatalogCEletroLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Eletrólitos'**
  String get diaryCatalogCEletroLabel;

  /// No description provided for @diaryCatalogCEletroPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou eletrólitos?'**
  String get diaryCatalogCEletroPrompt;

  /// No description provided for @diaryCatalogCCurcumaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cúrcuma'**
  String get diaryCatalogCCurcumaLabel;

  /// No description provided for @diaryCatalogCCurcumaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou cúrcuma?'**
  String get diaryCatalogCCurcumaPrompt;

  /// No description provided for @diaryCatalogCPropolisLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Própolis'**
  String get diaryCatalogCPropolisLabel;

  /// No description provided for @diaryCatalogCPropolisPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou própolis?'**
  String get diaryCatalogCPropolisPrompt;

  /// No description provided for @diaryCatalogCMacaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Maca peruana'**
  String get diaryCatalogCMacaLabel;

  /// No description provided for @diaryCatalogCMacaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou maca peruana?'**
  String get diaryCatalogCMacaPrompt;

  /// No description provided for @diaryCatalogCSpirulLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Spirulina'**
  String get diaryCatalogCSpirulLabel;

  /// No description provided for @diaryCatalogCSpirulPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou spirulina?'**
  String get diaryCatalogCSpirulPrompt;

  /// No description provided for @diaryCatalogCCogumLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cogumelos'**
  String get diaryCatalogCCogumLabel;

  /// No description provided for @diaryCatalogCCogumPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou cogumelos adaptógenos?'**
  String get diaryCatalogCCogumPrompt;

  /// No description provided for @diaryCatalogCBiotinaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Biotina'**
  String get diaryCatalogCBiotinaLabel;

  /// No description provided for @diaryCatalogCBiotinaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou biotina?'**
  String get diaryCatalogCBiotinaPrompt;

  /// No description provided for @diaryCatalogCCalcioLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cálcio'**
  String get diaryCatalogCCalcioLabel;

  /// No description provided for @diaryCatalogCCalcioPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou cálcio?'**
  String get diaryCatalogCCalcioPrompt;

  /// No description provided for @diaryCatalogCSelenioLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selênio'**
  String get diaryCatalogCSelenioLabel;

  /// No description provided for @diaryCatalogCSelenioPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou selênio?'**
  String get diaryCatalogCSelenioPrompt;

  /// No description provided for @diaryCatalogCCoq10Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Coenzima Q10'**
  String get diaryCatalogCCoq10Label;

  /// No description provided for @diaryCatalogCCoq10Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou coenzima Q10?'**
  String get diaryCatalogCCoq10Prompt;

  /// No description provided for @diaryCatalogCNacLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'NAC'**
  String get diaryCatalogCNacLabel;

  /// No description provided for @diaryCatalogCNacPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou NAC (N-acetilcisteína)?'**
  String get diaryCatalogCNacPrompt;

  /// No description provided for @diaryCatalogCCitrulinaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Citrulina'**
  String get diaryCatalogCCitrulinaLabel;

  /// No description provided for @diaryCatalogCCitrulinaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou citrulina?'**
  String get diaryCatalogCCitrulinaPrompt;

  /// No description provided for @diaryCatalogCGlutaminaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Glutamina'**
  String get diaryCatalogCGlutaminaLabel;

  /// No description provided for @diaryCatalogCGlutaminaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou glutamina?'**
  String get diaryCatalogCGlutaminaPrompt;

  /// No description provided for @diaryCatalogCBcaaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'BCAA'**
  String get diaryCatalogCBcaaLabel;

  /// No description provided for @diaryCatalogCBcaaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou BCAA?'**
  String get diaryCatalogCBcaaPrompt;

  /// No description provided for @diaryCatalogCTaurinaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Taurina'**
  String get diaryCatalogCTaurinaLabel;

  /// No description provided for @diaryCatalogCTaurinaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou taurina?'**
  String get diaryCatalogCTaurinaPrompt;

  /// No description provided for @diaryCatalogCCarnitinaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carnitina'**
  String get diaryCatalogCCarnitinaLabel;

  /// No description provided for @diaryCatalogCCarnitinaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou carnitina?'**
  String get diaryCatalogCCarnitinaPrompt;

  /// No description provided for @diaryCatalogCTriptofanoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Triptofano'**
  String get diaryCatalogCTriptofanoLabel;

  /// No description provided for @diaryCatalogCTriptofanoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou triptofano?'**
  String get diaryCatalogCTriptofanoPrompt;

  /// No description provided for @diaryCatalogCGabaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'GABA'**
  String get diaryCatalogCGabaLabel;

  /// No description provided for @diaryCatalogCGabaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou GABA?'**
  String get diaryCatalogCGabaPrompt;

  /// No description provided for @diaryCatalogCValerianaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Valeriana ou passiflora'**
  String get diaryCatalogCValerianaLabel;

  /// No description provided for @diaryCatalogCValerianaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou valeriana ou passiflora?'**
  String get diaryCatalogCValerianaPrompt;

  /// No description provided for @diaryCatalogCFolicoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ácido fólico'**
  String get diaryCatalogCFolicoLabel;

  /// No description provided for @diaryCatalogCFolicoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou ácido fólico?'**
  String get diaryCatalogCFolicoPrompt;

  /// No description provided for @diaryCatalogCViteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vitamina E'**
  String get diaryCatalogCViteLabel;

  /// No description provided for @diaryCatalogCVitePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou vitamina E?'**
  String get diaryCatalogCVitePrompt;

  /// No description provided for @diaryCatalogCResverLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Resveratrol'**
  String get diaryCatalogCResverLabel;

  /// No description provided for @diaryCatalogCResverPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou resveratrol?'**
  String get diaryCatalogCResverPrompt;

  /// No description provided for @diaryCatalogCBerberLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Berberina'**
  String get diaryCatalogCBerberLabel;

  /// No description provided for @diaryCatalogCBerberPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou berberina?'**
  String get diaryCatalogCBerberPrompt;

  /// No description provided for @diaryCatalogCInositolLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Inositol'**
  String get diaryCatalogCInositolLabel;

  /// No description provided for @diaryCatalogCInositolPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou inositol?'**
  String get diaryCatalogCInositolPrompt;

  /// No description provided for @diaryCatalogCMelatLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Melatonina'**
  String get diaryCatalogCMelatLabel;

  /// No description provided for @diaryCatalogCMelatPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou melatonina?'**
  String get diaryCatalogCMelatPrompt;

  /// No description provided for @diaryCatalogCRemedLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remédio para dormir'**
  String get diaryCatalogCRemedLabel;

  /// No description provided for @diaryCatalogCRemedPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio para dormir?'**
  String get diaryCatalogCRemedPrompt;

  /// No description provided for @diaryCatalogCAnalgLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Analgésico'**
  String get diaryCatalogCAnalgLabel;

  /// No description provided for @diaryCatalogCAnalgPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou analgésico (dipirona, paracetamol)?'**
  String get diaryCatalogCAnalgPrompt;

  /// No description provided for @diaryCatalogCAntiinfLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Anti-inflamatório'**
  String get diaryCatalogCAntiinfLabel;

  /// No description provided for @diaryCatalogCAntiinfPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou anti-inflamatório?'**
  String get diaryCatalogCAntiinfPrompt;

  /// No description provided for @diaryCatalogCAntialLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Antialérgico'**
  String get diaryCatalogCAntialLabel;

  /// No description provided for @diaryCatalogCAntialPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou antialérgico?'**
  String get diaryCatalogCAntialPrompt;

  /// No description provided for @diaryCatalogCDescongLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Descongestionante'**
  String get diaryCatalogCDescongLabel;

  /// No description provided for @diaryCatalogCDescongPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou descongestionante nasal?'**
  String get diaryCatalogCDescongPrompt;

  /// No description provided for @diaryCatalogCAntibLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Antibiótico'**
  String get diaryCatalogCAntibLabel;

  /// No description provided for @diaryCatalogCAntibPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou antibiótico?'**
  String get diaryCatalogCAntibPrompt;

  /// No description provided for @diaryCatalogCCorticLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Corticoide'**
  String get diaryCatalogCCorticLabel;

  /// No description provided for @diaryCatalogCCorticPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou corticoide?'**
  String get diaryCatalogCCorticPrompt;

  /// No description provided for @diaryCatalogCRelaxmuscLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relaxante muscular'**
  String get diaryCatalogCRelaxmuscLabel;

  /// No description provided for @diaryCatalogCRelaxmuscPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou relaxante muscular?'**
  String get diaryCatalogCRelaxmuscPrompt;

  /// No description provided for @diaryCatalogCEnjooLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remédio para enjoo'**
  String get diaryCatalogCEnjooLabel;

  /// No description provided for @diaryCatalogCEnjooPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio para enjoo?'**
  String get diaryCatalogCEnjooPrompt;

  /// No description provided for @diaryCatalogCAnsiolLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ansiolítico'**
  String get diaryCatalogCAnsiolLabel;

  /// No description provided for @diaryCatalogCAnsiolPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou ansiolítico?'**
  String get diaryCatalogCAnsiolPrompt;

  /// No description provided for @diaryCatalogCAntidepLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Antidepressivo'**
  String get diaryCatalogCAntidepLabel;

  /// No description provided for @diaryCatalogCAntidepPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou antidepressivo?'**
  String get diaryCatalogCAntidepPrompt;

  /// No description provided for @diaryCatalogCEstimLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remédio para TDAH'**
  String get diaryCatalogCEstimLabel;

  /// No description provided for @diaryCatalogCEstimPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio para TDAH?'**
  String get diaryCatalogCEstimPrompt;

  /// No description provided for @diaryCatalogCPressaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remédio de pressão'**
  String get diaryCatalogCPressaoLabel;

  /// No description provided for @diaryCatalogCPressaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio de pressão?'**
  String get diaryCatalogCPressaoPrompt;

  /// No description provided for @diaryCatalogCTireoideLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tireoide'**
  String get diaryCatalogCTireoideLabel;

  /// No description provided for @diaryCatalogCTireoidePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio de tireoide?'**
  String get diaryCatalogCTireoidePrompt;

  /// No description provided for @diaryCatalogCDiabetesLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Diabetes'**
  String get diaryCatalogCDiabetesLabel;

  /// No description provided for @diaryCatalogCDiabetesPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio ou insulina para diabetes?'**
  String get diaryCatalogCDiabetesPrompt;

  /// No description provided for @diaryCatalogCGlp1Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remédio GLP-1'**
  String get diaryCatalogCGlp1Label;

  /// No description provided for @diaryCatalogCGlp1Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aplicou o remédio injetável para emagrecer ou diabetes (semaglutida, tirzepatida)?'**
  String get diaryCatalogCGlp1Prompt;

  /// No description provided for @diaryCatalogCAnticoncep2Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hormônio'**
  String get diaryCatalogCAnticoncep2Label;

  /// No description provided for @diaryCatalogCAnticoncep2Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou algum hormônio?'**
  String get diaryCatalogCAnticoncep2Prompt;

  /// No description provided for @diaryCatalogCIsotretLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Isotretinoína'**
  String get diaryCatalogCIsotretLabel;

  /// No description provided for @diaryCatalogCIsotretPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou isotretinoína (remédio para acne)?'**
  String get diaryCatalogCIsotretPrompt;

  /// No description provided for @diaryCatalogCMinoxLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Minoxidil'**
  String get diaryCatalogCMinoxLabel;

  /// No description provided for @diaryCatalogCMinoxPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou minoxidil?'**
  String get diaryCatalogCMinoxPrompt;

  /// No description provided for @diaryCatalogCFinastLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Finasterida'**
  String get diaryCatalogCFinastLabel;

  /// No description provided for @diaryCatalogCFinastPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou finasterida?'**
  String get diaryCatalogCFinastPrompt;

  /// No description provided for @diaryCatalogCNotempoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remédios no horário'**
  String get diaryCatalogCNotempoLabel;

  /// No description provided for @diaryCatalogCNotempoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou os remédios no horário certo?'**
  String get diaryCatalogCNotempoPrompt;

  /// No description provided for @diaryCatalogCEsqueceuLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esqueceu o remédio'**
  String get diaryCatalogCEsqueceuLabel;

  /// No description provided for @diaryCatalogCEsqueceuPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esqueceu de tomar algum remédio?'**
  String get diaryCatalogCEsqueceuPrompt;

  /// No description provided for @diaryCatalogCProtgastLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Protetor gástrico'**
  String get diaryCatalogCProtgastLabel;

  /// No description provided for @diaryCatalogCProtgastPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou omeprazol ou protetor do estômago?'**
  String get diaryCatalogCProtgastPrompt;

  /// No description provided for @diaryCatalogCAntiacidoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Antiácido'**
  String get diaryCatalogCAntiacidoLabel;

  /// No description provided for @diaryCatalogCAntiacidoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou antiácido?'**
  String get diaryCatalogCAntiacidoPrompt;

  /// No description provided for @diaryCatalogCLaxanteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Laxante'**
  String get diaryCatalogCLaxanteLabel;

  /// No description provided for @diaryCatalogCLaxantePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou laxante?'**
  String get diaryCatalogCLaxantePrompt;

  /// No description provided for @diaryCatalogCAntidiarLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Antidiarreico'**
  String get diaryCatalogCAntidiarLabel;

  /// No description provided for @diaryCatalogCAntidiarPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio para diarreia?'**
  String get diaryCatalogCAntidiarPrompt;

  /// No description provided for @diaryCatalogCColicaremLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remédio para cólica'**
  String get diaryCatalogCColicaremLabel;

  /// No description provided for @diaryCatalogCColicaremPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio para cólica?'**
  String get diaryCatalogCColicaremPrompt;

  /// No description provided for @diaryCatalogCEnxaqremLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remédio para enxaqueca'**
  String get diaryCatalogCEnxaqremLabel;

  /// No description provided for @diaryCatalogCEnxaqremPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio para enxaqueca?'**
  String get diaryCatalogCEnxaqremPrompt;

  /// No description provided for @diaryCatalogCAntitermicoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Antitérmico'**
  String get diaryCatalogCAntitermicoLabel;

  /// No description provided for @diaryCatalogCAntitermicoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio para febre?'**
  String get diaryCatalogCAntitermicoPrompt;

  /// No description provided for @diaryCatalogCXaropeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Xarope'**
  String get diaryCatalogCXaropeLabel;

  /// No description provided for @diaryCatalogCXaropePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou xarope para tosse?'**
  String get diaryCatalogCXaropePrompt;

  /// No description provided for @diaryCatalogCBombinhaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bombinha de asma'**
  String get diaryCatalogCBombinhaLabel;

  /// No description provided for @diaryCatalogCBombinhaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou bombinha?'**
  String get diaryCatalogCBombinhaPrompt;

  /// No description provided for @diaryCatalogCSpraynasalLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Spray nasal com corticoide'**
  String get diaryCatalogCSpraynasalLabel;

  /// No description provided for @diaryCatalogCSpraynasalPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou spray nasal com corticoide?'**
  String get diaryCatalogCSpraynasalPrompt;

  /// No description provided for @diaryCatalogCColirioLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Colírio'**
  String get diaryCatalogCColirioLabel;

  /// No description provided for @diaryCatalogCColirioPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou colírio?'**
  String get diaryCatalogCColirioPrompt;

  /// No description provided for @diaryCatalogCPomadaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pomada'**
  String get diaryCatalogCPomadaLabel;

  /// No description provided for @diaryCatalogCPomadaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou pomada ou creme de tratamento?'**
  String get diaryCatalogCPomadaPrompt;

  /// No description provided for @diaryCatalogCAntifungLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Antifúngico'**
  String get diaryCatalogCAntifungLabel;

  /// No description provided for @diaryCatalogCAntifungPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou antifúngico?'**
  String get diaryCatalogCAntifungPrompt;

  /// No description provided for @diaryCatalogCAntiviralLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Antiviral'**
  String get diaryCatalogCAntiviralLabel;

  /// No description provided for @diaryCatalogCAntiviralPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou antiviral?'**
  String get diaryCatalogCAntiviralPrompt;

  /// No description provided for @diaryCatalogCEstatinaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remédio de colesterol'**
  String get diaryCatalogCEstatinaLabel;

  /// No description provided for @diaryCatalogCEstatinaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio para colesterol?'**
  String get diaryCatalogCEstatinaPrompt;

  /// No description provided for @diaryCatalogCAnticoagLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Anticoagulante'**
  String get diaryCatalogCAnticoagLabel;

  /// No description provided for @diaryCatalogCAnticoagPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou anticoagulante?'**
  String get diaryCatalogCAnticoagPrompt;

  /// No description provided for @diaryCatalogCMetformLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Metformina'**
  String get diaryCatalogCMetformLabel;

  /// No description provided for @diaryCatalogCMetformPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou metformina?'**
  String get diaryCatalogCMetformPrompt;

  /// No description provided for @diaryCatalogCAnticonvLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Anticonvulsivante'**
  String get diaryCatalogCAnticonvLabel;

  /// No description provided for @diaryCatalogCAnticonvPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou anticonvulsivante?'**
  String get diaryCatalogCAnticonvPrompt;

  /// No description provided for @diaryCatalogCEstabilLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estabilizador de humor'**
  String get diaryCatalogCEstabilLabel;

  /// No description provided for @diaryCatalogCEstabilPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou estabilizador de humor?'**
  String get diaryCatalogCEstabilPrompt;

  /// No description provided for @diaryCatalogCInjecaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vitamina injetável'**
  String get diaryCatalogCInjecaoLabel;

  /// No description provided for @diaryCatalogCInjecaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou alguma vitamina injetável?'**
  String get diaryCatalogCInjecaoPrompt;

  /// No description provided for @diaryCatalogCProtetorLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Protetor solar'**
  String get diaryCatalogCProtetorLabel;

  /// No description provided for @diaryCatalogCProtetorPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou protetor solar?'**
  String get diaryCatalogCProtetorPrompt;

  /// No description provided for @diaryCatalogCSkincareLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Skincare'**
  String get diaryCatalogCSkincareLabel;

  /// No description provided for @diaryCatalogCSkincarePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez a rotina de cuidados com a pele?'**
  String get diaryCatalogCSkincarePrompt;

  /// No description provided for @diaryCatalogCHidratLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hidratou a pele'**
  String get diaryCatalogCHidratLabel;

  /// No description provided for @diaryCatalogCHidratPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou hidratante?'**
  String get diaryCatalogCHidratPrompt;

  /// No description provided for @diaryCatalogCFiodentalLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fio dental'**
  String get diaryCatalogCFiodentalLabel;

  /// No description provided for @diaryCatalogCFiodentalPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou fio dental?'**
  String get diaryCatalogCFiodentalPrompt;

  /// No description provided for @diaryCatalogCPausaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pausas no trabalho'**
  String get diaryCatalogCPausaLabel;

  /// No description provided for @diaryCatalogCPausaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez pausas durante o trabalho?'**
  String get diaryCatalogCPausaPrompt;

  /// No description provided for @diaryCatalogCPostura2Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ergonomia'**
  String get diaryCatalogCPostura2Label;

  /// No description provided for @diaryCatalogCPostura2Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trabalhou numa posição confortável?'**
  String get diaryCatalogCPostura2Prompt;

  /// No description provided for @diaryCatalogCCelnoiteLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Modo noturno'**
  String get diaryCatalogCCelnoiteLabel;

  /// No description provided for @diaryCatalogCCelnoitePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deixou o celular no modo noturno?'**
  String get diaryCatalogCCelnoitePrompt;

  /// No description provided for @diaryCatalogCOrganizouLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Organizou o dia'**
  String get diaryCatalogCOrganizouLabel;

  /// No description provided for @diaryCatalogCOrganizouPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Planejou o dia com antecedência?'**
  String get diaryCatalogCOrganizouPrompt;

  /// No description provided for @diaryCatalogCNatureza2Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Contato com a natureza'**
  String get diaryCatalogCNatureza2Label;

  /// No description provided for @diaryCatalogCNatureza2Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pisou na grama ou tocou a natureza?'**
  String get diaryCatalogCNatureza2Prompt;

  /// No description provided for @diaryCatalogCR130Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Levantou a cada hora'**
  String get diaryCatalogCR130Label;

  /// No description provided for @diaryCatalogCR130Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Levantou da cadeira a cada hora?'**
  String get diaryCatalogCR130Prompt;

  /// No description provided for @diaryCatalogCR131Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escada em vez do elevador'**
  String get diaryCatalogCR131Label;

  /// No description provided for @diaryCatalogCR131Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou a escada em vez do elevador?'**
  String get diaryCatalogCR131Prompt;

  /// No description provided for @diaryCatalogCR132Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pausa ativa no trabalho'**
  String get diaryCatalogCR132Label;

  /// No description provided for @diaryCatalogCR132Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez pausas para se mexer no trabalho?'**
  String get diaryCatalogCR132Prompt;

  /// No description provided for @diaryCatalogCR133Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carregou peso no dia a dia'**
  String get diaryCatalogCR133Label;

  /// No description provided for @diaryCatalogCR133Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carregou peso (compras, criança no colo)?'**
  String get diaryCatalogCR133Prompt;

  /// No description provided for @diaryCatalogCR134Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Brincou com as crianças'**
  String get diaryCatalogCR134Label;

  /// No description provided for @diaryCatalogCR134Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Brincou ativamente com as crianças?'**
  String get diaryCatalogCR134Prompt;

  /// No description provided for @diaryCatalogCR136Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pegou o celular ao acordar'**
  String get diaryCatalogCR136Label;

  /// No description provided for @diaryCatalogCR136Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pegou o celular logo ao acordar?'**
  String get diaryCatalogCR136Prompt;

  /// No description provided for @diaryCatalogCR137Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Celular nas refeições'**
  String get diaryCatalogCR137Label;

  /// No description provided for @diaryCatalogCR137Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou o celular durante as refeições?'**
  String get diaryCatalogCR137Prompt;

  /// No description provided for @diaryCatalogCR138Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'WhatsApp do trabalho fora do horário'**
  String get diaryCatalogCR138Label;

  /// No description provided for @diaryCatalogCR138Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respondeu trabalho fora do horário?'**
  String get diaryCatalogCR138Prompt;

  /// No description provided for @diaryCatalogCR139Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vídeos curtos'**
  String get diaryCatalogCR139Label;

  /// No description provided for @diaryCatalogCR139Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou rolando vídeos curtos (Reels, TikTok)?'**
  String get diaryCatalogCR139Prompt;

  /// No description provided for @diaryCatalogCR1310Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jogos no celular'**
  String get diaryCatalogCR1310Label;

  /// No description provided for @diaryCatalogCR1310Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jogou no celular?'**
  String get diaryCatalogCR1310Prompt;

  /// No description provided for @diaryCatalogCR1311Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Apostas online'**
  String get diaryCatalogCR1311Label;

  /// No description provided for @diaryCatalogCR1311Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez apostas online?'**
  String get diaryCatalogCR1311Prompt;

  /// No description provided for @diaryCatalogCR1312Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pausa para os olhos'**
  String get diaryCatalogCR1312Label;

  /// No description provided for @diaryCatalogCR1312Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez pausas para descansar os olhos?'**
  String get diaryCatalogCR1312Prompt;

  /// No description provided for @diaryCatalogCR1313Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Modo foco'**
  String get diaryCatalogCR1313Label;

  /// No description provided for @diaryCatalogCR1313Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usou o modo foco?'**
  String get diaryCatalogCR1313Prompt;

  /// No description provided for @diaryCatalogCR1314Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Notificações desligadas'**
  String get diaryCatalogCR1314Label;

  /// No description provided for @diaryCatalogCR1314Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Desligou as notificações?'**
  String get diaryCatalogCR1314Prompt;

  /// No description provided for @diaryCatalogCR1315Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trabalho sem interrupção'**
  String get diaryCatalogCR1315Label;

  /// No description provided for @diaryCatalogCR1315Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve um bloco de trabalho sem interrupção?'**
  String get diaryCatalogCR1315Prompt;

  /// No description provided for @diaryCatalogCR1316Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Celular fora do quarto'**
  String get diaryCatalogCR1316Label;

  /// No description provided for @diaryCatalogCR1316Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deixou o celular fora do quarto?'**
  String get diaryCatalogCR1316Prompt;

  /// No description provided for @diaryCatalogCR1317Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escovou os dentes 3 vezes'**
  String get diaryCatalogCR1317Label;

  /// No description provided for @diaryCatalogCR1317Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escovou os dentes 3 vezes?'**
  String get diaryCatalogCR1317Prompt;

  /// No description provided for @diaryCatalogCR1318Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tirou a maquiagem'**
  String get diaryCatalogCR1318Label;

  /// No description provided for @diaryCatalogCR1318Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tirou a maquiagem antes de dormir?'**
  String get diaryCatalogCR1318Prompt;

  /// No description provided for @diaryCatalogCR1319Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cuidou do cabelo'**
  String get diaryCatalogCR1319Label;

  /// No description provided for @diaryCatalogCR1319Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez hidratação ou cuidado no cabelo?'**
  String get diaryCatalogCR1319Prompt;

  /// No description provided for @diaryCatalogCR1320Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Unhas'**
  String get diaryCatalogCR1320Label;

  /// No description provided for @diaryCatalogCR1320Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez as unhas?'**
  String get diaryCatalogCR1320Prompt;

  /// No description provided for @diaryCatalogCR1321Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Barba'**
  String get diaryCatalogCR1321Label;

  /// No description provided for @diaryCatalogCR1321Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez a barba?'**
  String get diaryCatalogCR1321Prompt;

  /// No description provided for @diaryCatalogCR1322Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Repelente'**
  String get diaryCatalogCR1322Label;

  /// No description provided for @diaryCatalogCR1322Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou repelente?'**
  String get diaryCatalogCR1322Prompt;

  /// No description provided for @diaryCatalogCR1323Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hidratou os lábios'**
  String get diaryCatalogCR1323Label;

  /// No description provided for @diaryCatalogCR1323Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hidratou os lábios?'**
  String get diaryCatalogCR1323Prompt;

  /// No description provided for @diaryCatalogCR1324Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tempo para si'**
  String get diaryCatalogCR1324Label;

  /// No description provided for @diaryCatalogCR1324Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve um tempo só para você?'**
  String get diaryCatalogCR1324Prompt;

  /// No description provided for @diaryCatalogCR1325Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dipirona'**
  String get diaryCatalogCR1325Label;

  /// No description provided for @diaryCatalogCR1325Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou dipirona?'**
  String get diaryCatalogCR1325Prompt;

  /// No description provided for @diaryCatalogCR1326Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Paracetamol'**
  String get diaryCatalogCR1326Label;

  /// No description provided for @diaryCatalogCR1326Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou paracetamol?'**
  String get diaryCatalogCR1326Prompt;

  /// No description provided for @diaryCatalogCR1327Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ibuprofeno'**
  String get diaryCatalogCR1327Label;

  /// No description provided for @diaryCatalogCR1327Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou ibuprofeno?'**
  String get diaryCatalogCR1327Prompt;

  /// No description provided for @diaryCatalogCR1328Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nimesulida'**
  String get diaryCatalogCR1328Label;

  /// No description provided for @diaryCatalogCR1328Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou nimesulida?'**
  String get diaryCatalogCR1328Prompt;

  /// No description provided for @diaryCatalogCR1329Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relaxante com analgésico'**
  String get diaryCatalogCR1329Label;

  /// No description provided for @diaryCatalogCR1329Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou relaxante muscular com analgésico?'**
  String get diaryCatalogCR1329Prompt;

  /// No description provided for @diaryCatalogCR1330Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Omeprazol'**
  String get diaryCatalogCR1330Label;

  /// No description provided for @diaryCatalogCR1330Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou omeprazol?'**
  String get diaryCatalogCR1330Prompt;

  /// No description provided for @diaryCatalogCR1331Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remédio para gases'**
  String get diaryCatalogCR1331Label;

  /// No description provided for @diaryCatalogCR1331Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio para gases?'**
  String get diaryCatalogCR1331Prompt;

  /// No description provided for @diaryCatalogCR1332Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Losartana'**
  String get diaryCatalogCR1332Label;

  /// No description provided for @diaryCatalogCR1332Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou losartana?'**
  String get diaryCatalogCR1332Prompt;

  /// No description provided for @diaryCatalogCR1333Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Levotiroxina'**
  String get diaryCatalogCR1333Label;

  /// No description provided for @diaryCatalogCR1333Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou levotiroxina?'**
  String get diaryCatalogCR1333Prompt;

  /// No description provided for @diaryCatalogCR1334Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sertralina ou escitalopram'**
  String get diaryCatalogCR1334Label;

  /// No description provided for @diaryCatalogCR1334Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou o antidepressivo?'**
  String get diaryCatalogCR1334Prompt;

  /// No description provided for @diaryCatalogCR1335Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Clonazepam'**
  String get diaryCatalogCR1335Label;

  /// No description provided for @diaryCatalogCR1335Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou clonazepam?'**
  String get diaryCatalogCR1335Prompt;

  /// No description provided for @diaryCatalogCR1336Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Zolpidem'**
  String get diaryCatalogCR1336Label;

  /// No description provided for @diaryCatalogCR1336Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou zolpidem?'**
  String get diaryCatalogCR1336Prompt;

  /// No description provided for @diaryCatalogCR1337Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Loratadina'**
  String get diaryCatalogCR1337Label;

  /// No description provided for @diaryCatalogCR1337Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou loratadina?'**
  String get diaryCatalogCR1337Prompt;

  /// No description provided for @diaryCatalogCR1338Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Insulina'**
  String get diaryCatalogCR1338Label;

  /// No description provided for @diaryCatalogCR1338Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aplicou insulina?'**
  String get diaryCatalogCR1338Prompt;

  /// No description provided for @diaryCatalogCR1339Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sildenafila ou tadalafila'**
  String get diaryCatalogCR1339Label;

  /// No description provided for @diaryCatalogCR1339Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou sildenafila ou tadalafila?'**
  String get diaryCatalogCR1339Prompt;

  /// No description provided for @diaryCatalogCR1340Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lavagem nasal com soro'**
  String get diaryCatalogCR1340Label;

  /// No description provided for @diaryCatalogCR1340Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez lavagem nasal com soro?'**
  String get diaryCatalogCR1340Prompt;

  /// No description provided for @diaryCatalogCR1341Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remédio para infecção urinária'**
  String get diaryCatalogCR1341Label;

  /// No description provided for @diaryCatalogCR1341Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou remédio para infecção urinária?'**
  String get diaryCatalogCR1341Prompt;

  /// No description provided for @diaryCatalogCR1342Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Termogênico'**
  String get diaryCatalogCR1342Label;

  /// No description provided for @diaryCatalogCR1342Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou termogênico?'**
  String get diaryCatalogCR1342Prompt;

  /// No description provided for @diaryCatalogCR1343Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hipercalórico'**
  String get diaryCatalogCR1343Label;

  /// No description provided for @diaryCatalogCR1343Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou hipercalórico?'**
  String get diaryCatalogCR1343Prompt;

  /// No description provided for @diaryCatalogCR1344Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Picolinato de cromo'**
  String get diaryCatalogCR1344Label;

  /// No description provided for @diaryCatalogCR1344Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou picolinato de cromo?'**
  String get diaryCatalogCR1344Prompt;

  /// No description provided for @diaryCatalogCR1345Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Óleo de prímula'**
  String get diaryCatalogCR1345Label;

  /// No description provided for @diaryCatalogCR1345Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou óleo de prímula?'**
  String get diaryCatalogCR1345Prompt;

  /// No description provided for @diaryCatalogCR1346Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Levedo de cerveja'**
  String get diaryCatalogCR1346Label;

  /// No description provided for @diaryCatalogCR1346Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou levedo de cerveja?'**
  String get diaryCatalogCR1346Prompt;

  /// No description provided for @diaryCatalogCR1347Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vinagre de maçã em cápsula'**
  String get diaryCatalogCR1347Label;

  /// No description provided for @diaryCatalogCR1347Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou vinagre de maçã em cápsula?'**
  String get diaryCatalogCR1347Prompt;

  /// No description provided for @diaryCatalogCR1348Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cranberry'**
  String get diaryCatalogCR1348Label;

  /// No description provided for @diaryCatalogCR1348Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou cranberry?'**
  String get diaryCatalogCR1348Prompt;

  /// No description provided for @diaryCatalogCR1349Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Polivitamínico infantil'**
  String get diaryCatalogCR1349Label;

  /// No description provided for @diaryCatalogCR1349Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deu polivitamínico para a criança?'**
  String get diaryCatalogCR1349Prompt;

  /// No description provided for @diaryCatalogCR1350Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'DIU'**
  String get diaryCatalogCR1350Label;

  /// No description provided for @diaryCatalogCR1350Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usa DIU?'**
  String get diaryCatalogCR1350Prompt;

  /// No description provided for @diaryCatalogCR1351Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Implante contraceptivo'**
  String get diaryCatalogCR1351Label;

  /// No description provided for @diaryCatalogCR1351Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usa implante contraceptivo?'**
  String get diaryCatalogCR1351Prompt;

  /// No description provided for @diaryCatalogCR1352Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Injeção anticoncepcional'**
  String get diaryCatalogCR1352Label;

  /// No description provided for @diaryCatalogCR1352Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou a injeção anticoncepcional?'**
  String get diaryCatalogCR1352Prompt;

  /// No description provided for @diaryCatalogCR1353Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pílula do dia seguinte'**
  String get diaryCatalogCR1353Label;

  /// No description provided for @diaryCatalogCR1353Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomou a pílula do dia seguinte?'**
  String get diaryCatalogCR1353Prompt;

  /// No description provided for @diaryCatalogCR1354Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esqueceu a pílula'**
  String get diaryCatalogCR1354Label;

  /// No description provided for @diaryCatalogCR1354Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esqueceu o anticoncepcional?'**
  String get diaryCatalogCR1354Prompt;

  /// No description provided for @diaryCatalogCR1355Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Endometriose'**
  String get diaryCatalogCR1355Label;

  /// No description provided for @diaryCatalogCR1355Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu dor de endometriose?'**
  String get diaryCatalogCR1355Prompt;

  /// No description provided for @diaryCatalogCR1356Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ovário policístico (SOP)'**
  String get diaryCatalogCR1356Label;

  /// No description provided for @diaryCatalogCR1356Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sintomas de ovário policístico?'**
  String get diaryCatalogCR1356Prompt;

  /// No description provided for @diaryCatalogCR1357Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Candidíase'**
  String get diaryCatalogCR1357Label;

  /// No description provided for @diaryCatalogCR1357Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve candidíase?'**
  String get diaryCatalogCR1357Prompt;

  /// No description provided for @diaryCatalogCR1358Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Infecção urinária'**
  String get diaryCatalogCR1358Label;

  /// No description provided for @diaryCatalogCR1358Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve infecção urinária?'**
  String get diaryCatalogCR1358Prompt;

  /// No description provided for @diaryCatalogCR1359Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Secura vaginal'**
  String get diaryCatalogCR1359Label;

  /// No description provided for @diaryCatalogCR1359Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu secura vaginal?'**
  String get diaryCatalogCR1359Prompt;

  /// No description provided for @diaryCatalogCR1360Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Queda de cabelo'**
  String get diaryCatalogCR1360Label;

  /// No description provided for @diaryCatalogCR1360Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Notou queda de cabelo?'**
  String get diaryCatalogCR1360Prompt;

  /// No description provided for @diaryCatalogCR1361Label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Disfunção erétil'**
  String get diaryCatalogCR1361Label;

  /// No description provided for @diaryCatalogCR1361Prompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve dificuldade de ereção?'**
  String get diaryCatalogCR1361Prompt;

  /// No description provided for @diaryCatalogCWDesafioLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Encarou como desafio'**
  String get diaryCatalogCWDesafioLabel;

  /// No description provided for @diaryCatalogCWDesafioPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Encarou a pressão do dia como um desafio?'**
  String get diaryCatalogCWDesafioPrompt;

  /// No description provided for @diaryCatalogCWAmeacaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Encarou como ameaça'**
  String get diaryCatalogCWAmeacaLabel;

  /// No description provided for @diaryCatalogCWAmeacaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu a pressão do dia como uma ameaça?'**
  String get diaryCatalogCWAmeacaPrompt;

  /// No description provided for @diaryCatalogCWControleLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'No controle'**
  String get diaryCatalogCWControleLabel;

  /// No description provided for @diaryCatalogCWControlePrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu que estava no controle do seu dia?'**
  String get diaryCatalogCWControlePrompt;

  /// No description provided for @diaryCatalogCWEficaciaLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confiança em si'**
  String get diaryCatalogCWEficaciaLabel;

  /// No description provided for @diaryCatalogCWEficaciaPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu capaz de dar conta do que precisava?'**
  String get diaryCatalogCWEficaciaPrompt;

  /// No description provided for @diaryCatalogCWFluxoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estado de fluxo'**
  String get diaryCatalogCWFluxoLabel;

  /// No description provided for @diaryCatalogCWFluxoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficou imerso em algo sem ver o tempo passar?'**
  String get diaryCatalogCWFluxoPrompt;

  /// No description provided for @diaryCatalogCWConcentraLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dificuldade de concentração'**
  String get diaryCatalogCWConcentraLabel;

  /// No description provided for @diaryCatalogCWConcentraPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve dificuldade para se concentrar?'**
  String get diaryCatalogCWConcentraPrompt;

  /// No description provided for @diaryCatalogCWProgressoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Avançou em algo importante'**
  String get diaryCatalogCWProgressoLabel;

  /// No description provided for @diaryCatalogCWProgressoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fez progresso em algo que importa para você?'**
  String get diaryCatalogCWProgressoPrompt;

  /// No description provided for @diaryCatalogCWRealizacaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sensação de realização'**
  String get diaryCatalogCWRealizacaoLabel;

  /// No description provided for @diaryCatalogCWRealizacaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Terminou o dia com sensação de dever cumprido?'**
  String get diaryCatalogCWRealizacaoPrompt;

  /// No description provided for @diaryCatalogCWPropositoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senso de propósito'**
  String get diaryCatalogCWPropositoLabel;

  /// No description provided for @diaryCatalogCWPropositoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentiu que o seu dia teve um propósito?'**
  String get diaryCatalogCWPropositoPrompt;

  /// No description provided for @diaryCatalogCWOtimismoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Otimismo'**
  String get diaryCatalogCWOtimismoLabel;

  /// No description provided for @diaryCatalogCWOtimismoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu otimista e positivo?'**
  String get diaryCatalogCWOtimismoPrompt;

  /// No description provided for @diaryCatalogCWDepressaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sintomas de depressão'**
  String get diaryCatalogCWDepressaoLabel;

  /// No description provided for @diaryCatalogCWDepressaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve sintomas de depressão, como vazio ou falta de prazer nas coisas?'**
  String get diaryCatalogCWDepressaoPrompt;

  /// No description provided for @diaryCatalogCWRelacaoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relacionamento'**
  String get diaryCatalogCWRelacaoLabel;

  /// No description provided for @diaryCatalogCWRelacaoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Teve um bom momento com quem você ama?'**
  String get diaryCatalogCWRelacaoPrompt;

  /// No description provided for @diaryCatalogCWEsgotadoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Socialmente esgotado'**
  String get diaryCatalogCWEsgotadoLabel;

  /// No description provided for @diaryCatalogCWEsgotadoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se sentiu cansado de tanta gente e conversa?'**
  String get diaryCatalogCWEsgotadoPrompt;

  /// No description provided for @diaryCatalogCWIsoladoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Isolamento'**
  String get diaryCatalogCWIsoladoLabel;

  /// No description provided for @diaryCatalogCWIsoladoPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passou o dia sem contato com outras pessoas?'**
  String get diaryCatalogCWIsoladoPrompt;

  /// No description provided for @diaryUiCouldNotHearYouYouCanTypeBelow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível ouvir. Você pode escrever abaixo.'**
  String get diaryUiCouldNotHearYouYouCanTypeBelow;

  /// No description provided for @diaryUiSpeechIsUnavailableOrPermissionWasDeniedYouCanType.
  ///
  /// In pt_BR, this message translates to:
  /// **'A fala não está disponível ou a permissão foi negada. Você pode escrever.'**
  String get diaryUiSpeechIsUnavailableOrPermissionWasDeniedYouCanType;

  /// No description provided for @diaryUiCouldNotStartSpeechYouCanType.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível iniciar a fala. Você pode escrever.'**
  String get diaryUiCouldNotStartSpeechYouCanType;

  /// No description provided for @diaryUiCouldNotInterpretThisTryAgainYourTextIsStillHere.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível interpretar. Tente novamente. Seu texto está salvo aqui.'**
  String get diaryUiCouldNotInterpretThisTryAgainYourTextIsStillHere;

  /// No description provided for @diaryUiRecordWithAI.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registrar com a IA'**
  String get diaryUiRecordWithAI;

  /// No description provided for @diaryUiTellUsAboutYourDay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conte como foi o seu dia.'**
  String get diaryUiTellUsAboutYourDay;

  /// No description provided for @diaryUiReviewBeforeAdding.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confira antes de adicionar.'**
  String get diaryUiReviewBeforeAdding;

  /// No description provided for @diaryUiAICanMakeMistakesReviewTheEntriesAndRemoveAnythingThatDidNotHappen.
  ///
  /// In pt_BR, this message translates to:
  /// **'A IA pode errar. Revise os registros e remova o que não aconteceu.'**
  String
  get diaryUiAICanMakeMistakesReviewTheEntriesAndRemoveAnythingThatDidNotHappen;

  /// No description provided for @diaryUiIHad2CoffeesAndWalkedFor20Minutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tomei 2 cafés e caminhei por 20 minutos…'**
  String get diaryUiIHad2CoffeesAndWalkedFor20Minutes;

  /// No description provided for @diaryUiStopListening.
  ///
  /// In pt_BR, this message translates to:
  /// **'Parar de ouvir'**
  String get diaryUiStopListening;

  /// No description provided for @diaryUiSpeak.
  ///
  /// In pt_BR, this message translates to:
  /// **'Falar'**
  String get diaryUiSpeak;

  /// No description provided for @diaryUiNoEntriesIdentifiedTryDescribingItDifferently.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum registro identificado. Tente descrever de outra forma.'**
  String get diaryUiNoEntriesIdentifiedTryDescribingItDifferently;

  /// No description provided for @diaryUiRemove.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remover'**
  String get diaryUiRemove;

  /// No description provided for @diaryUiReviewEntries.
  ///
  /// In pt_BR, this message translates to:
  /// **'Revisar registros'**
  String get diaryUiReviewEntries;

  /// No description provided for @diaryUiAddToDay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar ao dia'**
  String get diaryUiAddToDay;

  /// No description provided for @diaryUiCouldNotSaveTryAgain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível salvar. Tente novamente.'**
  String get diaryUiCouldNotSaveTryAgain;

  /// No description provided for @diaryUiWhatToTrack.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que acompanhar'**
  String get diaryUiWhatToTrack;

  /// No description provided for @diaryUiRetry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tentar novamente'**
  String get diaryUiRetry;

  /// No description provided for @diaryUiAll.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todos'**
  String get diaryUiAll;

  /// No description provided for @diaryUiCreateYourHabit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar o seu hábito'**
  String get diaryUiCreateYourHabit;

  /// No description provided for @diaryUiSave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvar'**
  String get diaryUiSave;

  /// No description provided for @diaryUiCouldNotCreateThisHabitTryAgain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível criar o hábito. Tente novamente.'**
  String get diaryUiCouldNotCreateThisHabitTryAgain;

  /// No description provided for @diaryUiWhatWouldYouLikeToTrack.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você quer acompanhar?'**
  String get diaryUiWhatWouldYouLikeToTrack;

  /// No description provided for @diaryUiHabitName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome do hábito'**
  String get diaryUiHabitName;

  /// No description provided for @diaryUiResponseType.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como responder'**
  String get diaryUiResponseType;

  /// No description provided for @diaryUiYesOrNo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sim ou não'**
  String get diaryUiYesOrNo;

  /// No description provided for @diaryUiQuantity.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quantidade'**
  String get diaryUiQuantity;

  /// No description provided for @diaryUiUnitMlMinTimes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Unidade (ml, min, vezes…)'**
  String get diaryUiUnitMlMinTimes;

  /// No description provided for @diaryUiCreateHabit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar hábito'**
  String get diaryUiCreateHabit;

  /// No description provided for @diaryUiYourChapters.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus capítulos'**
  String get diaryUiYourChapters;

  /// No description provided for @diaryUiYourChaptersWillAppearAsYouRecordYourDays.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus capítulos vão aparecer conforme você registra seus dias.'**
  String get diaryUiYourChaptersWillAppearAsYouRecordYourDays;

  /// No description provided for @diaryUiChapter.
  ///
  /// In pt_BR, this message translates to:
  /// **'Capítulo'**
  String get diaryUiChapter;

  /// No description provided for @diaryUiByTheNumbers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Em números'**
  String get diaryUiByTheNumbers;

  /// No description provided for @diaryUiRecordedDays.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dias registrados'**
  String get diaryUiRecordedDays;

  /// No description provided for @diaryUiMoments.
  ///
  /// In pt_BR, this message translates to:
  /// **'Momentos'**
  String get diaryUiMoments;

  /// No description provided for @diaryUiAchievements.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conquistas'**
  String get diaryUiAchievements;

  /// No description provided for @diaryUiCouldNotAttachThePhotoUseAJPGPNGUpTo2MB.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível adicionar a foto. Use uma imagem JPG/PNG de até 2 MB.'**
  String get diaryUiCouldNotAttachThePhotoUseAJPGPNGUpTo2MB;

  /// No description provided for @diaryUiEnterAName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe o nome.'**
  String get diaryUiEnterAName;

  /// No description provided for @diaryUiCheckTheNutritionValues.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confira os valores nutricionais.'**
  String get diaryUiCheckTheNutritionValues;

  /// No description provided for @diaryUiDeleteEntry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Excluir registro'**
  String get diaryUiDeleteEntry;

  /// No description provided for @diaryUiWhatDidYouEat.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você comeu?'**
  String get diaryUiWhatDidYouEat;

  /// No description provided for @diaryUiFindAMeal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar refeição'**
  String get diaryUiFindAMeal;

  /// No description provided for @diaryUiFoodsAndAmounts.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alimentos e quantidades'**
  String get diaryUiFoodsAndAmounts;

  /// No description provided for @diaryUiNutrition.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informações nutricionais'**
  String get diaryUiNutrition;

  /// No description provided for @diaryUiValuesEnteredByYouOrFromTheSelectedMealAdjustForYourPortion.
  ///
  /// In pt_BR, this message translates to:
  /// **'Valores informados por você ou pela refeição escolhida. Ajuste conforme a porção.'**
  String get diaryUiValuesEnteredByYouOrFromTheSelectedMealAdjustForYourPortion;

  /// No description provided for @diaryUiProteinG.
  ///
  /// In pt_BR, this message translates to:
  /// **'Proteína (g)'**
  String get diaryUiProteinG;

  /// No description provided for @diaryUiCarbsG.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carboidratos (g)'**
  String get diaryUiCarbsG;

  /// No description provided for @diaryUiFatG.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gordura (g)'**
  String get diaryUiFatG;

  /// No description provided for @diaryUiRemovePhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remover foto'**
  String get diaryUiRemovePhoto;

  /// No description provided for @diaryUiTakeAPhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tirar foto'**
  String get diaryUiTakeAPhoto;

  /// No description provided for @diaryUiGallery.
  ///
  /// In pt_BR, this message translates to:
  /// **'Galeria'**
  String get diaryUiGallery;

  /// No description provided for @diaryUiEntry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registro'**
  String get diaryUiEntry;

  /// No description provided for @diaryUiDetails.
  ///
  /// In pt_BR, this message translates to:
  /// **'Detalhes'**
  String get diaryUiDetails;

  /// No description provided for @diaryUiTime.
  ///
  /// In pt_BR, this message translates to:
  /// **'Horário'**
  String get diaryUiTime;

  /// No description provided for @diaryUiDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Concluir'**
  String get diaryUiDone;

  /// No description provided for @diaryUiSearchFoods.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar alimentos'**
  String get diaryUiSearchFoods;

  /// No description provided for @diaryUiYourAccountChangedReopenTheDiary.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua conta mudou. Abra o Diário novamente.'**
  String get diaryUiYourAccountChangedReopenTheDiary;

  /// No description provided for @diaryUiDaySaved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dia salvo'**
  String get diaryUiDaySaved;

  /// No description provided for @diaryUiTimeline.
  ///
  /// In pt_BR, this message translates to:
  /// **'Linha do tempo'**
  String get diaryUiTimeline;

  /// No description provided for @diaryUiDiary.
  ///
  /// In pt_BR, this message translates to:
  /// **'Diário'**
  String get diaryUiDiary;

  /// No description provided for @diaryUiWhatHappenedToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que aconteceu hoje?'**
  String get diaryUiWhatHappenedToday;

  /// No description provided for @diaryUiWhatHappenedYesterday.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que aconteceu ontem?'**
  String get diaryUiWhatHappenedYesterday;

  /// No description provided for @diaryUiToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hoje'**
  String get diaryUiToday;

  /// No description provided for @diaryUiYesterday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ontem'**
  String get diaryUiYesterday;

  /// No description provided for @diaryUiMoments2.
  ///
  /// In pt_BR, this message translates to:
  /// **'momentos'**
  String get diaryUiMoments2;

  /// No description provided for @diaryUiYourDayBeginsWithAnEntry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu dia começa com um registro.'**
  String get diaryUiYourDayBeginsWithAnEntry;

  /// No description provided for @diaryUiNotes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Notas'**
  String get diaryUiNotes;

  /// No description provided for @diaryUiYouCanEditThePast7Days.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você pode editar os últimos 7 dias.'**
  String get diaryUiYouCanEditThePast7Days;

  /// No description provided for @diaryUiCouldNotSavePleaseTryAgain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível salvar. Tente novamente.'**
  String get diaryUiCouldNotSavePleaseTryAgain;

  /// No description provided for @diaryUiYourDiary.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu Diário'**
  String get diaryUiYourDiary;

  /// No description provided for @diaryUiThisDayIsReadOnly.
  ///
  /// In pt_BR, this message translates to:
  /// **'Este dia está fechado para edição.'**
  String get diaryUiThisDayIsReadOnly;

  /// No description provided for @diaryUiThisDayChangedElsewhereCloseAndRefreshBeforeSaving.
  ///
  /// In pt_BR, this message translates to:
  /// **'Este dia foi alterado em outro lugar. Feche e atualize antes de salvar.'**
  String get diaryUiThisDayChangedElsewhereCloseAndRefreshBeforeSaving;

  /// No description provided for @diaryUiCouldNotSaveYourDraftIsStillHere.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível salvar. Seu rascunho continua aqui.'**
  String get diaryUiCouldNotSaveYourDraftIsStillHere;

  /// No description provided for @diaryUiYourHabits.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus hábitos'**
  String get diaryUiYourHabits;

  /// No description provided for @diaryUiOf.
  ///
  /// In pt_BR, this message translates to:
  /// **'de'**
  String get diaryUiOf;

  /// No description provided for @diaryUiAddHabit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar hábito'**
  String get diaryUiAddHabit;

  /// No description provided for @diaryUiHowWasYourDay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como foi o dia'**
  String get diaryUiHowWasYourDay;

  /// No description provided for @diaryUiHowWasYourDay2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como foi o seu dia'**
  String get diaryUiHowWasYourDay2;

  /// No description provided for @diaryUiMoodEnergyStressAndASentence.
  ///
  /// In pt_BR, this message translates to:
  /// **'Humor, disposição, estresse e uma frase'**
  String get diaryUiMoodEnergyStressAndASentence;

  /// No description provided for @diaryUiThisDayIsClosedYouCanEditUpTo7DaysLater.
  ///
  /// In pt_BR, this message translates to:
  /// **'Este dia já fechou. Dá para mudar só até 7 dias depois.'**
  String get diaryUiThisDayIsClosedYouCanEditUpTo7DaysLater;

  /// No description provided for @diaryUiRecord.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registrar'**
  String get diaryUiRecord;

  /// No description provided for @diaryUiCouldNotSaveYourChangesAreKeptHereRetryOrDiscardToLeave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível salvar. Suas alterações continuam aqui. Tente novamente ou descarte para sair.'**
  String get diaryUiCouldNotSaveYourChangesAreKeptHereRetryOrDiscardToLeave;

  /// No description provided for @diaryUiDiscard.
  ///
  /// In pt_BR, this message translates to:
  /// **'Descartar'**
  String get diaryUiDiscard;

  /// No description provided for @diaryUiNo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não'**
  String get diaryUiNo;

  /// No description provided for @diaryUiYes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sim'**
  String get diaryUiYes;

  /// No description provided for @diaryUiAnswer.
  ///
  /// In pt_BR, this message translates to:
  /// **'Responder'**
  String get diaryUiAnswer;

  /// No description provided for @diaryUiASentenceAboutYourDay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma frase sobre o dia'**
  String get diaryUiASentenceAboutYourDay;

  /// No description provided for @diaryUiOnlyYouCanSeeThisHowWasYourDay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Só você vê. Como foi seu dia?'**
  String get diaryUiOnlyYouCanSeeThisHowWasYourDay;

  /// No description provided for @diaryUiTellUsAboutYourDayReviewBeforeSaving.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conte como foi. Ela marca tudo aqui para você.'**
  String get diaryUiTellUsAboutYourDayReviewBeforeSaving;

  /// No description provided for @diaryUiWrite.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escrever'**
  String get diaryUiWrite;

  /// No description provided for @diaryUiDidNotHappen.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não aconteceu'**
  String get diaryUiDidNotHappen;

  /// No description provided for @diaryValueRecorded.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feito'**
  String get diaryValueRecorded;

  /// No description provided for @diaryValueDidNotHappen.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não aconteceu'**
  String get diaryValueDidNotHappen;

  /// No description provided for @diaryValueTimes.
  ///
  /// In pt_BR, this message translates to:
  /// **'vezes'**
  String get diaryValueTimes;

  /// No description provided for @diaryValueCups.
  ///
  /// In pt_BR, this message translates to:
  /// **'xícaras'**
  String get diaryValueCups;

  /// No description provided for @diaryValueMeals.
  ///
  /// In pt_BR, this message translates to:
  /// **'refeições'**
  String get diaryValueMeals;

  /// No description provided for @diaryValueOutOfTen.
  ///
  /// In pt_BR, this message translates to:
  /// **'de 10'**
  String get diaryValueOutOfTen;

  /// No description provided for @diaryPortionLight.
  ///
  /// In pt_BR, this message translates to:
  /// **'Leve'**
  String get diaryPortionLight;

  /// No description provided for @diaryPortionNormal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Normal'**
  String get diaryPortionNormal;

  /// No description provided for @diaryPortionHeavy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pesado'**
  String get diaryPortionHeavy;

  /// No description provided for @diaryLoadFailed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível carregar o Diário. Tente novamente.'**
  String get diaryLoadFailed;

  /// No description provided for @diaryFatAbbreviation.
  ///
  /// In pt_BR, this message translates to:
  /// **'G'**
  String get diaryFatAbbreviation;

  /// No description provided for @diaryDateRange.
  ///
  /// In pt_BR, this message translates to:
  /// **'{start} a {end}'**
  String diaryDateRange(String start, String end);

  /// No description provided for @diaryCatalogSearch.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar entre {count}'**
  String diaryCatalogSearch(int count);

  /// No description provided for @diaryChooseCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha entre {count}'**
  String diaryChooseCount(int count);

  /// No description provided for @diaryGroupFood.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alimentação'**
  String get diaryGroupFood;

  /// No description provided for @diaryGroupSelfCare.
  ///
  /// In pt_BR, this message translates to:
  /// **'Autocuidado'**
  String get diaryGroupSelfCare;

  /// No description provided for @diaryGroupDrinks.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bebidas'**
  String get diaryGroupDrinks;

  /// No description provided for @diaryGroupMentalWellBeing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bem-estar mental'**
  String get diaryGroupMentalWellBeing;

  /// No description provided for @diaryGroupSubstancesAndMedication.
  ///
  /// In pt_BR, this message translates to:
  /// **'Drogas e medicação'**
  String get diaryGroupSubstancesAndMedication;

  /// No description provided for @diaryGroupMovement.
  ///
  /// In pt_BR, this message translates to:
  /// **'Movimento'**
  String get diaryGroupMovement;

  /// No description provided for @diaryGroupRecovery.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recuperação'**
  String get diaryGroupRecovery;

  /// No description provided for @diaryGroupMeals.
  ///
  /// In pt_BR, this message translates to:
  /// **'Refeições'**
  String get diaryGroupMeals;

  /// No description provided for @diaryGroupRoutineAndLeisure.
  ///
  /// In pt_BR, this message translates to:
  /// **'Rotina e lazer'**
  String get diaryGroupRoutineAndLeisure;

  /// No description provided for @diaryGroupHealth.
  ///
  /// In pt_BR, this message translates to:
  /// **'Saúde'**
  String get diaryGroupHealth;

  /// No description provided for @diaryGroupHealthAndSymptoms.
  ///
  /// In pt_BR, this message translates to:
  /// **'Saúde e sintomas'**
  String get diaryGroupHealthAndSymptoms;

  /// No description provided for @diaryGroupHormonalHealth.
  ///
  /// In pt_BR, this message translates to:
  /// **'Saúde hormonal'**
  String get diaryGroupHormonalHealth;

  /// No description provided for @diaryGroupSleepAndRhythm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sono e ritmo'**
  String get diaryGroupSleepAndRhythm;

  /// No description provided for @diaryGroupSupplements.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suplementos'**
  String get diaryGroupSupplements;

  /// No description provided for @diaryGroupScreensAndFocus.
  ///
  /// In pt_BR, this message translates to:
  /// **'Telas e foco'**
  String get diaryGroupScreensAndFocus;

  /// No description provided for @diaryGroupYourHabits.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus hábitos'**
  String get diaryGroupYourHabits;

  /// No description provided for @diaryScaleAcordou0.
  ///
  /// In pt_BR, this message translates to:
  /// **'Muito cansado'**
  String get diaryScaleAcordou0;

  /// No description provided for @diaryScaleAcordou1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cansado'**
  String get diaryScaleAcordou1;

  /// No description provided for @diaryScaleAcordou2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ok'**
  String get diaryScaleAcordou2;

  /// No description provided for @diaryScaleAcordou3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bem'**
  String get diaryScaleAcordou3;

  /// No description provided for @diaryScaleAcordou4.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ótimo'**
  String get diaryScaleAcordou4;

  /// No description provided for @diaryScaleHumor0.
  ///
  /// In pt_BR, this message translates to:
  /// **'Muito mal'**
  String get diaryScaleHumor0;

  /// No description provided for @diaryScaleHumor1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mal'**
  String get diaryScaleHumor1;

  /// No description provided for @diaryScaleHumor2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Neutro'**
  String get diaryScaleHumor2;

  /// No description provided for @diaryScaleHumor3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bem'**
  String get diaryScaleHumor3;

  /// No description provided for @diaryScaleHumor4.
  ///
  /// In pt_BR, this message translates to:
  /// **'Muito bem'**
  String get diaryScaleHumor4;

  /// No description provided for @diaryScaleEnergia0.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem energia'**
  String get diaryScaleEnergia0;

  /// No description provided for @diaryScaleEnergia1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Baixa'**
  String get diaryScaleEnergia1;

  /// No description provided for @diaryScaleEnergia2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ok'**
  String get diaryScaleEnergia2;

  /// No description provided for @diaryScaleEnergia3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Boa'**
  String get diaryScaleEnergia3;

  /// No description provided for @diaryScaleEnergia4.
  ///
  /// In pt_BR, this message translates to:
  /// **'Muita'**
  String get diaryScaleEnergia4;

  /// No description provided for @diaryScaleEstresse0.
  ///
  /// In pt_BR, this message translates to:
  /// **'Muito alto'**
  String get diaryScaleEstresse0;

  /// No description provided for @diaryScaleEstresse1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alto'**
  String get diaryScaleEstresse1;

  /// No description provided for @diaryScaleEstresse2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Médio'**
  String get diaryScaleEstresse2;

  /// No description provided for @diaryScaleEstresse3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pouco'**
  String get diaryScaleEstresse3;

  /// No description provided for @diaryScaleEstresse4.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum'**
  String get diaryScaleEstresse4;

  /// No description provided for @diaryReferenceLettuce.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alface'**
  String get diaryReferenceLettuce;

  /// No description provided for @diaryReferenceRice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Arroz'**
  String get diaryReferenceRice;

  /// No description provided for @diaryReferenceWhiteRice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Arroz branco'**
  String get diaryReferenceWhiteRice;

  /// No description provided for @diaryReferenceFries.
  ///
  /// In pt_BR, this message translates to:
  /// **'Batata frita'**
  String get diaryReferenceFries;

  /// No description provided for @diaryReferenceShoestringPotatoes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Batata palha'**
  String get diaryReferenceShoestringPotatoes;

  /// No description provided for @diaryReferenceSweetPotato.
  ///
  /// In pt_BR, this message translates to:
  /// **'Batata-doce'**
  String get diaryReferenceSweetPotato;

  /// No description provided for @diaryReferenceSteakWithOnions.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bife acebolado'**
  String get diaryReferenceSteakWithOnions;

  /// No description provided for @diaryReferenceCarrotCakeWithFrosting.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bolo de cenoura com cobertura'**
  String get diaryReferenceCarrotCakeWithFrosting;

  /// No description provided for @diaryReferenceBroccoli.
  ///
  /// In pt_BR, this message translates to:
  /// **'Brócolis'**
  String get diaryReferenceBroccoli;

  /// No description provided for @diaryReferenceCoffee.
  ///
  /// In pt_BR, this message translates to:
  /// **'Café'**
  String get diaryReferenceCoffee;

  /// No description provided for @diaryReferenceCoffeeWithMilk.
  ///
  /// In pt_BR, this message translates to:
  /// **'Café com leite'**
  String get diaryReferenceCoffeeWithMilk;

  /// No description provided for @diaryReferenceUnsweetenedCoffee.
  ///
  /// In pt_BR, this message translates to:
  /// **'Café sem açúcar'**
  String get diaryReferenceUnsweetenedCoffee;

  /// No description provided for @diaryReferenceSautedCollardGreens.
  ///
  /// In pt_BR, this message translates to:
  /// **'Couve refogada'**
  String get diaryReferenceSautedCollardGreens;

  /// No description provided for @diaryReferenceCouscousWithButter.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cuscuz com manteiga'**
  String get diaryReferenceCouscousWithButter;

  /// No description provided for @diaryReferenceToastedCassavaFlour.
  ///
  /// In pt_BR, this message translates to:
  /// **'Farofa'**
  String get diaryReferenceToastedCassavaFlour;

  /// No description provided for @diaryReferenceBeans.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feijão'**
  String get diaryReferenceBeans;

  /// No description provided for @diaryReferenceBlackBeans.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feijão preto'**
  String get diaryReferenceBlackBeans;

  /// No description provided for @diaryReferenceGrilledChicken.
  ///
  /// In pt_BR, this message translates to:
  /// **'Frango grelhado'**
  String get diaryReferenceGrilledChicken;

  /// No description provided for @diaryReferenceBerries.
  ///
  /// In pt_BR, this message translates to:
  /// **'Frutas vermelhas'**
  String get diaryReferenceBerries;

  /// No description provided for @diaryReferenceGinger.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gengibre'**
  String get diaryReferenceGinger;

  /// No description provided for @diaryReferenceBurger.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hambúrguer'**
  String get diaryReferenceBurger;

  /// No description provided for @diaryReferencePlainYogurt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Iogurte natural'**
  String get diaryReferencePlainYogurt;

  /// No description provided for @diaryReferenceOrange.
  ///
  /// In pt_BR, this message translates to:
  /// **'Laranja'**
  String get diaryReferenceOrange;

  /// No description provided for @diaryReferenceVegetables.
  ///
  /// In pt_BR, this message translates to:
  /// **'Legumes'**
  String get diaryReferenceVegetables;

  /// No description provided for @diaryReferenceLemon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Limão'**
  String get diaryReferenceLemon;

  /// No description provided for @diaryReferencePasta.
  ///
  /// In pt_BR, this message translates to:
  /// **'Macarrão'**
  String get diaryReferencePasta;

  /// No description provided for @diaryReferencePapaya.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mamão'**
  String get diaryReferencePapaya;

  /// No description provided for @diaryReferenceApple.
  ///
  /// In pt_BR, this message translates to:
  /// **'Maçã'**
  String get diaryReferenceApple;

  /// No description provided for @diaryReferenceSauce.
  ///
  /// In pt_BR, this message translates to:
  /// **'Molho'**
  String get diaryReferenceSauce;

  /// No description provided for @diaryReferenceMeatSauce.
  ///
  /// In pt_BR, this message translates to:
  /// **'Molho de carne'**
  String get diaryReferenceMeatSauce;

  /// No description provided for @diaryReferenceStrawberry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Morango'**
  String get diaryReferenceStrawberry;

  /// No description provided for @diaryReferenceOmelet.
  ///
  /// In pt_BR, this message translates to:
  /// **'Omelete'**
  String get diaryReferenceOmelet;

  /// No description provided for @diaryReferenceBoiledEgg.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ovo cozido'**
  String get diaryReferenceBoiledEgg;

  /// No description provided for @diaryReferenceFriedEgg.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ovo frito'**
  String get diaryReferenceFriedEgg;

  /// No description provided for @diaryReferenceScrambledEggs.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ovos mexidos'**
  String get diaryReferenceScrambledEggs;

  /// No description provided for @diaryReferenceCucumber.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pepino'**
  String get diaryReferenceCucumber;

  /// No description provided for @diaryReferenceCalabreseSausagePizza.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pizza de calabresa'**
  String get diaryReferenceCalabreseSausagePizza;

  /// No description provided for @diaryReferenceBrazilianCheeseBread.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pão de queijo'**
  String get diaryReferenceBrazilianCheeseBread;

  /// No description provided for @diaryReferenceBreadRollWithButter.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pão francês com manteiga'**
  String get diaryReferenceBreadRollWithButter;

  /// No description provided for @diaryReferenceWholeWheatBread.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pão integral'**
  String get diaryReferenceWholeWheatBread;

  /// No description provided for @diaryReferenceFreshWhiteCheese.
  ///
  /// In pt_BR, this message translates to:
  /// **'Queijo branco'**
  String get diaryReferenceFreshWhiteCheese;

  /// No description provided for @diaryReferenceCoalhoCheese.
  ///
  /// In pt_BR, this message translates to:
  /// **'Queijo coalho'**
  String get diaryReferenceCoalhoCheese;

  /// No description provided for @diaryReferenceGratedCheese.
  ///
  /// In pt_BR, this message translates to:
  /// **'Queijo ralado'**
  String get diaryReferenceGratedCheese;

  /// No description provided for @diaryReferenceTomatoSalad.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salada com tomate'**
  String get diaryReferenceTomatoSalad;

  /// No description provided for @diaryReferenceGreenSalad.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salada verde'**
  String get diaryReferenceGreenSalad;

  /// No description provided for @diaryReferenceGrilledSalmon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salmão grelhado'**
  String get diaryReferenceGrilledSalmon;

  /// No description provided for @diaryReferenceFreshSandwich.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sanduíche natural'**
  String get diaryReferenceFreshSandwich;

  /// No description provided for @diaryReferenceSoySauce.
  ///
  /// In pt_BR, this message translates to:
  /// **'Shoyu'**
  String get diaryReferenceSoySauce;

  /// No description provided for @diaryReferencePumpkinSoup.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sopa de abóbora'**
  String get diaryReferencePumpkinSoup;

  /// No description provided for @diaryReferenceBeefStroganoff.
  ///
  /// In pt_BR, this message translates to:
  /// **'Strogonoff de carne'**
  String get diaryReferenceBeefStroganoff;

  /// No description provided for @diaryReferenceJuice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suco'**
  String get diaryReferenceJuice;

  /// No description provided for @diaryReferenceAssortedSushi.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sushi variado'**
  String get diaryReferenceAssortedSushi;

  /// No description provided for @diaryReferenceTapiocaWithEgg.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tapioca com ovo'**
  String get diaryReferenceTapiocaWithEgg;

  /// No description provided for @diaryReferenceToast.
  ///
  /// In pt_BR, this message translates to:
  /// **'Torrada'**
  String get diaryReferenceToast;

  /// No description provided for @diaryReferenceGrapes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uvas'**
  String get diaryReferenceGrapes;

  /// No description provided for @diaryReference1Spoonful.
  ///
  /// In pt_BR, this message translates to:
  /// **'1 colher'**
  String get diaryReference1Spoonful;

  /// No description provided for @diaryReference1Slice.
  ///
  /// In pt_BR, this message translates to:
  /// **'1 fatia'**
  String get diaryReference1Slice;

  /// No description provided for @diaryReference1Egg.
  ///
  /// In pt_BR, this message translates to:
  /// **'1 ovo'**
  String get diaryReference1Egg;

  /// No description provided for @diaryReference1Piece.
  ///
  /// In pt_BR, this message translates to:
  /// **'1 unidade'**
  String get diaryReference1Piece;

  /// No description provided for @diaryReference1Cup.
  ///
  /// In pt_BR, this message translates to:
  /// **'1 xícara'**
  String get diaryReference1Cup;

  /// No description provided for @diaryReference10Pieces.
  ///
  /// In pt_BR, this message translates to:
  /// **'10 peças'**
  String get diaryReference10Pieces;

  /// No description provided for @diaryReference2Slices.
  ///
  /// In pt_BR, this message translates to:
  /// **'2 fatias'**
  String get diaryReference2Slices;

  /// No description provided for @diaryReference2Eggs.
  ///
  /// In pt_BR, this message translates to:
  /// **'2 ovos'**
  String get diaryReference2Eggs;

  /// No description provided for @diaryReference2Pieces.
  ///
  /// In pt_BR, this message translates to:
  /// **'2 unidades'**
  String get diaryReference2Pieces;

  /// No description provided for @diaryReference3Slices.
  ///
  /// In pt_BR, this message translates to:
  /// **'3 fatias'**
  String get diaryReference3Slices;

  /// No description provided for @diaryReference3Eggs.
  ///
  /// In pt_BR, this message translates to:
  /// **'3 ovos'**
  String get diaryReference3Eggs;

  /// No description provided for @diaryReference3Pieces.
  ///
  /// In pt_BR, this message translates to:
  /// **'3 unidades'**
  String get diaryReference3Pieces;

  /// No description provided for @diaryReference4Segments.
  ///
  /// In pt_BR, this message translates to:
  /// **'4 gomos'**
  String get diaryReference4Segments;

  /// No description provided for @diaryReference4Pieces.
  ///
  /// In pt_BR, this message translates to:
  /// **'4 unidades'**
  String get diaryReference4Pieces;

  /// No description provided for @diaryReferenceTheBeginning.
  ///
  /// In pt_BR, this message translates to:
  /// **'O começo'**
  String get diaryReferenceTheBeginning;

  /// No description provided for @diaryReferenceTheBandLearnsWhoYouAreOver11DaysHrvRangedFrom54To66MsThatIsWhereYourBaselineBegins.
  ///
  /// In pt_BR, this message translates to:
  /// **'A pulseira aprende quem você é. Em 11 dias a VFC ficou entre 54 e 66 ms. É daí que nasce o seu normal.'**
  String
  get diaryReferenceTheBandLearnsWhoYouAreOver11DaysHrvRangedFrom54To66MsThatIsWhereYourBaselineBegins;

  /// No description provided for @diaryReferenceSep11ToSep2111Days.
  ///
  /// In pt_BR, this message translates to:
  /// **'11 set a 21 set · 11 dias'**
  String get diaryReferenceSep11ToSep2111Days;

  /// No description provided for @diaryReferenceAverageHrv.
  ///
  /// In pt_BR, this message translates to:
  /// **'VFC média'**
  String get diaryReferenceAverageHrv;

  /// No description provided for @diaryReferenceWorkouts.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treinos'**
  String get diaryReferenceWorkouts;

  /// No description provided for @diaryReferenceSleep.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sono'**
  String get diaryReferenceSleep;

  /// No description provided for @diaryReferenceYouSleepBetterAround11Pm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você dorme melhor perto das 23h'**
  String get diaryReferenceYouSleepBetterAround11Pm;

  /// No description provided for @diaryReferenceSep18ByndLearned.
  ///
  /// In pt_BR, this message translates to:
  /// **'18 set · A BYND aprendeu'**
  String get diaryReferenceSep18ByndLearned;

  /// No description provided for @diaryReferenceDay1StartedWithTheBand.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dia 1: começou com a pulseira'**
  String get diaryReferenceDay1StartedWithTheBand;

  /// No description provided for @diaryReferenceSep11Milestone.
  ///
  /// In pt_BR, this message translates to:
  /// **'11 set · Marco'**
  String get diaryReferenceSep11Milestone;

  /// No description provided for @diaryReferenceTheCold.
  ///
  /// In pt_BR, this message translates to:
  /// **'O resfriado'**
  String get diaryReferenceTheCold;

  /// No description provided for @diaryReferenceYourBodyGaveAWarningTwoDaysEarlierBreathingRoseOnTheNightsOfSep23And24YourThroatOnlyF.
  ///
  /// In pt_BR, this message translates to:
  /// **'O corpo avisou dois dias antes. A respiração subiu nas noites de 23 e 24/09; a garganta só arranhou em 25/09. Cinco dias sem treino.'**
  String
  get diaryReferenceYourBodyGaveAWarningTwoDaysEarlierBreathingRoseOnTheNightsOfSep23And24YourThroatOnlyF;

  /// No description provided for @diaryReferenceSep22ToSep298Days.
  ///
  /// In pt_BR, this message translates to:
  /// **'22 set a 29 set · 8 dias'**
  String get diaryReferenceSep22ToSep298Days;

  /// No description provided for @diaryReferenceBreathing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respiração'**
  String get diaryReferenceBreathing;

  /// No description provided for @diaryReference164Rpm.
  ///
  /// In pt_BR, this message translates to:
  /// **'16,4rpm'**
  String get diaryReference164Rpm;

  /// No description provided for @diaryReferenceRecovery.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recuperação'**
  String get diaryReferenceRecovery;

  /// No description provided for @diaryReferenceNoTraining.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem treino'**
  String get diaryReferenceNoTraining;

  /// No description provided for @diaryReference5Days.
  ///
  /// In pt_BR, this message translates to:
  /// **'5dias'**
  String get diaryReference5Days;

  /// No description provided for @diaryReferenceBestNight.
  ///
  /// In pt_BR, this message translates to:
  /// **'Melhor noite'**
  String get diaryReferenceBestNight;

  /// No description provided for @diaryReferenceSep28.
  ///
  /// In pt_BR, this message translates to:
  /// **'28 set'**
  String get diaryReferenceSep28;

  /// No description provided for @diaryReferenceColdSpotted2DaysEarlier.
  ///
  /// In pt_BR, this message translates to:
  /// **'Resfriado, visto 2 dias antes'**
  String get diaryReferenceColdSpotted2DaysEarlier;

  /// No description provided for @diaryReferenceSep23ToSep29Event.
  ///
  /// In pt_BR, this message translates to:
  /// **'23 set a 29 set · Evento'**
  String get diaryReferenceSep23ToSep29Event;

  /// No description provided for @diaryReferenceBackStronger.
  ///
  /// In pt_BR, this message translates to:
  /// **'De volta, mais forte'**
  String get diaryReferenceBackStronger;

  /// No description provided for @diaryReferenceTheBestStretchOfTheTwoMonthsRecoveryReached91OnOct1ItOnlyFellOnAThursdayAfterWineThat.
  ///
  /// In pt_BR, this message translates to:
  /// **'A melhor fase dos dois meses. A recuperação chegou a 91 em 1 out. Só caiu numa quinta depois do vinho: foi quando a BYND achou esse padrão.'**
  String
  get diaryReferenceTheBestStretchOfTheTwoMonthsRecoveryReached91OnOct1ItOnlyFellOnAThursdayAfterWineThat;

  /// No description provided for @diaryReferenceSep30ToOct1516Days.
  ///
  /// In pt_BR, this message translates to:
  /// **'30 set a 15 out · 16 dias'**
  String get diaryReferenceSep30ToOct1516Days;

  /// No description provided for @diaryReferenceBest.
  ///
  /// In pt_BR, this message translates to:
  /// **'Melhor'**
  String get diaryReferenceBest;

  /// No description provided for @diaryReferenceRuns.
  ///
  /// In pt_BR, this message translates to:
  /// **'Corridas'**
  String get diaryReferenceRuns;

  /// No description provided for @diaryReferenceNewPattern.
  ///
  /// In pt_BR, this message translates to:
  /// **'Padrão novo'**
  String get diaryReferenceNewPattern;

  /// No description provided for @diaryReferenceWine.
  ///
  /// In pt_BR, this message translates to:
  /// **'vinho'**
  String get diaryReferenceWine;

  /// No description provided for @diaryReferenceBestRecovery.
  ///
  /// In pt_BR, this message translates to:
  /// **'Melhor recuperação'**
  String get diaryReferenceBestRecovery;

  /// No description provided for @diaryReferenceOct1.
  ///
  /// In pt_BR, this message translates to:
  /// **'1 out'**
  String get diaryReferenceOct1;

  /// No description provided for @diaryReference30DaysByndLearnedYourBaseline.
  ///
  /// In pt_BR, this message translates to:
  /// **'30 dias: a BYND aprendeu o seu normal'**
  String get diaryReference30DaysByndLearnedYourBaseline;

  /// No description provided for @diaryReferenceOct10Milestone.
  ///
  /// In pt_BR, this message translates to:
  /// **'10 out · Marco'**
  String get diaryReferenceOct10Milestone;

  /// No description provided for @diaryReferenceWednesdayWineTakesItsTollOnThursday.
  ///
  /// In pt_BR, this message translates to:
  /// **'O vinho de quarta cobra na quinta'**
  String get diaryReferenceWednesdayWineTakesItsTollOnThursday;

  /// No description provided for @diaryReferenceOct8ByndLearned.
  ///
  /// In pt_BR, this message translates to:
  /// **'8 out · A BYND aprendeu'**
  String get diaryReferenceOct8ByndLearned;

  /// No description provided for @diaryReferenceDeadlineWeek.
  ///
  /// In pt_BR, this message translates to:
  /// **'A semana de entrega'**
  String get diaryReferenceDeadlineWeek;

  /// No description provided for @diaryReferenceLittleSleepLotsOfCoffeeFourNightsPastMidnightAnd4CoffeesADayStressDoubledAndRecoveryF.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pouco sono, muito café. Quatro noites depois da meia-noite e 4 cafés por dia. O estresse dobrou e a recuperação caiu para 53.'**
  String
  get diaryReferenceLittleSleepLotsOfCoffeeFourNightsPastMidnightAnd4CoffeesADayStressDoubledAndRecoveryF;

  /// No description provided for @diaryReferenceOct16ToOct227Days.
  ///
  /// In pt_BR, this message translates to:
  /// **'16 out a 22 out · 7 dias'**
  String get diaryReferenceOct16ToOct227Days;

  /// No description provided for @diaryReferenceStress.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estresse'**
  String get diaryReferenceStress;

  /// No description provided for @diaryReferenceYourCycleIsRegularAt28Days.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu ciclo é regular, de 28 dias'**
  String get diaryReferenceYourCycleIsRegularAt28Days;

  /// No description provided for @diaryReferenceOct20ByndLearned.
  ///
  /// In pt_BR, this message translates to:
  /// **'20 out · A BYND aprendeu'**
  String get diaryReferenceOct20ByndLearned;

  /// No description provided for @diaryReferenceDeadlineWeekAtWork.
  ///
  /// In pt_BR, this message translates to:
  /// **'Semana de entrega no trabalho'**
  String get diaryReferenceDeadlineWeekAtWork;

  /// No description provided for @diaryReferenceOct16ToOct20Event.
  ///
  /// In pt_BR, this message translates to:
  /// **'16 out a 20 out · Evento'**
  String get diaryReferenceOct16ToOct20Event;

  /// No description provided for @diaryReferenceThe14Km.
  ///
  /// In pt_BR, this message translates to:
  /// **'Os 14 km'**
  String get diaryReferenceThe14Km;

  /// No description provided for @diaryReferenceRecordHrvAndYourLongestRunHrvReached73MsOnOct28ThenCameThreeHardWorkoutsInARowAndThe1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recorde de VFC e a corrida mais longa. A VFC bateu 73 ms em 28 out. Depois vieram três treinos fortes seguidos e os 14 km, e a VFC caiu para 46 na quinta.'**
  String
  get diaryReferenceRecordHrvAndYourLongestRunHrvReached73MsOnOct28ThenCameThreeHardWorkoutsInARowAndThe1;

  /// No description provided for @diaryReferenceOct23ToNov514Days.
  ///
  /// In pt_BR, this message translates to:
  /// **'23 out a 5 nov · 14 dias'**
  String get diaryReferenceOct23ToNov514Days;

  /// No description provided for @diaryReferenceRecordHrv.
  ///
  /// In pt_BR, this message translates to:
  /// **'VFC recorde'**
  String get diaryReferenceRecordHrv;

  /// No description provided for @diaryReferenceRun.
  ///
  /// In pt_BR, this message translates to:
  /// **'Corrida'**
  String get diaryReferenceRun;

  /// No description provided for @diaryReferenceOct28.
  ///
  /// In pt_BR, this message translates to:
  /// **'28 out'**
  String get diaryReferenceOct28;

  /// No description provided for @diaryReferenceLongestRun.
  ///
  /// In pt_BR, this message translates to:
  /// **'Corrida mais longa'**
  String get diaryReferenceLongestRun;

  /// No description provided for @diaryReferenceNov4.
  ///
  /// In pt_BR, this message translates to:
  /// **'4 nov'**
  String get diaryReferenceNov4;

  /// No description provided for @diaryReferenceMostActiveDay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dia mais ativo'**
  String get diaryReferenceMostActiveDay;

  /// No description provided for @diaryReference21950Steps.
  ///
  /// In pt_BR, this message translates to:
  /// **'21.950passos'**
  String get diaryReference21950Steps;

  /// No description provided for @diaryReferenceNightsOnSchedule.
  ///
  /// In pt_BR, this message translates to:
  /// **'Noites no horário'**
  String get diaryReferenceNightsOnSchedule;

  /// No description provided for @diaryReferenceNov1.
  ///
  /// In pt_BR, this message translates to:
  /// **'1 nov'**
  String get diaryReferenceNov1;

  /// No description provided for @diaryReference4Of8.
  ///
  /// In pt_BR, this message translates to:
  /// **'4de 8'**
  String get diaryReference4Of8;

  /// No description provided for @diaryReferenceThreeHardWorkoutsInARow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Três treinos fortes seguidos'**
  String get diaryReferenceThreeHardWorkoutsInARow;

  /// No description provided for @diaryReferenceNov3ToNov5Event.
  ///
  /// In pt_BR, this message translates to:
  /// **'3 nov a 5 nov · Evento'**
  String get diaryReferenceNov3ToNov5Event;

  /// No description provided for @diaryReferenceJoinedTheBedBy11PmChallenge.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrou no desafio “Deitar até 23h”'**
  String get diaryReferenceJoinedTheBedBy11PmChallenge;

  /// No description provided for @diaryReferenceNov1Milestone.
  ///
  /// In pt_BR, this message translates to:
  /// **'1 nov · Marco'**
  String get diaryReferenceNov1Milestone;

  /// No description provided for @diaryReferenceStressRisesWithShortSleep.
  ///
  /// In pt_BR, this message translates to:
  /// **'O estresse sobe com o sono curto'**
  String get diaryReferenceStressRisesWithShortSleep;

  /// No description provided for @diaryReferenceOct23ByndLearned.
  ///
  /// In pt_BR, this message translates to:
  /// **'23 out · A BYND aprendeu'**
  String get diaryReferenceOct23ByndLearned;

  /// No description provided for @diaryReferenceWokeUp.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acordou'**
  String get diaryReferenceWokeUp;

  /// No description provided for @diaryReference7H42OfSleepScore82MeasuredByTheBand.
  ///
  /// In pt_BR, this message translates to:
  /// **'7h42 de sono · nota 82 · medido pela pulseira'**
  String get diaryReference7H42OfSleepScore82MeasuredByTheBand;

  /// No description provided for @diaryReferenceLightWorkoutMobilityAndStrength.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino leve · mobilidade e força'**
  String get diaryReferenceLightWorkoutMobilityAndStrength;

  /// No description provided for @diaryReference35MinLoad28MeasuredByTheBand.
  ///
  /// In pt_BR, this message translates to:
  /// **'35 min · carga 28 · medido pela pulseira'**
  String get diaryReference35MinLoad28MeasuredByTheBand;

  /// No description provided for @diaryReference74OutOf100ReadyToTrainMeasuredByTheBand.
  ///
  /// In pt_BR, this message translates to:
  /// **'74 de 100 · boa para treinar · medido pela pulseira'**
  String get diaryReference74OutOf100ReadyToTrainMeasuredByTheBand;

  /// No description provided for @diaryReferenceHalfwayToYourStepGoal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Metade da meta de passos'**
  String get diaryReferenceHalfwayToYourStepGoal;

  /// No description provided for @diaryReference5000StepsMeasuredByTheBand.
  ///
  /// In pt_BR, this message translates to:
  /// **'5.000 passos · medido pela pulseira'**
  String get diaryReference5000StepsMeasuredByTheBand;

  /// No description provided for @diaryReferenceStressPeak.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pico de estresse'**
  String get diaryReferenceStressPeak;

  /// No description provided for @diaryReference57OutOf100After2HSittingMeasuredByTheBand.
  ///
  /// In pt_BR, this message translates to:
  /// **'57 de 100 · depois de 2 h sentado · medido pela pulseira'**
  String get diaryReference57OutOf100After2HSittingMeasuredByTheBand;

  /// No description provided for @diaryReferenceMomentOfCalm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Momento de calma'**
  String get diaryReferenceMomentOfCalm;

  /// No description provided for @diaryReference12MinLowStressMeasuredByTheBand.
  ///
  /// In pt_BR, this message translates to:
  /// **'12 min · estresse baixo · medido pela pulseira'**
  String get diaryReference12MinLowStressMeasuredByTheBand;

  /// No description provided for @diaryReferenceWalk.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caminhada'**
  String get diaryReferenceWalk;

  /// No description provided for @diaryReference24Min21KmMeasuredByTheBand.
  ///
  /// In pt_BR, this message translates to:
  /// **'24 min · 2,1 km · medido pela pulseira'**
  String get diaryReference24Min21KmMeasuredByTheBand;

  /// No description provided for @diaryReferenceBodyReadyForSleep.
  ///
  /// In pt_BR, this message translates to:
  /// **'Corpo pronto para dormir'**
  String get diaryReferenceBodyReadyForSleep;

  /// No description provided for @diaryReference364CTemperatureDroppingMeasuredByTheBand.
  ///
  /// In pt_BR, this message translates to:
  /// **'36,4 °C · temperatura caindo · medido pela pulseira'**
  String get diaryReference364CTemperatureDroppingMeasuredByTheBand;

  /// No description provided for @diaryReference6H10OfSleepScore64MeasuredByTheBand.
  ///
  /// In pt_BR, this message translates to:
  /// **'6h10 de sono · nota 64 · medido pela pulseira'**
  String get diaryReference6H10OfSleepScore64MeasuredByTheBand;

  /// No description provided for @diaryReference42MinLoad61MeasuredByTheBand.
  ///
  /// In pt_BR, this message translates to:
  /// **'42 min · carga 61 · medido pela pulseira'**
  String get diaryReference42MinLoad61MeasuredByTheBand;

  /// No description provided for @diaryReferenceWentToBed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foi dormir'**
  String get diaryReferenceWentToBed;

  /// No description provided for @diaryReference2240MeasuredByTheBand.
  ///
  /// In pt_BR, this message translates to:
  /// **'22:40  · medido pela pulseira'**
  String get diaryReference2240MeasuredByTheBand;

  /// No description provided for @diaryAutomaticWokeUp.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acordou'**
  String get diaryAutomaticWokeUp;

  /// No description provided for @diaryAutomaticActivity.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atividade'**
  String get diaryAutomaticActivity;

  /// No description provided for @diaryChapterCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'de {count} capítulos'**
  String diaryChapterCount(int count);

  /// No description provided for @diaryDidNotHappenAction.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não aconteceu: {title}'**
  String diaryDidNotHappenAction(String title);

  /// No description provided for @diaryToggleAction.
  ///
  /// In pt_BR, this message translates to:
  /// **'Marcar {title}'**
  String diaryToggleAction(String title);

  /// No description provided for @diaryBandAndEntries.
  ///
  /// In pt_BR, this message translates to:
  /// **'{bandCount} da pulseira · {entryCount} registros seus'**
  String diaryBandAndEntries(int bandCount, int entryCount);

  /// No description provided for @diaryHowWasDate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como foi o dia {date}?'**
  String diaryHowWasDate(String date);

  /// No description provided for @diarySpeechLanguageUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'O reconhecimento de voz neste idioma não está disponível no aparelho. Você pode escrever.'**
  String get diarySpeechLanguageUnavailable;

  /// No description provided for @diaryWhatHappenedOnThisDay.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que aconteceu neste dia?'**
  String get diaryWhatHappenedOnThisDay;
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
