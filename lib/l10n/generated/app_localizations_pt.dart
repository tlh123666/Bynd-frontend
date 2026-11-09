// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get language => 'Idioma';

  @override
  String get chooseLanguage => 'Escolha o idioma';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortugueseBrazil => 'Português (Brasil)';

  @override
  String get languagePreferenceNotSaved =>
      'Idioma alterado nesta sessão, mas não foi possível salvar a preferência.';

  @override
  String get menu => 'Menu';

  @override
  String get youGroup => 'VOCÊ';

  @override
  String get appGroup => 'APP';

  @override
  String get settings => 'Ajustes';

  @override
  String get languageMenu => 'Idioma';

  @override
  String get integrations => 'Integrações';

  @override
  String get privacy => 'Privacidade';

  @override
  String get help => 'Ajuda';

  @override
  String get signOut => 'Sair';

  @override
  String get deviceConnected => 'Conectada · há 5 min';

  @override
  String get diary => 'Diário';

  @override
  String get journey => 'Jornada';

  @override
  String get activities => 'Atividades';

  @override
  String get community => 'Comunidade';

  @override
  String get goals => 'Objetivos';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get atlas => 'Atlas';

  @override
  String get health => 'Saúde';

  @override
  String get quickActions => 'Ações rápidas';

  @override
  String get loading => 'Carregando';

  @override
  String get close => 'Fechar';

  @override
  String get back => 'Voltar';

  @override
  String get history => 'Histórico';

  @override
  String get quickActionsHeading => 'AÇÕES RÁPIDAS';

  @override
  String get quickActionsSuggestion =>
      'Para esta manhã, a BYND sugere 15 minutos de sol antes do trabalho.';

  @override
  String get quickActionsSuggestionAfternoon =>
      'Para esta tarde, a BYND sugere uma pausa para respirar.';

  @override
  String get quickActionsSuggestionEvening =>
      'Para esta noite, a BYND sugere respirar antes de dormir.';

  @override
  String get breatheFiveMinutes => 'Respirar\n5 min';

  @override
  String get logMeal => 'Registrar\nrefeição';

  @override
  String get startActivity => 'Iniciar\natividade';

  @override
  String get reviewDay => 'Como foi\no dia';

  @override
  String get logActivity => 'Registrar\natividade';

  @override
  String get doEcg => 'Fazer\nECG';

  @override
  String comingSoon(Object feature) {
    return '$feature: em breve.';
  }

  @override
  String get activityRegisterComingSoon => 'Registro de atividade: em breve.';

  @override
  String get sectionComingSoon => 'Esta seção estará disponível em breve.';

  @override
  String get activityHistoryComingSoon => 'Histórico de atividades: em breve.';

  @override
  String get activityUnavailableHeading => 'DADOS INDISPONÍVEIS';

  @override
  String get activityUnavailableTitle =>
      'Seus dados de atividade aparecerão aqui.';

  @override
  String get activityUnavailableDescription =>
      'A integração de dados e o cálculo da carga ainda não estão disponíveis.';

  @override
  String get dayInNumbers => 'O dia em números';

  @override
  String get dailyMetricsUnavailable =>
      'Métricas diárias ainda não integradas.';

  @override
  String get modalities => 'Modalidades';

  @override
  String get recentModalitiesUnavailable =>
      'As modalidades recentes aparecerão aqui.';

  @override
  String get todayActivities => 'Atividades de hoje';

  @override
  String get noSyncedActivity => 'Nenhuma atividade sincronizada.';

  @override
  String get todayPlanPrompt => 'O que vamos fazer hoje?';

  @override
  String get register => 'Registrar';

  @override
  String get startActivityTitle => 'Iniciar atividade';

  @override
  String searchActivities(Object count) {
    return 'Buscar entre $count modalidades';
  }

  @override
  String get recent => 'Recentes';

  @override
  String get categoryCardio => 'Cardio';

  @override
  String get categoryStrength => 'Força';

  @override
  String get categorySports => 'Esportes';

  @override
  String get categoryCombat => 'Lutas';

  @override
  String get categoryAquatic => 'Aquáticos';

  @override
  String get categoryMindBody => 'Mente e corpo';

  @override
  String get categoryRecovery => 'Recuperação';

  @override
  String get categoryOther => 'Outros';

  @override
  String get activityHintHyrox => '16 etapas da prova';

  @override
  String get activityHintRaceStages => '5 etapas da prova';

  @override
  String get activityHintPoolPace => 'piscina e ritmo';

  @override
  String get activityHintGps => 'com GPS';

  @override
  String get activityHintSetsWeight => 'séries e peso';

  @override
  String get activityHintRounds => 'rounds';

  @override
  String get activityHintGameTime => 'tempo de jogo';

  @override
  String get activityHintHeartRateNoMovement => 'coração sem movimento';

  @override
  String get activityHintBreathingCalm => 'respiração e calma';

  @override
  String get activityHintStepsMovement => 'passos e movimento';

  @override
  String get activityHintMachineDistance => 'distância da máquina';

  @override
  String get activityHintTimeHeartRate => 'tempo e coração';

  @override
  String noActivityMatches(Object query) {
    return 'Nenhuma modalidade com “$query”. Use “Outro”.';
  }

  @override
  String get closeCalendar => 'Fechar calendário';

  @override
  String get previousMonth => 'Mês anterior';

  @override
  String get nextMonth => 'Próximo mês';

  @override
  String get goodRecovery => 'recuperação boa';

  @override
  String get mediumRecovery => 'recuperação média';

  @override
  String get lowRecovery => 'recuperação baixa';

  @override
  String get preparationClose => 'Fechar preparação';

  @override
  String get watchNotIntegrated => 'Pulseira não integrada';

  @override
  String get heartRateBatteryUnavailable =>
      'Frequência cardíaca e bateria indisponíveis';

  @override
  String get routeRecording => 'Registrar o percurso';

  @override
  String get gpsUnavailable => 'GPS indisponível; nenhum percurso será gravado';

  @override
  String get startActivityButton => 'Iniciar atividade';

  @override
  String get waitingForSensors => 'Aguardando integração de sensores e sessão';

  @override
  String get weatherUnavailable => 'Clima indisponível';

  @override
  String get weatherNotIntegrated =>
      'Localização e serviço meteorológico não integrados';

  @override
  String get suggestedLoadUnavailable => 'Carga sugerida indisponível';

  @override
  String get loadNotIntegrated =>
      'Dados e cálculo da carga ainda não integrados';

  @override
  String get howToStart => 'Como deseja começar?';

  @override
  String get startWithoutPlan => 'Começar sem plano';

  @override
  String get exercisesCanBeAddedLater => 'Os exercícios podem entrar depois';

  @override
  String get yourWorkouts => 'Seus treinos';

  @override
  String get savedWorkoutsUnavailable => 'Treinos salvos ainda não disponíveis';

  @override
  String get savedWorkoutsNotConnected =>
      'Os treinos salvos não estão conectados neste app';

  @override
  String get otherWays => 'Outras formas';

  @override
  String get buildWorkout => 'Montar treino novo';

  @override
  String get workoutEditorNotIntegrated =>
      'Editor de exercícios, séries e carga não integrado';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get profile => 'Perfil';

  @override
  String get profileMembership => 'Brasília · com a BYND há 2 meses';

  @override
  String get birthDateValue => '17 abr 1992';

  @override
  String get profileEditComingSoon => 'Edição de perfil em breve.';

  @override
  String get age => 'Idade';

  @override
  String get years => 'anos';

  @override
  String get height => 'Altura';

  @override
  String get weight => 'Peso';

  @override
  String get yourData => 'SEUS DADOS';

  @override
  String get birthDate => 'Data de nascimento';

  @override
  String get biologicalSex => 'Sexo biológico';

  @override
  String get female => 'Feminino';

  @override
  String get city => 'Cidade';

  @override
  String get goal => 'Objetivo';

  @override
  String get loseFatKeepMuscle => 'Perder gordura sem perder massa magra';

  @override
  String get units => 'Unidades';

  @override
  String get metric => 'Métrico';

  @override
  String get account => 'CONTA';

  @override
  String get wristband => 'Pulseira';

  @override
  String get wristbandConnectedSince => 'BYND ONE · conectada desde 9 set 2026';

  @override
  String connectedDeviceComingSoon(Object device) {
    return '$device: em breve.';
  }

  @override
  String get calendarWeekdayMon => 'Seg';

  @override
  String get calendarWeekdayTue => 'Ter';

  @override
  String get calendarWeekdayWed => 'Qua';

  @override
  String get calendarWeekdayThu => 'Qui';

  @override
  String get calendarWeekdayFri => 'Sex';

  @override
  String get calendarWeekdaySat => 'Sáb';

  @override
  String get calendarWeekdaySun => 'Dom';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get language => 'Idioma';

  @override
  String get chooseLanguage => 'Escolha o idioma';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortugueseBrazil => 'Português (Brasil)';

  @override
  String get languagePreferenceNotSaved =>
      'Idioma alterado nesta sessão, mas não foi possível salvar a preferência.';

  @override
  String get menu => 'Menu';

  @override
  String get youGroup => 'VOCÊ';

  @override
  String get appGroup => 'APP';

  @override
  String get settings => 'Ajustes';

  @override
  String get languageMenu => 'Idioma';

  @override
  String get integrations => 'Integrações';

  @override
  String get privacy => 'Privacidade';

  @override
  String get help => 'Ajuda';

  @override
  String get signOut => 'Sair';

  @override
  String get deviceConnected => 'Conectada · há 5 min';

  @override
  String get diary => 'Diário';

  @override
  String get journey => 'Jornada';

  @override
  String get activities => 'Atividades';

  @override
  String get community => 'Comunidade';

  @override
  String get goals => 'Objetivos';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get atlas => 'Atlas';

  @override
  String get health => 'Saúde';

  @override
  String get quickActions => 'Ações rápidas';

  @override
  String get loading => 'Carregando';

  @override
  String get close => 'Fechar';

  @override
  String get back => 'Voltar';

  @override
  String get history => 'Histórico';

  @override
  String get quickActionsHeading => 'AÇÕES RÁPIDAS';

  @override
  String get quickActionsSuggestion =>
      'Para esta manhã, a BYND sugere 15 minutos de sol antes do trabalho.';

  @override
  String get quickActionsSuggestionAfternoon =>
      'Para esta tarde, a BYND sugere uma pausa para respirar.';

  @override
  String get quickActionsSuggestionEvening =>
      'Para esta noite, a BYND sugere respirar antes de dormir.';

  @override
  String get breatheFiveMinutes => 'Respirar\n5 min';

  @override
  String get logMeal => 'Registrar\nrefeição';

  @override
  String get startActivity => 'Iniciar\natividade';

  @override
  String get reviewDay => 'Como foi\no dia';

  @override
  String get logActivity => 'Registrar\natividade';

  @override
  String get doEcg => 'Fazer\nECG';

  @override
  String comingSoon(Object feature) {
    return '$feature: em breve.';
  }

  @override
  String get activityRegisterComingSoon => 'Registro de atividade: em breve.';

  @override
  String get sectionComingSoon => 'Esta seção estará disponível em breve.';

  @override
  String get activityHistoryComingSoon => 'Histórico de atividades: em breve.';

  @override
  String get activityUnavailableHeading => 'DADOS INDISPONÍVEIS';

  @override
  String get activityUnavailableTitle =>
      'Seus dados de atividade aparecerão aqui.';

  @override
  String get activityUnavailableDescription =>
      'A integração de dados e o cálculo da carga ainda não estão disponíveis.';

  @override
  String get dayInNumbers => 'O dia em números';

  @override
  String get dailyMetricsUnavailable =>
      'Métricas diárias ainda não integradas.';

  @override
  String get modalities => 'Modalidades';

  @override
  String get recentModalitiesUnavailable =>
      'As modalidades recentes aparecerão aqui.';

  @override
  String get todayActivities => 'Atividades de hoje';

  @override
  String get noSyncedActivity => 'Nenhuma atividade sincronizada.';

  @override
  String get todayPlanPrompt => 'O que vamos fazer hoje?';

  @override
  String get register => 'Registrar';

  @override
  String get startActivityTitle => 'Iniciar atividade';

  @override
  String searchActivities(Object count) {
    return 'Buscar entre $count modalidades';
  }

  @override
  String get recent => 'Recentes';

  @override
  String get categoryCardio => 'Cardio';

  @override
  String get categoryStrength => 'Força';

  @override
  String get categorySports => 'Esportes';

  @override
  String get categoryCombat => 'Lutas';

  @override
  String get categoryAquatic => 'Aquáticos';

  @override
  String get categoryMindBody => 'Mente e corpo';

  @override
  String get categoryRecovery => 'Recuperação';

  @override
  String get categoryOther => 'Outros';

  @override
  String get activityHintHyrox => '16 etapas da prova';

  @override
  String get activityHintRaceStages => '5 etapas da prova';

  @override
  String get activityHintPoolPace => 'piscina e ritmo';

  @override
  String get activityHintGps => 'com GPS';

  @override
  String get activityHintSetsWeight => 'séries e peso';

  @override
  String get activityHintRounds => 'rounds';

  @override
  String get activityHintGameTime => 'tempo de jogo';

  @override
  String get activityHintHeartRateNoMovement => 'coração sem movimento';

  @override
  String get activityHintBreathingCalm => 'respiração e calma';

  @override
  String get activityHintStepsMovement => 'passos e movimento';

  @override
  String get activityHintMachineDistance => 'distância da máquina';

  @override
  String get activityHintTimeHeartRate => 'tempo e coração';

  @override
  String noActivityMatches(Object query) {
    return 'Nenhuma modalidade com “$query”. Use “Outro”.';
  }

  @override
  String get closeCalendar => 'Fechar calendário';

  @override
  String get previousMonth => 'Mês anterior';

  @override
  String get nextMonth => 'Próximo mês';

  @override
  String get goodRecovery => 'recuperação boa';

  @override
  String get mediumRecovery => 'recuperação média';

  @override
  String get lowRecovery => 'recuperação baixa';

  @override
  String get preparationClose => 'Fechar preparação';

  @override
  String get watchNotIntegrated => 'Pulseira não integrada';

  @override
  String get heartRateBatteryUnavailable =>
      'Frequência cardíaca e bateria indisponíveis';

  @override
  String get routeRecording => 'Registrar o percurso';

  @override
  String get gpsUnavailable => 'GPS indisponível; nenhum percurso será gravado';

  @override
  String get startActivityButton => 'Iniciar atividade';

  @override
  String get waitingForSensors => 'Aguardando integração de sensores e sessão';

  @override
  String get weatherUnavailable => 'Clima indisponível';

  @override
  String get weatherNotIntegrated =>
      'Localização e serviço meteorológico não integrados';

  @override
  String get suggestedLoadUnavailable => 'Carga sugerida indisponível';

  @override
  String get loadNotIntegrated =>
      'Dados e cálculo da carga ainda não integrados';

  @override
  String get howToStart => 'Como deseja começar?';

  @override
  String get startWithoutPlan => 'Começar sem plano';

  @override
  String get exercisesCanBeAddedLater => 'Os exercícios podem entrar depois';

  @override
  String get yourWorkouts => 'Seus treinos';

  @override
  String get savedWorkoutsUnavailable => 'Treinos salvos ainda não disponíveis';

  @override
  String get savedWorkoutsNotConnected =>
      'Os treinos salvos não estão conectados neste app';

  @override
  String get otherWays => 'Outras formas';

  @override
  String get buildWorkout => 'Montar treino novo';

  @override
  String get workoutEditorNotIntegrated =>
      'Editor de exercícios, séries e carga não integrado';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get profile => 'Perfil';

  @override
  String get profileMembership => 'Brasília · com a BYND há 2 meses';

  @override
  String get birthDateValue => '17 abr 1992';

  @override
  String get profileEditComingSoon => 'Edição de perfil em breve.';

  @override
  String get age => 'Idade';

  @override
  String get years => 'anos';

  @override
  String get height => 'Altura';

  @override
  String get weight => 'Peso';

  @override
  String get yourData => 'SEUS DADOS';

  @override
  String get birthDate => 'Data de nascimento';

  @override
  String get biologicalSex => 'Sexo biológico';

  @override
  String get female => 'Feminino';

  @override
  String get city => 'Cidade';

  @override
  String get goal => 'Objetivo';

  @override
  String get loseFatKeepMuscle => 'Perder gordura sem perder massa magra';

  @override
  String get units => 'Unidades';

  @override
  String get metric => 'Métrico';

  @override
  String get account => 'CONTA';

  @override
  String get wristband => 'Pulseira';

  @override
  String get wristbandConnectedSince => 'BYND ONE · conectada desde 9 set 2026';

  @override
  String connectedDeviceComingSoon(Object device) {
    return '$device: em breve.';
  }

  @override
  String get calendarWeekdayMon => 'Seg';

  @override
  String get calendarWeekdayTue => 'Ter';

  @override
  String get calendarWeekdayWed => 'Qua';

  @override
  String get calendarWeekdayThu => 'Qui';

  @override
  String get calendarWeekdayFri => 'Sex';

  @override
  String get calendarWeekdaySat => 'Sáb';

  @override
  String get calendarWeekdaySun => 'Dom';
}
