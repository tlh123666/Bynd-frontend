// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get exerciseDetailCountAs => 'Conta como';

  @override
  String get exerciseDetailSeconds => 'segundos';

  @override
  String get exerciseDetailMinutes => 'minutos';

  @override
  String get exerciseDetailRepsBody => 'repetições (peso do corpo)';

  @override
  String get exerciseDetailRepsWeight => 'repetições × carga';

  @override
  String get exerciseDetailTitle => 'Exercício';

  @override
  String exerciseDetailHow(String name) {
    return 'Como fazer: $name';
  }

  @override
  String get exerciseDetailMark => 'Marcar para adicionar';

  @override
  String get exerciseDetailMuscles => 'Músculos';

  @override
  String get exerciseDetailEquipment => 'Equipamento';

  @override
  String get exerciseDetailGroup => 'Grupo';

  @override
  String get exerciseDetailLevel => 'Nível';

  @override
  String exerciseDetailAnimation(String name) {
    return 'Animação: $name';
  }

  @override
  String get exerciseDetailNoAnimation =>
      'Animação não disponível para este exercício.';

  @override
  String get exerciseConfirmEmpty => 'Confirmar';

  @override
  String get exerciseSelectorTitle => 'Selecionar exercícios';

  @override
  String get exerciseSearch => 'Buscar exercício ou músculo';

  @override
  String get exerciseAll => 'Todos';

  @override
  String get exerciseMark => 'Marque os exercícios';

  @override
  String exerciseAdd(int count) {
    return 'Adicionar ($count)';
  }

  @override
  String exerciseCount(int count) {
    return '$count exercícios';
  }

  @override
  String get exerciseEmpty => 'Nenhum exercício encontrado.';

  @override
  String get exerciseLoadError => 'Não foi possível carregar os exercícios.';

  @override
  String get exerciseRetry => 'Tentar novamente';

  @override
  String exerciseSelectedCount(int count) {
    return '$count exercícios selecionados · demonstração';
  }

  @override
  String get exerciseDraftNote =>
      'Prévia local · ainda não é possível salvar o treino';

  @override
  String get exerciseAddMore => 'Adicionar exercício';

  @override
  String get workoutLocalNote =>
      'Salvo apenas neste dispositivo · não sincronizado';

  @override
  String get workoutDefaultsNote => 'Valores iniciais de exemplo';

  @override
  String get workoutSaveError =>
      'Não foi possível salvar neste dispositivo. Tente novamente.';

  @override
  String get workoutLoadError => 'Não foi possível carregar os treinos locais.';

  @override
  String get workoutReplaceExercise => 'Trocar exercício';

  @override
  String get workoutCloseSets => 'Fechar séries';

  @override
  String get workoutEditSets => 'Editar séries';

  @override
  String get workoutShowExercise => 'Ver como fazer';

  @override
  String get workoutRemoveExercise => 'Remover';

  @override
  String get workoutDuplicateExercise => 'Duplicar';

  @override
  String get workoutRemoveSet => 'Remover série';

  @override
  String get workoutAddSet => 'Adicionar série';

  @override
  String get workoutSet => 'Série';

  @override
  String get workoutAmount => 'Repetições / tempo';

  @override
  String get workoutWeightKg => 'Peso (kg)';

  @override
  String get workoutDone => 'Concluir';

  @override
  String get workoutCancel => 'Cancelar';

  @override
  String get workoutInvalidSet => 'Informe valores válidos.';

  @override
  String get workoutPlanPreview => 'Plano local · atividade ainda não iniciada';

  @override
  String get workoutReorder => 'Reordenar exercícios';

  @override
  String get workoutMoveUp => 'Mover para cima';

  @override
  String get workoutMoveDown => 'Mover para baixo';

  @override
  String workoutSuggestedName(String group) {
    return 'Treino de $group';
  }

  @override
  String get workoutMenuEdit => 'Editar';

  @override
  String get workoutMenuDelete => 'Apagar';

  @override
  String get workoutDeleteTitle => 'Apagar treino?';

  @override
  String workoutDeleteMessage(String name) {
    return '“$name” será removido dos treinos locais.';
  }

  @override
  String get workoutActionError =>
      'Não foi possível atualizar os treinos locais.';

  @override
  String get workoutBuilderTitle => 'Montar treino';

  @override
  String get workoutBuilderWeight => 'kg levantados';

  @override
  String get workoutBuilderEmptyCount => '0 EXERCÍCIOS · 0 SÉRIES';

  @override
  String get workoutBuilderName => 'NOME DO TREINO';

  @override
  String get workoutBuilderNameHint => 'Treino de força';

  @override
  String get workoutBuilderEmptyTitle => 'Monte o seu treino';

  @override
  String get workoutBuilderEmptyHint =>
      'Toque no + e escolha entre 218 exercícios.';

  @override
  String get workoutBuilderAdd => 'Adicionar exercícios';

  @override
  String get workoutBuilderUnavailable =>
      'O catálogo de exercícios ainda não está conectado.';

  @override
  String get workoutBuilderStart => 'Começar';

  @override
  String get strengthDemoNote =>
      'Modelos de demonstração · não são treinos salvos';

  @override
  String get strengthDemoUnavailable =>
      'Os modelos e o editor ainda não estão conectados.';

  @override
  String get strengthDemoName1 => 'Demonstração';

  @override
  String get strengthDemoName2 => 'Pernas e glúteos';

  @override
  String get strengthDemoName3 => 'Superiores';

  @override
  String get strengthDemoName4 => 'Corpo todo';

  @override
  String get strengthDemoName5 => 'Pernas';

  @override
  String get strengthDemoName6 => 'Superiores e core';

  @override
  String get strengthDemoName7 => 'Treino leve · mobilidade';

  @override
  String strengthExerciseCount(int exercises, int sets) {
    return '$exercises exercícios · $sets séries';
  }

  @override
  String get strengthCreateHint => 'escolher exercícios, séries e carga';

  @override
  String strengthOptions(String name) {
    return 'Opções de $name';
  }

  @override
  String get activityRegistrationPreview =>
      'Prévia · dados simulados · não salvo';

  @override
  String get activityDetailHighIntensity => 'Alta intensidade';

  @override
  String get activityDetailEffortPeaks => 'Picos de esforço';

  @override
  String get registrationTitle => 'Registrar atividade';

  @override
  String get registrationModality => 'MODALIDADE';

  @override
  String get registrationChange => 'tocar para trocar';

  @override
  String get registrationWhen => 'QUANDO';

  @override
  String get registrationOtherDay => 'Outro dia';

  @override
  String get registrationStart => 'Começou às';

  @override
  String get registrationDuration => 'Duração';

  @override
  String get registrationEffort => 'ESFORÇO QUE VOCÊ SENTIU';

  @override
  String get registrationOfTen => 'de 10';

  @override
  String get registrationEstimated => 'carga estimada de exemplo';

  @override
  String get registrationSave => 'Salvar';

  @override
  String get registrationUnavailable =>
      'Demonstração: o registro de atividades ainda não está conectado.';

  @override
  String get registrationInvalid =>
      'A atividade não pode terminar no futuro ou depois da meia-noite.';

  @override
  String get registrationDone => 'Concluído';

  @override
  String get registrationHigh => 'ALTA';

  @override
  String get registrationModerate => 'MODERADA';

  @override
  String get registrationLight => 'Leve';

  @override
  String get registrationStrong => 'Forte';

  @override
  String get registrationMaximum => 'Máximo';

  @override
  String get registrationShortPhrases => 'frases curtas';

  @override
  String get registrationEffortDescription => 'Esforço de 1 a 10';

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
  String get historyNormalStatus => 'DENTRO DO SEU NORMAL';

  @override
  String get historyAverage => 'sua média';

  @override
  String get historyNormalRange => 'normal 35–58';

  @override
  String get historySevenDayAverage => 'média de 7 dias';

  @override
  String get historyDemoMonth => 'nov';

  @override
  String historyDemoSummary(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count atividades',
      one: '$count atividade',
    );
    return '$_temp0 · $minutes min no total';
  }

  @override
  String get historyDemoTime => 'hoje 07:50';

  @override
  String get activityDetailDemoSource => 'Exemplo · dados ilustrativos';

  @override
  String get activityDetailTimeTo => 'a';

  @override
  String get activityDetailDuration => 'Duração';

  @override
  String get activityDetailCalories => 'Calorias';

  @override
  String get activityDetailAverageHeartRate => 'FC média';

  @override
  String get activityDetailMaximumHeartRate => 'FC máxima';

  @override
  String get activityDetailHeartZones => 'Zonas da FC';

  @override
  String activityDetailZoneMost(int zone) {
    return 'mais tempo na zona $zone';
  }

  @override
  String get activityDetailZone => 'Zona';

  @override
  String get activityDetailZoneRest => 'repouso';

  @override
  String get activityDetailZoneVeryLight => 'muito leve';

  @override
  String get activityDetailZoneLight => 'leve';

  @override
  String get activityDetailZoneModerate => 'moderada';

  @override
  String get activityDetailZoneHard => 'intensa';

  @override
  String get activityDetailZoneMaximum => 'máxima';

  @override
  String get activityDetailMin => 'Mín';

  @override
  String get activityDetailMax => 'Máx';

  @override
  String get activityDetailOptions => 'Opções';

  @override
  String get activityDetailShare => 'Compartilhar';

  @override
  String get activityDetailEdit => 'Editar horário e duração';

  @override
  String get activityDetailDelete => 'Apagar atividade';

  @override
  String get activityDetailStart => 'Horário de início (HH:mm)';

  @override
  String get activityDetailSave => 'Salvar';

  @override
  String get activityDetailCancel => 'Cancelar';

  @override
  String get activityDetailInvalid =>
      'Informe um horário válido e uma duração de 1 a 720 minutos.';

  @override
  String get activityDetailDemoOnly =>
      'Apenas demonstração · alterações duram até você sair desta página.';

  @override
  String get activityDetailCopied => 'Resumo de exemplo copiado.';

  @override
  String get activityDetailCopyFailed =>
      'Não foi possível copiar o resumo de exemplo.';

  @override
  String get activityDetailDeleteConfirm => 'Apagar este exemplo?';

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
  String get activityTargetStatus => 'ABAIXO DO ALVO';

  @override
  String get activityTargetTitle => 'Falta pouco para o alvo.';

  @override
  String get activityTargetDescription =>
      'Hoje: musculação, 35 min, carga 28. Com recuperação em 57, a meta do dia é 35–55: faltam 7. Uma caminhada leve de 20 a 30 minutos deve completar a meta. Estimativa de recuperação para amanhã: perto de 66.';

  @override
  String get activityMetricActiveCalories => 'Calorias ativas';

  @override
  String get activityMetricActiveMinutes => 'Minutos ativos';

  @override
  String get activityMetricSteps => 'Passos';

  @override
  String get activityMetricRestingTime => 'Tempo parado';

  @override
  String get activityMetricAbove25 => '↑ 25% acima';

  @override
  String get activityMetricAbove28 => '↑ 28% acima';

  @override
  String get activityMetricWithinNormal => 'dentro do normal';

  @override
  String get activityMetricNormalCalories => 'normal 256–383 kcal';

  @override
  String get activityMetricNormalMinutes => 'normal 35–53 min';

  @override
  String get activityMetricNormalSteps => 'normal 3.904–5.856';

  @override
  String get activityMetricNormalRest => 'normal 3h32–5h18';

  @override
  String get activityDemoStrength => 'Musculação';

  @override
  String get activityDemoRun => 'Corrida';

  @override
  String get activityDemoWalk => 'Caminhada';

  @override
  String get activityDemoSetsAndWeight => 'séries e peso';

  @override
  String get activityDemoWithGps => 'com GPS';

  @override
  String activityDemoSummary(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count treinos',
      one: '$count treino',
    );
    return '$_temp0 · $minutes min no total';
  }

  @override
  String get activityDemoLoadLabel => 'carga';

  @override
  String get activityDemoLabel =>
      'Dados ilustrativos de demonstração · não sincronizados';

  @override
  String get activityDemoStepsValue => '6.240';

  @override
  String get activityDemoRestingTimeValue => '4h44';

  @override
  String get dayInNumbers => 'O dia em números';

  @override
  String get dailyMetricsUnavailable =>
      'Métricas diárias ainda não integradas.';

  @override
  String get modalities => 'Modalidades';

  @override
  String get viewAll => 'Ver todas';

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

  @override
  String get homeMorning => 'Bom dia';

  @override
  String get homeAfternoon => 'Boa tarde';

  @override
  String get homeEvening => 'Boa noite';

  @override
  String get homePastGreeting => 'Como foi o seu dia';

  @override
  String get homeDirection => 'Ver direção completa';

  @override
  String get homeSignals => 'Seus sinais';

  @override
  String get homeAllSignals => 'Ver todos ›';

  @override
  String get homeCustomize => 'Personalizar a Home';

  @override
  String get homeCustomizeHelp =>
      'Escolha os 6 sinais que ficam na sua Home e arraste pela alça ≡ para mudar a ordem.';

  @override
  String get homeOnHome => 'NA HOME';

  @override
  String get homeOtherSignals => 'OUTROS SINAIS';

  @override
  String get homeSixSlots =>
      'A Home tem 6 lugares. Desmarque um antes de escolher outro.';

  @override
  String get homeSave => 'Salvar';

  @override
  String get homePreferenceFailed =>
      'Não foi possível salvar sua preferência. Tente novamente.';

  @override
  String get homePhoto => 'Trocar a foto do topo';

  @override
  String get homeShowMore => 'Mostrar mais';

  @override
  String get homeShowLess => 'Mostrar menos';

  @override
  String get homeRetry => 'Tentar novamente';

  @override
  String get homeUnavailable => 'Não foi possível carregar a Home.';

  @override
  String get homeSignIn => 'Entre na sua conta para ver seus dados.';

  @override
  String get homeSignInAction => 'Entrar na conta';

  @override
  String get homeNoMeasurement => 'Sem dados neste dia';

  @override
  String get homeSync =>
      'Conecte e sincronize sua pulseira para ver seus sinais.';

  @override
  String get homePartial => 'Algumas informações não foram atualizadas.';

  @override
  String get homeMapaTitle => 'O que o seu corpo está revelando?';

  @override
  String get homeMapaBody =>
      'Uma relação entre seus hábitos, sono, atividade e recuperação começou a aparecer.';

  @override
  String get homeMapaWaiting =>
      'Seu Mapa está se formando. Continue usando a pulseira para descobrir relações entre seus hábitos e seus sinais.';

  @override
  String get homeExploreMapa => 'Explorar meu Mapa →';

  @override
  String get homeDiaryKicker => 'SEU DIÁRIO';

  @override
  String get homeDiaryTitle => 'Como foi o seu dia?';

  @override
  String get homeDiaryBody =>
      'Registre alimentação, treino, humor, café e o que mais aconteceu.';

  @override
  String get homeAddEntry => 'Adicionar registro +';

  @override
  String get homePatterns => 'padrões';

  @override
  String get homeWaitingPatterns => 'Em formação';

  @override
  String get homeNumbers => 'Seus números';

  @override
  String get homeWeek => 'SEMANA · UM PONTO POR DIA';

  @override
  String get homeMinimum => 'Mínima';

  @override
  String get homeAverage => 'Média';

  @override
  String get homeMaximum => 'Máxima';

  @override
  String get homeHistoryError => 'Não foi possível carregar o histórico.';

  @override
  String get homeHistoryEmpty => 'Ainda não há medições nesta semana.';

  @override
  String get homeRecommendation => 'Para hoje';

  @override
  String get homeDiary => 'Diário';

  @override
  String get homeDiaryEmpty =>
      'Seu dia, do seu jeito. Adicione o primeiro registro.';

  @override
  String get homeNewEntry => 'Novo registro';

  @override
  String get homeEntryLabel => 'O que aconteceu?';

  @override
  String get homeEntryNote => 'Mais detalhes (opcional)';

  @override
  String get homeEntryRequired => 'Descreva o registro antes de salvar.';

  @override
  String get homeEntrySaved => 'Registro salvo.';

  @override
  String get homeEntryFailed => 'Não foi possível salvar. Tente novamente.';

  @override
  String get homeMeal => 'Alimentação';

  @override
  String get homeTraining => 'Treino';

  @override
  String get homeMood => 'Humor';

  @override
  String get homeCaffeine => 'Café';

  @override
  String get homeOther => 'Outro';

  @override
  String get homeUnknownDirection => 'Aguardando seus sinais.';

  @override
  String get homeDataOnly =>
      'Medições da sua pulseira. Os dados ausentes não são estimados.';

  @override
  String get homeSelectedCount => 'de 6';

  @override
  String get homeOpenDevice => 'Conectar pulseira';

  @override
  String get homeRefresh => 'Atualizar';

  @override
  String get homeDrag => 'Arrastar para mudar a ordem';

  @override
  String get homeNoDirection =>
      'Sincronize a pulseira para acompanhar a direção do seu dia.';

  @override
  String get homeAccountChanged =>
      'Sua conta mudou. Feche esta tela e abra novamente para ver os dados atuais.';

  @override
  String get authWelcome => 'BEM-VINDO À BYND';

  @override
  String get authHeadline => 'Seu corpo.\nSua direção.';

  @override
  String get authSubtitle => 'Entenda seus sinais. Viva no seu ritmo.';

  @override
  String get authEmailContinue => 'Continuar com e-mail';

  @override
  String get authGoogleContinue => 'Continuar com Google';

  @override
  String get authEmailTitle => 'Qual é o seu e-mail?';

  @override
  String get authEmailBody =>
      'Vamos enviar um código para você entrar. Sem senha.';

  @override
  String get authAccountHint =>
      'No primeiro acesso, você pode criar sua conta por aqui.';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authEmailHint => 'voce@exemplo.com';

  @override
  String get authSendCode => 'Enviar código';

  @override
  String get authCodeTitle => 'Confira seu e-mail';

  @override
  String authCodeBody(String email) {
    return 'Enviamos um código de 6 dígitos para $email.';
  }

  @override
  String get authCodeLabel => 'Código de verificação';

  @override
  String get authCodeHint => '000000';

  @override
  String get authEditEmail => 'Alterar e-mail';

  @override
  String get authSignIn => 'Entrar';

  @override
  String get authCreateAccount => 'Criar conta e entrar';

  @override
  String get authResend => 'Reenviar código';

  @override
  String authResendIn(int seconds) {
    return 'Reenviar em ${seconds}s';
  }

  @override
  String get authSpamHint =>
      'Não chegou? Confira a caixa de spam ou peça um novo código.';

  @override
  String get authCodeSent => 'Código enviado. Confira também a caixa de spam.';

  @override
  String get authInvalidEmail => 'Informe um e-mail válido.';

  @override
  String get authInvalidCode => 'Digite os 6 números do código.';

  @override
  String get authCodeRejected =>
      'Não foi possível validar o código. Confira os números ou peça outro.';

  @override
  String get authCodeExpired =>
      'Esse código expirou. Peça um novo para continuar.';

  @override
  String get authNetworkError =>
      'Não foi possível conectar. Confira sua conexão e tente novamente.';

  @override
  String get authServerError =>
      'Não foi possível entrar agora. Tente novamente em instantes.';

  @override
  String get authRateLimited => 'Aguarde um pouco antes de tentar novamente.';

  @override
  String get authStorageError =>
      'Não foi possível salvar seu acesso neste dispositivo. Tente novamente.';

  @override
  String get authGoogleError =>
      'Não foi possível entrar com Google. Tente novamente ou use seu e-mail.';

  @override
  String get authSessionExpired =>
      'Seu acesso expirou. Entre novamente para continuar.';

  @override
  String get authConsentTitle => 'Seus dados de saúde, sua escolha';

  @override
  String get authConsentBody =>
      'A BYND usa os sinais de saúde coletados pela sua pulseira, como frequência cardíaca, VFC, sono e atividade, para gerar informações pessoais sobre o seu corpo. Para criar sua conta, precisamos do seu consentimento para esse tratamento.';

  @override
  String get authConsentLabel =>
      'Concordo com o tratamento dos meus dados de saúde para gerar informações pessoais, conforme descrito em Privacidade.';

  @override
  String get authConsentRequired =>
      'Para criar sua conta, confirme sua escolha sobre os dados de saúde.';

  @override
  String get authConsentAccept => 'Concordar e continuar';

  @override
  String get authConsentDecline => 'Agora não';

  @override
  String get authPrivacy => 'Privacidade';

  @override
  String get authPrivacyLink => 'Como usamos seus dados';

  @override
  String get authPrivacyTitle => 'Seus dados na BYND';

  @override
  String get authPrivacyPurposeTitle => 'Para entender seus sinais';

  @override
  String get authPrivacyPurpose =>
      'Os dados de saúde da pulseira e os registros que você adiciona permitem apresentar informações sobre sono, atividade e outros sinais do seu corpo.';

  @override
  String get authPrivacyChoiceTitle => 'Uma escolha explícita';

  @override
  String get authPrivacyChoice =>
      'A criação da conta exige seu consentimento para o tratamento dos dados de saúde. Você pode ler estas informações e voltar sem concordar; nesse caso, nenhuma conta será criada por esta etapa.';

  @override
  String get authPrivacyAccessTitle => 'Seu acesso';

  @override
  String get authPrivacyAccess =>
      'O acesso por e-mail usa um código temporário. Guarde esse código só para você. A sessão permanece no dispositivo até você sair ou o acesso expirar.';

  @override
  String get authLegalFootnote =>
      'Conheça como a BYND utiliza seus dados antes de continuar.';

  @override
  String get authRestore => 'Preparando seu acesso…';

  @override
  String get authSignOutTitle => 'Sair da sua conta?';

  @override
  String get authSignOutBody =>
      'Você poderá entrar novamente com seu e-mail ou com Google.';

  @override
  String get authSignOutConfirm => 'Sair';

  @override
  String get authCancel => 'Cancelar';

  @override
  String get authSignOutFailed =>
      'Você saiu, mas não foi possível limpar todos os dados locais. Tente reiniciar o app.';

  @override
  String authBackground(int index, int total) {
    return 'Paisagem $index de $total';
  }

  @override
  String get authChangeLanguage => 'Alterar idioma';

  @override
  String get communityMyGroups => 'Meus grupos';

  @override
  String get communityEmptyGroups =>
      'Nenhum grupo ainda. Crie um ou entre com um convite.';

  @override
  String get communityToday => 'Para hoje';

  @override
  String get communityMarkDone => 'Marcar como feito';

  @override
  String get communityMarkedDone => 'Dia marcado como feito.';

  @override
  String get communityDoneToday => 'Feito hoje';

  @override
  String get communityRetry => 'Tentar novamente';

  @override
  String get communityAccept => 'Aceitar';

  @override
  String get communityDecline => 'Recusar';

  @override
  String communityMemberCount(Object count) {
    return '$count pessoas';
  }

  @override
  String communityDaysTotal(Object days) {
    return 'desafio de $days dias';
  }

  @override
  String get communityEmptyChat => 'Nenhuma mensagem ainda. Diga oi!';

  @override
  String get communityDayToday => 'Hoje';

  @override
  String get communityDayYesterday => 'Ontem';

  @override
  String get communityMessageRecalled => 'Mensagem removida';

  @override
  String get communitySendHint => 'Mensagem para o grupo';

  @override
  String communityInvitationFrom(Object group, Object inviter) {
    return '$inviter convidou você para \"$group\"';
  }

  @override
  String get communityNewCover => 'Criar grupo\nou entrar com código';

  @override
  String communityInviteFromShort(Object name) {
    return 'convite de $name';
  }

  @override
  String communityRankBadge(Object rank, Object total) {
    return '$rankº no desafio de $total';
  }

  @override
  String get communityParaHoje => 'Para hoje';

  @override
  String get communityPickChallenge => 'Escolher um desafio';

  @override
  String get communityPickChallengeSub => 'sozinho ou com o seu grupo';

  @override
  String communityDayOfTotal(Object day, Object total) {
    return 'dia $day de $total';
  }

  @override
  String get communityMuralToday => 'No grupo hoje';

  @override
  String get communityMuralYesterday => 'No grupo ontem';

  @override
  String get communityMuralIntro =>
      'Do mais novo para o mais antigo. Toque em \"Dar força\" para apoiar.';

  @override
  String get communityNoCheckinsToday =>
      'Nenhum check-in hoje ainda. Quem fizer aparece aqui.';

  @override
  String get communityNoCheckinsYesterday => 'Nenhum check-in ontem.';

  @override
  String get communityAtlasKicker => 'ATLAS · RESUMO DO GRUPO';

  @override
  String get communityCheer => 'Dar força';

  @override
  String get communityCheerSoon => 'Dar força chega em breve.';

  @override
  String get communityRespond => 'Responder';

  @override
  String get communityOpenGroupChat => 'Abrir a conversa do grupo';

  @override
  String get communityCheckinText => '✓ Check-in de hoje';

  @override
  String get communityNewTitle => 'Novo';

  @override
  String get communityTabChallenges => 'Desafios';

  @override
  String get communityTabCreateGroup => 'Criar grupo';

  @override
  String get communityTabCode => 'Código';

  @override
  String get communityChallengesIntro =>
      'Desafios criados pela BYND com especialistas. Faça sozinho ou leve para o seu grupo.';

  @override
  String get communityDetailsOpen => 'Ver detalhes';

  @override
  String get communityDetailsClose => 'Fechar';

  @override
  String get communityChallengeWhy => 'Por que funciona';

  @override
  String get communityChallengeDaily => 'Todo dia';

  @override
  String get communityEnrolledBadge => 'Você está neste desafio';

  @override
  String get communityStartToday => 'Começar hoje';

  @override
  String get communityChallengeLeave => 'Sair do desafio';

  @override
  String get communityStepName => '1 · Nome do grupo';

  @override
  String get communityStepInvite => '2 · Quem você quer chamar (e-mail)';

  @override
  String get communityCodeIntro =>
      'Recebeu um convite? Digite o código do grupo (ele vem no link ou na mensagem de quem te chamou).';

  @override
  String get communityCodeHint => 'BYND-0000';

  @override
  String get communityCodeGo => 'Entrar no grupo';

  @override
  String get communityCodeSoon => 'Entrar por código chega em breve.';

  @override
  String get communityAjustesTitle => 'Grupo';

  @override
  String get communityAjustesInvite => '+ Convidar';

  @override
  String get communityPlacarTitle => 'Placar';

  @override
  String get communityRoleAdmin => 'admin';

  @override
  String get communityNotifTitle => 'Avisos';

  @override
  String get communityNotifMessages => 'Mensagens';

  @override
  String get communityLeaveDoubleTap => 'Toque de novo para sair';

  @override
  String get communityInviteTitle => 'Convidar para o grupo';

  @override
  String get communityInviteEmailHint => 'nome@exemplo.com';

  @override
  String get communityInviteSend => 'Enviar';

  @override
  String get communityInviteSuccess => 'Convite enviado.';

  @override
  String communityMembersTitle(Object count) {
    return 'Pessoas · $count';
  }

  @override
  String get communityLeaveGroup => 'Sair do grupo';

  @override
  String get communityGoalsTitle => 'Objetivos';

  @override
  String get communityNoGoals => 'Nenhum objetivo neste grupo ainda.';

  @override
  String get communityCreateIntro =>
      'Um grupo é para fazer desafios juntos, comparar os números do objetivo e conversar.';

  @override
  String get communityGroupName => 'Nome do grupo';

  @override
  String get communityGroupNameHint => 'Ex.: Corrida das 6h, Família, Trabalho';

  @override
  String get communityGroupDescription => 'Descrição';

  @override
  String get communityGroupDescriptionHint => 'Sobre o que é o grupo?';

  @override
  String get communityInviteEmails => 'Quem você quer chamar';

  @override
  String get communityInviteEmailsHint => 'e-mails separados por vírgula';

  @override
  String get communityGroupCreate => 'Criar grupo';

  @override
  String get communityCreating => 'Criando...';

  @override
  String communityGroupCreated(Object count) {
    return 'Grupo criado · $count convite(s) enviado(s).';
  }

  @override
  String get communityCreateNote =>
      'Pode criar sem ninguém: depois de criar, você chama mais gente nos ajustes do grupo.';

  @override
  String get communityPublicGroup => 'Grupo público';

  @override
  String get communityJoin => 'Entrar';

  @override
  String get communityJoinedGroup => 'Boas-vindas ao grupo!';

  @override
  String get atlasInsights => 'Insights';

  @override
  String get atlasChat => 'Conversar com o ATLAS';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get insightsRefresh => 'Atualizar';

  @override
  String get insightsError =>
      'Não foi possível carregar os insights. Puxe para baixo e tente novamente.';

  @override
  String get insightsEmpty =>
      'Nenhum insight ainda. Continue sincronizando a pulseira — o ATLAS fala quando seus dados contam algo que vale a pena saber.';

  @override
  String get insightsFactors => 'O que pode estar envolvido';

  @override
  String get insightsActions => 'O que você pode experimentar';

  @override
  String get chatTitle => 'Atlas';

  @override
  String get chatNew => 'Nova conversa';

  @override
  String get chatEmptyHint =>
      'Pergunte sobre sono, recuperação, estresse ou prontidão para treinar. O ATLAS responde com os seus dados e explica o que significam.';

  @override
  String get chatInputHint => 'Pergunte ao Atlas';

  @override
  String get menuMapa => 'Mapa';

  @override
  String get chatSug1 => 'Como estou?';

  @override
  String get chatSug2 => 'Me dá um resumo do meu dia';

  @override
  String get chatSug3 => 'Por que a VFC não volta?';

  @override
  String get chatHistoryTitle => 'Conversas';

  @override
  String get chatHistoryEmpty => 'Nenhuma conversa ainda.';

  @override
  String get chatHistoryUntitled => 'Conversa sem título';

  @override
  String get chatContinueLast => 'Continuar última conversa';

  @override
  String get healthGroupSleep => 'Sono';

  @override
  String get healthGroupEnergy => 'Energia';

  @override
  String get healthGroupMetabolism => 'Metabolismo';

  @override
  String get healthGroupHeartBody => 'Coração e corpo';

  @override
  String get healthGroupBreathOxygen => 'Respiração e oxigênio';

  @override
  String get healthGroupLongevity => 'Longevidade';

  @override
  String get memoriaTitle => 'Memória';

  @override
  String get memoriaHeroTitle => 'O que o Atlas sabe de você';

  @override
  String get memoriaHeroSub => 'Quanto mais ele sabe, melhores as respostas.';

  @override
  String get memoriaKicker => 'O que ele guardou';

  @override
  String get memoriaCurrent => 'Atual';

  @override
  String get memoriaPast => 'Passou';

  @override
  String get memoriaTold => 'Você contou';

  @override
  String get memoriaPerceived => 'O Atlas percebeu';

  @override
  String get memoriaSince => 'desde';

  @override
  String get diaryCatalogAguaLabel => 'Beber água';

  @override
  String get diaryCatalogAguaPrompt => 'Bebeu água?';

  @override
  String get diaryCatalogProtLabel => 'Comer proteína';

  @override
  String get diaryCatalogProtPrompt => 'Comeu proteína nas refeições?';

  @override
  String get diaryCatalogFrutLabel => 'Fruta e verdura';

  @override
  String get diaryCatalogFrutPrompt => 'Comeu fruta e verdura?';

  @override
  String get diaryCatalogJantarLabel => 'Jantar até as 20h';

  @override
  String get diaryCatalogJantarPrompt => 'Jantou até as 20h?';

  @override
  String get diaryCatalogDoceLabel => 'Doce';

  @override
  String get diaryCatalogDocePrompt => 'Comeu doce?';

  @override
  String get diaryCatalogAlcLabel => 'Álcool';

  @override
  String get diaryCatalogAlcPrompt => 'Bebeu álcool?';

  @override
  String get diaryCatalogCafe15Label => 'Café depois das 15h';

  @override
  String get diaryCatalogCafe15Prompt => 'Tomou café depois das 15h?';

  @override
  String get diaryCatalogRefriLabel => 'Refrigerante';

  @override
  String get diaryCatalogRefriPrompt => 'Tomou refrigerante?';

  @override
  String get diaryCatalogCafeLabel => 'Café';

  @override
  String get diaryCatalogCafePrompt => 'Tomou café?';

  @override
  String get diaryCatalogTelaLabel => 'Celular na cama';

  @override
  String get diaryCatalogTelaPrompt => 'Usou o celular na cama?';

  @override
  String get diaryCatalogLuzLabel => 'Sol pela manhã';

  @override
  String get diaryCatalogLuzPrompt => 'Pegou sol de manhã?';

  @override
  String get diaryCatalogLerLabel => 'Ler antes de dormir';

  @override
  String get diaryCatalogLerPrompt => 'Leu antes de dormir?';

  @override
  String get diaryCatalogRespLabel => 'Respiração';

  @override
  String get diaryCatalogRespPrompt => 'Fez a respiração?';

  @override
  String get diaryCatalogMeditLabel => 'Meditar';

  @override
  String get diaryCatalogMeditPrompt => 'Meditou?';

  @override
  String get diaryCatalogGratLabel => 'Escrever 3 gratidões';

  @override
  String get diaryCatalogGratPrompt => 'Escreveu as gratidões?';

  @override
  String get diaryCatalogGeloLabel => 'Banho gelado';

  @override
  String get diaryCatalogGeloPrompt => 'Tomou banho gelado?';

  @override
  String get diaryCatalogAlongLabel => 'Alongar';

  @override
  String get diaryCatalogAlongPrompt => 'Alongou?';

  @override
  String get diaryCatalogDorLabel => 'Dor muscular';

  @override
  String get diaryCatalogDorPrompt => 'Sentiu dor muscular?';

  @override
  String get diaryCatalogRemedioLabel => 'Tomar o remédio';

  @override
  String get diaryCatalogRemedioPrompt => 'Tomou o remédio?';

  @override
  String get diaryCatalogGlpLabel => 'Aplicar o GLP-1';

  @override
  String get diaryCatalogGlpPrompt => 'Aplicou o GLP-1?';

  @override
  String get diaryCatalogCreatLabel => 'Creatina';

  @override
  String get diaryCatalogCreatPrompt => 'Tomou creatina?';

  @override
  String get diaryCatalogVitLabel => 'Vitaminas';

  @override
  String get diaryCatalogVitPrompt => 'Tomou as vitaminas?';

  @override
  String get diaryCatalogAcordouLabel => 'Como acordou';

  @override
  String get diaryCatalogAcordouPrompt => 'Como acordou?';

  @override
  String get diaryCatalogHumorLabel => 'Humor';

  @override
  String get diaryCatalogHumorPrompt => 'Como está o humor?';

  @override
  String get diaryCatalogEnergiaLabel => 'Disposição';

  @override
  String get diaryCatalogEnergiaPrompt => 'Como está a disposição?';

  @override
  String get diaryCatalogEstresseLabel => 'Estresse';

  @override
  String get diaryCatalogEstressePrompt => 'Quanto estresse hoje?';

  @override
  String get diaryCatalogCafeMLabel => 'Café da manhã';

  @override
  String get diaryCatalogCafeMPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogLancheMLabel => 'Lanche da manhã';

  @override
  String get diaryCatalogLancheMPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogAlmocoLabel => 'Almoço';

  @override
  String get diaryCatalogAlmocoPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogLancheTLabel => 'Lanche da tarde';

  @override
  String get diaryCatalogLancheTPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogJantarRLabel => 'Jantar';

  @override
  String get diaryCatalogJantarRPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogCeiaLabel => 'Ceia';

  @override
  String get diaryCatalogCeiaPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogWheyLabel => 'Whey';

  @override
  String get diaryCatalogWheyPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogGripeLabel => 'Sinal de gripe';

  @override
  String get diaryCatalogGripePrompt => 'Sentiu sinal de gripe?';

  @override
  String get diaryCatalogCAguaLabel => 'Água';

  @override
  String get diaryCatalogCAguaPrompt => 'Bebeu água suficiente?';

  @override
  String get diaryCatalogCExpressoLabel => 'Café expresso';

  @override
  String get diaryCatalogCExpressoPrompt => 'Tomou expresso?';

  @override
  String get diaryCatalogCCafeleiteLabel => 'Café com leite';

  @override
  String get diaryCatalogCCafeleitePrompt => 'Tomou café com leite?';

  @override
  String get diaryCatalogCChaLabel => 'Chá';

  @override
  String get diaryCatalogCChaPrompt => 'Tomou chá?';

  @override
  String get diaryCatalogCChapretoLabel => 'Chá preto ou mate';

  @override
  String get diaryCatalogCChapretoPrompt =>
      'Tomou chá preto ou mate (com cafeína)?';

  @override
  String get diaryCatalogCChimarraoLabel => 'Chimarrão';

  @override
  String get diaryCatalogCChimarraoPrompt => 'Tomou chimarrão?';

  @override
  String get diaryCatalogCTerereLabel => 'Tereré';

  @override
  String get diaryCatalogCTererePrompt => 'Tomou tereré?';

  @override
  String get diaryCatalogCEnergLabel => 'Energético';

  @override
  String get diaryCatalogCEnergPrompt => 'Tomou energético?';

  @override
  String get diaryCatalogCSucoLabel => 'Suco natural';

  @override
  String get diaryCatalogCSucoPrompt => 'Tomou suco natural?';

  @override
  String get diaryCatalogCSucocxLabel => 'Suco de caixinha';

  @override
  String get diaryCatalogCSucocxPrompt => 'Tomou suco de caixinha ou em pó?';

  @override
  String get diaryCatalogCCocoLabel => 'Água de coco';

  @override
  String get diaryCatalogCCocoPrompt => 'Tomou água de coco?';

  @override
  String get diaryCatalogCIsotLabel => 'Isotônico';

  @override
  String get diaryCatalogCIsotPrompt => 'Tomou isotônico?';

  @override
  String get diaryCatalogCLeiteLabel => 'Leite';

  @override
  String get diaryCatalogCLeitePrompt => 'Tomou leite?';

  @override
  String get diaryCatalogCVegetalLabel => 'Bebida vegetal';

  @override
  String get diaryCatalogCVegetalPrompt => 'Tomou leite vegetal?';

  @override
  String get diaryCatalogCKombuchaLabel => 'Kombucha';

  @override
  String get diaryCatalogCKombuchaPrompt => 'Tomou kombucha?';

  @override
  String get diaryCatalogCCervejaLabel => 'Cerveja';

  @override
  String get diaryCatalogCCervejaPrompt => 'Tomou cerveja?';

  @override
  String get diaryCatalogCVinhoLabel => 'Vinho';

  @override
  String get diaryCatalogCVinhoPrompt => 'Tomou vinho?';

  @override
  String get diaryCatalogCCaipirinhaLabel => 'Caipirinha';

  @override
  String get diaryCatalogCCaipirinhaPrompt => 'Tomou caipirinha?';

  @override
  String get diaryCatalogCCachacaLabel => 'Cachaça';

  @override
  String get diaryCatalogCCachacaPrompt => 'Tomou cachaça?';

  @override
  String get diaryCatalogCDestiladoLabel => 'Destilado';

  @override
  String get diaryCatalogCDestiladoPrompt => 'Tomou vodka, whisky ou gin?';

  @override
  String get diaryCatalogCDrinksLabel => 'Drinks';

  @override
  String get diaryCatalogCDrinksPrompt => 'Tomou drinks?';

  @override
  String get diaryCatalogCAlctardeLabel => 'Álcool à noite';

  @override
  String get diaryCatalogCAlctardePrompt => 'Bebeu perto da hora de dormir?';

  @override
  String get diaryCatalogCRessacaLabel => 'Ressaca';

  @override
  String get diaryCatalogCRessacaPrompt => 'Acordou de ressaca?';

  @override
  String get diaryCatalogCAguagasLabel => 'Água com gás';

  @override
  String get diaryCatalogCAguagasPrompt => 'Tomou água com gás?';

  @override
  String get diaryCatalogCChaverdeLabel => 'Chá verde';

  @override
  String get diaryCatalogCChaverdePrompt => 'Tomou chá verde?';

  @override
  String get diaryCatalogCCamomilaLabel => 'Chá calmante';

  @override
  String get diaryCatalogCCamomilaPrompt =>
      'Tomou chá de camomila, erva-cidreira ou melissa?';

  @override
  String get diaryCatalogCDescafLabel => 'Café descafeinado';

  @override
  String get diaryCatalogCDescafPrompt => 'Tomou café descafeinado?';

  @override
  String get diaryCatalogCSmoothieLabel => 'Vitamina ou smoothie';

  @override
  String get diaryCatalogCSmoothiePrompt => 'Tomou vitamina de frutas?';

  @override
  String get diaryCatalogCShakeLabel => 'Shake de proteína';

  @override
  String get diaryCatalogCShakePrompt => 'Tomou shake de proteína?';

  @override
  String get diaryCatalogCCaldocanaLabel => 'Caldo de cana';

  @override
  String get diaryCatalogCCaldocanaPrompt => 'Tomou caldo de cana?';

  @override
  String get diaryCatalogCAchocLabel => 'Achocolatado';

  @override
  String get diaryCatalogCAchocPrompt => 'Tomou achocolatado?';

  @override
  String get diaryCatalogCSemalcLabel => 'Cerveja sem álcool';

  @override
  String get diaryCatalogCSemalcPrompt => 'Tomou cerveja sem álcool?';

  @override
  String get diaryCatalogCBebquenteLabel => 'Bebida quente à noite';

  @override
  String get diaryCatalogCBebquentePrompt =>
      'Tomou algo quente antes de dormir?';

  @override
  String get diaryCatalogCAguamanhaLabel => 'Água ao acordar';

  @override
  String get diaryCatalogCAguamanhaPrompt => 'Bebeu água logo ao acordar?';

  @override
  String get diaryCatalogCCafemLabel => 'Café da manhã';

  @override
  String get diaryCatalogCCafemPrompt => 'Tomou café da manhã?';

  @override
  String get diaryCatalogCCafemanhaLabel => 'Café da manhã';

  @override
  String get diaryCatalogCCafemanhaPrompt => 'Tomou café da manhã?';

  @override
  String get diaryCatalogCAlmLabel => 'Almoço';

  @override
  String get diaryCatalogCAlmPrompt => 'Almoçou?';

  @override
  String get diaryCatalogCJantarLabel => 'Jantar';

  @override
  String get diaryCatalogCJantarPrompt => 'Jantou?';

  @override
  String get diaryCatalogCLancheLabel => 'Lanche da tarde';

  @override
  String get diaryCatalogCLanchePrompt => 'Fez lanche da tarde?';

  @override
  String get diaryCatalogCBeliscouLabel => 'Beliscou';

  @override
  String get diaryCatalogCBeliscouPrompt => 'Beliscou entre as refeições?';

  @override
  String get diaryCatalogCPularefLabel => 'Pulou refeição';

  @override
  String get diaryCatalogCPularefPrompt => 'Pulou alguma refeição?';

  @override
  String get diaryCatalogCTardeLabel => 'Comeu tarde';

  @override
  String get diaryCatalogCTardePrompt => 'Comeu perto da hora de dormir?';

  @override
  String get diaryCatalogCJejumLabel => 'Jejum';

  @override
  String get diaryCatalogCJejumPrompt => 'Fez jejum intermitente?';

  @override
  String get diaryCatalogCComeudemaisLabel => 'Comeu demais';

  @override
  String get diaryCatalogCComeudemaisPrompt => 'Comeu além do ponto?';

  @override
  String get diaryCatalogCPesadaLabel => 'Refeição pesada';

  @override
  String get diaryCatalogCPesadaPrompt => 'Fez uma refeição pesada?';

  @override
  String get diaryCatalogCProtLabel => 'Proteína';

  @override
  String get diaryCatalogCProtPrompt => 'Bateu a proteína do dia?';

  @override
  String get diaryCatalogCCaseiraLabel => 'Comida caseira';

  @override
  String get diaryCatalogCCaseiraPrompt => 'Comeu comida feita em casa?';

  @override
  String get diaryCatalogCMarmitaLabel => 'Marmita';

  @override
  String get diaryCatalogCMarmitaPrompt => 'Levou marmita?';

  @override
  String get diaryCatalogCForaLabel => 'Comeu fora';

  @override
  String get diaryCatalogCForaPrompt => 'Comeu em restaurante?';

  @override
  String get diaryCatalogCDeliveryLabel => 'Delivery';

  @override
  String get diaryCatalogCDeliveryPrompt => 'Pediu comida por aplicativo?';

  @override
  String get diaryCatalogCFastfoodLabel => 'Fast food';

  @override
  String get diaryCatalogCFastfoodPrompt => 'Comeu fast food?';

  @override
  String get diaryCatalogCPizzaLabel => 'Pizza';

  @override
  String get diaryCatalogCPizzaPrompt => 'Comeu pizza?';

  @override
  String get diaryCatalogCProcLabel => 'Sem processados';

  @override
  String get diaryCatalogCProcPrompt => 'Evitou ultraprocessados?';

  @override
  String get diaryCatalogCSalgLabel => 'Salgadinho';

  @override
  String get diaryCatalogCSalgPrompt =>
      'Comeu salgadinho ou biscoito recheado?';

  @override
  String get diaryCatalogCFritoLabel => 'Fritura';

  @override
  String get diaryCatalogCFritoPrompt => 'Comeu fritura?';

  @override
  String get diaryCatalogCPastelLabel => 'Pastel ou coxinha';

  @override
  String get diaryCatalogCPastelPrompt =>
      'Comeu pastel, coxinha ou salgado frito?';

  @override
  String get diaryCatalogCChocoLabel => 'Chocolate';

  @override
  String get diaryCatalogCChocoPrompt => 'Comeu chocolate?';

  @override
  String get diaryCatalogCSorveteLabel => 'Sorvete';

  @override
  String get diaryCatalogCSorvetePrompt => 'Tomou sorvete?';

  @override
  String get diaryCatalogCBrigadeiroLabel => 'Brigadeiro ou bolo';

  @override
  String get diaryCatalogCBrigadeiroPrompt => 'Comeu brigadeiro ou bolo?';

  @override
  String get diaryCatalogCFrutaLabel => 'Frutas';

  @override
  String get diaryCatalogCFrutaPrompt => 'Comeu frutas?';

  @override
  String get diaryCatalogCVerduraLabel => 'Salada e verduras';

  @override
  String get diaryCatalogCVerduraPrompt => 'Comeu salada ou verduras?';

  @override
  String get diaryCatalogCLegumeLabel => 'Legumes';

  @override
  String get diaryCatalogCLegumePrompt => 'Comeu legumes?';

  @override
  String get diaryCatalogCFibraLabel => 'Fibras';

  @override
  String get diaryCatalogCFibraPrompt => 'Comeu fibras?';

  @override
  String get diaryCatalogCFeijaoLabel => 'Feijão';

  @override
  String get diaryCatalogCFeijaoPrompt => 'Comeu feijão?';

  @override
  String get diaryCatalogCArrozLabel => 'Arroz integral';

  @override
  String get diaryCatalogCArrozPrompt => 'Comeu arroz integral?';

  @override
  String get diaryCatalogCOvoLabel => 'Ovos';

  @override
  String get diaryCatalogCOvoPrompt => 'Comeu ovos?';

  @override
  String get diaryCatalogCCarnevLabel => 'Carne vermelha';

  @override
  String get diaryCatalogCCarnevPrompt => 'Comeu carne vermelha?';

  @override
  String get diaryCatalogCFrangoLabel => 'Frango';

  @override
  String get diaryCatalogCFrangoPrompt => 'Comeu frango?';

  @override
  String get diaryCatalogCPeixeLabel => 'Peixe';

  @override
  String get diaryCatalogCPeixePrompt => 'Comeu peixe?';

  @override
  String get diaryCatalogCEmbutLabel => 'Embutidos';

  @override
  String get diaryCatalogCEmbutPrompt =>
      'Comeu presunto, salsicha ou linguiça?';

  @override
  String get diaryCatalogCChurrascoLabel => 'Churrasco';

  @override
  String get diaryCatalogCChurrascoPrompt => 'Comeu churrasco?';

  @override
  String get diaryCatalogCFeijoadaLabel => 'Feijoada';

  @override
  String get diaryCatalogCFeijoadaPrompt => 'Comeu feijoada?';

  @override
  String get diaryCatalogCAcaiLabel => 'Açaí';

  @override
  String get diaryCatalogCAcaiPrompt => 'Tomou açaí?';

  @override
  String get diaryCatalogCTapiocaLabel => 'Tapioca ou cuscuz';

  @override
  String get diaryCatalogCTapiocaPrompt => 'Comeu tapioca ou cuscuz?';

  @override
  String get diaryCatalogCPaoqueijoLabel => 'Pão de queijo';

  @override
  String get diaryCatalogCPaoqueijoPrompt => 'Comeu pão de queijo?';

  @override
  String get diaryCatalogCPaobrancoLabel => 'Pão branco';

  @override
  String get diaryCatalogCPaobrancoPrompt => 'Comeu pão francês ou pão branco?';

  @override
  String get diaryCatalogCMacarraoLabel => 'Massa';

  @override
  String get diaryCatalogCMacarraoPrompt => 'Comeu macarrão ou massa?';

  @override
  String get diaryCatalogCLatLabel => 'Sem laticínios';

  @override
  String get diaryCatalogCLatPrompt => 'Ficou sem leite e derivados?';

  @override
  String get diaryCatalogCGlutenLabel => 'Sem glúten';

  @override
  String get diaryCatalogCGlutenPrompt => 'Ficou sem glúten?';

  @override
  String get diaryCatalogCVeganoLabel => 'Sem carne';

  @override
  String get diaryCatalogCVeganoPrompt => 'Ficou sem carne no dia?';

  @override
  String get diaryCatalogCCarboLabel => 'Pouco carboidrato';

  @override
  String get diaryCatalogCCarboPrompt => 'Comeu pouco carboidrato?';

  @override
  String get diaryCatalogCApimentadaLabel => 'Comida apimentada';

  @override
  String get diaryCatalogCApimentadaPrompt => 'Comeu comida apimentada?';

  @override
  String get diaryCatalogCSalLabel => 'Muito sal';

  @override
  String get diaryCatalogCSalPrompt => 'Comeu comida muito salgada?';

  @override
  String get diaryCatalogCAdocanteLabel => 'Adoçante';

  @override
  String get diaryCatalogCAdocantePrompt => 'Usou adoçante?';

  @override
  String get diaryCatalogCProtcafeLabel => 'Proteína no café';

  @override
  String get diaryCatalogCProtcafePrompt => 'Comeu proteína no café da manhã?';

  @override
  String get diaryCatalogCCarbonoiteLabel => 'Carboidrato à noite';

  @override
  String get diaryCatalogCCarbonoitePrompt => 'Comeu carboidrato no jantar?';

  @override
  String get diaryCatalogCJantarleveLabel => 'Jantar leve';

  @override
  String get diaryCatalogCJantarlevePrompt => 'Jantou leve?';

  @override
  String get diaryCatalogCAveiaLabel => 'Aveia';

  @override
  String get diaryCatalogCAveiaPrompt => 'Comeu aveia?';

  @override
  String get diaryCatalogCIogurteLabel => 'Iogurte';

  @override
  String get diaryCatalogCIogurtePrompt => 'Comeu iogurte?';

  @override
  String get diaryCatalogCQueijoLabel => 'Queijo';

  @override
  String get diaryCatalogCQueijoPrompt => 'Comeu queijo?';

  @override
  String get diaryCatalogCCastanhaLabel => 'Castanhas';

  @override
  String get diaryCatalogCCastanhaPrompt => 'Comeu castanhas ou nozes?';

  @override
  String get diaryCatalogCAbacateLabel => 'Abacate';

  @override
  String get diaryCatalogCAbacatePrompt => 'Comeu abacate?';

  @override
  String get diaryCatalogCTubercLabel => 'Batata-doce ou mandioca';

  @override
  String get diaryCatalogCTubercPrompt =>
      'Comeu batata-doce, mandioca ou inhame?';

  @override
  String get diaryCatalogCSopaLabel => 'Sopa';

  @override
  String get diaryCatalogCSopaPrompt => 'Tomou sopa?';

  @override
  String get diaryCatalogCJaponesLabel => 'Comida japonesa';

  @override
  String get diaryCatalogCJaponesPrompt => 'Comeu comida japonesa?';

  @override
  String get diaryCatalogCHamburguerLabel => 'Hambúrguer';

  @override
  String get diaryCatalogCHamburguerPrompt => 'Comeu hambúrguer?';

  @override
  String get diaryCatalogCCongeladoLabel => 'Comida congelada';

  @override
  String get diaryCatalogCCongeladoPrompt => 'Comeu comida pronta congelada?';

  @override
  String get diaryCatalogCSobremesaLabel => 'Sobremesa';

  @override
  String get diaryCatalogCSobremesaPrompt => 'Comeu sobremesa?';

  @override
  String get diaryCatalogCRapidoLabel => 'Comeu rápido';

  @override
  String get diaryCatalogCRapidoPrompt => 'Comeu com pressa?';

  @override
  String get diaryCatalogCTela2Label => 'Comeu vendo tela';

  @override
  String get diaryCatalogCTela2Prompt => 'Comeu assistindo TV ou celular?';

  @override
  String get diaryCatalogCEmfamiliaLabel => 'Refeição em família';

  @override
  String get diaryCatalogCEmfamiliaPrompt => 'Comeu junto com a família?';

  @override
  String get diaryCatalogCCozinhouLabel => 'Cozinhou';

  @override
  String get diaryCatalogCCozinhouPrompt => 'Cozinhou a própria comida?';

  @override
  String get diaryCatalogCLivreLabel => 'Refeição livre';

  @override
  String get diaryCatalogCLivrePrompt => 'Fez uma refeição livre?';

  @override
  String get diaryCatalogCFomeLabel => 'Passou fome';

  @override
  String get diaryCatalogCFomePrompt => 'Ficou muitas horas sem comer?';

  @override
  String get diaryCatalogCCabecaLabel => 'Cabeça';

  @override
  String get diaryCatalogCCabecaPrompt => 'Como está sua cabeça?';

  @override
  String get diaryCatalogCDisposicaoLabel => 'Disposição';

  @override
  String get diaryCatalogCDisposicaoPrompt => 'Como está sua disposição?';

  @override
  String get diaryCatalogCAnsLabel => 'Ansiedade';

  @override
  String get diaryCatalogCAnsPrompt => 'Se sentiu nervoso ou ansioso?';

  @override
  String get diaryCatalogCEstresLabel => 'Estresse';

  @override
  String get diaryCatalogCEstresPrompt => 'Teve um dia estressante?';

  @override
  String get diaryCatalogCHumorLabel => 'Bom humor';

  @override
  String get diaryCatalogCHumorPrompt => 'Teve um dia de bom humor?';

  @override
  String get diaryCatalogCIrritLabel => 'Irritação';

  @override
  String get diaryCatalogCIrritPrompt => 'Se sentiu irritado?';

  @override
  String get diaryCatalogCTristeLabel => 'Tristeza';

  @override
  String get diaryCatalogCTristePrompt => 'Se sentiu triste?';

  @override
  String get diaryCatalogCDesanimoLabel => 'Desânimo';

  @override
  String get diaryCatalogCDesanimoPrompt =>
      'Se sentiu sem energia ou desanimado?';

  @override
  String get diaryCatalogCMotivLabel => 'Motivação';

  @override
  String get diaryCatalogCMotivPrompt => 'Se sentiu motivado?';

  @override
  String get diaryCatalogCFocoLabel => 'Foco';

  @override
  String get diaryCatalogCFocoPrompt => 'Conseguiu se concentrar bem?';

  @override
  String get diaryCatalogCProdLabel => 'Produtivo';

  @override
  String get diaryCatalogCProdPrompt => 'Teve um dia produtivo?';

  @override
  String get diaryCatalogCSobrecLabel => 'Sobrecarga';

  @override
  String get diaryCatalogCSobrecPrompt => 'Se sentiu sobrecarregado?';

  @override
  String get diaryCatalogCPreocLabel => 'Preocupação';

  @override
  String get diaryCatalogCPreocPrompt => 'Ficou preocupado com algo?';

  @override
  String get diaryCatalogCDinheiroLabel => 'Dinheiro';

  @override
  String get diaryCatalogCDinheiroPrompt => 'Se preocupou com dinheiro?';

  @override
  String get diaryCatalogCConflitoLabel => 'Discussão';

  @override
  String get diaryCatalogCConflitoPrompt => 'Teve alguma discussão?';

  @override
  String get diaryCatalogCSozinhoLabel => 'Solidão';

  @override
  String get diaryCatalogCSozinhoPrompt => 'Se sentiu sozinho?';

  @override
  String get diaryCatalogCRisadaLabel => 'Risadas';

  @override
  String get diaryCatalogCRisadaPrompt => 'Deu boas risadas?';

  @override
  String get diaryCatalogCGratLabel => 'Gratidão';

  @override
  String get diaryCatalogCGratPrompt => 'Pensou ou escreveu sobre gratidão?';

  @override
  String get diaryCatalogCMeditLabel => 'Meditação';

  @override
  String get diaryCatalogCMeditPrompt => 'Meditou?';

  @override
  String get diaryCatalogCTerapiaLabel => 'Terapia';

  @override
  String get diaryCatalogCTerapiaPrompt => 'Teve sessão de terapia?';

  @override
  String get diaryCatalogCFeLabel => 'Oração ou fé';

  @override
  String get diaryCatalogCFePrompt => 'Rezou, orou ou foi à igreja?';

  @override
  String get diaryCatalogCEscritaLabel => 'Escreveu';

  @override
  String get diaryCatalogCEscritaPrompt => 'Escreveu num diário?';

  @override
  String get diaryCatalogCLeituraLabel => 'Leitura';

  @override
  String get diaryCatalogCLeituraPrompt => 'Leu um livro?';

  @override
  String get diaryCatalogCHobbyLabel => 'Hobby';

  @override
  String get diaryCatalogCHobbyPrompt => 'Fez algo que gosta só por prazer?';

  @override
  String get diaryCatalogCMusicaLabel => 'Música';

  @override
  String get diaryCatalogCMusicaPrompt => 'Ouviu ou tocou música?';

  @override
  String get diaryCatalogCSocialLabel => 'Amigos';

  @override
  String get diaryCatalogCSocialPrompt => 'Encontrou amigos?';

  @override
  String get diaryCatalogCFamiliaLabel => 'Família';

  @override
  String get diaryCatalogCFamiliaPrompt => 'Passou tempo com a família?';

  @override
  String get diaryCatalogCNaturezaLabel => 'Natureza';

  @override
  String get diaryCatalogCNaturezaPrompt => 'Passou tempo na natureza?';

  @override
  String get diaryCatalogCRedesLabel => 'Redes sociais';

  @override
  String get diaryCatalogCRedesPrompt => 'Ficou muito tempo nas redes sociais?';

  @override
  String get diaryCatalogCNoticiasLabel => 'Notícias';

  @override
  String get diaryCatalogCNoticiasPrompt => 'Consumiu muita notícia?';

  @override
  String get diaryCatalogCDesconectLabel => 'Desconectou';

  @override
  String get diaryCatalogCDesconectPrompt => 'Ficou um tempo longe do celular?';

  @override
  String get diaryCatalogCTedioLabel => 'Tédio';

  @override
  String get diaryCatalogCTedioPrompt => 'Sentiu tédio?';

  @override
  String get diaryCatalogCAceleradoLabel => 'Pensamento acelerado';

  @override
  String get diaryCatalogCAceleradoPrompt => 'Ficou com a cabeça a mil?';

  @override
  String get diaryCatalogCPanicoLabel => 'Crise de ansiedade';

  @override
  String get diaryCatalogCPanicoPrompt => 'Teve crise de ansiedade ou pânico?';

  @override
  String get diaryCatalogCLutoLabel => 'Luto';

  @override
  String get diaryCatalogCLutoPrompt => 'Está passando por um luto?';

  @override
  String get diaryCatalogCAutoestLabel => 'Autoestima boa';

  @override
  String get diaryCatalogCAutoestPrompt => 'Se sentiu bem consigo mesmo?';

  @override
  String get diaryCatalogCArlivreLabel => 'Ar livre';

  @override
  String get diaryCatalogCArlivrePrompt => 'Passou tempo ao ar livre?';

  @override
  String get diaryCatalogCVoluntLabel => 'Ajudou alguém';

  @override
  String get diaryCatalogCVoluntPrompt => 'Fez algo por alguém hoje?';

  @override
  String get diaryCatalogCAprendeuLabel => 'Aprendeu algo';

  @override
  String get diaryCatalogCAprendeuPrompt => 'Aprendeu algo novo?';

  @override
  String get diaryCatalogCConversaLabel => 'Conversa importante';

  @override
  String get diaryCatalogCConversaPrompt =>
      'Teve uma conversa difícil ou importante?';

  @override
  String get diaryCatalogCSemtempoLabel => 'Sem tempo para si';

  @override
  String get diaryCatalogCSemtempoPrompt => 'Ficou sem nenhum tempo para você?';

  @override
  String get diaryCatalogCCalmaLabel => 'Dia tranquilo';

  @override
  String get diaryCatalogCCalmaPrompt => 'Teve um dia tranquilo?';

  @override
  String get diaryCatalogCHomeoffLabel => 'Home office';

  @override
  String get diaryCatalogCHomeoffPrompt => 'Trabalhou de casa?';

  @override
  String get diaryCatalogCPresencialLabel => 'Trabalho presencial';

  @override
  String get diaryCatalogCPresencialPrompt => 'Trabalhou no escritório?';

  @override
  String get diaryCatalogCLongoLabel => 'Expediente longo';

  @override
  String get diaryCatalogCLongoPrompt => 'Trabalhou mais de 10 horas?';

  @override
  String get diaryCatalogCReuniaoLabel => 'Reunião à noite';

  @override
  String get diaryCatalogCReuniaoPrompt => 'Trabalhou ou fez reunião à noite?';

  @override
  String get diaryCatalogCPlantaoLabel => 'Plantão';

  @override
  String get diaryCatalogCPlantaoPrompt =>
      'Trabalhou de madrugada ou de plantão?';

  @override
  String get diaryCatalogCTransitoLabel => 'Trânsito';

  @override
  String get diaryCatalogCTransitoPrompt => 'Pegou muito trânsito?';

  @override
  String get diaryCatalogCDirigiuLabel => 'Dirigiu muito';

  @override
  String get diaryCatalogCDirigiuPrompt => 'Dirigiu por mais de 1 hora?';

  @override
  String get diaryCatalogCOnibusLabel => 'Transporte público';

  @override
  String get diaryCatalogCOnibusPrompt => 'Pegou ônibus ou metrô lotado?';

  @override
  String get diaryCatalogCSentadoLabel => 'Muito sentado';

  @override
  String get diaryCatalogCSentadoPrompt => 'Passou o dia muito sentado?';

  @override
  String get diaryCatalogCEmpeLabel => 'Em pé';

  @override
  String get diaryCatalogCEmpePrompt => 'Passou muito tempo em pé?';

  @override
  String get diaryCatalogCPassosLabel => 'Caminhada';

  @override
  String get diaryCatalogCPassosPrompt => 'Caminhou mais de 30 minutos?';

  @override
  String get diaryCatalogCEscadasLabel => 'Escadas';

  @override
  String get diaryCatalogCEscadasPrompt => 'Subiu escadas?';

  @override
  String get diaryCatalogCCasa2Label => 'Tarefas de casa';

  @override
  String get diaryCatalogCCasa2Prompt =>
      'Fez faxina ou tarefas pesadas de casa?';

  @override
  String get diaryCatalogCFilhosLabel => 'Cuidou de criança';

  @override
  String get diaryCatalogCFilhosPrompt => 'Cuidou de criança o dia todo?';

  @override
  String get diaryCatalogCPetsLabel => 'Pet';

  @override
  String get diaryCatalogCPetsPrompt => 'Passeou ou brincou com o pet?';

  @override
  String get diaryCatalogCViagemLabel => 'Viagem';

  @override
  String get diaryCatalogCViagemPrompt => 'Viajou?';

  @override
  String get diaryCatalogCVooLabel => 'Voo';

  @override
  String get diaryCatalogCVooPrompt => 'Pegou avião?';

  @override
  String get diaryCatalogCFusoLabel => 'Fuso horário';

  @override
  String get diaryCatalogCFusoPrompt => 'Mudou de fuso horário?';

  @override
  String get diaryCatalogCPraiaLabel => 'Praia';

  @override
  String get diaryCatalogCPraiaPrompt => 'Foi à praia?';

  @override
  String get diaryCatalogCPiscinaLabel => 'Piscina';

  @override
  String get diaryCatalogCPiscinaPrompt => 'Entrou na piscina?';

  @override
  String get diaryCatalogCCalorLabel => 'Calor forte';

  @override
  String get diaryCatalogCCalorPrompt => 'Ficou muito tempo no calor?';

  @override
  String get diaryCatalogCFrioLabel => 'Frio';

  @override
  String get diaryCatalogCFrioPrompt => 'Passou frio?';

  @override
  String get diaryCatalogCFestaLabel => 'Festa ou balada';

  @override
  String get diaryCatalogCFestaPrompt => 'Saiu à noite?';

  @override
  String get diaryCatalogCShowLabel => 'Show';

  @override
  String get diaryCatalogCShowPrompt => 'Foi a um show ou evento?';

  @override
  String get diaryCatalogCFutebolLabel => 'Assistiu ao jogo';

  @override
  String get diaryCatalogCFutebolPrompt => 'Assistiu a jogo de futebol?';

  @override
  String get diaryCatalogCPeladaLabel => 'Pelada';

  @override
  String get diaryCatalogCPeladaPrompt => 'Jogou bola com os amigos?';

  @override
  String get diaryCatalogCGamesLabel => 'Videogame';

  @override
  String get diaryCatalogCGamesPrompt => 'Jogou videogame?';

  @override
  String get diaryCatalogCSerieLabel => 'Maratonou série';

  @override
  String get diaryCatalogCSeriePrompt => 'Ficou horas vendo série?';

  @override
  String get diaryCatalogCSexoLabel => 'Atividade sexual';

  @override
  String get diaryCatalogCSexoPrompt => 'Teve atividade sexual?';

  @override
  String get diaryCatalogCCigarLabel => 'Cigarro';

  @override
  String get diaryCatalogCCigarPrompt => 'Fumou?';

  @override
  String get diaryCatalogCVapeLabel => 'Vape';

  @override
  String get diaryCatalogCVapePrompt => 'Usou vape ou pod?';

  @override
  String get diaryCatalogCNarguileLabel => 'Narguilé';

  @override
  String get diaryCatalogCNarguilePrompt => 'Fumou narguilé?';

  @override
  String get diaryCatalogCCanabLabel => 'Cannabis';

  @override
  String get diaryCatalogCCanabPrompt => 'Usou cannabis?';

  @override
  String get diaryCatalogCAcordoucedoLabel => 'Acordou cedo';

  @override
  String get diaryCatalogCAcordoucedoPrompt => 'Acordou antes das 6h?';

  @override
  String get diaryCatalogCDormiuforaLabel => 'Dormiu fora de casa';

  @override
  String get diaryCatalogCDormiuforaPrompt => 'Dormiu fora de casa?';

  @override
  String get diaryCatalogCViagemtrabLabel => 'Viagem a trabalho';

  @override
  String get diaryCatalogCViagemtrabPrompt => 'Viajou a trabalho?';

  @override
  String get diaryCatalogCPrazoLabel => 'Prazo ou prova';

  @override
  String get diaryCatalogCPrazoPrompt =>
      'Teve prazo, prova ou entrega importante?';

  @override
  String get diaryCatalogCPublicoLabel => 'Falou em público';

  @override
  String get diaryCatalogCPublicoPrompt => 'Fez apresentação em público?';

  @override
  String get diaryCatalogCCuidadorLabel => 'Cuidou de alguém';

  @override
  String get diaryCatalogCCuidadorPrompt =>
      'Cuidou de um familiar doente ou idoso?';

  @override
  String get diaryCatalogCMudancaLabel => 'Mudança';

  @override
  String get diaryCatalogCMudancaPrompt => 'Está de mudança ou em obra?';

  @override
  String get diaryCatalogCJardimLabel => 'Jardinagem';

  @override
  String get diaryCatalogCJardimPrompt => 'Mexeu com plantas?';

  @override
  String get diaryCatalogCChuvaLabel => 'Dia de chuva';

  @override
  String get diaryCatalogCChuvaPrompt => 'Choveu o dia todo?';

  @override
  String get diaryCatalogCSecoLabel => 'Tempo seco';

  @override
  String get diaryCatalogCSecoPrompt => 'O ar estava muito seco?';

  @override
  String get diaryCatalogCFumacaLabel => 'Poluição ou fumaça';

  @override
  String get diaryCatalogCFumacaPrompt => 'Ficou exposto a poluição ou fumaça?';

  @override
  String get diaryCatalogCFolgaLabel => 'Dia de folga';

  @override
  String get diaryCatalogCFolgaPrompt => 'Foi um dia de folga?';

  @override
  String get diaryCatalogCAcordouLabel => 'Como acordou';

  @override
  String get diaryCatalogCAcordouPrompt => 'Como você acordou?';

  @override
  String get diaryCatalogCAlongLabel => 'Alongamento';

  @override
  String get diaryCatalogCAlongPrompt => 'Alongou?';

  @override
  String get diaryCatalogCMobilLabel => 'Mobilidade';

  @override
  String get diaryCatalogCMobilPrompt => 'Fez mobilidade?';

  @override
  String get diaryCatalogCSaunaLabel => 'Sauna';

  @override
  String get diaryCatalogCSaunaPrompt => 'Fez sauna?';

  @override
  String get diaryCatalogCBanhoqLabel => 'Banho quente';

  @override
  String get diaryCatalogCBanhoqPrompt => 'Tomou banho quente antes de dormir?';

  @override
  String get diaryCatalogCMassaLabel => 'Massagem';

  @override
  String get diaryCatalogCMassaPrompt => 'Fez massagem?';

  @override
  String get diaryCatalogCRoloLabel => 'Rolo';

  @override
  String get diaryCatalogCRoloPrompt => 'Usou rolo de liberação?';

  @override
  String get diaryCatalogCCompressLabel => 'Compressão';

  @override
  String get diaryCatalogCCompressPrompt => 'Usou botas de compressão?';

  @override
  String get diaryCatalogCFisioLabel => 'Fisioterapia';

  @override
  String get diaryCatalogCFisioPrompt => 'Teve fisioterapia?';

  @override
  String get diaryCatalogCQuiroLabel => 'Quiropraxia';

  @override
  String get diaryCatalogCQuiroPrompt => 'Teve quiropraxia ou osteopatia?';

  @override
  String get diaryCatalogCAcupLabel => 'Acupuntura';

  @override
  String get diaryCatalogCAcupPrompt => 'Fez acupuntura?';

  @override
  String get diaryCatalogCCochiloLabel => 'Cochilo';

  @override
  String get diaryCatalogCCochiloPrompt => 'Cochilou?';

  @override
  String get diaryCatalogCDescansoLabel => 'Dia de descanso';

  @override
  String get diaryCatalogCDescansoPrompt => 'Foi um dia de descanso?';

  @override
  String get diaryCatalogCYogaleveLabel => 'Yoga leve';

  @override
  String get diaryCatalogCYogalevePrompt => 'Fez yoga restaurativa?';

  @override
  String get diaryCatalogCPescocoLabel => 'Postura';

  @override
  String get diaryCatalogCPescocoPrompt => 'Cuidou da postura no trabalho?';

  @override
  String get diaryCatalogCBanheiraLabel => 'Banheira de gelo';

  @override
  String get diaryCatalogCBanheiraPrompt => 'Entrou na banheira de gelo?';

  @override
  String get diaryCatalogCCrioLabel => 'Crioterapia';

  @override
  String get diaryCatalogCCrioPrompt => 'Fez crioterapia de corpo inteiro?';

  @override
  String get diaryCatalogCContrasteLabel => 'Banho de contraste';

  @override
  String get diaryCatalogCContrastePrompt => 'Alternou água quente e fria?';

  @override
  String get diaryCatalogCOfuroLabel => 'Banho de imersão';

  @override
  String get diaryCatalogCOfuroPrompt => 'Tomou banho de imersão ou ofurô?';

  @override
  String get diaryCatalogCPistolaLabel => 'Pistola de massagem';

  @override
  String get diaryCatalogCPistolaPrompt => 'Usou pistola de massagem?';

  @override
  String get diaryCatalogCDrenagemLabel => 'Drenagem linfática';

  @override
  String get diaryCatalogCDrenagemPrompt => 'Fez drenagem linfática?';

  @override
  String get diaryCatalogCLuzvermLabel => 'Luz vermelha';

  @override
  String get diaryCatalogCLuzvermPrompt => 'Fez terapia de luz vermelha?';

  @override
  String get diaryCatalogCHiperbLabel => 'Câmara hiperbárica';

  @override
  String get diaryCatalogCHiperbPrompt => 'Fez sessão na câmara hiperbárica?';

  @override
  String get diaryCatalogCAlongnoiteLabel => 'Alongou antes de dormir';

  @override
  String get diaryCatalogCAlongnoitePrompt => 'Alongou antes de dormir?';

  @override
  String get diaryCatalogCPernasLabel => 'Pernas para cima';

  @override
  String get diaryCatalogCPernasPrompt => 'Ficou com as pernas para cima?';

  @override
  String get diaryCatalogCBolinhaLabel => 'Bolinha de liberação';

  @override
  String get diaryCatalogCBolinhaPrompt =>
      'Usou bolinha para soltar o músculo?';

  @override
  String get diaryCatalogCSolLabel => 'Sol da manhã';

  @override
  String get diaryCatalogCSolPrompt => 'Pegou sol pela manhã?';

  @override
  String get diaryCatalogCLuzLabel => 'Luz forte à noite';

  @override
  String get diaryCatalogCLuzPrompt => 'Ficou em luz forte depois das 21h?';

  @override
  String get diaryCatalogCTelaLabel => 'Tela na cama';

  @override
  String get diaryCatalogCTelaPrompt => 'Usou celular ou TV na cama?';

  @override
  String get diaryCatalogCOculosLabel => 'Óculos bloqueador';

  @override
  String get diaryCatalogCOculosPrompt => 'Usou óculos contra luz azul?';

  @override
  String get diaryCatalogCQuartoLabel => 'Quarto escuro';

  @override
  String get diaryCatalogCQuartoPrompt => 'Dormiu em quarto escuro?';

  @override
  String get diaryCatalogCFrescoLabel => 'Quarto fresco';

  @override
  String get diaryCatalogCFrescoPrompt => 'Dormiu em quarto fresco?';

  @override
  String get diaryCatalogCArcondLabel => 'Ar-condicionado';

  @override
  String get diaryCatalogCArcondPrompt => 'Dormiu com ar-condicionado?';

  @override
  String get diaryCatalogCVentilLabel => 'Ventilador';

  @override
  String get diaryCatalogCVentilPrompt => 'Dormiu com ventilador?';

  @override
  String get diaryCatalogCTampaoLabel => 'Tampão ou máscara';

  @override
  String get diaryCatalogCTampaoPrompt => 'Usou tampão de ouvido ou máscara?';

  @override
  String get diaryCatalogCLerCamaLabel => 'Leu antes de dormir';

  @override
  String get diaryCatalogCLerCamaPrompt => 'Leu antes de dormir?';

  @override
  String get diaryCatalogCDividiuLabel => 'Dividiu a cama';

  @override
  String get diaryCatalogCDividiuPrompt => 'Dividiu a cama com alguém?';

  @override
  String get diaryCatalogCRoncoLabel => 'Ronco do parceiro';

  @override
  String get diaryCatalogCRoncoPrompt => 'O ronco de alguém atrapalhou?';

  @override
  String get diaryCatalogCPetcamaLabel => 'Pet na cama';

  @override
  String get diaryCatalogCPetcamaPrompt => 'Dormiu com o pet?';

  @override
  String get diaryCatalogCFilhoLabel => 'Criança acordou';

  @override
  String get diaryCatalogCFilhoPrompt => 'Foi acordado por criança?';

  @override
  String get diaryCatalogCBarulhoLabel => 'Barulho';

  @override
  String get diaryCatalogCBarulhoPrompt => 'Teve barulho à noite?';

  @override
  String get diaryCatalogCCalornoiteLabel => 'Calor à noite';

  @override
  String get diaryCatalogCCalornoitePrompt => 'Passou calor dormindo?';

  @override
  String get diaryCatalogCHorarioLabel => 'Mesmo horário';

  @override
  String get diaryCatalogCHorarioPrompt => 'Deitou no horário de sempre?';

  @override
  String get diaryCatalogCTardouLabel => 'Deitou tarde';

  @override
  String get diaryCatalogCTardouPrompt => 'Deitou depois da meia-noite?';

  @override
  String get diaryCatalogCDespertLabel => 'Despertador';

  @override
  String get diaryCatalogCDespertPrompt => 'Acordou com despertador?';

  @override
  String get diaryCatalogCSonecaLabel => 'Soneca';

  @override
  String get diaryCatalogCSonecaPrompt => 'Apertou soneca no despertador?';

  @override
  String get diaryCatalogCMadrugadaLabel => 'Acordou de madrugada';

  @override
  String get diaryCatalogCMadrugadaPrompt =>
      'Acordou de madrugada e demorou a dormir?';

  @override
  String get diaryCatalogCPesadeloLabel => 'Sonhos agitados';

  @override
  String get diaryCatalogCPesadeloPrompt =>
      'Teve pesadelos ou sonhos agitados?';

  @override
  String get diaryCatalogCBanhonoiteLabel => 'Banho antes de dormir';

  @override
  String get diaryCatalogCBanhonoitePrompt => 'Tomou banho antes de dormir?';

  @override
  String get diaryCatalogCRotinaLabel => 'Rotina de sono';

  @override
  String get diaryCatalogCRotinaPrompt => 'Fez a sua rotina antes de dormir?';

  @override
  String get diaryCatalogCRuidoLabel => 'Ruído branco';

  @override
  String get diaryCatalogCRuidoPrompt => 'Dormiu com ruído branco?';

  @override
  String get diaryCatalogCMusicadormLabel => 'Música para dormir';

  @override
  String get diaryCatalogCMusicadormPrompt => 'Ouviu música para dormir?';

  @override
  String get diaryCatalogCCobertorLabel => 'Cobertor pesado';

  @override
  String get diaryCatalogCCobertorPrompt => 'Usou cobertor pesado?';

  @override
  String get diaryCatalogCFitabocaLabel => 'Fita na boca';

  @override
  String get diaryCatalogCFitabocaPrompt => 'Usou fita na boca para dormir?';

  @override
  String get diaryCatalogCSofaLabel => 'Dormiu no sofá';

  @override
  String get diaryCatalogCSofaPrompt => 'Pegou no sono no sofá?';

  @override
  String get diaryCatalogCCelmadrLabel => 'Celular de madrugada';

  @override
  String get diaryCatalogCCelmadrPrompt => 'Olhou o celular de madrugada?';

  @override
  String get diaryCatalogCBanheiroLabel => 'Levantou para o banheiro';

  @override
  String get diaryCatalogCBanheiroPrompt =>
      'Levantou para ir ao banheiro à noite?';

  @override
  String get diaryCatalogCCochilotardeLabel => 'Cochilo depois das 16h';

  @override
  String get diaryCatalogCCochilotardePrompt => 'Cochilou depois das 16h?';

  @override
  String get diaryCatalogCDorLabel => 'Dor de cabeça';

  @override
  String get diaryCatalogCDorPrompt => 'Sentiu dor de cabeça?';

  @override
  String get diaryCatalogCEnxaquecaLabel => 'Enxaqueca';

  @override
  String get diaryCatalogCEnxaquecaPrompt => 'Teve enxaqueca?';

  @override
  String get diaryCatalogCDoenteLabel => 'Doente';

  @override
  String get diaryCatalogCDoentePrompt => 'Se sentiu doente?';

  @override
  String get diaryCatalogCGripeLabel => 'Gripe ou resfriado';

  @override
  String get diaryCatalogCGripePrompt => 'Teve sintomas de gripe ou resfriado?';

  @override
  String get diaryCatalogCFebreLabel => 'Febre';

  @override
  String get diaryCatalogCFebrePrompt => 'Teve febre?';

  @override
  String get diaryCatalogCGargantaLabel => 'Dor de garganta';

  @override
  String get diaryCatalogCGargantaPrompt => 'Teve dor de garganta?';

  @override
  String get diaryCatalogCTosseLabel => 'Tosse';

  @override
  String get diaryCatalogCTossePrompt => 'Teve tosse?';

  @override
  String get diaryCatalogCCongestLabel => 'Nariz entupido';

  @override
  String get diaryCatalogCCongestPrompt => 'Ficou com o nariz entupido?';

  @override
  String get diaryCatalogCRiniteLabel => 'Rinite ou alergia';

  @override
  String get diaryCatalogCRinitePrompt => 'Teve crise de rinite ou alergia?';

  @override
  String get diaryCatalogCInchacoLabel => 'Inchaço';

  @override
  String get diaryCatalogCInchacoPrompt => 'Se sentiu inchado?';

  @override
  String get diaryCatalogCIntestinoLabel => 'Intestino em dia';

  @override
  String get diaryCatalogCIntestinoPrompt => 'O intestino funcionou bem?';

  @override
  String get diaryCatalogCPresoLabel => 'Intestino preso';

  @override
  String get diaryCatalogCPresoPrompt => 'Ficou com o intestino preso?';

  @override
  String get diaryCatalogCDiarreiaLabel => 'Diarreia';

  @override
  String get diaryCatalogCDiarreiaPrompt => 'Teve diarreia?';

  @override
  String get diaryCatalogCAziaLabel => 'Azia ou refluxo';

  @override
  String get diaryCatalogCAziaPrompt => 'Teve azia ou refluxo?';

  @override
  String get diaryCatalogCNauseaLabel => 'Enjoo';

  @override
  String get diaryCatalogCNauseaPrompt => 'Sentiu enjoo?';

  @override
  String get diaryCatalogCCostasLabel => 'Dor nas costas';

  @override
  String get diaryCatalogCCostasPrompt => 'Sentiu dor nas costas?';

  @override
  String get diaryCatalogCArticulLabel => 'Dor nas articulações';

  @override
  String get diaryCatalogCArticulPrompt => 'Sentiu dor nas articulações?';

  @override
  String get diaryCatalogCLesaoLabel => 'Lesão';

  @override
  String get diaryCatalogCLesaoPrompt => 'Está com alguma lesão?';

  @override
  String get diaryCatalogCDenteLabel => 'Dor de dente';

  @override
  String get diaryCatalogCDentePrompt => 'Teve dor de dente?';

  @override
  String get diaryCatalogCNevoaLabel => 'Mente nublada';

  @override
  String get diaryCatalogCNevoaPrompt => 'Sentiu a mente nublada?';

  @override
  String get diaryCatalogCTonturaLabel => 'Tontura';

  @override
  String get diaryCatalogCTonturaPrompt => 'Sentiu tontura?';

  @override
  String get diaryCatalogCCansacoLabel => 'Cansaço extremo';

  @override
  String get diaryCatalogCCansacoPrompt => 'Sentiu um cansaço fora do normal?';

  @override
  String get diaryCatalogCAcneLabel => 'Pele';

  @override
  String get diaryCatalogCAcnePrompt => 'Teve espinhas ou pele irritada?';

  @override
  String get diaryCatalogCPalpitLabel => 'Palpitação';

  @override
  String get diaryCatalogCPalpitPrompt => 'Sentiu o coração acelerar parado?';

  @override
  String get diaryCatalogCVacinaLabel => 'Vacina';

  @override
  String get diaryCatalogCVacinaPrompt => 'Tomou vacina?';

  @override
  String get diaryCatalogCConsultaLabel => 'Consulta médica';

  @override
  String get diaryCatalogCConsultaPrompt => 'Foi ao médico?';

  @override
  String get diaryCatalogCExameLabel => 'Exame de sangue';

  @override
  String get diaryCatalogCExamePrompt => 'Fez exame de sangue?';

  @override
  String get diaryCatalogCPressaoaltaLabel => 'Pressão alta';

  @override
  String get diaryCatalogCPressaoaltaPrompt => 'Sentiu a pressão alta?';

  @override
  String get diaryCatalogCPressaobaixaLabel => 'Pressão baixa';

  @override
  String get diaryCatalogCPressaobaixaPrompt => 'Sentiu a pressão baixa?';

  @override
  String get diaryCatalogCHipoglicLabel => 'Hipoglicemia';

  @override
  String get diaryCatalogCHipoglicPrompt => 'Teve queda de açúcar no sangue?';

  @override
  String get diaryCatalogCCaibraLabel => 'Cãibra';

  @override
  String get diaryCatalogCCaibraPrompt => 'Teve cãibra?';

  @override
  String get diaryCatalogCOlhosLabel => 'Olhos cansados';

  @override
  String get diaryCatalogCOlhosPrompt => 'Ficou com os olhos cansados?';

  @override
  String get diaryCatalogCOuvidoLabel => 'Dor de ouvido';

  @override
  String get diaryCatalogCOuvidoPrompt => 'Teve dor de ouvido?';

  @override
  String get diaryCatalogCSinusiteLabel => 'Sinusite';

  @override
  String get diaryCatalogCSinusitePrompt => 'Teve crise de sinusite?';

  @override
  String get diaryCatalogCAsmaLabel => 'Crise de asma';

  @override
  String get diaryCatalogCAsmaPrompt => 'Teve crise de asma?';

  @override
  String get diaryCatalogCJoelhoLabel => 'Dor no joelho';

  @override
  String get diaryCatalogCJoelhoPrompt => 'Sentiu dor no joelho?';

  @override
  String get diaryCatalogCOmbroLabel => 'Dor no ombro';

  @override
  String get diaryCatalogCOmbroPrompt => 'Sentiu dor no ombro?';

  @override
  String get diaryCatalogCDentistaLabel => 'Dentista';

  @override
  String get diaryCatalogCDentistaPrompt => 'Foi ao dentista?';

  @override
  String get diaryCatalogCProcedimentoLabel => 'Procedimento ou cirurgia';

  @override
  String get diaryCatalogCProcedimentoPrompt =>
      'Fez algum procedimento médico?';

  @override
  String get diaryCatalogCGasesLabel => 'Gases';

  @override
  String get diaryCatalogCGasesPrompt => 'Teve gases ou estufamento?';

  @override
  String get diaryCatalogCMenstrLabel => 'Menstruação';

  @override
  String get diaryCatalogCMenstrPrompt => 'Está menstruada?';

  @override
  String get diaryCatalogCFluxoLabel => 'Fluxo intenso';

  @override
  String get diaryCatalogCFluxoPrompt => 'O fluxo está intenso?';

  @override
  String get diaryCatalogCColicaLabel => 'Cólica';

  @override
  String get diaryCatalogCColicaPrompt => 'Teve cólica?';

  @override
  String get diaryCatalogCTpmLabel => 'TPM';

  @override
  String get diaryCatalogCTpmPrompt => 'Sentiu sintomas de TPM?';

  @override
  String get diaryCatalogCOvulLabel => 'Ovulação';

  @override
  String get diaryCatalogCOvulPrompt => 'Está ovulando?';

  @override
  String get diaryCatalogCAnticonLabel => 'Anticoncepcional';

  @override
  String get diaryCatalogCAnticonPrompt => 'Tomou anticoncepcional?';

  @override
  String get diaryCatalogCCaloraoLabel => 'Ondas de calor';

  @override
  String get diaryCatalogCCaloraoPrompt => 'Teve ondas de calor?';

  @override
  String get diaryCatalogCSuornoiteLabel => 'Suor noturno';

  @override
  String get diaryCatalogCSuornoitePrompt => 'Suou à noite?';

  @override
  String get diaryCatalogCLibidoLabel => 'Libido';

  @override
  String get diaryCatalogCLibidoPrompt => 'Sentiu a libido alta?';

  @override
  String get diaryCatalogCSeiosLabel => 'Seios sensíveis';

  @override
  String get diaryCatalogCSeiosPrompt => 'Sentiu os seios sensíveis?';

  @override
  String get diaryCatalogCRetencaoLabel => 'Retenção de líquido';

  @override
  String get diaryCatalogCRetencaoPrompt => 'Sentiu retenção de líquido?';

  @override
  String get diaryCatalogCGravidezLabel => 'Gravidez';

  @override
  String get diaryCatalogCGravidezPrompt => 'Está grávida?';

  @override
  String get diaryCatalogCAmamentLabel => 'Amamentação';

  @override
  String get diaryCatalogCAmamentPrompt => 'Está amamentando?';

  @override
  String get diaryCatalogCReposicaoLabel => 'Reposição hormonal';

  @override
  String get diaryCatalogCReposicaoPrompt => 'Fez reposição hormonal?';

  @override
  String get diaryCatalogCTestoLabel => 'Testosterona';

  @override
  String get diaryCatalogCTestoPrompt => 'Aplicou testosterona?';

  @override
  String get diaryCatalogCEscapeLabel => 'Escape';

  @override
  String get diaryCatalogCEscapePrompt => 'Teve escape fora da menstruação?';

  @override
  String get diaryCatalogCAcnehormLabel => 'Acne hormonal';

  @override
  String get diaryCatalogCAcnehormPrompt => 'Teve espinhas do ciclo?';

  @override
  String get diaryCatalogCHumorcicloLabel => 'Humor do ciclo';

  @override
  String get diaryCatalogCHumorcicloPrompt =>
      'Sentiu o humor mudar com o ciclo?';

  @override
  String get diaryCatalogCMenopausaLabel => 'Menopausa';

  @override
  String get diaryCatalogCMenopausaPrompt => 'Sentiu sintomas da menopausa?';

  @override
  String get diaryCatalogCTesteovulLabel => 'Teste de ovulação';

  @override
  String get diaryCatalogCTesteovulPrompt => 'Fez teste de ovulação?';

  @override
  String get diaryCatalogCTentandoLabel => 'Tentando engravidar';

  @override
  String get diaryCatalogCTentandoPrompt => 'Está tentando engravidar?';

  @override
  String get diaryCatalogCPospartoLabel => 'Pós-parto';

  @override
  String get diaryCatalogCPospartoPrompt => 'Está no pós-parto?';

  @override
  String get diaryCatalogCMagLabel => 'Magnésio';

  @override
  String get diaryCatalogCMagPrompt => 'Tomou magnésio?';

  @override
  String get diaryCatalogCWheyLabel => 'Whey';

  @override
  String get diaryCatalogCWheyPrompt => 'Tomou whey?';

  @override
  String get diaryCatalogCVitdLabel => 'Vitamina D';

  @override
  String get diaryCatalogCVitdPrompt => 'Tomou vitamina D?';

  @override
  String get diaryCatalogCOmegaLabel => 'Ômega 3';

  @override
  String get diaryCatalogCOmegaPrompt => 'Tomou ômega 3?';

  @override
  String get diaryCatalogCColagLabel => 'Colágeno';

  @override
  String get diaryCatalogCColagPrompt => 'Tomou colágeno?';

  @override
  String get diaryCatalogCAshwaLabel => 'Ashwagandha';

  @override
  String get diaryCatalogCAshwaPrompt => 'Tomou ashwagandha?';

  @override
  String get diaryCatalogCZincoLabel => 'Zinco';

  @override
  String get diaryCatalogCZincoPrompt => 'Tomou zinco?';

  @override
  String get diaryCatalogCFerroLabel => 'Ferro';

  @override
  String get diaryCatalogCFerroPrompt => 'Tomou ferro?';

  @override
  String get diaryCatalogCB12Label => 'Vitamina B12';

  @override
  String get diaryCatalogCB12Prompt => 'Tomou vitamina B12?';

  @override
  String get diaryCatalogCComplexobLabel => 'Complexo B';

  @override
  String get diaryCatalogCComplexobPrompt => 'Tomou complexo B?';

  @override
  String get diaryCatalogCVitcLabel => 'Vitamina C';

  @override
  String get diaryCatalogCVitcPrompt => 'Tomou vitamina C?';

  @override
  String get diaryCatalogCK2Label => 'Vitamina K2';

  @override
  String get diaryCatalogCK2Prompt => 'Tomou vitamina K2?';

  @override
  String get diaryCatalogCMultiLabel => 'Multivitamínico';

  @override
  String get diaryCatalogCMultiPrompt => 'Tomou multivitamínico?';

  @override
  String get diaryCatalogCProbioLabel => 'Probiótico';

  @override
  String get diaryCatalogCProbioPrompt => 'Tomou probiótico?';

  @override
  String get diaryCatalogCPsylliumLabel => 'Fibras (psyllium)';

  @override
  String get diaryCatalogCPsylliumPrompt => 'Tomou fibra em pó?';

  @override
  String get diaryCatalogCGlicinaLabel => 'Glicina';

  @override
  String get diaryCatalogCGlicinaPrompt => 'Tomou glicina?';

  @override
  String get diaryCatalogCTeaninaLabel => 'L-teanina';

  @override
  String get diaryCatalogCTeaninaPrompt => 'Tomou L-teanina?';

  @override
  String get diaryCatalogCCafcapLabel => 'Cafeína em cápsula';

  @override
  String get diaryCatalogCCafcapPrompt => 'Tomou cafeína em cápsula?';

  @override
  String get diaryCatalogCPretreinoLabel => 'Pré-treino';

  @override
  String get diaryCatalogCPretreinoPrompt => 'Tomou pré-treino?';

  @override
  String get diaryCatalogCBetaLabel => 'Beta-alanina';

  @override
  String get diaryCatalogCBetaPrompt => 'Tomou beta-alanina?';

  @override
  String get diaryCatalogCEletroLabel => 'Eletrólitos';

  @override
  String get diaryCatalogCEletroPrompt => 'Tomou eletrólitos?';

  @override
  String get diaryCatalogCCurcumaLabel => 'Cúrcuma';

  @override
  String get diaryCatalogCCurcumaPrompt => 'Tomou cúrcuma?';

  @override
  String get diaryCatalogCPropolisLabel => 'Própolis';

  @override
  String get diaryCatalogCPropolisPrompt => 'Tomou própolis?';

  @override
  String get diaryCatalogCMacaLabel => 'Maca peruana';

  @override
  String get diaryCatalogCMacaPrompt => 'Tomou maca peruana?';

  @override
  String get diaryCatalogCSpirulLabel => 'Spirulina';

  @override
  String get diaryCatalogCSpirulPrompt => 'Tomou spirulina?';

  @override
  String get diaryCatalogCCogumLabel => 'Cogumelos';

  @override
  String get diaryCatalogCCogumPrompt => 'Tomou cogumelos adaptógenos?';

  @override
  String get diaryCatalogCBiotinaLabel => 'Biotina';

  @override
  String get diaryCatalogCBiotinaPrompt => 'Tomou biotina?';

  @override
  String get diaryCatalogCCalcioLabel => 'Cálcio';

  @override
  String get diaryCatalogCCalcioPrompt => 'Tomou cálcio?';

  @override
  String get diaryCatalogCSelenioLabel => 'Selênio';

  @override
  String get diaryCatalogCSelenioPrompt => 'Tomou selênio?';

  @override
  String get diaryCatalogCCoq10Label => 'Coenzima Q10';

  @override
  String get diaryCatalogCCoq10Prompt => 'Tomou coenzima Q10?';

  @override
  String get diaryCatalogCNacLabel => 'NAC';

  @override
  String get diaryCatalogCNacPrompt => 'Tomou NAC (N-acetilcisteína)?';

  @override
  String get diaryCatalogCCitrulinaLabel => 'Citrulina';

  @override
  String get diaryCatalogCCitrulinaPrompt => 'Tomou citrulina?';

  @override
  String get diaryCatalogCGlutaminaLabel => 'Glutamina';

  @override
  String get diaryCatalogCGlutaminaPrompt => 'Tomou glutamina?';

  @override
  String get diaryCatalogCBcaaLabel => 'BCAA';

  @override
  String get diaryCatalogCBcaaPrompt => 'Tomou BCAA?';

  @override
  String get diaryCatalogCTaurinaLabel => 'Taurina';

  @override
  String get diaryCatalogCTaurinaPrompt => 'Tomou taurina?';

  @override
  String get diaryCatalogCCarnitinaLabel => 'Carnitina';

  @override
  String get diaryCatalogCCarnitinaPrompt => 'Tomou carnitina?';

  @override
  String get diaryCatalogCTriptofanoLabel => 'Triptofano';

  @override
  String get diaryCatalogCTriptofanoPrompt => 'Tomou triptofano?';

  @override
  String get diaryCatalogCGabaLabel => 'GABA';

  @override
  String get diaryCatalogCGabaPrompt => 'Tomou GABA?';

  @override
  String get diaryCatalogCValerianaLabel => 'Valeriana ou passiflora';

  @override
  String get diaryCatalogCValerianaPrompt => 'Tomou valeriana ou passiflora?';

  @override
  String get diaryCatalogCFolicoLabel => 'Ácido fólico';

  @override
  String get diaryCatalogCFolicoPrompt => 'Tomou ácido fólico?';

  @override
  String get diaryCatalogCViteLabel => 'Vitamina E';

  @override
  String get diaryCatalogCVitePrompt => 'Tomou vitamina E?';

  @override
  String get diaryCatalogCResverLabel => 'Resveratrol';

  @override
  String get diaryCatalogCResverPrompt => 'Tomou resveratrol?';

  @override
  String get diaryCatalogCBerberLabel => 'Berberina';

  @override
  String get diaryCatalogCBerberPrompt => 'Tomou berberina?';

  @override
  String get diaryCatalogCInositolLabel => 'Inositol';

  @override
  String get diaryCatalogCInositolPrompt => 'Tomou inositol?';

  @override
  String get diaryCatalogCMelatLabel => 'Melatonina';

  @override
  String get diaryCatalogCMelatPrompt => 'Tomou melatonina?';

  @override
  String get diaryCatalogCRemedLabel => 'Remédio para dormir';

  @override
  String get diaryCatalogCRemedPrompt => 'Tomou remédio para dormir?';

  @override
  String get diaryCatalogCAnalgLabel => 'Analgésico';

  @override
  String get diaryCatalogCAnalgPrompt =>
      'Tomou analgésico (dipirona, paracetamol)?';

  @override
  String get diaryCatalogCAntiinfLabel => 'Anti-inflamatório';

  @override
  String get diaryCatalogCAntiinfPrompt => 'Tomou anti-inflamatório?';

  @override
  String get diaryCatalogCAntialLabel => 'Antialérgico';

  @override
  String get diaryCatalogCAntialPrompt => 'Tomou antialérgico?';

  @override
  String get diaryCatalogCDescongLabel => 'Descongestionante';

  @override
  String get diaryCatalogCDescongPrompt => 'Usou descongestionante nasal?';

  @override
  String get diaryCatalogCAntibLabel => 'Antibiótico';

  @override
  String get diaryCatalogCAntibPrompt => 'Tomou antibiótico?';

  @override
  String get diaryCatalogCCorticLabel => 'Corticoide';

  @override
  String get diaryCatalogCCorticPrompt => 'Tomou corticoide?';

  @override
  String get diaryCatalogCRelaxmuscLabel => 'Relaxante muscular';

  @override
  String get diaryCatalogCRelaxmuscPrompt => 'Tomou relaxante muscular?';

  @override
  String get diaryCatalogCEnjooLabel => 'Remédio para enjoo';

  @override
  String get diaryCatalogCEnjooPrompt => 'Tomou remédio para enjoo?';

  @override
  String get diaryCatalogCAnsiolLabel => 'Ansiolítico';

  @override
  String get diaryCatalogCAnsiolPrompt => 'Tomou ansiolítico?';

  @override
  String get diaryCatalogCAntidepLabel => 'Antidepressivo';

  @override
  String get diaryCatalogCAntidepPrompt => 'Tomou antidepressivo?';

  @override
  String get diaryCatalogCEstimLabel => 'Remédio para TDAH';

  @override
  String get diaryCatalogCEstimPrompt => 'Tomou remédio para TDAH?';

  @override
  String get diaryCatalogCPressaoLabel => 'Remédio de pressão';

  @override
  String get diaryCatalogCPressaoPrompt => 'Tomou remédio de pressão?';

  @override
  String get diaryCatalogCTireoideLabel => 'Tireoide';

  @override
  String get diaryCatalogCTireoidePrompt => 'Tomou remédio de tireoide?';

  @override
  String get diaryCatalogCDiabetesLabel => 'Diabetes';

  @override
  String get diaryCatalogCDiabetesPrompt =>
      'Tomou remédio ou insulina para diabetes?';

  @override
  String get diaryCatalogCGlp1Label => 'Remédio GLP-1';

  @override
  String get diaryCatalogCGlp1Prompt =>
      'Aplicou o remédio injetável para emagrecer ou diabetes (semaglutida, tirzepatida)?';

  @override
  String get diaryCatalogCAnticoncep2Label => 'Hormônio';

  @override
  String get diaryCatalogCAnticoncep2Prompt => 'Tomou algum hormônio?';

  @override
  String get diaryCatalogCIsotretLabel => 'Isotretinoína';

  @override
  String get diaryCatalogCIsotretPrompt =>
      'Tomou isotretinoína (remédio para acne)?';

  @override
  String get diaryCatalogCMinoxLabel => 'Minoxidil';

  @override
  String get diaryCatalogCMinoxPrompt => 'Usou minoxidil?';

  @override
  String get diaryCatalogCFinastLabel => 'Finasterida';

  @override
  String get diaryCatalogCFinastPrompt => 'Tomou finasterida?';

  @override
  String get diaryCatalogCNotempoLabel => 'Remédios no horário';

  @override
  String get diaryCatalogCNotempoPrompt =>
      'Tomou os remédios no horário certo?';

  @override
  String get diaryCatalogCEsqueceuLabel => 'Esqueceu o remédio';

  @override
  String get diaryCatalogCEsqueceuPrompt => 'Esqueceu de tomar algum remédio?';

  @override
  String get diaryCatalogCProtgastLabel => 'Protetor gástrico';

  @override
  String get diaryCatalogCProtgastPrompt =>
      'Tomou omeprazol ou protetor do estômago?';

  @override
  String get diaryCatalogCAntiacidoLabel => 'Antiácido';

  @override
  String get diaryCatalogCAntiacidoPrompt => 'Tomou antiácido?';

  @override
  String get diaryCatalogCLaxanteLabel => 'Laxante';

  @override
  String get diaryCatalogCLaxantePrompt => 'Tomou laxante?';

  @override
  String get diaryCatalogCAntidiarLabel => 'Antidiarreico';

  @override
  String get diaryCatalogCAntidiarPrompt => 'Tomou remédio para diarreia?';

  @override
  String get diaryCatalogCColicaremLabel => 'Remédio para cólica';

  @override
  String get diaryCatalogCColicaremPrompt => 'Tomou remédio para cólica?';

  @override
  String get diaryCatalogCEnxaqremLabel => 'Remédio para enxaqueca';

  @override
  String get diaryCatalogCEnxaqremPrompt => 'Tomou remédio para enxaqueca?';

  @override
  String get diaryCatalogCAntitermicoLabel => 'Antitérmico';

  @override
  String get diaryCatalogCAntitermicoPrompt => 'Tomou remédio para febre?';

  @override
  String get diaryCatalogCXaropeLabel => 'Xarope';

  @override
  String get diaryCatalogCXaropePrompt => 'Tomou xarope para tosse?';

  @override
  String get diaryCatalogCBombinhaLabel => 'Bombinha de asma';

  @override
  String get diaryCatalogCBombinhaPrompt => 'Usou bombinha?';

  @override
  String get diaryCatalogCSpraynasalLabel => 'Spray nasal com corticoide';

  @override
  String get diaryCatalogCSpraynasalPrompt =>
      'Usou spray nasal com corticoide?';

  @override
  String get diaryCatalogCColirioLabel => 'Colírio';

  @override
  String get diaryCatalogCColirioPrompt => 'Usou colírio?';

  @override
  String get diaryCatalogCPomadaLabel => 'Pomada';

  @override
  String get diaryCatalogCPomadaPrompt => 'Usou pomada ou creme de tratamento?';

  @override
  String get diaryCatalogCAntifungLabel => 'Antifúngico';

  @override
  String get diaryCatalogCAntifungPrompt => 'Tomou antifúngico?';

  @override
  String get diaryCatalogCAntiviralLabel => 'Antiviral';

  @override
  String get diaryCatalogCAntiviralPrompt => 'Tomou antiviral?';

  @override
  String get diaryCatalogCEstatinaLabel => 'Remédio de colesterol';

  @override
  String get diaryCatalogCEstatinaPrompt => 'Tomou remédio para colesterol?';

  @override
  String get diaryCatalogCAnticoagLabel => 'Anticoagulante';

  @override
  String get diaryCatalogCAnticoagPrompt => 'Tomou anticoagulante?';

  @override
  String get diaryCatalogCMetformLabel => 'Metformina';

  @override
  String get diaryCatalogCMetformPrompt => 'Tomou metformina?';

  @override
  String get diaryCatalogCAnticonvLabel => 'Anticonvulsivante';

  @override
  String get diaryCatalogCAnticonvPrompt => 'Tomou anticonvulsivante?';

  @override
  String get diaryCatalogCEstabilLabel => 'Estabilizador de humor';

  @override
  String get diaryCatalogCEstabilPrompt => 'Tomou estabilizador de humor?';

  @override
  String get diaryCatalogCInjecaoLabel => 'Vitamina injetável';

  @override
  String get diaryCatalogCInjecaoPrompt => 'Tomou alguma vitamina injetável?';

  @override
  String get diaryCatalogCProtetorLabel => 'Protetor solar';

  @override
  String get diaryCatalogCProtetorPrompt => 'Passou protetor solar?';

  @override
  String get diaryCatalogCSkincareLabel => 'Skincare';

  @override
  String get diaryCatalogCSkincarePrompt =>
      'Fez a rotina de cuidados com a pele?';

  @override
  String get diaryCatalogCHidratLabel => 'Hidratou a pele';

  @override
  String get diaryCatalogCHidratPrompt => 'Passou hidratante?';

  @override
  String get diaryCatalogCFiodentalLabel => 'Fio dental';

  @override
  String get diaryCatalogCFiodentalPrompt => 'Passou fio dental?';

  @override
  String get diaryCatalogCPausaLabel => 'Pausas no trabalho';

  @override
  String get diaryCatalogCPausaPrompt => 'Fez pausas durante o trabalho?';

  @override
  String get diaryCatalogCPostura2Label => 'Ergonomia';

  @override
  String get diaryCatalogCPostura2Prompt =>
      'Trabalhou numa posição confortável?';

  @override
  String get diaryCatalogCCelnoiteLabel => 'Modo noturno';

  @override
  String get diaryCatalogCCelnoitePrompt => 'Deixou o celular no modo noturno?';

  @override
  String get diaryCatalogCOrganizouLabel => 'Organizou o dia';

  @override
  String get diaryCatalogCOrganizouPrompt => 'Planejou o dia com antecedência?';

  @override
  String get diaryCatalogCNatureza2Label => 'Contato com a natureza';

  @override
  String get diaryCatalogCNatureza2Prompt =>
      'Pisou na grama ou tocou a natureza?';

  @override
  String get diaryCatalogCR130Label => 'Levantou a cada hora';

  @override
  String get diaryCatalogCR130Prompt => 'Levantou da cadeira a cada hora?';

  @override
  String get diaryCatalogCR131Label => 'Escada em vez do elevador';

  @override
  String get diaryCatalogCR131Prompt => 'Usou a escada em vez do elevador?';

  @override
  String get diaryCatalogCR132Label => 'Pausa ativa no trabalho';

  @override
  String get diaryCatalogCR132Prompt => 'Fez pausas para se mexer no trabalho?';

  @override
  String get diaryCatalogCR133Label => 'Carregou peso no dia a dia';

  @override
  String get diaryCatalogCR133Prompt =>
      'Carregou peso (compras, criança no colo)?';

  @override
  String get diaryCatalogCR134Label => 'Brincou com as crianças';

  @override
  String get diaryCatalogCR134Prompt => 'Brincou ativamente com as crianças?';

  @override
  String get diaryCatalogCR136Label => 'Pegou o celular ao acordar';

  @override
  String get diaryCatalogCR136Prompt => 'Pegou o celular logo ao acordar?';

  @override
  String get diaryCatalogCR137Label => 'Celular nas refeições';

  @override
  String get diaryCatalogCR137Prompt => 'Usou o celular durante as refeições?';

  @override
  String get diaryCatalogCR138Label => 'WhatsApp do trabalho fora do horário';

  @override
  String get diaryCatalogCR138Prompt => 'Respondeu trabalho fora do horário?';

  @override
  String get diaryCatalogCR139Label => 'Vídeos curtos';

  @override
  String get diaryCatalogCR139Prompt =>
      'Ficou rolando vídeos curtos (Reels, TikTok)?';

  @override
  String get diaryCatalogCR1310Label => 'Jogos no celular';

  @override
  String get diaryCatalogCR1310Prompt => 'Jogou no celular?';

  @override
  String get diaryCatalogCR1311Label => 'Apostas online';

  @override
  String get diaryCatalogCR1311Prompt => 'Fez apostas online?';

  @override
  String get diaryCatalogCR1312Label => 'Pausa para os olhos';

  @override
  String get diaryCatalogCR1312Prompt => 'Fez pausas para descansar os olhos?';

  @override
  String get diaryCatalogCR1313Label => 'Modo foco';

  @override
  String get diaryCatalogCR1313Prompt => 'Usou o modo foco?';

  @override
  String get diaryCatalogCR1314Label => 'Notificações desligadas';

  @override
  String get diaryCatalogCR1314Prompt => 'Desligou as notificações?';

  @override
  String get diaryCatalogCR1315Label => 'Trabalho sem interrupção';

  @override
  String get diaryCatalogCR1315Prompt =>
      'Teve um bloco de trabalho sem interrupção?';

  @override
  String get diaryCatalogCR1316Label => 'Celular fora do quarto';

  @override
  String get diaryCatalogCR1316Prompt => 'Deixou o celular fora do quarto?';

  @override
  String get diaryCatalogCR1317Label => 'Escovou os dentes 3 vezes';

  @override
  String get diaryCatalogCR1317Prompt => 'Escovou os dentes 3 vezes?';

  @override
  String get diaryCatalogCR1318Label => 'Tirou a maquiagem';

  @override
  String get diaryCatalogCR1318Prompt => 'Tirou a maquiagem antes de dormir?';

  @override
  String get diaryCatalogCR1319Label => 'Cuidou do cabelo';

  @override
  String get diaryCatalogCR1319Prompt => 'Fez hidratação ou cuidado no cabelo?';

  @override
  String get diaryCatalogCR1320Label => 'Unhas';

  @override
  String get diaryCatalogCR1320Prompt => 'Fez as unhas?';

  @override
  String get diaryCatalogCR1321Label => 'Barba';

  @override
  String get diaryCatalogCR1321Prompt => 'Fez a barba?';

  @override
  String get diaryCatalogCR1322Label => 'Repelente';

  @override
  String get diaryCatalogCR1322Prompt => 'Passou repelente?';

  @override
  String get diaryCatalogCR1323Label => 'Hidratou os lábios';

  @override
  String get diaryCatalogCR1323Prompt => 'Hidratou os lábios?';

  @override
  String get diaryCatalogCR1324Label => 'Tempo para si';

  @override
  String get diaryCatalogCR1324Prompt => 'Teve um tempo só para você?';

  @override
  String get diaryCatalogCR1325Label => 'Dipirona';

  @override
  String get diaryCatalogCR1325Prompt => 'Tomou dipirona?';

  @override
  String get diaryCatalogCR1326Label => 'Paracetamol';

  @override
  String get diaryCatalogCR1326Prompt => 'Tomou paracetamol?';

  @override
  String get diaryCatalogCR1327Label => 'Ibuprofeno';

  @override
  String get diaryCatalogCR1327Prompt => 'Tomou ibuprofeno?';

  @override
  String get diaryCatalogCR1328Label => 'Nimesulida';

  @override
  String get diaryCatalogCR1328Prompt => 'Tomou nimesulida?';

  @override
  String get diaryCatalogCR1329Label => 'Relaxante com analgésico';

  @override
  String get diaryCatalogCR1329Prompt =>
      'Tomou relaxante muscular com analgésico?';

  @override
  String get diaryCatalogCR1330Label => 'Omeprazol';

  @override
  String get diaryCatalogCR1330Prompt => 'Tomou omeprazol?';

  @override
  String get diaryCatalogCR1331Label => 'Remédio para gases';

  @override
  String get diaryCatalogCR1331Prompt => 'Tomou remédio para gases?';

  @override
  String get diaryCatalogCR1332Label => 'Losartana';

  @override
  String get diaryCatalogCR1332Prompt => 'Tomou losartana?';

  @override
  String get diaryCatalogCR1333Label => 'Levotiroxina';

  @override
  String get diaryCatalogCR1333Prompt => 'Tomou levotiroxina?';

  @override
  String get diaryCatalogCR1334Label => 'Sertralina ou escitalopram';

  @override
  String get diaryCatalogCR1334Prompt => 'Tomou o antidepressivo?';

  @override
  String get diaryCatalogCR1335Label => 'Clonazepam';

  @override
  String get diaryCatalogCR1335Prompt => 'Tomou clonazepam?';

  @override
  String get diaryCatalogCR1336Label => 'Zolpidem';

  @override
  String get diaryCatalogCR1336Prompt => 'Tomou zolpidem?';

  @override
  String get diaryCatalogCR1337Label => 'Loratadina';

  @override
  String get diaryCatalogCR1337Prompt => 'Tomou loratadina?';

  @override
  String get diaryCatalogCR1338Label => 'Insulina';

  @override
  String get diaryCatalogCR1338Prompt => 'Aplicou insulina?';

  @override
  String get diaryCatalogCR1339Label => 'Sildenafila ou tadalafila';

  @override
  String get diaryCatalogCR1339Prompt => 'Tomou sildenafila ou tadalafila?';

  @override
  String get diaryCatalogCR1340Label => 'Lavagem nasal com soro';

  @override
  String get diaryCatalogCR1340Prompt => 'Fez lavagem nasal com soro?';

  @override
  String get diaryCatalogCR1341Label => 'Remédio para infecção urinária';

  @override
  String get diaryCatalogCR1341Prompt =>
      'Tomou remédio para infecção urinária?';

  @override
  String get diaryCatalogCR1342Label => 'Termogênico';

  @override
  String get diaryCatalogCR1342Prompt => 'Tomou termogênico?';

  @override
  String get diaryCatalogCR1343Label => 'Hipercalórico';

  @override
  String get diaryCatalogCR1343Prompt => 'Tomou hipercalórico?';

  @override
  String get diaryCatalogCR1344Label => 'Picolinato de cromo';

  @override
  String get diaryCatalogCR1344Prompt => 'Tomou picolinato de cromo?';

  @override
  String get diaryCatalogCR1345Label => 'Óleo de prímula';

  @override
  String get diaryCatalogCR1345Prompt => 'Tomou óleo de prímula?';

  @override
  String get diaryCatalogCR1346Label => 'Levedo de cerveja';

  @override
  String get diaryCatalogCR1346Prompt => 'Tomou levedo de cerveja?';

  @override
  String get diaryCatalogCR1347Label => 'Vinagre de maçã em cápsula';

  @override
  String get diaryCatalogCR1347Prompt => 'Tomou vinagre de maçã em cápsula?';

  @override
  String get diaryCatalogCR1348Label => 'Cranberry';

  @override
  String get diaryCatalogCR1348Prompt => 'Tomou cranberry?';

  @override
  String get diaryCatalogCR1349Label => 'Polivitamínico infantil';

  @override
  String get diaryCatalogCR1349Prompt => 'Deu polivitamínico para a criança?';

  @override
  String get diaryCatalogCR1350Label => 'DIU';

  @override
  String get diaryCatalogCR1350Prompt => 'Usa DIU?';

  @override
  String get diaryCatalogCR1351Label => 'Implante contraceptivo';

  @override
  String get diaryCatalogCR1351Prompt => 'Usa implante contraceptivo?';

  @override
  String get diaryCatalogCR1352Label => 'Injeção anticoncepcional';

  @override
  String get diaryCatalogCR1352Prompt => 'Tomou a injeção anticoncepcional?';

  @override
  String get diaryCatalogCR1353Label => 'Pílula do dia seguinte';

  @override
  String get diaryCatalogCR1353Prompt => 'Tomou a pílula do dia seguinte?';

  @override
  String get diaryCatalogCR1354Label => 'Esqueceu a pílula';

  @override
  String get diaryCatalogCR1354Prompt => 'Esqueceu o anticoncepcional?';

  @override
  String get diaryCatalogCR1355Label => 'Endometriose';

  @override
  String get diaryCatalogCR1355Prompt => 'Sentiu dor de endometriose?';

  @override
  String get diaryCatalogCR1356Label => 'Ovário policístico (SOP)';

  @override
  String get diaryCatalogCR1356Prompt => 'Sintomas de ovário policístico?';

  @override
  String get diaryCatalogCR1357Label => 'Candidíase';

  @override
  String get diaryCatalogCR1357Prompt => 'Teve candidíase?';

  @override
  String get diaryCatalogCR1358Label => 'Infecção urinária';

  @override
  String get diaryCatalogCR1358Prompt => 'Teve infecção urinária?';

  @override
  String get diaryCatalogCR1359Label => 'Secura vaginal';

  @override
  String get diaryCatalogCR1359Prompt => 'Sentiu secura vaginal?';

  @override
  String get diaryCatalogCR1360Label => 'Queda de cabelo';

  @override
  String get diaryCatalogCR1360Prompt => 'Notou queda de cabelo?';

  @override
  String get diaryCatalogCR1361Label => 'Disfunção erétil';

  @override
  String get diaryCatalogCR1361Prompt => 'Teve dificuldade de ereção?';

  @override
  String get diaryCatalogCWDesafioLabel => 'Encarou como desafio';

  @override
  String get diaryCatalogCWDesafioPrompt =>
      'Encarou a pressão do dia como um desafio?';

  @override
  String get diaryCatalogCWAmeacaLabel => 'Encarou como ameaça';

  @override
  String get diaryCatalogCWAmeacaPrompt =>
      'Sentiu a pressão do dia como uma ameaça?';

  @override
  String get diaryCatalogCWControleLabel => 'No controle';

  @override
  String get diaryCatalogCWControlePrompt =>
      'Sentiu que estava no controle do seu dia?';

  @override
  String get diaryCatalogCWEficaciaLabel => 'Confiança em si';

  @override
  String get diaryCatalogCWEficaciaPrompt =>
      'Se sentiu capaz de dar conta do que precisava?';

  @override
  String get diaryCatalogCWFluxoLabel => 'Estado de fluxo';

  @override
  String get diaryCatalogCWFluxoPrompt =>
      'Ficou imerso em algo sem ver o tempo passar?';

  @override
  String get diaryCatalogCWConcentraLabel => 'Dificuldade de concentração';

  @override
  String get diaryCatalogCWConcentraPrompt =>
      'Teve dificuldade para se concentrar?';

  @override
  String get diaryCatalogCWProgressoLabel => 'Avançou em algo importante';

  @override
  String get diaryCatalogCWProgressoPrompt =>
      'Fez progresso em algo que importa para você?';

  @override
  String get diaryCatalogCWRealizacaoLabel => 'Sensação de realização';

  @override
  String get diaryCatalogCWRealizacaoPrompt =>
      'Terminou o dia com sensação de dever cumprido?';

  @override
  String get diaryCatalogCWPropositoLabel => 'Senso de propósito';

  @override
  String get diaryCatalogCWPropositoPrompt =>
      'Sentiu que o seu dia teve um propósito?';

  @override
  String get diaryCatalogCWOtimismoLabel => 'Otimismo';

  @override
  String get diaryCatalogCWOtimismoPrompt => 'Se sentiu otimista e positivo?';

  @override
  String get diaryCatalogCWDepressaoLabel => 'Sintomas de depressão';

  @override
  String get diaryCatalogCWDepressaoPrompt =>
      'Teve sintomas de depressão, como vazio ou falta de prazer nas coisas?';

  @override
  String get diaryCatalogCWRelacaoLabel => 'Relacionamento';

  @override
  String get diaryCatalogCWRelacaoPrompt =>
      'Teve um bom momento com quem você ama?';

  @override
  String get diaryCatalogCWEsgotadoLabel => 'Socialmente esgotado';

  @override
  String get diaryCatalogCWEsgotadoPrompt =>
      'Se sentiu cansado de tanta gente e conversa?';

  @override
  String get diaryCatalogCWIsoladoLabel => 'Isolamento';

  @override
  String get diaryCatalogCWIsoladoPrompt =>
      'Passou o dia sem contato com outras pessoas?';

  @override
  String get diaryUiCouldNotHearYouYouCanTypeBelow =>
      'Não foi possível ouvir. Você pode escrever abaixo.';

  @override
  String get diaryUiSpeechIsUnavailableOrPermissionWasDeniedYouCanType =>
      'A fala não está disponível ou a permissão foi negada. Você pode escrever.';

  @override
  String get diaryUiCouldNotStartSpeechYouCanType =>
      'Não foi possível iniciar a fala. Você pode escrever.';

  @override
  String get diaryUiCouldNotInterpretThisTryAgainYourTextIsStillHere =>
      'Não foi possível interpretar. Tente novamente. Seu texto está salvo aqui.';

  @override
  String get diaryUiRecordWithAI => 'Registrar com a IA';

  @override
  String get diaryUiTellUsAboutYourDay => 'Conte como foi o seu dia.';

  @override
  String get diaryUiReviewBeforeAdding => 'Confira antes de adicionar.';

  @override
  String
  get diaryUiAICanMakeMistakesReviewTheEntriesAndRemoveAnythingThatDidNotHappen =>
      'A IA pode errar. Revise os registros e remova o que não aconteceu.';

  @override
  String get diaryUiIHad2CoffeesAndWalkedFor20Minutes =>
      'Tomei 2 cafés e caminhei por 20 minutos…';

  @override
  String get diaryUiStopListening => 'Parar de ouvir';

  @override
  String get diaryUiSpeak => 'Falar';

  @override
  String get diaryUiNoEntriesIdentifiedTryDescribingItDifferently =>
      'Nenhum registro identificado. Tente descrever de outra forma.';

  @override
  String get diaryUiRemove => 'Remover';

  @override
  String get diaryUiReviewEntries => 'Revisar registros';

  @override
  String get diaryUiAddToDay => 'Adicionar ao dia';

  @override
  String get diaryUiCouldNotSaveTryAgain =>
      'Não foi possível salvar. Tente novamente.';

  @override
  String get diaryUiWhatToTrack => 'O que acompanhar';

  @override
  String get diaryUiRetry => 'Tentar novamente';

  @override
  String get diaryUiAll => 'Todos';

  @override
  String get diaryUiCreateYourHabit => 'Criar o seu hábito';

  @override
  String get diaryUiSave => 'Salvar';

  @override
  String get diaryUiCouldNotCreateThisHabitTryAgain =>
      'Não foi possível criar o hábito. Tente novamente.';

  @override
  String get diaryUiWhatWouldYouLikeToTrack => 'O que você quer acompanhar?';

  @override
  String get diaryUiHabitName => 'Nome do hábito';

  @override
  String get diaryUiResponseType => 'Como responder';

  @override
  String get diaryUiYesOrNo => 'Sim ou não';

  @override
  String get diaryUiQuantity => 'Quantidade';

  @override
  String get diaryUiUnitMlMinTimes => 'Unidade (ml, min, vezes…)';

  @override
  String get diaryUiCreateHabit => 'Criar hábito';

  @override
  String get diaryUiYourChapters => 'Seus capítulos';

  @override
  String get diaryUiYourChaptersWillAppearAsYouRecordYourDays =>
      'Seus capítulos vão aparecer conforme você registra seus dias.';

  @override
  String get diaryUiChapter => 'Capítulo';

  @override
  String get diaryUiByTheNumbers => 'Em números';

  @override
  String get diaryUiRecordedDays => 'Dias registrados';

  @override
  String get diaryUiMoments => 'Momentos';

  @override
  String get diaryUiAchievements => 'Conquistas';

  @override
  String get diaryUiCouldNotAttachThePhotoUseAJPGPNGUpTo2MB =>
      'Não foi possível adicionar a foto. Use uma imagem JPG/PNG de até 2 MB.';

  @override
  String get diaryUiEnterAName => 'Informe o nome.';

  @override
  String get diaryUiCheckTheNutritionValues =>
      'Confira os valores nutricionais.';

  @override
  String get diaryUiDeleteEntry => 'Excluir registro';

  @override
  String get diaryUiWhatDidYouEat => 'O que você comeu?';

  @override
  String get diaryUiFindAMeal => 'Buscar refeição';

  @override
  String get diaryUiFoodsAndAmounts => 'Alimentos e quantidades';

  @override
  String get diaryUiNutrition => 'Informações nutricionais';

  @override
  String
  get diaryUiValuesEnteredByYouOrFromTheSelectedMealAdjustForYourPortion =>
      'Valores informados por você ou pela refeição escolhida. Ajuste conforme a porção.';

  @override
  String get diaryUiProteinG => 'Proteína (g)';

  @override
  String get diaryUiCarbsG => 'Carboidratos (g)';

  @override
  String get diaryUiFatG => 'Gordura (g)';

  @override
  String get diaryUiRemovePhoto => 'Remover foto';

  @override
  String get diaryUiTakeAPhoto => 'Tirar foto';

  @override
  String get diaryUiGallery => 'Galeria';

  @override
  String get diaryUiEntry => 'Registro';

  @override
  String get diaryUiDetails => 'Detalhes';

  @override
  String get diaryUiTime => 'Horário';

  @override
  String get diaryUiDone => 'Concluir';

  @override
  String get diaryUiSearchFoods => 'Buscar alimentos';

  @override
  String get diaryUiYourAccountChangedReopenTheDiary =>
      'Sua conta mudou. Abra o Diário novamente.';

  @override
  String get diaryUiDaySaved => 'Dia salvo';

  @override
  String get diaryUiTimeline => 'Linha do tempo';

  @override
  String get diaryUiDiary => 'Diário';

  @override
  String get diaryUiWhatHappenedToday => 'O que aconteceu hoje?';

  @override
  String get diaryUiWhatHappenedYesterday => 'O que aconteceu ontem?';

  @override
  String get diaryUiToday => 'Hoje';

  @override
  String get diaryUiYesterday => 'Ontem';

  @override
  String get diaryUiMoments2 => 'momentos';

  @override
  String get diaryUiYourDayBeginsWithAnEntry =>
      'Seu dia começa com um registro.';

  @override
  String get diaryUiNotes => 'Notas';

  @override
  String get diaryUiYouCanEditThePast7Days =>
      'Você pode editar os últimos 7 dias.';

  @override
  String get diaryUiCouldNotSavePleaseTryAgain =>
      'Não foi possível salvar. Tente novamente.';

  @override
  String get diaryUiYourDiary => 'Seu Diário';

  @override
  String get diaryUiThisDayIsReadOnly => 'Este dia está fechado para edição.';

  @override
  String get diaryUiThisDayChangedElsewhereCloseAndRefreshBeforeSaving =>
      'Este dia foi alterado em outro lugar. Feche e atualize antes de salvar.';

  @override
  String get diaryUiCouldNotSaveYourDraftIsStillHere =>
      'Não foi possível salvar. Seu rascunho continua aqui.';

  @override
  String get diaryUiYourHabits => 'Seus hábitos';

  @override
  String get diaryUiOf => 'de';

  @override
  String get diaryUiAddHabit => 'Adicionar hábito';

  @override
  String get diaryUiHowWasYourDay => 'Como foi o dia';

  @override
  String get diaryUiHowWasYourDay2 => 'Como foi o seu dia';

  @override
  String get diaryUiMoodEnergyStressAndASentence =>
      'Humor, disposição, estresse e uma frase';

  @override
  String get diaryUiThisDayIsClosedYouCanEditUpTo7DaysLater =>
      'Este dia já fechou. Dá para mudar só até 7 dias depois.';

  @override
  String get diaryUiRecord => 'Registrar';

  @override
  String get diaryUiCouldNotSaveYourChangesAreKeptHereRetryOrDiscardToLeave =>
      'Não foi possível salvar. Suas alterações continuam aqui. Tente novamente ou descarte para sair.';

  @override
  String get diaryUiDiscard => 'Descartar';

  @override
  String get diaryUiNo => 'Não';

  @override
  String get diaryUiYes => 'Sim';

  @override
  String get diaryUiAnswer => 'Responder';

  @override
  String get diaryUiASentenceAboutYourDay => 'Uma frase sobre o dia';

  @override
  String get diaryUiOnlyYouCanSeeThisHowWasYourDay =>
      'Só você vê. Como foi seu dia?';

  @override
  String get diaryUiTellUsAboutYourDayReviewBeforeSaving =>
      'Conte como foi. Ela marca tudo aqui para você.';

  @override
  String get diaryUiWrite => 'Escrever';

  @override
  String get diaryUiDidNotHappen => 'Não aconteceu';

  @override
  String get diaryValueRecorded => 'Feito';

  @override
  String get diaryValueDidNotHappen => 'Não aconteceu';

  @override
  String get diaryValueTimes => 'vezes';

  @override
  String get diaryValueCups => 'xícaras';

  @override
  String get diaryValueMeals => 'refeições';

  @override
  String get diaryValueOutOfTen => 'de 10';

  @override
  String get diaryPortionLight => 'Leve';

  @override
  String get diaryPortionNormal => 'Normal';

  @override
  String get diaryPortionHeavy => 'Pesado';

  @override
  String get diaryLoadFailed =>
      'Não foi possível carregar o Diário. Tente novamente.';

  @override
  String get diaryFatAbbreviation => 'G';

  @override
  String diaryDateRange(String start, String end) {
    return '$start a $end';
  }

  @override
  String diaryCatalogSearch(int count) {
    return 'Buscar entre $count';
  }

  @override
  String diaryChooseCount(int count) {
    return 'Escolha entre $count';
  }

  @override
  String get diaryGroupFood => 'Alimentação';

  @override
  String get diaryGroupSelfCare => 'Autocuidado';

  @override
  String get diaryGroupDrinks => 'Bebidas';

  @override
  String get diaryGroupMentalWellBeing => 'Bem-estar mental';

  @override
  String get diaryGroupSubstancesAndMedication => 'Drogas e medicação';

  @override
  String get diaryGroupMovement => 'Movimento';

  @override
  String get diaryGroupRecovery => 'Recuperação';

  @override
  String get diaryGroupMeals => 'Refeições';

  @override
  String get diaryGroupRoutineAndLeisure => 'Rotina e lazer';

  @override
  String get diaryGroupHealth => 'Saúde';

  @override
  String get diaryGroupHealthAndSymptoms => 'Saúde e sintomas';

  @override
  String get diaryGroupHormonalHealth => 'Saúde hormonal';

  @override
  String get diaryGroupSleepAndRhythm => 'Sono e ritmo';

  @override
  String get diaryGroupSupplements => 'Suplementos';

  @override
  String get diaryGroupScreensAndFocus => 'Telas e foco';

  @override
  String get diaryGroupYourHabits => 'Seus hábitos';

  @override
  String get diaryScaleAcordou0 => 'Muito cansado';

  @override
  String get diaryScaleAcordou1 => 'Cansado';

  @override
  String get diaryScaleAcordou2 => 'Ok';

  @override
  String get diaryScaleAcordou3 => 'Bem';

  @override
  String get diaryScaleAcordou4 => 'Ótimo';

  @override
  String get diaryScaleHumor0 => 'Muito mal';

  @override
  String get diaryScaleHumor1 => 'Mal';

  @override
  String get diaryScaleHumor2 => 'Neutro';

  @override
  String get diaryScaleHumor3 => 'Bem';

  @override
  String get diaryScaleHumor4 => 'Muito bem';

  @override
  String get diaryScaleEnergia0 => 'Sem energia';

  @override
  String get diaryScaleEnergia1 => 'Baixa';

  @override
  String get diaryScaleEnergia2 => 'Ok';

  @override
  String get diaryScaleEnergia3 => 'Boa';

  @override
  String get diaryScaleEnergia4 => 'Muita';

  @override
  String get diaryScaleEstresse0 => 'Muito alto';

  @override
  String get diaryScaleEstresse1 => 'Alto';

  @override
  String get diaryScaleEstresse2 => 'Médio';

  @override
  String get diaryScaleEstresse3 => 'Pouco';

  @override
  String get diaryScaleEstresse4 => 'Nenhum';

  @override
  String get diaryReferenceLettuce => 'Alface';

  @override
  String get diaryReferenceRice => 'Arroz';

  @override
  String get diaryReferenceWhiteRice => 'Arroz branco';

  @override
  String get diaryReferenceFries => 'Batata frita';

  @override
  String get diaryReferenceShoestringPotatoes => 'Batata palha';

  @override
  String get diaryReferenceSweetPotato => 'Batata-doce';

  @override
  String get diaryReferenceSteakWithOnions => 'Bife acebolado';

  @override
  String get diaryReferenceCarrotCakeWithFrosting =>
      'Bolo de cenoura com cobertura';

  @override
  String get diaryReferenceBroccoli => 'Brócolis';

  @override
  String get diaryReferenceCoffee => 'Café';

  @override
  String get diaryReferenceCoffeeWithMilk => 'Café com leite';

  @override
  String get diaryReferenceUnsweetenedCoffee => 'Café sem açúcar';

  @override
  String get diaryReferenceSautedCollardGreens => 'Couve refogada';

  @override
  String get diaryReferenceCouscousWithButter => 'Cuscuz com manteiga';

  @override
  String get diaryReferenceToastedCassavaFlour => 'Farofa';

  @override
  String get diaryReferenceBeans => 'Feijão';

  @override
  String get diaryReferenceBlackBeans => 'Feijão preto';

  @override
  String get diaryReferenceGrilledChicken => 'Frango grelhado';

  @override
  String get diaryReferenceBerries => 'Frutas vermelhas';

  @override
  String get diaryReferenceGinger => 'Gengibre';

  @override
  String get diaryReferenceBurger => 'Hambúrguer';

  @override
  String get diaryReferencePlainYogurt => 'Iogurte natural';

  @override
  String get diaryReferenceOrange => 'Laranja';

  @override
  String get diaryReferenceVegetables => 'Legumes';

  @override
  String get diaryReferenceLemon => 'Limão';

  @override
  String get diaryReferencePasta => 'Macarrão';

  @override
  String get diaryReferencePapaya => 'Mamão';

  @override
  String get diaryReferenceApple => 'Maçã';

  @override
  String get diaryReferenceSauce => 'Molho';

  @override
  String get diaryReferenceMeatSauce => 'Molho de carne';

  @override
  String get diaryReferenceStrawberry => 'Morango';

  @override
  String get diaryReferenceOmelet => 'Omelete';

  @override
  String get diaryReferenceBoiledEgg => 'Ovo cozido';

  @override
  String get diaryReferenceFriedEgg => 'Ovo frito';

  @override
  String get diaryReferenceScrambledEggs => 'Ovos mexidos';

  @override
  String get diaryReferenceCucumber => 'Pepino';

  @override
  String get diaryReferenceCalabreseSausagePizza => 'Pizza de calabresa';

  @override
  String get diaryReferenceBrazilianCheeseBread => 'Pão de queijo';

  @override
  String get diaryReferenceBreadRollWithButter => 'Pão francês com manteiga';

  @override
  String get diaryReferenceWholeWheatBread => 'Pão integral';

  @override
  String get diaryReferenceFreshWhiteCheese => 'Queijo branco';

  @override
  String get diaryReferenceCoalhoCheese => 'Queijo coalho';

  @override
  String get diaryReferenceGratedCheese => 'Queijo ralado';

  @override
  String get diaryReferenceTomatoSalad => 'Salada com tomate';

  @override
  String get diaryReferenceGreenSalad => 'Salada verde';

  @override
  String get diaryReferenceGrilledSalmon => 'Salmão grelhado';

  @override
  String get diaryReferenceFreshSandwich => 'Sanduíche natural';

  @override
  String get diaryReferenceSoySauce => 'Shoyu';

  @override
  String get diaryReferencePumpkinSoup => 'Sopa de abóbora';

  @override
  String get diaryReferenceBeefStroganoff => 'Strogonoff de carne';

  @override
  String get diaryReferenceJuice => 'Suco';

  @override
  String get diaryReferenceAssortedSushi => 'Sushi variado';

  @override
  String get diaryReferenceTapiocaWithEgg => 'Tapioca com ovo';

  @override
  String get diaryReferenceToast => 'Torrada';

  @override
  String get diaryReferenceGrapes => 'Uvas';

  @override
  String get diaryReference1Spoonful => '1 colher';

  @override
  String get diaryReference1Slice => '1 fatia';

  @override
  String get diaryReference1Egg => '1 ovo';

  @override
  String get diaryReference1Piece => '1 unidade';

  @override
  String get diaryReference1Cup => '1 xícara';

  @override
  String get diaryReference10Pieces => '10 peças';

  @override
  String get diaryReference2Slices => '2 fatias';

  @override
  String get diaryReference2Eggs => '2 ovos';

  @override
  String get diaryReference2Pieces => '2 unidades';

  @override
  String get diaryReference3Slices => '3 fatias';

  @override
  String get diaryReference3Eggs => '3 ovos';

  @override
  String get diaryReference3Pieces => '3 unidades';

  @override
  String get diaryReference4Segments => '4 gomos';

  @override
  String get diaryReference4Pieces => '4 unidades';

  @override
  String get diaryReferenceTheBeginning => 'O começo';

  @override
  String
  get diaryReferenceTheBandLearnsWhoYouAreOver11DaysHrvRangedFrom54To66MsThatIsWhereYourBaselineBegins =>
      'A pulseira aprende quem você é. Em 11 dias a VFC ficou entre 54 e 66 ms. É daí que nasce o seu normal.';

  @override
  String get diaryReferenceSep11ToSep2111Days => '11 set a 21 set · 11 dias';

  @override
  String get diaryReferenceAverageHrv => 'VFC média';

  @override
  String get diaryReferenceWorkouts => 'Treinos';

  @override
  String get diaryReferenceSleep => 'Sono';

  @override
  String get diaryReferenceYouSleepBetterAround11Pm =>
      'Você dorme melhor perto das 23h';

  @override
  String get diaryReferenceSep18ByndLearned => '18 set · A BYND aprendeu';

  @override
  String get diaryReferenceDay1StartedWithTheBand =>
      'Dia 1: começou com a pulseira';

  @override
  String get diaryReferenceSep11Milestone => '11 set · Marco';

  @override
  String get diaryReferenceTheCold => 'O resfriado';

  @override
  String
  get diaryReferenceYourBodyGaveAWarningTwoDaysEarlierBreathingRoseOnTheNightsOfSep23And24YourThroatOnlyF =>
      'O corpo avisou dois dias antes. A respiração subiu nas noites de 23 e 24/09; a garganta só arranhou em 25/09. Cinco dias sem treino.';

  @override
  String get diaryReferenceSep22ToSep298Days => '22 set a 29 set · 8 dias';

  @override
  String get diaryReferenceBreathing => 'Respiração';

  @override
  String get diaryReference164Rpm => '16,4rpm';

  @override
  String get diaryReferenceRecovery => 'Recuperação';

  @override
  String get diaryReferenceNoTraining => 'Sem treino';

  @override
  String get diaryReference5Days => '5dias';

  @override
  String get diaryReferenceBestNight => 'Melhor noite';

  @override
  String get diaryReferenceSep28 => '28 set';

  @override
  String get diaryReferenceColdSpotted2DaysEarlier =>
      'Resfriado, visto 2 dias antes';

  @override
  String get diaryReferenceSep23ToSep29Event => '23 set a 29 set · Evento';

  @override
  String get diaryReferenceBackStronger => 'De volta, mais forte';

  @override
  String
  get diaryReferenceTheBestStretchOfTheTwoMonthsRecoveryReached91OnOct1ItOnlyFellOnAThursdayAfterWineThat =>
      'A melhor fase dos dois meses. A recuperação chegou a 91 em 1 out. Só caiu numa quinta depois do vinho: foi quando a BYND achou esse padrão.';

  @override
  String get diaryReferenceSep30ToOct1516Days => '30 set a 15 out · 16 dias';

  @override
  String get diaryReferenceBest => 'Melhor';

  @override
  String get diaryReferenceRuns => 'Corridas';

  @override
  String get diaryReferenceNewPattern => 'Padrão novo';

  @override
  String get diaryReferenceWine => 'vinho';

  @override
  String get diaryReferenceBestRecovery => 'Melhor recuperação';

  @override
  String get diaryReferenceOct1 => '1 out';

  @override
  String get diaryReference30DaysByndLearnedYourBaseline =>
      '30 dias: a BYND aprendeu o seu normal';

  @override
  String get diaryReferenceOct10Milestone => '10 out · Marco';

  @override
  String get diaryReferenceWednesdayWineTakesItsTollOnThursday =>
      'O vinho de quarta cobra na quinta';

  @override
  String get diaryReferenceOct8ByndLearned => '8 out · A BYND aprendeu';

  @override
  String get diaryReferenceDeadlineWeek => 'A semana de entrega';

  @override
  String
  get diaryReferenceLittleSleepLotsOfCoffeeFourNightsPastMidnightAnd4CoffeesADayStressDoubledAndRecoveryF =>
      'Pouco sono, muito café. Quatro noites depois da meia-noite e 4 cafés por dia. O estresse dobrou e a recuperação caiu para 53.';

  @override
  String get diaryReferenceOct16ToOct227Days => '16 out a 22 out · 7 dias';

  @override
  String get diaryReferenceStress => 'Estresse';

  @override
  String get diaryReferenceYourCycleIsRegularAt28Days =>
      'Seu ciclo é regular, de 28 dias';

  @override
  String get diaryReferenceOct20ByndLearned => '20 out · A BYND aprendeu';

  @override
  String get diaryReferenceDeadlineWeekAtWork =>
      'Semana de entrega no trabalho';

  @override
  String get diaryReferenceOct16ToOct20Event => '16 out a 20 out · Evento';

  @override
  String get diaryReferenceThe14Km => 'Os 14 km';

  @override
  String
  get diaryReferenceRecordHrvAndYourLongestRunHrvReached73MsOnOct28ThenCameThreeHardWorkoutsInARowAndThe1 =>
      'Recorde de VFC e a corrida mais longa. A VFC bateu 73 ms em 28 out. Depois vieram três treinos fortes seguidos e os 14 km, e a VFC caiu para 46 na quinta.';

  @override
  String get diaryReferenceOct23ToNov514Days => '23 out a 5 nov · 14 dias';

  @override
  String get diaryReferenceRecordHrv => 'VFC recorde';

  @override
  String get diaryReferenceRun => 'Corrida';

  @override
  String get diaryReferenceOct28 => '28 out';

  @override
  String get diaryReferenceLongestRun => 'Corrida mais longa';

  @override
  String get diaryReferenceNov4 => '4 nov';

  @override
  String get diaryReferenceMostActiveDay => 'Dia mais ativo';

  @override
  String get diaryReference21950Steps => '21.950passos';

  @override
  String get diaryReferenceNightsOnSchedule => 'Noites no horário';

  @override
  String get diaryReferenceNov1 => '1 nov';

  @override
  String get diaryReference4Of8 => '4de 8';

  @override
  String get diaryReferenceThreeHardWorkoutsInARow =>
      'Três treinos fortes seguidos';

  @override
  String get diaryReferenceNov3ToNov5Event => '3 nov a 5 nov · Evento';

  @override
  String get diaryReferenceJoinedTheBedBy11PmChallenge =>
      'Entrou no desafio “Deitar até 23h”';

  @override
  String get diaryReferenceNov1Milestone => '1 nov · Marco';

  @override
  String get diaryReferenceStressRisesWithShortSleep =>
      'O estresse sobe com o sono curto';

  @override
  String get diaryReferenceOct23ByndLearned => '23 out · A BYND aprendeu';

  @override
  String get diaryReferenceWokeUp => 'Acordou';

  @override
  String get diaryReference7H42OfSleepScore82MeasuredByTheBand =>
      '7h42 de sono · nota 82 · medido pela pulseira';

  @override
  String get diaryReferenceLightWorkoutMobilityAndStrength =>
      'Treino leve · mobilidade e força';

  @override
  String get diaryReference35MinLoad28MeasuredByTheBand =>
      '35 min · carga 28 · medido pela pulseira';

  @override
  String get diaryReference74OutOf100ReadyToTrainMeasuredByTheBand =>
      '74 de 100 · boa para treinar · medido pela pulseira';

  @override
  String get diaryReferenceHalfwayToYourStepGoal => 'Metade da meta de passos';

  @override
  String get diaryReference5000StepsMeasuredByTheBand =>
      '5.000 passos · medido pela pulseira';

  @override
  String get diaryReferenceStressPeak => 'Pico de estresse';

  @override
  String get diaryReference57OutOf100After2HSittingMeasuredByTheBand =>
      '57 de 100 · depois de 2 h sentado · medido pela pulseira';

  @override
  String get diaryReferenceMomentOfCalm => 'Momento de calma';

  @override
  String get diaryReference12MinLowStressMeasuredByTheBand =>
      '12 min · estresse baixo · medido pela pulseira';

  @override
  String get diaryReferenceWalk => 'Caminhada';

  @override
  String get diaryReference24Min21KmMeasuredByTheBand =>
      '24 min · 2,1 km · medido pela pulseira';

  @override
  String get diaryReferenceBodyReadyForSleep => 'Corpo pronto para dormir';

  @override
  String get diaryReference364CTemperatureDroppingMeasuredByTheBand =>
      '36,4 °C · temperatura caindo · medido pela pulseira';

  @override
  String get diaryReference6H10OfSleepScore64MeasuredByTheBand =>
      '6h10 de sono · nota 64 · medido pela pulseira';

  @override
  String get diaryReference42MinLoad61MeasuredByTheBand =>
      '42 min · carga 61 · medido pela pulseira';

  @override
  String get diaryReferenceWentToBed => 'Foi dormir';

  @override
  String get diaryReference2240MeasuredByTheBand =>
      '22:40  · medido pela pulseira';

  @override
  String get diaryAutomaticWokeUp => 'Acordou';

  @override
  String get diaryAutomaticActivity => 'Atividade';

  @override
  String diaryChapterCount(int count) {
    return 'de $count capítulos';
  }

  @override
  String diaryDidNotHappenAction(String title) {
    return 'Não aconteceu: $title';
  }

  @override
  String diaryToggleAction(String title) {
    return 'Marcar $title';
  }

  @override
  String diaryBandAndEntries(int bandCount, int entryCount) {
    return '$bandCount da pulseira · $entryCount registros seus';
  }

  @override
  String diaryHowWasDate(String date) {
    return 'Como foi o dia $date?';
  }

  @override
  String get diarySpeechLanguageUnavailable =>
      'O reconhecimento de voz neste idioma não está disponível no aparelho. Você pode escrever.';

  @override
  String get diaryWhatHappenedOnThisDay => 'O que aconteceu neste dia?';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get exerciseDetailCountAs => 'Conta como';

  @override
  String get exerciseDetailSeconds => 'segundos';

  @override
  String get exerciseDetailMinutes => 'minutos';

  @override
  String get exerciseDetailRepsBody => 'repetições (peso do corpo)';

  @override
  String get exerciseDetailRepsWeight => 'repetições × carga';

  @override
  String get exerciseDetailTitle => 'Exercício';

  @override
  String exerciseDetailHow(String name) {
    return 'Como fazer: $name';
  }

  @override
  String get exerciseDetailMark => 'Marcar para adicionar';

  @override
  String get exerciseDetailMuscles => 'Músculos';

  @override
  String get exerciseDetailEquipment => 'Equipamento';

  @override
  String get exerciseDetailGroup => 'Grupo';

  @override
  String get exerciseDetailLevel => 'Nível';

  @override
  String exerciseDetailAnimation(String name) {
    return 'Animação: $name';
  }

  @override
  String get exerciseDetailNoAnimation =>
      'Animação não disponível para este exercício.';

  @override
  String get exerciseConfirmEmpty => 'Confirmar';

  @override
  String get exerciseSelectorTitle => 'Selecionar exercícios';

  @override
  String get exerciseSearch => 'Buscar exercício ou músculo';

  @override
  String get exerciseAll => 'Todos';

  @override
  String get exerciseMark => 'Marque os exercícios';

  @override
  String exerciseAdd(int count) {
    return 'Adicionar ($count)';
  }

  @override
  String exerciseCount(int count) {
    return '$count exercícios';
  }

  @override
  String get exerciseEmpty => 'Nenhum exercício encontrado.';

  @override
  String get exerciseLoadError => 'Não foi possível carregar os exercícios.';

  @override
  String get exerciseRetry => 'Tentar novamente';

  @override
  String exerciseSelectedCount(int count) {
    return '$count exercícios selecionados · demonstração';
  }

  @override
  String get exerciseDraftNote =>
      'Prévia local · ainda não é possível salvar o treino';

  @override
  String get exerciseAddMore => 'Adicionar exercício';

  @override
  String get workoutLocalNote =>
      'Salvo apenas neste dispositivo · não sincronizado';

  @override
  String get workoutDefaultsNote => 'Valores iniciais de exemplo';

  @override
  String get workoutSaveError =>
      'Não foi possível salvar neste dispositivo. Tente novamente.';

  @override
  String get workoutLoadError => 'Não foi possível carregar os treinos locais.';

  @override
  String get workoutReplaceExercise => 'Trocar exercício';

  @override
  String get workoutCloseSets => 'Fechar séries';

  @override
  String get workoutEditSets => 'Editar séries';

  @override
  String get workoutShowExercise => 'Ver como fazer';

  @override
  String get workoutRemoveExercise => 'Remover';

  @override
  String get workoutDuplicateExercise => 'Duplicar';

  @override
  String get workoutRemoveSet => 'Remover série';

  @override
  String get workoutAddSet => 'Adicionar série';

  @override
  String get workoutSet => 'Série';

  @override
  String get workoutAmount => 'Repetições / tempo';

  @override
  String get workoutWeightKg => 'Peso (kg)';

  @override
  String get workoutDone => 'Concluir';

  @override
  String get workoutCancel => 'Cancelar';

  @override
  String get workoutInvalidSet => 'Informe valores válidos.';

  @override
  String get workoutPlanPreview => 'Plano local · atividade ainda não iniciada';

  @override
  String get workoutReorder => 'Reordenar exercícios';

  @override
  String get workoutMoveUp => 'Mover para cima';

  @override
  String get workoutMoveDown => 'Mover para baixo';

  @override
  String workoutSuggestedName(String group) {
    return 'Treino de $group';
  }

  @override
  String get workoutMenuEdit => 'Editar';

  @override
  String get workoutMenuDelete => 'Apagar';

  @override
  String get workoutDeleteTitle => 'Apagar treino?';

  @override
  String workoutDeleteMessage(String name) {
    return '“$name” será removido dos treinos locais.';
  }

  @override
  String get workoutActionError =>
      'Não foi possível atualizar os treinos locais.';

  @override
  String get workoutBuilderTitle => 'Montar treino';

  @override
  String get workoutBuilderWeight => 'kg levantados';

  @override
  String get workoutBuilderEmptyCount => '0 EXERCÍCIOS · 0 SÉRIES';

  @override
  String get workoutBuilderName => 'NOME DO TREINO';

  @override
  String get workoutBuilderNameHint => 'Treino de força';

  @override
  String get workoutBuilderEmptyTitle => 'Monte o seu treino';

  @override
  String get workoutBuilderEmptyHint =>
      'Toque no + e escolha entre 218 exercícios.';

  @override
  String get workoutBuilderAdd => 'Adicionar exercícios';

  @override
  String get workoutBuilderUnavailable =>
      'O catálogo de exercícios ainda não está conectado.';

  @override
  String get workoutBuilderStart => 'Começar';

  @override
  String get strengthDemoNote =>
      'Modelos de demonstração · não são treinos salvos';

  @override
  String get strengthDemoUnavailable =>
      'Os modelos e o editor ainda não estão conectados.';

  @override
  String get strengthDemoName1 => 'Demonstração';

  @override
  String get strengthDemoName2 => 'Pernas e glúteos';

  @override
  String get strengthDemoName3 => 'Superiores';

  @override
  String get strengthDemoName4 => 'Corpo todo';

  @override
  String get strengthDemoName5 => 'Pernas';

  @override
  String get strengthDemoName6 => 'Superiores e core';

  @override
  String get strengthDemoName7 => 'Treino leve · mobilidade';

  @override
  String strengthExerciseCount(int exercises, int sets) {
    return '$exercises exercícios · $sets séries';
  }

  @override
  String get strengthCreateHint => 'escolher exercícios, séries e carga';

  @override
  String strengthOptions(String name) {
    return 'Opções de $name';
  }

  @override
  String get activityRegistrationPreview =>
      'Prévia · dados simulados · não salvo';

  @override
  String get activityDetailHighIntensity => 'Alta intensidade';

  @override
  String get activityDetailEffortPeaks => 'Picos de esforço';

  @override
  String get registrationTitle => 'Registrar atividade';

  @override
  String get registrationModality => 'MODALIDADE';

  @override
  String get registrationChange => 'tocar para trocar';

  @override
  String get registrationWhen => 'QUANDO';

  @override
  String get registrationOtherDay => 'Outro dia';

  @override
  String get registrationStart => 'Começou às';

  @override
  String get registrationDuration => 'Duração';

  @override
  String get registrationEffort => 'ESFORÇO QUE VOCÊ SENTIU';

  @override
  String get registrationOfTen => 'de 10';

  @override
  String get registrationEstimated => 'carga estimada de exemplo';

  @override
  String get registrationSave => 'Salvar';

  @override
  String get registrationUnavailable =>
      'Demonstração: o registro de atividades ainda não está conectado.';

  @override
  String get registrationInvalid =>
      'A atividade não pode terminar no futuro ou depois da meia-noite.';

  @override
  String get registrationDone => 'Concluído';

  @override
  String get registrationHigh => 'ALTA';

  @override
  String get registrationModerate => 'MODERADA';

  @override
  String get registrationLight => 'Leve';

  @override
  String get registrationStrong => 'Forte';

  @override
  String get registrationMaximum => 'Máximo';

  @override
  String get registrationShortPhrases => 'frases curtas';

  @override
  String get registrationEffortDescription => 'Esforço de 1 a 10';

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
  String get historyNormalStatus => 'DENTRO DO SEU NORMAL';

  @override
  String get historyAverage => 'sua média';

  @override
  String get historyNormalRange => 'normal 35–58';

  @override
  String get historySevenDayAverage => 'média de 7 dias';

  @override
  String get historyDemoMonth => 'nov';

  @override
  String historyDemoSummary(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count atividades',
      one: '$count atividade',
    );
    return '$_temp0 · $minutes min no total';
  }

  @override
  String get historyDemoTime => 'hoje 07:50';

  @override
  String get activityDetailDemoSource => 'Exemplo · dados ilustrativos';

  @override
  String get activityDetailTimeTo => 'a';

  @override
  String get activityDetailDuration => 'Duração';

  @override
  String get activityDetailCalories => 'Calorias';

  @override
  String get activityDetailAverageHeartRate => 'FC média';

  @override
  String get activityDetailMaximumHeartRate => 'FC máxima';

  @override
  String get activityDetailHeartZones => 'Zonas da FC';

  @override
  String activityDetailZoneMost(int zone) {
    return 'mais tempo na zona $zone';
  }

  @override
  String get activityDetailZone => 'Zona';

  @override
  String get activityDetailZoneRest => 'repouso';

  @override
  String get activityDetailZoneVeryLight => 'muito leve';

  @override
  String get activityDetailZoneLight => 'leve';

  @override
  String get activityDetailZoneModerate => 'moderada';

  @override
  String get activityDetailZoneHard => 'intensa';

  @override
  String get activityDetailZoneMaximum => 'máxima';

  @override
  String get activityDetailMin => 'Mín';

  @override
  String get activityDetailMax => 'Máx';

  @override
  String get activityDetailOptions => 'Opções';

  @override
  String get activityDetailShare => 'Compartilhar';

  @override
  String get activityDetailEdit => 'Editar horário e duração';

  @override
  String get activityDetailDelete => 'Apagar atividade';

  @override
  String get activityDetailStart => 'Horário de início (HH:mm)';

  @override
  String get activityDetailSave => 'Salvar';

  @override
  String get activityDetailCancel => 'Cancelar';

  @override
  String get activityDetailInvalid =>
      'Informe um horário válido e uma duração de 1 a 720 minutos.';

  @override
  String get activityDetailDemoOnly =>
      'Apenas demonstração · alterações duram até você sair desta página.';

  @override
  String get activityDetailCopied => 'Resumo de exemplo copiado.';

  @override
  String get activityDetailCopyFailed =>
      'Não foi possível copiar o resumo de exemplo.';

  @override
  String get activityDetailDeleteConfirm => 'Apagar este exemplo?';

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
  String get activityTargetStatus => 'ABAIXO DO ALVO';

  @override
  String get activityTargetTitle => 'Falta pouco para o alvo.';

  @override
  String get activityTargetDescription =>
      'Hoje: musculação, 35 min, carga 28. Com recuperação em 57, a meta do dia é 35–55: faltam 7. Uma caminhada leve de 20 a 30 minutos deve completar a meta. Estimativa de recuperação para amanhã: perto de 66.';

  @override
  String get activityMetricActiveCalories => 'Calorias ativas';

  @override
  String get activityMetricActiveMinutes => 'Minutos ativos';

  @override
  String get activityMetricSteps => 'Passos';

  @override
  String get activityMetricRestingTime => 'Tempo parado';

  @override
  String get activityMetricAbove25 => '↑ 25% acima';

  @override
  String get activityMetricAbove28 => '↑ 28% acima';

  @override
  String get activityMetricWithinNormal => 'dentro do normal';

  @override
  String get activityMetricNormalCalories => 'normal 256–383 kcal';

  @override
  String get activityMetricNormalMinutes => 'normal 35–53 min';

  @override
  String get activityMetricNormalSteps => 'normal 3.904–5.856';

  @override
  String get activityMetricNormalRest => 'normal 3h32–5h18';

  @override
  String get activityDemoStrength => 'Musculação';

  @override
  String get activityDemoRun => 'Corrida';

  @override
  String get activityDemoWalk => 'Caminhada';

  @override
  String get activityDemoSetsAndWeight => 'séries e peso';

  @override
  String get activityDemoWithGps => 'com GPS';

  @override
  String activityDemoSummary(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count treinos',
      one: '$count treino',
    );
    return '$_temp0 · $minutes min no total';
  }

  @override
  String get activityDemoLoadLabel => 'carga';

  @override
  String get activityDemoLabel =>
      'Dados ilustrativos de demonstração · não sincronizados';

  @override
  String get activityDemoStepsValue => '6.240';

  @override
  String get activityDemoRestingTimeValue => '4h44';

  @override
  String get dayInNumbers => 'O dia em números';

  @override
  String get dailyMetricsUnavailable =>
      'Métricas diárias ainda não integradas.';

  @override
  String get modalities => 'Modalidades';

  @override
  String get viewAll => 'Ver todas';

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

  @override
  String get homeMorning => 'Bom dia';

  @override
  String get homeAfternoon => 'Boa tarde';

  @override
  String get homeEvening => 'Boa noite';

  @override
  String get homePastGreeting => 'Como foi o seu dia';

  @override
  String get homeDirection => 'Ver direção completa';

  @override
  String get homeSignals => 'Seus sinais';

  @override
  String get homeAllSignals => 'Ver todos ›';

  @override
  String get homeCustomize => 'Personalizar a Home';

  @override
  String get homeCustomizeHelp =>
      'Escolha os 6 sinais que ficam na sua Home e arraste pela alça ≡ para mudar a ordem.';

  @override
  String get homeOnHome => 'NA HOME';

  @override
  String get homeOtherSignals => 'OUTROS SINAIS';

  @override
  String get homeSixSlots =>
      'A Home tem 6 lugares. Desmarque um antes de escolher outro.';

  @override
  String get homeSave => 'Salvar';

  @override
  String get homePreferenceFailed =>
      'Não foi possível salvar sua preferência. Tente novamente.';

  @override
  String get homePhoto => 'Trocar a foto do topo';

  @override
  String get homeShowMore => 'Mostrar mais';

  @override
  String get homeShowLess => 'Mostrar menos';

  @override
  String get homeRetry => 'Tentar novamente';

  @override
  String get homeUnavailable => 'Não foi possível carregar a Home.';

  @override
  String get homeSignIn => 'Entre na sua conta para ver seus dados.';

  @override
  String get homeSignInAction => 'Entrar na conta';

  @override
  String get homeNoMeasurement => 'Sem dados neste dia';

  @override
  String get homeSync =>
      'Conecte e sincronize sua pulseira para ver seus sinais.';

  @override
  String get homePartial => 'Algumas informações não foram atualizadas.';

  @override
  String get homeMapaTitle => 'O que o seu corpo está revelando?';

  @override
  String get homeMapaBody =>
      'Uma relação entre seus hábitos, sono, atividade e recuperação começou a aparecer.';

  @override
  String get homeMapaWaiting =>
      'Seu Mapa está se formando. Continue usando a pulseira para descobrir relações entre seus hábitos e seus sinais.';

  @override
  String get homeExploreMapa => 'Explorar meu Mapa →';

  @override
  String get homeDiaryKicker => 'SEU DIÁRIO';

  @override
  String get homeDiaryTitle => 'Como foi o seu dia?';

  @override
  String get homeDiaryBody =>
      'Registre alimentação, treino, humor, café e o que mais aconteceu.';

  @override
  String get homeAddEntry => 'Adicionar registro +';

  @override
  String get homePatterns => 'padrões';

  @override
  String get homeWaitingPatterns => 'Em formação';

  @override
  String get homeNumbers => 'Seus números';

  @override
  String get homeWeek => 'SEMANA · UM PONTO POR DIA';

  @override
  String get homeMinimum => 'Mínima';

  @override
  String get homeAverage => 'Média';

  @override
  String get homeMaximum => 'Máxima';

  @override
  String get homeHistoryError => 'Não foi possível carregar o histórico.';

  @override
  String get homeHistoryEmpty => 'Ainda não há medições nesta semana.';

  @override
  String get homeRecommendation => 'Para hoje';

  @override
  String get homeDiary => 'Diário';

  @override
  String get homeDiaryEmpty =>
      'Seu dia, do seu jeito. Adicione o primeiro registro.';

  @override
  String get homeNewEntry => 'Novo registro';

  @override
  String get homeEntryLabel => 'O que aconteceu?';

  @override
  String get homeEntryNote => 'Mais detalhes (opcional)';

  @override
  String get homeEntryRequired => 'Descreva o registro antes de salvar.';

  @override
  String get homeEntrySaved => 'Registro salvo.';

  @override
  String get homeEntryFailed => 'Não foi possível salvar. Tente novamente.';

  @override
  String get homeMeal => 'Alimentação';

  @override
  String get homeTraining => 'Treino';

  @override
  String get homeMood => 'Humor';

  @override
  String get homeCaffeine => 'Café';

  @override
  String get homeOther => 'Outro';

  @override
  String get homeUnknownDirection => 'Aguardando seus sinais.';

  @override
  String get homeDataOnly =>
      'Medições da sua pulseira. Os dados ausentes não são estimados.';

  @override
  String get homeSelectedCount => 'de 6';

  @override
  String get homeOpenDevice => 'Conectar pulseira';

  @override
  String get homeRefresh => 'Atualizar';

  @override
  String get homeDrag => 'Arrastar para mudar a ordem';

  @override
  String get homeNoDirection =>
      'Sincronize a pulseira para acompanhar a direção do seu dia.';

  @override
  String get homeAccountChanged =>
      'Sua conta mudou. Feche esta tela e abra novamente para ver os dados atuais.';

  @override
  String get authWelcome => 'BEM-VINDO À BYND';

  @override
  String get authHeadline => 'Seu corpo.\nSua direção.';

  @override
  String get authSubtitle => 'Entenda seus sinais. Viva no seu ritmo.';

  @override
  String get authEmailContinue => 'Continuar com e-mail';

  @override
  String get authGoogleContinue => 'Continuar com Google';

  @override
  String get authEmailTitle => 'Qual é o seu e-mail?';

  @override
  String get authEmailBody =>
      'Vamos enviar um código para você entrar. Sem senha.';

  @override
  String get authAccountHint =>
      'No primeiro acesso, você pode criar sua conta por aqui.';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authEmailHint => 'voce@exemplo.com';

  @override
  String get authSendCode => 'Enviar código';

  @override
  String get authCodeTitle => 'Confira seu e-mail';

  @override
  String authCodeBody(String email) {
    return 'Enviamos um código de 6 dígitos para $email.';
  }

  @override
  String get authCodeLabel => 'Código de verificação';

  @override
  String get authCodeHint => '000000';

  @override
  String get authEditEmail => 'Alterar e-mail';

  @override
  String get authSignIn => 'Entrar';

  @override
  String get authCreateAccount => 'Criar conta e entrar';

  @override
  String get authResend => 'Reenviar código';

  @override
  String authResendIn(int seconds) {
    return 'Reenviar em ${seconds}s';
  }

  @override
  String get authSpamHint =>
      'Não chegou? Confira a caixa de spam ou peça um novo código.';

  @override
  String get authCodeSent => 'Código enviado. Confira também a caixa de spam.';

  @override
  String get authInvalidEmail => 'Informe um e-mail válido.';

  @override
  String get authInvalidCode => 'Digite os 6 números do código.';

  @override
  String get authCodeRejected =>
      'Não foi possível validar o código. Confira os números ou peça outro.';

  @override
  String get authCodeExpired =>
      'Esse código expirou. Peça um novo para continuar.';

  @override
  String get authNetworkError =>
      'Não foi possível conectar. Confira sua conexão e tente novamente.';

  @override
  String get authServerError =>
      'Não foi possível entrar agora. Tente novamente em instantes.';

  @override
  String get authRateLimited => 'Aguarde um pouco antes de tentar novamente.';

  @override
  String get authStorageError =>
      'Não foi possível salvar seu acesso neste dispositivo. Tente novamente.';

  @override
  String get authGoogleError =>
      'Não foi possível entrar com Google. Tente novamente ou use seu e-mail.';

  @override
  String get authSessionExpired =>
      'Seu acesso expirou. Entre novamente para continuar.';

  @override
  String get authConsentTitle => 'Seus dados de saúde, sua escolha';

  @override
  String get authConsentBody =>
      'A BYND usa os sinais de saúde coletados pela sua pulseira, como frequência cardíaca, VFC, sono e atividade, para gerar informações pessoais sobre o seu corpo. Para criar sua conta, precisamos do seu consentimento para esse tratamento.';

  @override
  String get authConsentLabel =>
      'Concordo com o tratamento dos meus dados de saúde para gerar informações pessoais, conforme descrito em Privacidade.';

  @override
  String get authConsentRequired =>
      'Para criar sua conta, confirme sua escolha sobre os dados de saúde.';

  @override
  String get authConsentAccept => 'Concordar e continuar';

  @override
  String get authConsentDecline => 'Agora não';

  @override
  String get authPrivacy => 'Privacidade';

  @override
  String get authPrivacyLink => 'Como usamos seus dados';

  @override
  String get authPrivacyTitle => 'Seus dados na BYND';

  @override
  String get authPrivacyPurposeTitle => 'Para entender seus sinais';

  @override
  String get authPrivacyPurpose =>
      'Os dados de saúde da pulseira e os registros que você adiciona permitem apresentar informações sobre sono, atividade e outros sinais do seu corpo.';

  @override
  String get authPrivacyChoiceTitle => 'Uma escolha explícita';

  @override
  String get authPrivacyChoice =>
      'A criação da conta exige seu consentimento para o tratamento dos dados de saúde. Você pode ler estas informações e voltar sem concordar; nesse caso, nenhuma conta será criada por esta etapa.';

  @override
  String get authPrivacyAccessTitle => 'Seu acesso';

  @override
  String get authPrivacyAccess =>
      'O acesso por e-mail usa um código temporário. Guarde esse código só para você. A sessão permanece no dispositivo até você sair ou o acesso expirar.';

  @override
  String get authLegalFootnote =>
      'Conheça como a BYND utiliza seus dados antes de continuar.';

  @override
  String get authRestore => 'Preparando seu acesso…';

  @override
  String get authSignOutTitle => 'Sair da sua conta?';

  @override
  String get authSignOutBody =>
      'Você poderá entrar novamente com seu e-mail ou com Google.';

  @override
  String get authSignOutConfirm => 'Sair';

  @override
  String get authCancel => 'Cancelar';

  @override
  String get authSignOutFailed =>
      'Você saiu, mas não foi possível limpar todos os dados locais. Tente reiniciar o app.';

  @override
  String authBackground(int index, int total) {
    return 'Paisagem $index de $total';
  }

  @override
  String get authChangeLanguage => 'Alterar idioma';

  @override
  String get communityMyGroups => 'Meus grupos';

  @override
  String get communityEmptyGroups =>
      'Nenhum grupo ainda. Crie um ou entre com um convite.';

  @override
  String get communityToday => 'Para hoje';

  @override
  String get communityMarkDone => 'Marcar como feito';

  @override
  String get communityMarkedDone => 'Dia marcado como feito.';

  @override
  String get communityDoneToday => 'Feito hoje';

  @override
  String get communityRetry => 'Tentar novamente';

  @override
  String get communityAccept => 'Aceitar';

  @override
  String get communityDecline => 'Recusar';

  @override
  String communityMemberCount(Object count) {
    return '$count pessoas';
  }

  @override
  String communityDaysTotal(Object days) {
    return 'desafio de $days dias';
  }

  @override
  String get communityEmptyChat => 'Nenhuma mensagem ainda. Diga oi!';

  @override
  String get communityDayToday => 'Hoje';

  @override
  String get communityDayYesterday => 'Ontem';

  @override
  String get communityMessageRecalled => 'Mensagem removida';

  @override
  String get communitySendHint => 'Mensagem para o grupo';

  @override
  String communityInvitationFrom(Object group, Object inviter) {
    return '$inviter convidou você para \"$group\"';
  }

  @override
  String get communityNewCover => 'Criar grupo\nou entrar com código';

  @override
  String communityInviteFromShort(Object name) {
    return 'convite de $name';
  }

  @override
  String communityRankBadge(Object rank, Object total) {
    return '$rankº no desafio de $total';
  }

  @override
  String get communityParaHoje => 'Para hoje';

  @override
  String get communityPickChallenge => 'Escolher um desafio';

  @override
  String get communityPickChallengeSub => 'sozinho ou com o seu grupo';

  @override
  String communityDayOfTotal(Object day, Object total) {
    return 'dia $day de $total';
  }

  @override
  String get communityMuralToday => 'No grupo hoje';

  @override
  String get communityMuralYesterday => 'No grupo ontem';

  @override
  String get communityMuralIntro =>
      'Do mais novo para o mais antigo. Toque em \"Dar força\" para apoiar.';

  @override
  String get communityNoCheckinsToday =>
      'Nenhum check-in hoje ainda. Quem fizer aparece aqui.';

  @override
  String get communityNoCheckinsYesterday => 'Nenhum check-in ontem.';

  @override
  String get communityAtlasKicker => 'ATLAS · RESUMO DO GRUPO';

  @override
  String get communityCheer => 'Dar força';

  @override
  String get communityCheerSoon => 'Dar força chega em breve.';

  @override
  String get communityRespond => 'Responder';

  @override
  String get communityOpenGroupChat => 'Abrir a conversa do grupo';

  @override
  String get communityCheckinText => '✓ Check-in de hoje';

  @override
  String get communityNewTitle => 'Novo';

  @override
  String get communityTabChallenges => 'Desafios';

  @override
  String get communityTabCreateGroup => 'Criar grupo';

  @override
  String get communityTabCode => 'Código';

  @override
  String get communityChallengesIntro =>
      'Desafios criados pela BYND com especialistas. Faça sozinho ou leve para o seu grupo.';

  @override
  String get communityDetailsOpen => 'Ver detalhes';

  @override
  String get communityDetailsClose => 'Fechar';

  @override
  String get communityChallengeWhy => 'Por que funciona';

  @override
  String get communityChallengeDaily => 'Todo dia';

  @override
  String get communityEnrolledBadge => 'Você está neste desafio';

  @override
  String get communityStartToday => 'Começar hoje';

  @override
  String get communityChallengeLeave => 'Sair do desafio';

  @override
  String get communityStepName => '1 · Nome do grupo';

  @override
  String get communityStepInvite => '2 · Quem você quer chamar (e-mail)';

  @override
  String get communityCodeIntro =>
      'Recebeu um convite? Digite o código do grupo (ele vem no link ou na mensagem de quem te chamou).';

  @override
  String get communityCodeHint => 'BYND-0000';

  @override
  String get communityCodeGo => 'Entrar no grupo';

  @override
  String get communityCodeSoon => 'Entrar por código chega em breve.';

  @override
  String get communityAjustesTitle => 'Grupo';

  @override
  String get communityAjustesInvite => '+ Convidar';

  @override
  String get communityPlacarTitle => 'Placar';

  @override
  String get communityRoleAdmin => 'admin';

  @override
  String get communityNotifTitle => 'Avisos';

  @override
  String get communityNotifMessages => 'Mensagens';

  @override
  String get communityLeaveDoubleTap => 'Toque de novo para sair';

  @override
  String get communityInviteTitle => 'Convidar para o grupo';

  @override
  String get communityInviteEmailHint => 'nome@exemplo.com';

  @override
  String get communityInviteSend => 'Enviar';

  @override
  String get communityInviteSuccess => 'Convite enviado.';

  @override
  String communityMembersTitle(Object count) {
    return 'Pessoas · $count';
  }

  @override
  String get communityLeaveGroup => 'Sair do grupo';

  @override
  String get communityGoalsTitle => 'Objetivos';

  @override
  String get communityNoGoals => 'Nenhum objetivo neste grupo ainda.';

  @override
  String get communityCreateIntro =>
      'Um grupo é para fazer desafios juntos, comparar os números do objetivo e conversar.';

  @override
  String get communityGroupName => 'Nome do grupo';

  @override
  String get communityGroupNameHint => 'Ex.: Corrida das 6h, Família, Trabalho';

  @override
  String get communityGroupDescription => 'Descrição';

  @override
  String get communityGroupDescriptionHint => 'Sobre o que é o grupo?';

  @override
  String get communityInviteEmails => 'Quem você quer chamar';

  @override
  String get communityInviteEmailsHint => 'e-mails separados por vírgula';

  @override
  String get communityGroupCreate => 'Criar grupo';

  @override
  String get communityCreating => 'Criando...';

  @override
  String communityGroupCreated(Object count) {
    return 'Grupo criado · $count convite(s) enviado(s).';
  }

  @override
  String get communityCreateNote =>
      'Pode criar sem ninguém: depois de criar, você chama mais gente nos ajustes do grupo.';

  @override
  String get communityPublicGroup => 'Grupo público';

  @override
  String get communityJoin => 'Entrar';

  @override
  String get communityJoinedGroup => 'Boas-vindas ao grupo!';

  @override
  String get atlasInsights => 'Insights';

  @override
  String get atlasChat => 'Conversar com o ATLAS';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get insightsRefresh => 'Atualizar';

  @override
  String get insightsError =>
      'Não foi possível carregar os insights. Puxe para baixo e tente novamente.';

  @override
  String get insightsEmpty =>
      'Nenhum insight ainda. Continue sincronizando a pulseira — o ATLAS fala quando seus dados contam algo que vale a pena saber.';

  @override
  String get insightsFactors => 'O que pode estar envolvido';

  @override
  String get insightsActions => 'O que você pode experimentar';

  @override
  String get chatTitle => 'Atlas';

  @override
  String get chatNew => 'Nova conversa';

  @override
  String get chatEmptyHint =>
      'Pergunte sobre sono, recuperação, estresse ou prontidão para treinar. O ATLAS responde com os seus dados e explica o que significam.';

  @override
  String get chatInputHint => 'Pergunte ao Atlas';

  @override
  String get menuMapa => 'Mapa';

  @override
  String get chatSug1 => 'Como estou?';

  @override
  String get chatSug2 => 'Me dá um resumo do meu dia';

  @override
  String get chatSug3 => 'Por que a VFC não volta?';

  @override
  String get chatHistoryTitle => 'Conversas';

  @override
  String get chatHistoryEmpty => 'Nenhuma conversa ainda.';

  @override
  String get chatHistoryUntitled => 'Conversa sem título';

  @override
  String get chatContinueLast => 'Continuar última conversa';

  @override
  String get healthGroupSleep => 'Sono';

  @override
  String get healthGroupEnergy => 'Energia';

  @override
  String get healthGroupMetabolism => 'Metabolismo';

  @override
  String get healthGroupHeartBody => 'Coração e corpo';

  @override
  String get healthGroupBreathOxygen => 'Respiração e oxigênio';

  @override
  String get healthGroupLongevity => 'Longevidade';

  @override
  String get memoriaTitle => 'Memória';

  @override
  String get memoriaHeroTitle => 'O que o Atlas sabe de você';

  @override
  String get memoriaHeroSub => 'Quanto mais ele sabe, melhores as respostas.';

  @override
  String get memoriaKicker => 'O que ele guardou';

  @override
  String get memoriaCurrent => 'Atual';

  @override
  String get memoriaPast => 'Passou';

  @override
  String get memoriaTold => 'Você contou';

  @override
  String get memoriaPerceived => 'O Atlas percebeu';

  @override
  String get memoriaSince => 'desde';

  @override
  String get diaryCatalogAguaLabel => 'Beber água';

  @override
  String get diaryCatalogAguaPrompt => 'Bebeu água?';

  @override
  String get diaryCatalogProtLabel => 'Comer proteína';

  @override
  String get diaryCatalogProtPrompt => 'Comeu proteína nas refeições?';

  @override
  String get diaryCatalogFrutLabel => 'Fruta e verdura';

  @override
  String get diaryCatalogFrutPrompt => 'Comeu fruta e verdura?';

  @override
  String get diaryCatalogJantarLabel => 'Jantar até as 20h';

  @override
  String get diaryCatalogJantarPrompt => 'Jantou até as 20h?';

  @override
  String get diaryCatalogDoceLabel => 'Doce';

  @override
  String get diaryCatalogDocePrompt => 'Comeu doce?';

  @override
  String get diaryCatalogAlcLabel => 'Álcool';

  @override
  String get diaryCatalogAlcPrompt => 'Bebeu álcool?';

  @override
  String get diaryCatalogCafe15Label => 'Café depois das 15h';

  @override
  String get diaryCatalogCafe15Prompt => 'Tomou café depois das 15h?';

  @override
  String get diaryCatalogRefriLabel => 'Refrigerante';

  @override
  String get diaryCatalogRefriPrompt => 'Tomou refrigerante?';

  @override
  String get diaryCatalogCafeLabel => 'Café';

  @override
  String get diaryCatalogCafePrompt => 'Tomou café?';

  @override
  String get diaryCatalogTelaLabel => 'Celular na cama';

  @override
  String get diaryCatalogTelaPrompt => 'Usou o celular na cama?';

  @override
  String get diaryCatalogLuzLabel => 'Sol pela manhã';

  @override
  String get diaryCatalogLuzPrompt => 'Pegou sol de manhã?';

  @override
  String get diaryCatalogLerLabel => 'Ler antes de dormir';

  @override
  String get diaryCatalogLerPrompt => 'Leu antes de dormir?';

  @override
  String get diaryCatalogRespLabel => 'Respiração';

  @override
  String get diaryCatalogRespPrompt => 'Fez a respiração?';

  @override
  String get diaryCatalogMeditLabel => 'Meditar';

  @override
  String get diaryCatalogMeditPrompt => 'Meditou?';

  @override
  String get diaryCatalogGratLabel => 'Escrever 3 gratidões';

  @override
  String get diaryCatalogGratPrompt => 'Escreveu as gratidões?';

  @override
  String get diaryCatalogGeloLabel => 'Banho gelado';

  @override
  String get diaryCatalogGeloPrompt => 'Tomou banho gelado?';

  @override
  String get diaryCatalogAlongLabel => 'Alongar';

  @override
  String get diaryCatalogAlongPrompt => 'Alongou?';

  @override
  String get diaryCatalogDorLabel => 'Dor muscular';

  @override
  String get diaryCatalogDorPrompt => 'Sentiu dor muscular?';

  @override
  String get diaryCatalogRemedioLabel => 'Tomar o remédio';

  @override
  String get diaryCatalogRemedioPrompt => 'Tomou o remédio?';

  @override
  String get diaryCatalogGlpLabel => 'Aplicar o GLP-1';

  @override
  String get diaryCatalogGlpPrompt => 'Aplicou o GLP-1?';

  @override
  String get diaryCatalogCreatLabel => 'Creatina';

  @override
  String get diaryCatalogCreatPrompt => 'Tomou creatina?';

  @override
  String get diaryCatalogVitLabel => 'Vitaminas';

  @override
  String get diaryCatalogVitPrompt => 'Tomou as vitaminas?';

  @override
  String get diaryCatalogAcordouLabel => 'Como acordou';

  @override
  String get diaryCatalogAcordouPrompt => 'Como acordou?';

  @override
  String get diaryCatalogHumorLabel => 'Humor';

  @override
  String get diaryCatalogHumorPrompt => 'Como está o humor?';

  @override
  String get diaryCatalogEnergiaLabel => 'Disposição';

  @override
  String get diaryCatalogEnergiaPrompt => 'Como está a disposição?';

  @override
  String get diaryCatalogEstresseLabel => 'Estresse';

  @override
  String get diaryCatalogEstressePrompt => 'Quanto estresse hoje?';

  @override
  String get diaryCatalogCafeMLabel => 'Café da manhã';

  @override
  String get diaryCatalogCafeMPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogLancheMLabel => 'Lanche da manhã';

  @override
  String get diaryCatalogLancheMPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogAlmocoLabel => 'Almoço';

  @override
  String get diaryCatalogAlmocoPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogLancheTLabel => 'Lanche da tarde';

  @override
  String get diaryCatalogLancheTPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogJantarRLabel => 'Jantar';

  @override
  String get diaryCatalogJantarRPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogCeiaLabel => 'Ceia';

  @override
  String get diaryCatalogCeiaPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogWheyLabel => 'Whey';

  @override
  String get diaryCatalogWheyPrompt => 'O que você comeu?';

  @override
  String get diaryCatalogGripeLabel => 'Sinal de gripe';

  @override
  String get diaryCatalogGripePrompt => 'Sentiu sinal de gripe?';

  @override
  String get diaryCatalogCAguaLabel => 'Água';

  @override
  String get diaryCatalogCAguaPrompt => 'Bebeu água suficiente?';

  @override
  String get diaryCatalogCExpressoLabel => 'Café expresso';

  @override
  String get diaryCatalogCExpressoPrompt => 'Tomou expresso?';

  @override
  String get diaryCatalogCCafeleiteLabel => 'Café com leite';

  @override
  String get diaryCatalogCCafeleitePrompt => 'Tomou café com leite?';

  @override
  String get diaryCatalogCChaLabel => 'Chá';

  @override
  String get diaryCatalogCChaPrompt => 'Tomou chá?';

  @override
  String get diaryCatalogCChapretoLabel => 'Chá preto ou mate';

  @override
  String get diaryCatalogCChapretoPrompt =>
      'Tomou chá preto ou mate (com cafeína)?';

  @override
  String get diaryCatalogCChimarraoLabel => 'Chimarrão';

  @override
  String get diaryCatalogCChimarraoPrompt => 'Tomou chimarrão?';

  @override
  String get diaryCatalogCTerereLabel => 'Tereré';

  @override
  String get diaryCatalogCTererePrompt => 'Tomou tereré?';

  @override
  String get diaryCatalogCEnergLabel => 'Energético';

  @override
  String get diaryCatalogCEnergPrompt => 'Tomou energético?';

  @override
  String get diaryCatalogCSucoLabel => 'Suco natural';

  @override
  String get diaryCatalogCSucoPrompt => 'Tomou suco natural?';

  @override
  String get diaryCatalogCSucocxLabel => 'Suco de caixinha';

  @override
  String get diaryCatalogCSucocxPrompt => 'Tomou suco de caixinha ou em pó?';

  @override
  String get diaryCatalogCCocoLabel => 'Água de coco';

  @override
  String get diaryCatalogCCocoPrompt => 'Tomou água de coco?';

  @override
  String get diaryCatalogCIsotLabel => 'Isotônico';

  @override
  String get diaryCatalogCIsotPrompt => 'Tomou isotônico?';

  @override
  String get diaryCatalogCLeiteLabel => 'Leite';

  @override
  String get diaryCatalogCLeitePrompt => 'Tomou leite?';

  @override
  String get diaryCatalogCVegetalLabel => 'Bebida vegetal';

  @override
  String get diaryCatalogCVegetalPrompt => 'Tomou leite vegetal?';

  @override
  String get diaryCatalogCKombuchaLabel => 'Kombucha';

  @override
  String get diaryCatalogCKombuchaPrompt => 'Tomou kombucha?';

  @override
  String get diaryCatalogCCervejaLabel => 'Cerveja';

  @override
  String get diaryCatalogCCervejaPrompt => 'Tomou cerveja?';

  @override
  String get diaryCatalogCVinhoLabel => 'Vinho';

  @override
  String get diaryCatalogCVinhoPrompt => 'Tomou vinho?';

  @override
  String get diaryCatalogCCaipirinhaLabel => 'Caipirinha';

  @override
  String get diaryCatalogCCaipirinhaPrompt => 'Tomou caipirinha?';

  @override
  String get diaryCatalogCCachacaLabel => 'Cachaça';

  @override
  String get diaryCatalogCCachacaPrompt => 'Tomou cachaça?';

  @override
  String get diaryCatalogCDestiladoLabel => 'Destilado';

  @override
  String get diaryCatalogCDestiladoPrompt => 'Tomou vodka, whisky ou gin?';

  @override
  String get diaryCatalogCDrinksLabel => 'Drinks';

  @override
  String get diaryCatalogCDrinksPrompt => 'Tomou drinks?';

  @override
  String get diaryCatalogCAlctardeLabel => 'Álcool à noite';

  @override
  String get diaryCatalogCAlctardePrompt => 'Bebeu perto da hora de dormir?';

  @override
  String get diaryCatalogCRessacaLabel => 'Ressaca';

  @override
  String get diaryCatalogCRessacaPrompt => 'Acordou de ressaca?';

  @override
  String get diaryCatalogCAguagasLabel => 'Água com gás';

  @override
  String get diaryCatalogCAguagasPrompt => 'Tomou água com gás?';

  @override
  String get diaryCatalogCChaverdeLabel => 'Chá verde';

  @override
  String get diaryCatalogCChaverdePrompt => 'Tomou chá verde?';

  @override
  String get diaryCatalogCCamomilaLabel => 'Chá calmante';

  @override
  String get diaryCatalogCCamomilaPrompt =>
      'Tomou chá de camomila, erva-cidreira ou melissa?';

  @override
  String get diaryCatalogCDescafLabel => 'Café descafeinado';

  @override
  String get diaryCatalogCDescafPrompt => 'Tomou café descafeinado?';

  @override
  String get diaryCatalogCSmoothieLabel => 'Vitamina ou smoothie';

  @override
  String get diaryCatalogCSmoothiePrompt => 'Tomou vitamina de frutas?';

  @override
  String get diaryCatalogCShakeLabel => 'Shake de proteína';

  @override
  String get diaryCatalogCShakePrompt => 'Tomou shake de proteína?';

  @override
  String get diaryCatalogCCaldocanaLabel => 'Caldo de cana';

  @override
  String get diaryCatalogCCaldocanaPrompt => 'Tomou caldo de cana?';

  @override
  String get diaryCatalogCAchocLabel => 'Achocolatado';

  @override
  String get diaryCatalogCAchocPrompt => 'Tomou achocolatado?';

  @override
  String get diaryCatalogCSemalcLabel => 'Cerveja sem álcool';

  @override
  String get diaryCatalogCSemalcPrompt => 'Tomou cerveja sem álcool?';

  @override
  String get diaryCatalogCBebquenteLabel => 'Bebida quente à noite';

  @override
  String get diaryCatalogCBebquentePrompt =>
      'Tomou algo quente antes de dormir?';

  @override
  String get diaryCatalogCAguamanhaLabel => 'Água ao acordar';

  @override
  String get diaryCatalogCAguamanhaPrompt => 'Bebeu água logo ao acordar?';

  @override
  String get diaryCatalogCCafemLabel => 'Café da manhã';

  @override
  String get diaryCatalogCCafemPrompt => 'Tomou café da manhã?';

  @override
  String get diaryCatalogCCafemanhaLabel => 'Café da manhã';

  @override
  String get diaryCatalogCCafemanhaPrompt => 'Tomou café da manhã?';

  @override
  String get diaryCatalogCAlmLabel => 'Almoço';

  @override
  String get diaryCatalogCAlmPrompt => 'Almoçou?';

  @override
  String get diaryCatalogCJantarLabel => 'Jantar';

  @override
  String get diaryCatalogCJantarPrompt => 'Jantou?';

  @override
  String get diaryCatalogCLancheLabel => 'Lanche da tarde';

  @override
  String get diaryCatalogCLanchePrompt => 'Fez lanche da tarde?';

  @override
  String get diaryCatalogCBeliscouLabel => 'Beliscou';

  @override
  String get diaryCatalogCBeliscouPrompt => 'Beliscou entre as refeições?';

  @override
  String get diaryCatalogCPularefLabel => 'Pulou refeição';

  @override
  String get diaryCatalogCPularefPrompt => 'Pulou alguma refeição?';

  @override
  String get diaryCatalogCTardeLabel => 'Comeu tarde';

  @override
  String get diaryCatalogCTardePrompt => 'Comeu perto da hora de dormir?';

  @override
  String get diaryCatalogCJejumLabel => 'Jejum';

  @override
  String get diaryCatalogCJejumPrompt => 'Fez jejum intermitente?';

  @override
  String get diaryCatalogCComeudemaisLabel => 'Comeu demais';

  @override
  String get diaryCatalogCComeudemaisPrompt => 'Comeu além do ponto?';

  @override
  String get diaryCatalogCPesadaLabel => 'Refeição pesada';

  @override
  String get diaryCatalogCPesadaPrompt => 'Fez uma refeição pesada?';

  @override
  String get diaryCatalogCProtLabel => 'Proteína';

  @override
  String get diaryCatalogCProtPrompt => 'Bateu a proteína do dia?';

  @override
  String get diaryCatalogCCaseiraLabel => 'Comida caseira';

  @override
  String get diaryCatalogCCaseiraPrompt => 'Comeu comida feita em casa?';

  @override
  String get diaryCatalogCMarmitaLabel => 'Marmita';

  @override
  String get diaryCatalogCMarmitaPrompt => 'Levou marmita?';

  @override
  String get diaryCatalogCForaLabel => 'Comeu fora';

  @override
  String get diaryCatalogCForaPrompt => 'Comeu em restaurante?';

  @override
  String get diaryCatalogCDeliveryLabel => 'Delivery';

  @override
  String get diaryCatalogCDeliveryPrompt => 'Pediu comida por aplicativo?';

  @override
  String get diaryCatalogCFastfoodLabel => 'Fast food';

  @override
  String get diaryCatalogCFastfoodPrompt => 'Comeu fast food?';

  @override
  String get diaryCatalogCPizzaLabel => 'Pizza';

  @override
  String get diaryCatalogCPizzaPrompt => 'Comeu pizza?';

  @override
  String get diaryCatalogCProcLabel => 'Sem processados';

  @override
  String get diaryCatalogCProcPrompt => 'Evitou ultraprocessados?';

  @override
  String get diaryCatalogCSalgLabel => 'Salgadinho';

  @override
  String get diaryCatalogCSalgPrompt =>
      'Comeu salgadinho ou biscoito recheado?';

  @override
  String get diaryCatalogCFritoLabel => 'Fritura';

  @override
  String get diaryCatalogCFritoPrompt => 'Comeu fritura?';

  @override
  String get diaryCatalogCPastelLabel => 'Pastel ou coxinha';

  @override
  String get diaryCatalogCPastelPrompt =>
      'Comeu pastel, coxinha ou salgado frito?';

  @override
  String get diaryCatalogCChocoLabel => 'Chocolate';

  @override
  String get diaryCatalogCChocoPrompt => 'Comeu chocolate?';

  @override
  String get diaryCatalogCSorveteLabel => 'Sorvete';

  @override
  String get diaryCatalogCSorvetePrompt => 'Tomou sorvete?';

  @override
  String get diaryCatalogCBrigadeiroLabel => 'Brigadeiro ou bolo';

  @override
  String get diaryCatalogCBrigadeiroPrompt => 'Comeu brigadeiro ou bolo?';

  @override
  String get diaryCatalogCFrutaLabel => 'Frutas';

  @override
  String get diaryCatalogCFrutaPrompt => 'Comeu frutas?';

  @override
  String get diaryCatalogCVerduraLabel => 'Salada e verduras';

  @override
  String get diaryCatalogCVerduraPrompt => 'Comeu salada ou verduras?';

  @override
  String get diaryCatalogCLegumeLabel => 'Legumes';

  @override
  String get diaryCatalogCLegumePrompt => 'Comeu legumes?';

  @override
  String get diaryCatalogCFibraLabel => 'Fibras';

  @override
  String get diaryCatalogCFibraPrompt => 'Comeu fibras?';

  @override
  String get diaryCatalogCFeijaoLabel => 'Feijão';

  @override
  String get diaryCatalogCFeijaoPrompt => 'Comeu feijão?';

  @override
  String get diaryCatalogCArrozLabel => 'Arroz integral';

  @override
  String get diaryCatalogCArrozPrompt => 'Comeu arroz integral?';

  @override
  String get diaryCatalogCOvoLabel => 'Ovos';

  @override
  String get diaryCatalogCOvoPrompt => 'Comeu ovos?';

  @override
  String get diaryCatalogCCarnevLabel => 'Carne vermelha';

  @override
  String get diaryCatalogCCarnevPrompt => 'Comeu carne vermelha?';

  @override
  String get diaryCatalogCFrangoLabel => 'Frango';

  @override
  String get diaryCatalogCFrangoPrompt => 'Comeu frango?';

  @override
  String get diaryCatalogCPeixeLabel => 'Peixe';

  @override
  String get diaryCatalogCPeixePrompt => 'Comeu peixe?';

  @override
  String get diaryCatalogCEmbutLabel => 'Embutidos';

  @override
  String get diaryCatalogCEmbutPrompt =>
      'Comeu presunto, salsicha ou linguiça?';

  @override
  String get diaryCatalogCChurrascoLabel => 'Churrasco';

  @override
  String get diaryCatalogCChurrascoPrompt => 'Comeu churrasco?';

  @override
  String get diaryCatalogCFeijoadaLabel => 'Feijoada';

  @override
  String get diaryCatalogCFeijoadaPrompt => 'Comeu feijoada?';

  @override
  String get diaryCatalogCAcaiLabel => 'Açaí';

  @override
  String get diaryCatalogCAcaiPrompt => 'Tomou açaí?';

  @override
  String get diaryCatalogCTapiocaLabel => 'Tapioca ou cuscuz';

  @override
  String get diaryCatalogCTapiocaPrompt => 'Comeu tapioca ou cuscuz?';

  @override
  String get diaryCatalogCPaoqueijoLabel => 'Pão de queijo';

  @override
  String get diaryCatalogCPaoqueijoPrompt => 'Comeu pão de queijo?';

  @override
  String get diaryCatalogCPaobrancoLabel => 'Pão branco';

  @override
  String get diaryCatalogCPaobrancoPrompt => 'Comeu pão francês ou pão branco?';

  @override
  String get diaryCatalogCMacarraoLabel => 'Massa';

  @override
  String get diaryCatalogCMacarraoPrompt => 'Comeu macarrão ou massa?';

  @override
  String get diaryCatalogCLatLabel => 'Sem laticínios';

  @override
  String get diaryCatalogCLatPrompt => 'Ficou sem leite e derivados?';

  @override
  String get diaryCatalogCGlutenLabel => 'Sem glúten';

  @override
  String get diaryCatalogCGlutenPrompt => 'Ficou sem glúten?';

  @override
  String get diaryCatalogCVeganoLabel => 'Sem carne';

  @override
  String get diaryCatalogCVeganoPrompt => 'Ficou sem carne no dia?';

  @override
  String get diaryCatalogCCarboLabel => 'Pouco carboidrato';

  @override
  String get diaryCatalogCCarboPrompt => 'Comeu pouco carboidrato?';

  @override
  String get diaryCatalogCApimentadaLabel => 'Comida apimentada';

  @override
  String get diaryCatalogCApimentadaPrompt => 'Comeu comida apimentada?';

  @override
  String get diaryCatalogCSalLabel => 'Muito sal';

  @override
  String get diaryCatalogCSalPrompt => 'Comeu comida muito salgada?';

  @override
  String get diaryCatalogCAdocanteLabel => 'Adoçante';

  @override
  String get diaryCatalogCAdocantePrompt => 'Usou adoçante?';

  @override
  String get diaryCatalogCProtcafeLabel => 'Proteína no café';

  @override
  String get diaryCatalogCProtcafePrompt => 'Comeu proteína no café da manhã?';

  @override
  String get diaryCatalogCCarbonoiteLabel => 'Carboidrato à noite';

  @override
  String get diaryCatalogCCarbonoitePrompt => 'Comeu carboidrato no jantar?';

  @override
  String get diaryCatalogCJantarleveLabel => 'Jantar leve';

  @override
  String get diaryCatalogCJantarlevePrompt => 'Jantou leve?';

  @override
  String get diaryCatalogCAveiaLabel => 'Aveia';

  @override
  String get diaryCatalogCAveiaPrompt => 'Comeu aveia?';

  @override
  String get diaryCatalogCIogurteLabel => 'Iogurte';

  @override
  String get diaryCatalogCIogurtePrompt => 'Comeu iogurte?';

  @override
  String get diaryCatalogCQueijoLabel => 'Queijo';

  @override
  String get diaryCatalogCQueijoPrompt => 'Comeu queijo?';

  @override
  String get diaryCatalogCCastanhaLabel => 'Castanhas';

  @override
  String get diaryCatalogCCastanhaPrompt => 'Comeu castanhas ou nozes?';

  @override
  String get diaryCatalogCAbacateLabel => 'Abacate';

  @override
  String get diaryCatalogCAbacatePrompt => 'Comeu abacate?';

  @override
  String get diaryCatalogCTubercLabel => 'Batata-doce ou mandioca';

  @override
  String get diaryCatalogCTubercPrompt =>
      'Comeu batata-doce, mandioca ou inhame?';

  @override
  String get diaryCatalogCSopaLabel => 'Sopa';

  @override
  String get diaryCatalogCSopaPrompt => 'Tomou sopa?';

  @override
  String get diaryCatalogCJaponesLabel => 'Comida japonesa';

  @override
  String get diaryCatalogCJaponesPrompt => 'Comeu comida japonesa?';

  @override
  String get diaryCatalogCHamburguerLabel => 'Hambúrguer';

  @override
  String get diaryCatalogCHamburguerPrompt => 'Comeu hambúrguer?';

  @override
  String get diaryCatalogCCongeladoLabel => 'Comida congelada';

  @override
  String get diaryCatalogCCongeladoPrompt => 'Comeu comida pronta congelada?';

  @override
  String get diaryCatalogCSobremesaLabel => 'Sobremesa';

  @override
  String get diaryCatalogCSobremesaPrompt => 'Comeu sobremesa?';

  @override
  String get diaryCatalogCRapidoLabel => 'Comeu rápido';

  @override
  String get diaryCatalogCRapidoPrompt => 'Comeu com pressa?';

  @override
  String get diaryCatalogCTela2Label => 'Comeu vendo tela';

  @override
  String get diaryCatalogCTela2Prompt => 'Comeu assistindo TV ou celular?';

  @override
  String get diaryCatalogCEmfamiliaLabel => 'Refeição em família';

  @override
  String get diaryCatalogCEmfamiliaPrompt => 'Comeu junto com a família?';

  @override
  String get diaryCatalogCCozinhouLabel => 'Cozinhou';

  @override
  String get diaryCatalogCCozinhouPrompt => 'Cozinhou a própria comida?';

  @override
  String get diaryCatalogCLivreLabel => 'Refeição livre';

  @override
  String get diaryCatalogCLivrePrompt => 'Fez uma refeição livre?';

  @override
  String get diaryCatalogCFomeLabel => 'Passou fome';

  @override
  String get diaryCatalogCFomePrompt => 'Ficou muitas horas sem comer?';

  @override
  String get diaryCatalogCCabecaLabel => 'Cabeça';

  @override
  String get diaryCatalogCCabecaPrompt => 'Como está sua cabeça?';

  @override
  String get diaryCatalogCDisposicaoLabel => 'Disposição';

  @override
  String get diaryCatalogCDisposicaoPrompt => 'Como está sua disposição?';

  @override
  String get diaryCatalogCAnsLabel => 'Ansiedade';

  @override
  String get diaryCatalogCAnsPrompt => 'Se sentiu nervoso ou ansioso?';

  @override
  String get diaryCatalogCEstresLabel => 'Estresse';

  @override
  String get diaryCatalogCEstresPrompt => 'Teve um dia estressante?';

  @override
  String get diaryCatalogCHumorLabel => 'Bom humor';

  @override
  String get diaryCatalogCHumorPrompt => 'Teve um dia de bom humor?';

  @override
  String get diaryCatalogCIrritLabel => 'Irritação';

  @override
  String get diaryCatalogCIrritPrompt => 'Se sentiu irritado?';

  @override
  String get diaryCatalogCTristeLabel => 'Tristeza';

  @override
  String get diaryCatalogCTristePrompt => 'Se sentiu triste?';

  @override
  String get diaryCatalogCDesanimoLabel => 'Desânimo';

  @override
  String get diaryCatalogCDesanimoPrompt =>
      'Se sentiu sem energia ou desanimado?';

  @override
  String get diaryCatalogCMotivLabel => 'Motivação';

  @override
  String get diaryCatalogCMotivPrompt => 'Se sentiu motivado?';

  @override
  String get diaryCatalogCFocoLabel => 'Foco';

  @override
  String get diaryCatalogCFocoPrompt => 'Conseguiu se concentrar bem?';

  @override
  String get diaryCatalogCProdLabel => 'Produtivo';

  @override
  String get diaryCatalogCProdPrompt => 'Teve um dia produtivo?';

  @override
  String get diaryCatalogCSobrecLabel => 'Sobrecarga';

  @override
  String get diaryCatalogCSobrecPrompt => 'Se sentiu sobrecarregado?';

  @override
  String get diaryCatalogCPreocLabel => 'Preocupação';

  @override
  String get diaryCatalogCPreocPrompt => 'Ficou preocupado com algo?';

  @override
  String get diaryCatalogCDinheiroLabel => 'Dinheiro';

  @override
  String get diaryCatalogCDinheiroPrompt => 'Se preocupou com dinheiro?';

  @override
  String get diaryCatalogCConflitoLabel => 'Discussão';

  @override
  String get diaryCatalogCConflitoPrompt => 'Teve alguma discussão?';

  @override
  String get diaryCatalogCSozinhoLabel => 'Solidão';

  @override
  String get diaryCatalogCSozinhoPrompt => 'Se sentiu sozinho?';

  @override
  String get diaryCatalogCRisadaLabel => 'Risadas';

  @override
  String get diaryCatalogCRisadaPrompt => 'Deu boas risadas?';

  @override
  String get diaryCatalogCGratLabel => 'Gratidão';

  @override
  String get diaryCatalogCGratPrompt => 'Pensou ou escreveu sobre gratidão?';

  @override
  String get diaryCatalogCMeditLabel => 'Meditação';

  @override
  String get diaryCatalogCMeditPrompt => 'Meditou?';

  @override
  String get diaryCatalogCTerapiaLabel => 'Terapia';

  @override
  String get diaryCatalogCTerapiaPrompt => 'Teve sessão de terapia?';

  @override
  String get diaryCatalogCFeLabel => 'Oração ou fé';

  @override
  String get diaryCatalogCFePrompt => 'Rezou, orou ou foi à igreja?';

  @override
  String get diaryCatalogCEscritaLabel => 'Escreveu';

  @override
  String get diaryCatalogCEscritaPrompt => 'Escreveu num diário?';

  @override
  String get diaryCatalogCLeituraLabel => 'Leitura';

  @override
  String get diaryCatalogCLeituraPrompt => 'Leu um livro?';

  @override
  String get diaryCatalogCHobbyLabel => 'Hobby';

  @override
  String get diaryCatalogCHobbyPrompt => 'Fez algo que gosta só por prazer?';

  @override
  String get diaryCatalogCMusicaLabel => 'Música';

  @override
  String get diaryCatalogCMusicaPrompt => 'Ouviu ou tocou música?';

  @override
  String get diaryCatalogCSocialLabel => 'Amigos';

  @override
  String get diaryCatalogCSocialPrompt => 'Encontrou amigos?';

  @override
  String get diaryCatalogCFamiliaLabel => 'Família';

  @override
  String get diaryCatalogCFamiliaPrompt => 'Passou tempo com a família?';

  @override
  String get diaryCatalogCNaturezaLabel => 'Natureza';

  @override
  String get diaryCatalogCNaturezaPrompt => 'Passou tempo na natureza?';

  @override
  String get diaryCatalogCRedesLabel => 'Redes sociais';

  @override
  String get diaryCatalogCRedesPrompt => 'Ficou muito tempo nas redes sociais?';

  @override
  String get diaryCatalogCNoticiasLabel => 'Notícias';

  @override
  String get diaryCatalogCNoticiasPrompt => 'Consumiu muita notícia?';

  @override
  String get diaryCatalogCDesconectLabel => 'Desconectou';

  @override
  String get diaryCatalogCDesconectPrompt => 'Ficou um tempo longe do celular?';

  @override
  String get diaryCatalogCTedioLabel => 'Tédio';

  @override
  String get diaryCatalogCTedioPrompt => 'Sentiu tédio?';

  @override
  String get diaryCatalogCAceleradoLabel => 'Pensamento acelerado';

  @override
  String get diaryCatalogCAceleradoPrompt => 'Ficou com a cabeça a mil?';

  @override
  String get diaryCatalogCPanicoLabel => 'Crise de ansiedade';

  @override
  String get diaryCatalogCPanicoPrompt => 'Teve crise de ansiedade ou pânico?';

  @override
  String get diaryCatalogCLutoLabel => 'Luto';

  @override
  String get diaryCatalogCLutoPrompt => 'Está passando por um luto?';

  @override
  String get diaryCatalogCAutoestLabel => 'Autoestima boa';

  @override
  String get diaryCatalogCAutoestPrompt => 'Se sentiu bem consigo mesmo?';

  @override
  String get diaryCatalogCArlivreLabel => 'Ar livre';

  @override
  String get diaryCatalogCArlivrePrompt => 'Passou tempo ao ar livre?';

  @override
  String get diaryCatalogCVoluntLabel => 'Ajudou alguém';

  @override
  String get diaryCatalogCVoluntPrompt => 'Fez algo por alguém hoje?';

  @override
  String get diaryCatalogCAprendeuLabel => 'Aprendeu algo';

  @override
  String get diaryCatalogCAprendeuPrompt => 'Aprendeu algo novo?';

  @override
  String get diaryCatalogCConversaLabel => 'Conversa importante';

  @override
  String get diaryCatalogCConversaPrompt =>
      'Teve uma conversa difícil ou importante?';

  @override
  String get diaryCatalogCSemtempoLabel => 'Sem tempo para si';

  @override
  String get diaryCatalogCSemtempoPrompt => 'Ficou sem nenhum tempo para você?';

  @override
  String get diaryCatalogCCalmaLabel => 'Dia tranquilo';

  @override
  String get diaryCatalogCCalmaPrompt => 'Teve um dia tranquilo?';

  @override
  String get diaryCatalogCHomeoffLabel => 'Home office';

  @override
  String get diaryCatalogCHomeoffPrompt => 'Trabalhou de casa?';

  @override
  String get diaryCatalogCPresencialLabel => 'Trabalho presencial';

  @override
  String get diaryCatalogCPresencialPrompt => 'Trabalhou no escritório?';

  @override
  String get diaryCatalogCLongoLabel => 'Expediente longo';

  @override
  String get diaryCatalogCLongoPrompt => 'Trabalhou mais de 10 horas?';

  @override
  String get diaryCatalogCReuniaoLabel => 'Reunião à noite';

  @override
  String get diaryCatalogCReuniaoPrompt => 'Trabalhou ou fez reunião à noite?';

  @override
  String get diaryCatalogCPlantaoLabel => 'Plantão';

  @override
  String get diaryCatalogCPlantaoPrompt =>
      'Trabalhou de madrugada ou de plantão?';

  @override
  String get diaryCatalogCTransitoLabel => 'Trânsito';

  @override
  String get diaryCatalogCTransitoPrompt => 'Pegou muito trânsito?';

  @override
  String get diaryCatalogCDirigiuLabel => 'Dirigiu muito';

  @override
  String get diaryCatalogCDirigiuPrompt => 'Dirigiu por mais de 1 hora?';

  @override
  String get diaryCatalogCOnibusLabel => 'Transporte público';

  @override
  String get diaryCatalogCOnibusPrompt => 'Pegou ônibus ou metrô lotado?';

  @override
  String get diaryCatalogCSentadoLabel => 'Muito sentado';

  @override
  String get diaryCatalogCSentadoPrompt => 'Passou o dia muito sentado?';

  @override
  String get diaryCatalogCEmpeLabel => 'Em pé';

  @override
  String get diaryCatalogCEmpePrompt => 'Passou muito tempo em pé?';

  @override
  String get diaryCatalogCPassosLabel => 'Caminhada';

  @override
  String get diaryCatalogCPassosPrompt => 'Caminhou mais de 30 minutos?';

  @override
  String get diaryCatalogCEscadasLabel => 'Escadas';

  @override
  String get diaryCatalogCEscadasPrompt => 'Subiu escadas?';

  @override
  String get diaryCatalogCCasa2Label => 'Tarefas de casa';

  @override
  String get diaryCatalogCCasa2Prompt =>
      'Fez faxina ou tarefas pesadas de casa?';

  @override
  String get diaryCatalogCFilhosLabel => 'Cuidou de criança';

  @override
  String get diaryCatalogCFilhosPrompt => 'Cuidou de criança o dia todo?';

  @override
  String get diaryCatalogCPetsLabel => 'Pet';

  @override
  String get diaryCatalogCPetsPrompt => 'Passeou ou brincou com o pet?';

  @override
  String get diaryCatalogCViagemLabel => 'Viagem';

  @override
  String get diaryCatalogCViagemPrompt => 'Viajou?';

  @override
  String get diaryCatalogCVooLabel => 'Voo';

  @override
  String get diaryCatalogCVooPrompt => 'Pegou avião?';

  @override
  String get diaryCatalogCFusoLabel => 'Fuso horário';

  @override
  String get diaryCatalogCFusoPrompt => 'Mudou de fuso horário?';

  @override
  String get diaryCatalogCPraiaLabel => 'Praia';

  @override
  String get diaryCatalogCPraiaPrompt => 'Foi à praia?';

  @override
  String get diaryCatalogCPiscinaLabel => 'Piscina';

  @override
  String get diaryCatalogCPiscinaPrompt => 'Entrou na piscina?';

  @override
  String get diaryCatalogCCalorLabel => 'Calor forte';

  @override
  String get diaryCatalogCCalorPrompt => 'Ficou muito tempo no calor?';

  @override
  String get diaryCatalogCFrioLabel => 'Frio';

  @override
  String get diaryCatalogCFrioPrompt => 'Passou frio?';

  @override
  String get diaryCatalogCFestaLabel => 'Festa ou balada';

  @override
  String get diaryCatalogCFestaPrompt => 'Saiu à noite?';

  @override
  String get diaryCatalogCShowLabel => 'Show';

  @override
  String get diaryCatalogCShowPrompt => 'Foi a um show ou evento?';

  @override
  String get diaryCatalogCFutebolLabel => 'Assistiu ao jogo';

  @override
  String get diaryCatalogCFutebolPrompt => 'Assistiu a jogo de futebol?';

  @override
  String get diaryCatalogCPeladaLabel => 'Pelada';

  @override
  String get diaryCatalogCPeladaPrompt => 'Jogou bola com os amigos?';

  @override
  String get diaryCatalogCGamesLabel => 'Videogame';

  @override
  String get diaryCatalogCGamesPrompt => 'Jogou videogame?';

  @override
  String get diaryCatalogCSerieLabel => 'Maratonou série';

  @override
  String get diaryCatalogCSeriePrompt => 'Ficou horas vendo série?';

  @override
  String get diaryCatalogCSexoLabel => 'Atividade sexual';

  @override
  String get diaryCatalogCSexoPrompt => 'Teve atividade sexual?';

  @override
  String get diaryCatalogCCigarLabel => 'Cigarro';

  @override
  String get diaryCatalogCCigarPrompt => 'Fumou?';

  @override
  String get diaryCatalogCVapeLabel => 'Vape';

  @override
  String get diaryCatalogCVapePrompt => 'Usou vape ou pod?';

  @override
  String get diaryCatalogCNarguileLabel => 'Narguilé';

  @override
  String get diaryCatalogCNarguilePrompt => 'Fumou narguilé?';

  @override
  String get diaryCatalogCCanabLabel => 'Cannabis';

  @override
  String get diaryCatalogCCanabPrompt => 'Usou cannabis?';

  @override
  String get diaryCatalogCAcordoucedoLabel => 'Acordou cedo';

  @override
  String get diaryCatalogCAcordoucedoPrompt => 'Acordou antes das 6h?';

  @override
  String get diaryCatalogCDormiuforaLabel => 'Dormiu fora de casa';

  @override
  String get diaryCatalogCDormiuforaPrompt => 'Dormiu fora de casa?';

  @override
  String get diaryCatalogCViagemtrabLabel => 'Viagem a trabalho';

  @override
  String get diaryCatalogCViagemtrabPrompt => 'Viajou a trabalho?';

  @override
  String get diaryCatalogCPrazoLabel => 'Prazo ou prova';

  @override
  String get diaryCatalogCPrazoPrompt =>
      'Teve prazo, prova ou entrega importante?';

  @override
  String get diaryCatalogCPublicoLabel => 'Falou em público';

  @override
  String get diaryCatalogCPublicoPrompt => 'Fez apresentação em público?';

  @override
  String get diaryCatalogCCuidadorLabel => 'Cuidou de alguém';

  @override
  String get diaryCatalogCCuidadorPrompt =>
      'Cuidou de um familiar doente ou idoso?';

  @override
  String get diaryCatalogCMudancaLabel => 'Mudança';

  @override
  String get diaryCatalogCMudancaPrompt => 'Está de mudança ou em obra?';

  @override
  String get diaryCatalogCJardimLabel => 'Jardinagem';

  @override
  String get diaryCatalogCJardimPrompt => 'Mexeu com plantas?';

  @override
  String get diaryCatalogCChuvaLabel => 'Dia de chuva';

  @override
  String get diaryCatalogCChuvaPrompt => 'Choveu o dia todo?';

  @override
  String get diaryCatalogCSecoLabel => 'Tempo seco';

  @override
  String get diaryCatalogCSecoPrompt => 'O ar estava muito seco?';

  @override
  String get diaryCatalogCFumacaLabel => 'Poluição ou fumaça';

  @override
  String get diaryCatalogCFumacaPrompt => 'Ficou exposto a poluição ou fumaça?';

  @override
  String get diaryCatalogCFolgaLabel => 'Dia de folga';

  @override
  String get diaryCatalogCFolgaPrompt => 'Foi um dia de folga?';

  @override
  String get diaryCatalogCAcordouLabel => 'Como acordou';

  @override
  String get diaryCatalogCAcordouPrompt => 'Como você acordou?';

  @override
  String get diaryCatalogCAlongLabel => 'Alongamento';

  @override
  String get diaryCatalogCAlongPrompt => 'Alongou?';

  @override
  String get diaryCatalogCMobilLabel => 'Mobilidade';

  @override
  String get diaryCatalogCMobilPrompt => 'Fez mobilidade?';

  @override
  String get diaryCatalogCSaunaLabel => 'Sauna';

  @override
  String get diaryCatalogCSaunaPrompt => 'Fez sauna?';

  @override
  String get diaryCatalogCBanhoqLabel => 'Banho quente';

  @override
  String get diaryCatalogCBanhoqPrompt => 'Tomou banho quente antes de dormir?';

  @override
  String get diaryCatalogCMassaLabel => 'Massagem';

  @override
  String get diaryCatalogCMassaPrompt => 'Fez massagem?';

  @override
  String get diaryCatalogCRoloLabel => 'Rolo';

  @override
  String get diaryCatalogCRoloPrompt => 'Usou rolo de liberação?';

  @override
  String get diaryCatalogCCompressLabel => 'Compressão';

  @override
  String get diaryCatalogCCompressPrompt => 'Usou botas de compressão?';

  @override
  String get diaryCatalogCFisioLabel => 'Fisioterapia';

  @override
  String get diaryCatalogCFisioPrompt => 'Teve fisioterapia?';

  @override
  String get diaryCatalogCQuiroLabel => 'Quiropraxia';

  @override
  String get diaryCatalogCQuiroPrompt => 'Teve quiropraxia ou osteopatia?';

  @override
  String get diaryCatalogCAcupLabel => 'Acupuntura';

  @override
  String get diaryCatalogCAcupPrompt => 'Fez acupuntura?';

  @override
  String get diaryCatalogCCochiloLabel => 'Cochilo';

  @override
  String get diaryCatalogCCochiloPrompt => 'Cochilou?';

  @override
  String get diaryCatalogCDescansoLabel => 'Dia de descanso';

  @override
  String get diaryCatalogCDescansoPrompt => 'Foi um dia de descanso?';

  @override
  String get diaryCatalogCYogaleveLabel => 'Yoga leve';

  @override
  String get diaryCatalogCYogalevePrompt => 'Fez yoga restaurativa?';

  @override
  String get diaryCatalogCPescocoLabel => 'Postura';

  @override
  String get diaryCatalogCPescocoPrompt => 'Cuidou da postura no trabalho?';

  @override
  String get diaryCatalogCBanheiraLabel => 'Banheira de gelo';

  @override
  String get diaryCatalogCBanheiraPrompt => 'Entrou na banheira de gelo?';

  @override
  String get diaryCatalogCCrioLabel => 'Crioterapia';

  @override
  String get diaryCatalogCCrioPrompt => 'Fez crioterapia de corpo inteiro?';

  @override
  String get diaryCatalogCContrasteLabel => 'Banho de contraste';

  @override
  String get diaryCatalogCContrastePrompt => 'Alternou água quente e fria?';

  @override
  String get diaryCatalogCOfuroLabel => 'Banho de imersão';

  @override
  String get diaryCatalogCOfuroPrompt => 'Tomou banho de imersão ou ofurô?';

  @override
  String get diaryCatalogCPistolaLabel => 'Pistola de massagem';

  @override
  String get diaryCatalogCPistolaPrompt => 'Usou pistola de massagem?';

  @override
  String get diaryCatalogCDrenagemLabel => 'Drenagem linfática';

  @override
  String get diaryCatalogCDrenagemPrompt => 'Fez drenagem linfática?';

  @override
  String get diaryCatalogCLuzvermLabel => 'Luz vermelha';

  @override
  String get diaryCatalogCLuzvermPrompt => 'Fez terapia de luz vermelha?';

  @override
  String get diaryCatalogCHiperbLabel => 'Câmara hiperbárica';

  @override
  String get diaryCatalogCHiperbPrompt => 'Fez sessão na câmara hiperbárica?';

  @override
  String get diaryCatalogCAlongnoiteLabel => 'Alongou antes de dormir';

  @override
  String get diaryCatalogCAlongnoitePrompt => 'Alongou antes de dormir?';

  @override
  String get diaryCatalogCPernasLabel => 'Pernas para cima';

  @override
  String get diaryCatalogCPernasPrompt => 'Ficou com as pernas para cima?';

  @override
  String get diaryCatalogCBolinhaLabel => 'Bolinha de liberação';

  @override
  String get diaryCatalogCBolinhaPrompt =>
      'Usou bolinha para soltar o músculo?';

  @override
  String get diaryCatalogCSolLabel => 'Sol da manhã';

  @override
  String get diaryCatalogCSolPrompt => 'Pegou sol pela manhã?';

  @override
  String get diaryCatalogCLuzLabel => 'Luz forte à noite';

  @override
  String get diaryCatalogCLuzPrompt => 'Ficou em luz forte depois das 21h?';

  @override
  String get diaryCatalogCTelaLabel => 'Tela na cama';

  @override
  String get diaryCatalogCTelaPrompt => 'Usou celular ou TV na cama?';

  @override
  String get diaryCatalogCOculosLabel => 'Óculos bloqueador';

  @override
  String get diaryCatalogCOculosPrompt => 'Usou óculos contra luz azul?';

  @override
  String get diaryCatalogCQuartoLabel => 'Quarto escuro';

  @override
  String get diaryCatalogCQuartoPrompt => 'Dormiu em quarto escuro?';

  @override
  String get diaryCatalogCFrescoLabel => 'Quarto fresco';

  @override
  String get diaryCatalogCFrescoPrompt => 'Dormiu em quarto fresco?';

  @override
  String get diaryCatalogCArcondLabel => 'Ar-condicionado';

  @override
  String get diaryCatalogCArcondPrompt => 'Dormiu com ar-condicionado?';

  @override
  String get diaryCatalogCVentilLabel => 'Ventilador';

  @override
  String get diaryCatalogCVentilPrompt => 'Dormiu com ventilador?';

  @override
  String get diaryCatalogCTampaoLabel => 'Tampão ou máscara';

  @override
  String get diaryCatalogCTampaoPrompt => 'Usou tampão de ouvido ou máscara?';

  @override
  String get diaryCatalogCLerCamaLabel => 'Leu antes de dormir';

  @override
  String get diaryCatalogCLerCamaPrompt => 'Leu antes de dormir?';

  @override
  String get diaryCatalogCDividiuLabel => 'Dividiu a cama';

  @override
  String get diaryCatalogCDividiuPrompt => 'Dividiu a cama com alguém?';

  @override
  String get diaryCatalogCRoncoLabel => 'Ronco do parceiro';

  @override
  String get diaryCatalogCRoncoPrompt => 'O ronco de alguém atrapalhou?';

  @override
  String get diaryCatalogCPetcamaLabel => 'Pet na cama';

  @override
  String get diaryCatalogCPetcamaPrompt => 'Dormiu com o pet?';

  @override
  String get diaryCatalogCFilhoLabel => 'Criança acordou';

  @override
  String get diaryCatalogCFilhoPrompt => 'Foi acordado por criança?';

  @override
  String get diaryCatalogCBarulhoLabel => 'Barulho';

  @override
  String get diaryCatalogCBarulhoPrompt => 'Teve barulho à noite?';

  @override
  String get diaryCatalogCCalornoiteLabel => 'Calor à noite';

  @override
  String get diaryCatalogCCalornoitePrompt => 'Passou calor dormindo?';

  @override
  String get diaryCatalogCHorarioLabel => 'Mesmo horário';

  @override
  String get diaryCatalogCHorarioPrompt => 'Deitou no horário de sempre?';

  @override
  String get diaryCatalogCTardouLabel => 'Deitou tarde';

  @override
  String get diaryCatalogCTardouPrompt => 'Deitou depois da meia-noite?';

  @override
  String get diaryCatalogCDespertLabel => 'Despertador';

  @override
  String get diaryCatalogCDespertPrompt => 'Acordou com despertador?';

  @override
  String get diaryCatalogCSonecaLabel => 'Soneca';

  @override
  String get diaryCatalogCSonecaPrompt => 'Apertou soneca no despertador?';

  @override
  String get diaryCatalogCMadrugadaLabel => 'Acordou de madrugada';

  @override
  String get diaryCatalogCMadrugadaPrompt =>
      'Acordou de madrugada e demorou a dormir?';

  @override
  String get diaryCatalogCPesadeloLabel => 'Sonhos agitados';

  @override
  String get diaryCatalogCPesadeloPrompt =>
      'Teve pesadelos ou sonhos agitados?';

  @override
  String get diaryCatalogCBanhonoiteLabel => 'Banho antes de dormir';

  @override
  String get diaryCatalogCBanhonoitePrompt => 'Tomou banho antes de dormir?';

  @override
  String get diaryCatalogCRotinaLabel => 'Rotina de sono';

  @override
  String get diaryCatalogCRotinaPrompt => 'Fez a sua rotina antes de dormir?';

  @override
  String get diaryCatalogCRuidoLabel => 'Ruído branco';

  @override
  String get diaryCatalogCRuidoPrompt => 'Dormiu com ruído branco?';

  @override
  String get diaryCatalogCMusicadormLabel => 'Música para dormir';

  @override
  String get diaryCatalogCMusicadormPrompt => 'Ouviu música para dormir?';

  @override
  String get diaryCatalogCCobertorLabel => 'Cobertor pesado';

  @override
  String get diaryCatalogCCobertorPrompt => 'Usou cobertor pesado?';

  @override
  String get diaryCatalogCFitabocaLabel => 'Fita na boca';

  @override
  String get diaryCatalogCFitabocaPrompt => 'Usou fita na boca para dormir?';

  @override
  String get diaryCatalogCSofaLabel => 'Dormiu no sofá';

  @override
  String get diaryCatalogCSofaPrompt => 'Pegou no sono no sofá?';

  @override
  String get diaryCatalogCCelmadrLabel => 'Celular de madrugada';

  @override
  String get diaryCatalogCCelmadrPrompt => 'Olhou o celular de madrugada?';

  @override
  String get diaryCatalogCBanheiroLabel => 'Levantou para o banheiro';

  @override
  String get diaryCatalogCBanheiroPrompt =>
      'Levantou para ir ao banheiro à noite?';

  @override
  String get diaryCatalogCCochilotardeLabel => 'Cochilo depois das 16h';

  @override
  String get diaryCatalogCCochilotardePrompt => 'Cochilou depois das 16h?';

  @override
  String get diaryCatalogCDorLabel => 'Dor de cabeça';

  @override
  String get diaryCatalogCDorPrompt => 'Sentiu dor de cabeça?';

  @override
  String get diaryCatalogCEnxaquecaLabel => 'Enxaqueca';

  @override
  String get diaryCatalogCEnxaquecaPrompt => 'Teve enxaqueca?';

  @override
  String get diaryCatalogCDoenteLabel => 'Doente';

  @override
  String get diaryCatalogCDoentePrompt => 'Se sentiu doente?';

  @override
  String get diaryCatalogCGripeLabel => 'Gripe ou resfriado';

  @override
  String get diaryCatalogCGripePrompt => 'Teve sintomas de gripe ou resfriado?';

  @override
  String get diaryCatalogCFebreLabel => 'Febre';

  @override
  String get diaryCatalogCFebrePrompt => 'Teve febre?';

  @override
  String get diaryCatalogCGargantaLabel => 'Dor de garganta';

  @override
  String get diaryCatalogCGargantaPrompt => 'Teve dor de garganta?';

  @override
  String get diaryCatalogCTosseLabel => 'Tosse';

  @override
  String get diaryCatalogCTossePrompt => 'Teve tosse?';

  @override
  String get diaryCatalogCCongestLabel => 'Nariz entupido';

  @override
  String get diaryCatalogCCongestPrompt => 'Ficou com o nariz entupido?';

  @override
  String get diaryCatalogCRiniteLabel => 'Rinite ou alergia';

  @override
  String get diaryCatalogCRinitePrompt => 'Teve crise de rinite ou alergia?';

  @override
  String get diaryCatalogCInchacoLabel => 'Inchaço';

  @override
  String get diaryCatalogCInchacoPrompt => 'Se sentiu inchado?';

  @override
  String get diaryCatalogCIntestinoLabel => 'Intestino em dia';

  @override
  String get diaryCatalogCIntestinoPrompt => 'O intestino funcionou bem?';

  @override
  String get diaryCatalogCPresoLabel => 'Intestino preso';

  @override
  String get diaryCatalogCPresoPrompt => 'Ficou com o intestino preso?';

  @override
  String get diaryCatalogCDiarreiaLabel => 'Diarreia';

  @override
  String get diaryCatalogCDiarreiaPrompt => 'Teve diarreia?';

  @override
  String get diaryCatalogCAziaLabel => 'Azia ou refluxo';

  @override
  String get diaryCatalogCAziaPrompt => 'Teve azia ou refluxo?';

  @override
  String get diaryCatalogCNauseaLabel => 'Enjoo';

  @override
  String get diaryCatalogCNauseaPrompt => 'Sentiu enjoo?';

  @override
  String get diaryCatalogCCostasLabel => 'Dor nas costas';

  @override
  String get diaryCatalogCCostasPrompt => 'Sentiu dor nas costas?';

  @override
  String get diaryCatalogCArticulLabel => 'Dor nas articulações';

  @override
  String get diaryCatalogCArticulPrompt => 'Sentiu dor nas articulações?';

  @override
  String get diaryCatalogCLesaoLabel => 'Lesão';

  @override
  String get diaryCatalogCLesaoPrompt => 'Está com alguma lesão?';

  @override
  String get diaryCatalogCDenteLabel => 'Dor de dente';

  @override
  String get diaryCatalogCDentePrompt => 'Teve dor de dente?';

  @override
  String get diaryCatalogCNevoaLabel => 'Mente nublada';

  @override
  String get diaryCatalogCNevoaPrompt => 'Sentiu a mente nublada?';

  @override
  String get diaryCatalogCTonturaLabel => 'Tontura';

  @override
  String get diaryCatalogCTonturaPrompt => 'Sentiu tontura?';

  @override
  String get diaryCatalogCCansacoLabel => 'Cansaço extremo';

  @override
  String get diaryCatalogCCansacoPrompt => 'Sentiu um cansaço fora do normal?';

  @override
  String get diaryCatalogCAcneLabel => 'Pele';

  @override
  String get diaryCatalogCAcnePrompt => 'Teve espinhas ou pele irritada?';

  @override
  String get diaryCatalogCPalpitLabel => 'Palpitação';

  @override
  String get diaryCatalogCPalpitPrompt => 'Sentiu o coração acelerar parado?';

  @override
  String get diaryCatalogCVacinaLabel => 'Vacina';

  @override
  String get diaryCatalogCVacinaPrompt => 'Tomou vacina?';

  @override
  String get diaryCatalogCConsultaLabel => 'Consulta médica';

  @override
  String get diaryCatalogCConsultaPrompt => 'Foi ao médico?';

  @override
  String get diaryCatalogCExameLabel => 'Exame de sangue';

  @override
  String get diaryCatalogCExamePrompt => 'Fez exame de sangue?';

  @override
  String get diaryCatalogCPressaoaltaLabel => 'Pressão alta';

  @override
  String get diaryCatalogCPressaoaltaPrompt => 'Sentiu a pressão alta?';

  @override
  String get diaryCatalogCPressaobaixaLabel => 'Pressão baixa';

  @override
  String get diaryCatalogCPressaobaixaPrompt => 'Sentiu a pressão baixa?';

  @override
  String get diaryCatalogCHipoglicLabel => 'Hipoglicemia';

  @override
  String get diaryCatalogCHipoglicPrompt => 'Teve queda de açúcar no sangue?';

  @override
  String get diaryCatalogCCaibraLabel => 'Cãibra';

  @override
  String get diaryCatalogCCaibraPrompt => 'Teve cãibra?';

  @override
  String get diaryCatalogCOlhosLabel => 'Olhos cansados';

  @override
  String get diaryCatalogCOlhosPrompt => 'Ficou com os olhos cansados?';

  @override
  String get diaryCatalogCOuvidoLabel => 'Dor de ouvido';

  @override
  String get diaryCatalogCOuvidoPrompt => 'Teve dor de ouvido?';

  @override
  String get diaryCatalogCSinusiteLabel => 'Sinusite';

  @override
  String get diaryCatalogCSinusitePrompt => 'Teve crise de sinusite?';

  @override
  String get diaryCatalogCAsmaLabel => 'Crise de asma';

  @override
  String get diaryCatalogCAsmaPrompt => 'Teve crise de asma?';

  @override
  String get diaryCatalogCJoelhoLabel => 'Dor no joelho';

  @override
  String get diaryCatalogCJoelhoPrompt => 'Sentiu dor no joelho?';

  @override
  String get diaryCatalogCOmbroLabel => 'Dor no ombro';

  @override
  String get diaryCatalogCOmbroPrompt => 'Sentiu dor no ombro?';

  @override
  String get diaryCatalogCDentistaLabel => 'Dentista';

  @override
  String get diaryCatalogCDentistaPrompt => 'Foi ao dentista?';

  @override
  String get diaryCatalogCProcedimentoLabel => 'Procedimento ou cirurgia';

  @override
  String get diaryCatalogCProcedimentoPrompt =>
      'Fez algum procedimento médico?';

  @override
  String get diaryCatalogCGasesLabel => 'Gases';

  @override
  String get diaryCatalogCGasesPrompt => 'Teve gases ou estufamento?';

  @override
  String get diaryCatalogCMenstrLabel => 'Menstruação';

  @override
  String get diaryCatalogCMenstrPrompt => 'Está menstruada?';

  @override
  String get diaryCatalogCFluxoLabel => 'Fluxo intenso';

  @override
  String get diaryCatalogCFluxoPrompt => 'O fluxo está intenso?';

  @override
  String get diaryCatalogCColicaLabel => 'Cólica';

  @override
  String get diaryCatalogCColicaPrompt => 'Teve cólica?';

  @override
  String get diaryCatalogCTpmLabel => 'TPM';

  @override
  String get diaryCatalogCTpmPrompt => 'Sentiu sintomas de TPM?';

  @override
  String get diaryCatalogCOvulLabel => 'Ovulação';

  @override
  String get diaryCatalogCOvulPrompt => 'Está ovulando?';

  @override
  String get diaryCatalogCAnticonLabel => 'Anticoncepcional';

  @override
  String get diaryCatalogCAnticonPrompt => 'Tomou anticoncepcional?';

  @override
  String get diaryCatalogCCaloraoLabel => 'Ondas de calor';

  @override
  String get diaryCatalogCCaloraoPrompt => 'Teve ondas de calor?';

  @override
  String get diaryCatalogCSuornoiteLabel => 'Suor noturno';

  @override
  String get diaryCatalogCSuornoitePrompt => 'Suou à noite?';

  @override
  String get diaryCatalogCLibidoLabel => 'Libido';

  @override
  String get diaryCatalogCLibidoPrompt => 'Sentiu a libido alta?';

  @override
  String get diaryCatalogCSeiosLabel => 'Seios sensíveis';

  @override
  String get diaryCatalogCSeiosPrompt => 'Sentiu os seios sensíveis?';

  @override
  String get diaryCatalogCRetencaoLabel => 'Retenção de líquido';

  @override
  String get diaryCatalogCRetencaoPrompt => 'Sentiu retenção de líquido?';

  @override
  String get diaryCatalogCGravidezLabel => 'Gravidez';

  @override
  String get diaryCatalogCGravidezPrompt => 'Está grávida?';

  @override
  String get diaryCatalogCAmamentLabel => 'Amamentação';

  @override
  String get diaryCatalogCAmamentPrompt => 'Está amamentando?';

  @override
  String get diaryCatalogCReposicaoLabel => 'Reposição hormonal';

  @override
  String get diaryCatalogCReposicaoPrompt => 'Fez reposição hormonal?';

  @override
  String get diaryCatalogCTestoLabel => 'Testosterona';

  @override
  String get diaryCatalogCTestoPrompt => 'Aplicou testosterona?';

  @override
  String get diaryCatalogCEscapeLabel => 'Escape';

  @override
  String get diaryCatalogCEscapePrompt => 'Teve escape fora da menstruação?';

  @override
  String get diaryCatalogCAcnehormLabel => 'Acne hormonal';

  @override
  String get diaryCatalogCAcnehormPrompt => 'Teve espinhas do ciclo?';

  @override
  String get diaryCatalogCHumorcicloLabel => 'Humor do ciclo';

  @override
  String get diaryCatalogCHumorcicloPrompt =>
      'Sentiu o humor mudar com o ciclo?';

  @override
  String get diaryCatalogCMenopausaLabel => 'Menopausa';

  @override
  String get diaryCatalogCMenopausaPrompt => 'Sentiu sintomas da menopausa?';

  @override
  String get diaryCatalogCTesteovulLabel => 'Teste de ovulação';

  @override
  String get diaryCatalogCTesteovulPrompt => 'Fez teste de ovulação?';

  @override
  String get diaryCatalogCTentandoLabel => 'Tentando engravidar';

  @override
  String get diaryCatalogCTentandoPrompt => 'Está tentando engravidar?';

  @override
  String get diaryCatalogCPospartoLabel => 'Pós-parto';

  @override
  String get diaryCatalogCPospartoPrompt => 'Está no pós-parto?';

  @override
  String get diaryCatalogCMagLabel => 'Magnésio';

  @override
  String get diaryCatalogCMagPrompt => 'Tomou magnésio?';

  @override
  String get diaryCatalogCWheyLabel => 'Whey';

  @override
  String get diaryCatalogCWheyPrompt => 'Tomou whey?';

  @override
  String get diaryCatalogCVitdLabel => 'Vitamina D';

  @override
  String get diaryCatalogCVitdPrompt => 'Tomou vitamina D?';

  @override
  String get diaryCatalogCOmegaLabel => 'Ômega 3';

  @override
  String get diaryCatalogCOmegaPrompt => 'Tomou ômega 3?';

  @override
  String get diaryCatalogCColagLabel => 'Colágeno';

  @override
  String get diaryCatalogCColagPrompt => 'Tomou colágeno?';

  @override
  String get diaryCatalogCAshwaLabel => 'Ashwagandha';

  @override
  String get diaryCatalogCAshwaPrompt => 'Tomou ashwagandha?';

  @override
  String get diaryCatalogCZincoLabel => 'Zinco';

  @override
  String get diaryCatalogCZincoPrompt => 'Tomou zinco?';

  @override
  String get diaryCatalogCFerroLabel => 'Ferro';

  @override
  String get diaryCatalogCFerroPrompt => 'Tomou ferro?';

  @override
  String get diaryCatalogCB12Label => 'Vitamina B12';

  @override
  String get diaryCatalogCB12Prompt => 'Tomou vitamina B12?';

  @override
  String get diaryCatalogCComplexobLabel => 'Complexo B';

  @override
  String get diaryCatalogCComplexobPrompt => 'Tomou complexo B?';

  @override
  String get diaryCatalogCVitcLabel => 'Vitamina C';

  @override
  String get diaryCatalogCVitcPrompt => 'Tomou vitamina C?';

  @override
  String get diaryCatalogCK2Label => 'Vitamina K2';

  @override
  String get diaryCatalogCK2Prompt => 'Tomou vitamina K2?';

  @override
  String get diaryCatalogCMultiLabel => 'Multivitamínico';

  @override
  String get diaryCatalogCMultiPrompt => 'Tomou multivitamínico?';

  @override
  String get diaryCatalogCProbioLabel => 'Probiótico';

  @override
  String get diaryCatalogCProbioPrompt => 'Tomou probiótico?';

  @override
  String get diaryCatalogCPsylliumLabel => 'Fibras (psyllium)';

  @override
  String get diaryCatalogCPsylliumPrompt => 'Tomou fibra em pó?';

  @override
  String get diaryCatalogCGlicinaLabel => 'Glicina';

  @override
  String get diaryCatalogCGlicinaPrompt => 'Tomou glicina?';

  @override
  String get diaryCatalogCTeaninaLabel => 'L-teanina';

  @override
  String get diaryCatalogCTeaninaPrompt => 'Tomou L-teanina?';

  @override
  String get diaryCatalogCCafcapLabel => 'Cafeína em cápsula';

  @override
  String get diaryCatalogCCafcapPrompt => 'Tomou cafeína em cápsula?';

  @override
  String get diaryCatalogCPretreinoLabel => 'Pré-treino';

  @override
  String get diaryCatalogCPretreinoPrompt => 'Tomou pré-treino?';

  @override
  String get diaryCatalogCBetaLabel => 'Beta-alanina';

  @override
  String get diaryCatalogCBetaPrompt => 'Tomou beta-alanina?';

  @override
  String get diaryCatalogCEletroLabel => 'Eletrólitos';

  @override
  String get diaryCatalogCEletroPrompt => 'Tomou eletrólitos?';

  @override
  String get diaryCatalogCCurcumaLabel => 'Cúrcuma';

  @override
  String get diaryCatalogCCurcumaPrompt => 'Tomou cúrcuma?';

  @override
  String get diaryCatalogCPropolisLabel => 'Própolis';

  @override
  String get diaryCatalogCPropolisPrompt => 'Tomou própolis?';

  @override
  String get diaryCatalogCMacaLabel => 'Maca peruana';

  @override
  String get diaryCatalogCMacaPrompt => 'Tomou maca peruana?';

  @override
  String get diaryCatalogCSpirulLabel => 'Spirulina';

  @override
  String get diaryCatalogCSpirulPrompt => 'Tomou spirulina?';

  @override
  String get diaryCatalogCCogumLabel => 'Cogumelos';

  @override
  String get diaryCatalogCCogumPrompt => 'Tomou cogumelos adaptógenos?';

  @override
  String get diaryCatalogCBiotinaLabel => 'Biotina';

  @override
  String get diaryCatalogCBiotinaPrompt => 'Tomou biotina?';

  @override
  String get diaryCatalogCCalcioLabel => 'Cálcio';

  @override
  String get diaryCatalogCCalcioPrompt => 'Tomou cálcio?';

  @override
  String get diaryCatalogCSelenioLabel => 'Selênio';

  @override
  String get diaryCatalogCSelenioPrompt => 'Tomou selênio?';

  @override
  String get diaryCatalogCCoq10Label => 'Coenzima Q10';

  @override
  String get diaryCatalogCCoq10Prompt => 'Tomou coenzima Q10?';

  @override
  String get diaryCatalogCNacLabel => 'NAC';

  @override
  String get diaryCatalogCNacPrompt => 'Tomou NAC (N-acetilcisteína)?';

  @override
  String get diaryCatalogCCitrulinaLabel => 'Citrulina';

  @override
  String get diaryCatalogCCitrulinaPrompt => 'Tomou citrulina?';

  @override
  String get diaryCatalogCGlutaminaLabel => 'Glutamina';

  @override
  String get diaryCatalogCGlutaminaPrompt => 'Tomou glutamina?';

  @override
  String get diaryCatalogCBcaaLabel => 'BCAA';

  @override
  String get diaryCatalogCBcaaPrompt => 'Tomou BCAA?';

  @override
  String get diaryCatalogCTaurinaLabel => 'Taurina';

  @override
  String get diaryCatalogCTaurinaPrompt => 'Tomou taurina?';

  @override
  String get diaryCatalogCCarnitinaLabel => 'Carnitina';

  @override
  String get diaryCatalogCCarnitinaPrompt => 'Tomou carnitina?';

  @override
  String get diaryCatalogCTriptofanoLabel => 'Triptofano';

  @override
  String get diaryCatalogCTriptofanoPrompt => 'Tomou triptofano?';

  @override
  String get diaryCatalogCGabaLabel => 'GABA';

  @override
  String get diaryCatalogCGabaPrompt => 'Tomou GABA?';

  @override
  String get diaryCatalogCValerianaLabel => 'Valeriana ou passiflora';

  @override
  String get diaryCatalogCValerianaPrompt => 'Tomou valeriana ou passiflora?';

  @override
  String get diaryCatalogCFolicoLabel => 'Ácido fólico';

  @override
  String get diaryCatalogCFolicoPrompt => 'Tomou ácido fólico?';

  @override
  String get diaryCatalogCViteLabel => 'Vitamina E';

  @override
  String get diaryCatalogCVitePrompt => 'Tomou vitamina E?';

  @override
  String get diaryCatalogCResverLabel => 'Resveratrol';

  @override
  String get diaryCatalogCResverPrompt => 'Tomou resveratrol?';

  @override
  String get diaryCatalogCBerberLabel => 'Berberina';

  @override
  String get diaryCatalogCBerberPrompt => 'Tomou berberina?';

  @override
  String get diaryCatalogCInositolLabel => 'Inositol';

  @override
  String get diaryCatalogCInositolPrompt => 'Tomou inositol?';

  @override
  String get diaryCatalogCMelatLabel => 'Melatonina';

  @override
  String get diaryCatalogCMelatPrompt => 'Tomou melatonina?';

  @override
  String get diaryCatalogCRemedLabel => 'Remédio para dormir';

  @override
  String get diaryCatalogCRemedPrompt => 'Tomou remédio para dormir?';

  @override
  String get diaryCatalogCAnalgLabel => 'Analgésico';

  @override
  String get diaryCatalogCAnalgPrompt =>
      'Tomou analgésico (dipirona, paracetamol)?';

  @override
  String get diaryCatalogCAntiinfLabel => 'Anti-inflamatório';

  @override
  String get diaryCatalogCAntiinfPrompt => 'Tomou anti-inflamatório?';

  @override
  String get diaryCatalogCAntialLabel => 'Antialérgico';

  @override
  String get diaryCatalogCAntialPrompt => 'Tomou antialérgico?';

  @override
  String get diaryCatalogCDescongLabel => 'Descongestionante';

  @override
  String get diaryCatalogCDescongPrompt => 'Usou descongestionante nasal?';

  @override
  String get diaryCatalogCAntibLabel => 'Antibiótico';

  @override
  String get diaryCatalogCAntibPrompt => 'Tomou antibiótico?';

  @override
  String get diaryCatalogCCorticLabel => 'Corticoide';

  @override
  String get diaryCatalogCCorticPrompt => 'Tomou corticoide?';

  @override
  String get diaryCatalogCRelaxmuscLabel => 'Relaxante muscular';

  @override
  String get diaryCatalogCRelaxmuscPrompt => 'Tomou relaxante muscular?';

  @override
  String get diaryCatalogCEnjooLabel => 'Remédio para enjoo';

  @override
  String get diaryCatalogCEnjooPrompt => 'Tomou remédio para enjoo?';

  @override
  String get diaryCatalogCAnsiolLabel => 'Ansiolítico';

  @override
  String get diaryCatalogCAnsiolPrompt => 'Tomou ansiolítico?';

  @override
  String get diaryCatalogCAntidepLabel => 'Antidepressivo';

  @override
  String get diaryCatalogCAntidepPrompt => 'Tomou antidepressivo?';

  @override
  String get diaryCatalogCEstimLabel => 'Remédio para TDAH';

  @override
  String get diaryCatalogCEstimPrompt => 'Tomou remédio para TDAH?';

  @override
  String get diaryCatalogCPressaoLabel => 'Remédio de pressão';

  @override
  String get diaryCatalogCPressaoPrompt => 'Tomou remédio de pressão?';

  @override
  String get diaryCatalogCTireoideLabel => 'Tireoide';

  @override
  String get diaryCatalogCTireoidePrompt => 'Tomou remédio de tireoide?';

  @override
  String get diaryCatalogCDiabetesLabel => 'Diabetes';

  @override
  String get diaryCatalogCDiabetesPrompt =>
      'Tomou remédio ou insulina para diabetes?';

  @override
  String get diaryCatalogCGlp1Label => 'Remédio GLP-1';

  @override
  String get diaryCatalogCGlp1Prompt =>
      'Aplicou o remédio injetável para emagrecer ou diabetes (semaglutida, tirzepatida)?';

  @override
  String get diaryCatalogCAnticoncep2Label => 'Hormônio';

  @override
  String get diaryCatalogCAnticoncep2Prompt => 'Tomou algum hormônio?';

  @override
  String get diaryCatalogCIsotretLabel => 'Isotretinoína';

  @override
  String get diaryCatalogCIsotretPrompt =>
      'Tomou isotretinoína (remédio para acne)?';

  @override
  String get diaryCatalogCMinoxLabel => 'Minoxidil';

  @override
  String get diaryCatalogCMinoxPrompt => 'Usou minoxidil?';

  @override
  String get diaryCatalogCFinastLabel => 'Finasterida';

  @override
  String get diaryCatalogCFinastPrompt => 'Tomou finasterida?';

  @override
  String get diaryCatalogCNotempoLabel => 'Remédios no horário';

  @override
  String get diaryCatalogCNotempoPrompt =>
      'Tomou os remédios no horário certo?';

  @override
  String get diaryCatalogCEsqueceuLabel => 'Esqueceu o remédio';

  @override
  String get diaryCatalogCEsqueceuPrompt => 'Esqueceu de tomar algum remédio?';

  @override
  String get diaryCatalogCProtgastLabel => 'Protetor gástrico';

  @override
  String get diaryCatalogCProtgastPrompt =>
      'Tomou omeprazol ou protetor do estômago?';

  @override
  String get diaryCatalogCAntiacidoLabel => 'Antiácido';

  @override
  String get diaryCatalogCAntiacidoPrompt => 'Tomou antiácido?';

  @override
  String get diaryCatalogCLaxanteLabel => 'Laxante';

  @override
  String get diaryCatalogCLaxantePrompt => 'Tomou laxante?';

  @override
  String get diaryCatalogCAntidiarLabel => 'Antidiarreico';

  @override
  String get diaryCatalogCAntidiarPrompt => 'Tomou remédio para diarreia?';

  @override
  String get diaryCatalogCColicaremLabel => 'Remédio para cólica';

  @override
  String get diaryCatalogCColicaremPrompt => 'Tomou remédio para cólica?';

  @override
  String get diaryCatalogCEnxaqremLabel => 'Remédio para enxaqueca';

  @override
  String get diaryCatalogCEnxaqremPrompt => 'Tomou remédio para enxaqueca?';

  @override
  String get diaryCatalogCAntitermicoLabel => 'Antitérmico';

  @override
  String get diaryCatalogCAntitermicoPrompt => 'Tomou remédio para febre?';

  @override
  String get diaryCatalogCXaropeLabel => 'Xarope';

  @override
  String get diaryCatalogCXaropePrompt => 'Tomou xarope para tosse?';

  @override
  String get diaryCatalogCBombinhaLabel => 'Bombinha de asma';

  @override
  String get diaryCatalogCBombinhaPrompt => 'Usou bombinha?';

  @override
  String get diaryCatalogCSpraynasalLabel => 'Spray nasal com corticoide';

  @override
  String get diaryCatalogCSpraynasalPrompt =>
      'Usou spray nasal com corticoide?';

  @override
  String get diaryCatalogCColirioLabel => 'Colírio';

  @override
  String get diaryCatalogCColirioPrompt => 'Usou colírio?';

  @override
  String get diaryCatalogCPomadaLabel => 'Pomada';

  @override
  String get diaryCatalogCPomadaPrompt => 'Usou pomada ou creme de tratamento?';

  @override
  String get diaryCatalogCAntifungLabel => 'Antifúngico';

  @override
  String get diaryCatalogCAntifungPrompt => 'Tomou antifúngico?';

  @override
  String get diaryCatalogCAntiviralLabel => 'Antiviral';

  @override
  String get diaryCatalogCAntiviralPrompt => 'Tomou antiviral?';

  @override
  String get diaryCatalogCEstatinaLabel => 'Remédio de colesterol';

  @override
  String get diaryCatalogCEstatinaPrompt => 'Tomou remédio para colesterol?';

  @override
  String get diaryCatalogCAnticoagLabel => 'Anticoagulante';

  @override
  String get diaryCatalogCAnticoagPrompt => 'Tomou anticoagulante?';

  @override
  String get diaryCatalogCMetformLabel => 'Metformina';

  @override
  String get diaryCatalogCMetformPrompt => 'Tomou metformina?';

  @override
  String get diaryCatalogCAnticonvLabel => 'Anticonvulsivante';

  @override
  String get diaryCatalogCAnticonvPrompt => 'Tomou anticonvulsivante?';

  @override
  String get diaryCatalogCEstabilLabel => 'Estabilizador de humor';

  @override
  String get diaryCatalogCEstabilPrompt => 'Tomou estabilizador de humor?';

  @override
  String get diaryCatalogCInjecaoLabel => 'Vitamina injetável';

  @override
  String get diaryCatalogCInjecaoPrompt => 'Tomou alguma vitamina injetável?';

  @override
  String get diaryCatalogCProtetorLabel => 'Protetor solar';

  @override
  String get diaryCatalogCProtetorPrompt => 'Passou protetor solar?';

  @override
  String get diaryCatalogCSkincareLabel => 'Skincare';

  @override
  String get diaryCatalogCSkincarePrompt =>
      'Fez a rotina de cuidados com a pele?';

  @override
  String get diaryCatalogCHidratLabel => 'Hidratou a pele';

  @override
  String get diaryCatalogCHidratPrompt => 'Passou hidratante?';

  @override
  String get diaryCatalogCFiodentalLabel => 'Fio dental';

  @override
  String get diaryCatalogCFiodentalPrompt => 'Passou fio dental?';

  @override
  String get diaryCatalogCPausaLabel => 'Pausas no trabalho';

  @override
  String get diaryCatalogCPausaPrompt => 'Fez pausas durante o trabalho?';

  @override
  String get diaryCatalogCPostura2Label => 'Ergonomia';

  @override
  String get diaryCatalogCPostura2Prompt =>
      'Trabalhou numa posição confortável?';

  @override
  String get diaryCatalogCCelnoiteLabel => 'Modo noturno';

  @override
  String get diaryCatalogCCelnoitePrompt => 'Deixou o celular no modo noturno?';

  @override
  String get diaryCatalogCOrganizouLabel => 'Organizou o dia';

  @override
  String get diaryCatalogCOrganizouPrompt => 'Planejou o dia com antecedência?';

  @override
  String get diaryCatalogCNatureza2Label => 'Contato com a natureza';

  @override
  String get diaryCatalogCNatureza2Prompt =>
      'Pisou na grama ou tocou a natureza?';

  @override
  String get diaryCatalogCR130Label => 'Levantou a cada hora';

  @override
  String get diaryCatalogCR130Prompt => 'Levantou da cadeira a cada hora?';

  @override
  String get diaryCatalogCR131Label => 'Escada em vez do elevador';

  @override
  String get diaryCatalogCR131Prompt => 'Usou a escada em vez do elevador?';

  @override
  String get diaryCatalogCR132Label => 'Pausa ativa no trabalho';

  @override
  String get diaryCatalogCR132Prompt => 'Fez pausas para se mexer no trabalho?';

  @override
  String get diaryCatalogCR133Label => 'Carregou peso no dia a dia';

  @override
  String get diaryCatalogCR133Prompt =>
      'Carregou peso (compras, criança no colo)?';

  @override
  String get diaryCatalogCR134Label => 'Brincou com as crianças';

  @override
  String get diaryCatalogCR134Prompt => 'Brincou ativamente com as crianças?';

  @override
  String get diaryCatalogCR136Label => 'Pegou o celular ao acordar';

  @override
  String get diaryCatalogCR136Prompt => 'Pegou o celular logo ao acordar?';

  @override
  String get diaryCatalogCR137Label => 'Celular nas refeições';

  @override
  String get diaryCatalogCR137Prompt => 'Usou o celular durante as refeições?';

  @override
  String get diaryCatalogCR138Label => 'WhatsApp do trabalho fora do horário';

  @override
  String get diaryCatalogCR138Prompt => 'Respondeu trabalho fora do horário?';

  @override
  String get diaryCatalogCR139Label => 'Vídeos curtos';

  @override
  String get diaryCatalogCR139Prompt =>
      'Ficou rolando vídeos curtos (Reels, TikTok)?';

  @override
  String get diaryCatalogCR1310Label => 'Jogos no celular';

  @override
  String get diaryCatalogCR1310Prompt => 'Jogou no celular?';

  @override
  String get diaryCatalogCR1311Label => 'Apostas online';

  @override
  String get diaryCatalogCR1311Prompt => 'Fez apostas online?';

  @override
  String get diaryCatalogCR1312Label => 'Pausa para os olhos';

  @override
  String get diaryCatalogCR1312Prompt => 'Fez pausas para descansar os olhos?';

  @override
  String get diaryCatalogCR1313Label => 'Modo foco';

  @override
  String get diaryCatalogCR1313Prompt => 'Usou o modo foco?';

  @override
  String get diaryCatalogCR1314Label => 'Notificações desligadas';

  @override
  String get diaryCatalogCR1314Prompt => 'Desligou as notificações?';

  @override
  String get diaryCatalogCR1315Label => 'Trabalho sem interrupção';

  @override
  String get diaryCatalogCR1315Prompt =>
      'Teve um bloco de trabalho sem interrupção?';

  @override
  String get diaryCatalogCR1316Label => 'Celular fora do quarto';

  @override
  String get diaryCatalogCR1316Prompt => 'Deixou o celular fora do quarto?';

  @override
  String get diaryCatalogCR1317Label => 'Escovou os dentes 3 vezes';

  @override
  String get diaryCatalogCR1317Prompt => 'Escovou os dentes 3 vezes?';

  @override
  String get diaryCatalogCR1318Label => 'Tirou a maquiagem';

  @override
  String get diaryCatalogCR1318Prompt => 'Tirou a maquiagem antes de dormir?';

  @override
  String get diaryCatalogCR1319Label => 'Cuidou do cabelo';

  @override
  String get diaryCatalogCR1319Prompt => 'Fez hidratação ou cuidado no cabelo?';

  @override
  String get diaryCatalogCR1320Label => 'Unhas';

  @override
  String get diaryCatalogCR1320Prompt => 'Fez as unhas?';

  @override
  String get diaryCatalogCR1321Label => 'Barba';

  @override
  String get diaryCatalogCR1321Prompt => 'Fez a barba?';

  @override
  String get diaryCatalogCR1322Label => 'Repelente';

  @override
  String get diaryCatalogCR1322Prompt => 'Passou repelente?';

  @override
  String get diaryCatalogCR1323Label => 'Hidratou os lábios';

  @override
  String get diaryCatalogCR1323Prompt => 'Hidratou os lábios?';

  @override
  String get diaryCatalogCR1324Label => 'Tempo para si';

  @override
  String get diaryCatalogCR1324Prompt => 'Teve um tempo só para você?';

  @override
  String get diaryCatalogCR1325Label => 'Dipirona';

  @override
  String get diaryCatalogCR1325Prompt => 'Tomou dipirona?';

  @override
  String get diaryCatalogCR1326Label => 'Paracetamol';

  @override
  String get diaryCatalogCR1326Prompt => 'Tomou paracetamol?';

  @override
  String get diaryCatalogCR1327Label => 'Ibuprofeno';

  @override
  String get diaryCatalogCR1327Prompt => 'Tomou ibuprofeno?';

  @override
  String get diaryCatalogCR1328Label => 'Nimesulida';

  @override
  String get diaryCatalogCR1328Prompt => 'Tomou nimesulida?';

  @override
  String get diaryCatalogCR1329Label => 'Relaxante com analgésico';

  @override
  String get diaryCatalogCR1329Prompt =>
      'Tomou relaxante muscular com analgésico?';

  @override
  String get diaryCatalogCR1330Label => 'Omeprazol';

  @override
  String get diaryCatalogCR1330Prompt => 'Tomou omeprazol?';

  @override
  String get diaryCatalogCR1331Label => 'Remédio para gases';

  @override
  String get diaryCatalogCR1331Prompt => 'Tomou remédio para gases?';

  @override
  String get diaryCatalogCR1332Label => 'Losartana';

  @override
  String get diaryCatalogCR1332Prompt => 'Tomou losartana?';

  @override
  String get diaryCatalogCR1333Label => 'Levotiroxina';

  @override
  String get diaryCatalogCR1333Prompt => 'Tomou levotiroxina?';

  @override
  String get diaryCatalogCR1334Label => 'Sertralina ou escitalopram';

  @override
  String get diaryCatalogCR1334Prompt => 'Tomou o antidepressivo?';

  @override
  String get diaryCatalogCR1335Label => 'Clonazepam';

  @override
  String get diaryCatalogCR1335Prompt => 'Tomou clonazepam?';

  @override
  String get diaryCatalogCR1336Label => 'Zolpidem';

  @override
  String get diaryCatalogCR1336Prompt => 'Tomou zolpidem?';

  @override
  String get diaryCatalogCR1337Label => 'Loratadina';

  @override
  String get diaryCatalogCR1337Prompt => 'Tomou loratadina?';

  @override
  String get diaryCatalogCR1338Label => 'Insulina';

  @override
  String get diaryCatalogCR1338Prompt => 'Aplicou insulina?';

  @override
  String get diaryCatalogCR1339Label => 'Sildenafila ou tadalafila';

  @override
  String get diaryCatalogCR1339Prompt => 'Tomou sildenafila ou tadalafila?';

  @override
  String get diaryCatalogCR1340Label => 'Lavagem nasal com soro';

  @override
  String get diaryCatalogCR1340Prompt => 'Fez lavagem nasal com soro?';

  @override
  String get diaryCatalogCR1341Label => 'Remédio para infecção urinária';

  @override
  String get diaryCatalogCR1341Prompt =>
      'Tomou remédio para infecção urinária?';

  @override
  String get diaryCatalogCR1342Label => 'Termogênico';

  @override
  String get diaryCatalogCR1342Prompt => 'Tomou termogênico?';

  @override
  String get diaryCatalogCR1343Label => 'Hipercalórico';

  @override
  String get diaryCatalogCR1343Prompt => 'Tomou hipercalórico?';

  @override
  String get diaryCatalogCR1344Label => 'Picolinato de cromo';

  @override
  String get diaryCatalogCR1344Prompt => 'Tomou picolinato de cromo?';

  @override
  String get diaryCatalogCR1345Label => 'Óleo de prímula';

  @override
  String get diaryCatalogCR1345Prompt => 'Tomou óleo de prímula?';

  @override
  String get diaryCatalogCR1346Label => 'Levedo de cerveja';

  @override
  String get diaryCatalogCR1346Prompt => 'Tomou levedo de cerveja?';

  @override
  String get diaryCatalogCR1347Label => 'Vinagre de maçã em cápsula';

  @override
  String get diaryCatalogCR1347Prompt => 'Tomou vinagre de maçã em cápsula?';

  @override
  String get diaryCatalogCR1348Label => 'Cranberry';

  @override
  String get diaryCatalogCR1348Prompt => 'Tomou cranberry?';

  @override
  String get diaryCatalogCR1349Label => 'Polivitamínico infantil';

  @override
  String get diaryCatalogCR1349Prompt => 'Deu polivitamínico para a criança?';

  @override
  String get diaryCatalogCR1350Label => 'DIU';

  @override
  String get diaryCatalogCR1350Prompt => 'Usa DIU?';

  @override
  String get diaryCatalogCR1351Label => 'Implante contraceptivo';

  @override
  String get diaryCatalogCR1351Prompt => 'Usa implante contraceptivo?';

  @override
  String get diaryCatalogCR1352Label => 'Injeção anticoncepcional';

  @override
  String get diaryCatalogCR1352Prompt => 'Tomou a injeção anticoncepcional?';

  @override
  String get diaryCatalogCR1353Label => 'Pílula do dia seguinte';

  @override
  String get diaryCatalogCR1353Prompt => 'Tomou a pílula do dia seguinte?';

  @override
  String get diaryCatalogCR1354Label => 'Esqueceu a pílula';

  @override
  String get diaryCatalogCR1354Prompt => 'Esqueceu o anticoncepcional?';

  @override
  String get diaryCatalogCR1355Label => 'Endometriose';

  @override
  String get diaryCatalogCR1355Prompt => 'Sentiu dor de endometriose?';

  @override
  String get diaryCatalogCR1356Label => 'Ovário policístico (SOP)';

  @override
  String get diaryCatalogCR1356Prompt => 'Sintomas de ovário policístico?';

  @override
  String get diaryCatalogCR1357Label => 'Candidíase';

  @override
  String get diaryCatalogCR1357Prompt => 'Teve candidíase?';

  @override
  String get diaryCatalogCR1358Label => 'Infecção urinária';

  @override
  String get diaryCatalogCR1358Prompt => 'Teve infecção urinária?';

  @override
  String get diaryCatalogCR1359Label => 'Secura vaginal';

  @override
  String get diaryCatalogCR1359Prompt => 'Sentiu secura vaginal?';

  @override
  String get diaryCatalogCR1360Label => 'Queda de cabelo';

  @override
  String get diaryCatalogCR1360Prompt => 'Notou queda de cabelo?';

  @override
  String get diaryCatalogCR1361Label => 'Disfunção erétil';

  @override
  String get diaryCatalogCR1361Prompt => 'Teve dificuldade de ereção?';

  @override
  String get diaryCatalogCWDesafioLabel => 'Encarou como desafio';

  @override
  String get diaryCatalogCWDesafioPrompt =>
      'Encarou a pressão do dia como um desafio?';

  @override
  String get diaryCatalogCWAmeacaLabel => 'Encarou como ameaça';

  @override
  String get diaryCatalogCWAmeacaPrompt =>
      'Sentiu a pressão do dia como uma ameaça?';

  @override
  String get diaryCatalogCWControleLabel => 'No controle';

  @override
  String get diaryCatalogCWControlePrompt =>
      'Sentiu que estava no controle do seu dia?';

  @override
  String get diaryCatalogCWEficaciaLabel => 'Confiança em si';

  @override
  String get diaryCatalogCWEficaciaPrompt =>
      'Se sentiu capaz de dar conta do que precisava?';

  @override
  String get diaryCatalogCWFluxoLabel => 'Estado de fluxo';

  @override
  String get diaryCatalogCWFluxoPrompt =>
      'Ficou imerso em algo sem ver o tempo passar?';

  @override
  String get diaryCatalogCWConcentraLabel => 'Dificuldade de concentração';

  @override
  String get diaryCatalogCWConcentraPrompt =>
      'Teve dificuldade para se concentrar?';

  @override
  String get diaryCatalogCWProgressoLabel => 'Avançou em algo importante';

  @override
  String get diaryCatalogCWProgressoPrompt =>
      'Fez progresso em algo que importa para você?';

  @override
  String get diaryCatalogCWRealizacaoLabel => 'Sensação de realização';

  @override
  String get diaryCatalogCWRealizacaoPrompt =>
      'Terminou o dia com sensação de dever cumprido?';

  @override
  String get diaryCatalogCWPropositoLabel => 'Senso de propósito';

  @override
  String get diaryCatalogCWPropositoPrompt =>
      'Sentiu que o seu dia teve um propósito?';

  @override
  String get diaryCatalogCWOtimismoLabel => 'Otimismo';

  @override
  String get diaryCatalogCWOtimismoPrompt => 'Se sentiu otimista e positivo?';

  @override
  String get diaryCatalogCWDepressaoLabel => 'Sintomas de depressão';

  @override
  String get diaryCatalogCWDepressaoPrompt =>
      'Teve sintomas de depressão, como vazio ou falta de prazer nas coisas?';

  @override
  String get diaryCatalogCWRelacaoLabel => 'Relacionamento';

  @override
  String get diaryCatalogCWRelacaoPrompt =>
      'Teve um bom momento com quem você ama?';

  @override
  String get diaryCatalogCWEsgotadoLabel => 'Socialmente esgotado';

  @override
  String get diaryCatalogCWEsgotadoPrompt =>
      'Se sentiu cansado de tanta gente e conversa?';

  @override
  String get diaryCatalogCWIsoladoLabel => 'Isolamento';

  @override
  String get diaryCatalogCWIsoladoPrompt =>
      'Passou o dia sem contato com outras pessoas?';

  @override
  String get diaryUiCouldNotHearYouYouCanTypeBelow =>
      'Não foi possível ouvir. Você pode escrever abaixo.';

  @override
  String get diaryUiSpeechIsUnavailableOrPermissionWasDeniedYouCanType =>
      'A fala não está disponível ou a permissão foi negada. Você pode escrever.';

  @override
  String get diaryUiCouldNotStartSpeechYouCanType =>
      'Não foi possível iniciar a fala. Você pode escrever.';

  @override
  String get diaryUiCouldNotInterpretThisTryAgainYourTextIsStillHere =>
      'Não foi possível interpretar. Tente novamente. Seu texto está salvo aqui.';

  @override
  String get diaryUiRecordWithAI => 'Registrar com a IA';

  @override
  String get diaryUiTellUsAboutYourDay => 'Conte como foi o seu dia.';

  @override
  String get diaryUiReviewBeforeAdding => 'Confira antes de adicionar.';

  @override
  String
  get diaryUiAICanMakeMistakesReviewTheEntriesAndRemoveAnythingThatDidNotHappen =>
      'A IA pode errar. Revise os registros e remova o que não aconteceu.';

  @override
  String get diaryUiIHad2CoffeesAndWalkedFor20Minutes =>
      'Tomei 2 cafés e caminhei por 20 minutos…';

  @override
  String get diaryUiStopListening => 'Parar de ouvir';

  @override
  String get diaryUiSpeak => 'Falar';

  @override
  String get diaryUiNoEntriesIdentifiedTryDescribingItDifferently =>
      'Nenhum registro identificado. Tente descrever de outra forma.';

  @override
  String get diaryUiRemove => 'Remover';

  @override
  String get diaryUiReviewEntries => 'Revisar registros';

  @override
  String get diaryUiAddToDay => 'Adicionar ao dia';

  @override
  String get diaryUiCouldNotSaveTryAgain =>
      'Não foi possível salvar. Tente novamente.';

  @override
  String get diaryUiWhatToTrack => 'O que acompanhar';

  @override
  String get diaryUiRetry => 'Tentar novamente';

  @override
  String get diaryUiAll => 'Todos';

  @override
  String get diaryUiCreateYourHabit => 'Criar o seu hábito';

  @override
  String get diaryUiSave => 'Salvar';

  @override
  String get diaryUiCouldNotCreateThisHabitTryAgain =>
      'Não foi possível criar o hábito. Tente novamente.';

  @override
  String get diaryUiWhatWouldYouLikeToTrack => 'O que você quer acompanhar?';

  @override
  String get diaryUiHabitName => 'Nome do hábito';

  @override
  String get diaryUiResponseType => 'Como responder';

  @override
  String get diaryUiYesOrNo => 'Sim ou não';

  @override
  String get diaryUiQuantity => 'Quantidade';

  @override
  String get diaryUiUnitMlMinTimes => 'Unidade (ml, min, vezes…)';

  @override
  String get diaryUiCreateHabit => 'Criar hábito';

  @override
  String get diaryUiYourChapters => 'Seus capítulos';

  @override
  String get diaryUiYourChaptersWillAppearAsYouRecordYourDays =>
      'Seus capítulos vão aparecer conforme você registra seus dias.';

  @override
  String get diaryUiChapter => 'Capítulo';

  @override
  String get diaryUiByTheNumbers => 'Em números';

  @override
  String get diaryUiRecordedDays => 'Dias registrados';

  @override
  String get diaryUiMoments => 'Momentos';

  @override
  String get diaryUiAchievements => 'Conquistas';

  @override
  String get diaryUiCouldNotAttachThePhotoUseAJPGPNGUpTo2MB =>
      'Não foi possível adicionar a foto. Use uma imagem JPG/PNG de até 2 MB.';

  @override
  String get diaryUiEnterAName => 'Informe o nome.';

  @override
  String get diaryUiCheckTheNutritionValues =>
      'Confira os valores nutricionais.';

  @override
  String get diaryUiDeleteEntry => 'Excluir registro';

  @override
  String get diaryUiWhatDidYouEat => 'O que você comeu?';

  @override
  String get diaryUiFindAMeal => 'Buscar refeição';

  @override
  String get diaryUiFoodsAndAmounts => 'Alimentos e quantidades';

  @override
  String get diaryUiNutrition => 'Informações nutricionais';

  @override
  String
  get diaryUiValuesEnteredByYouOrFromTheSelectedMealAdjustForYourPortion =>
      'Valores informados por você ou pela refeição escolhida. Ajuste conforme a porção.';

  @override
  String get diaryUiProteinG => 'Proteína (g)';

  @override
  String get diaryUiCarbsG => 'Carboidratos (g)';

  @override
  String get diaryUiFatG => 'Gordura (g)';

  @override
  String get diaryUiRemovePhoto => 'Remover foto';

  @override
  String get diaryUiTakeAPhoto => 'Tirar foto';

  @override
  String get diaryUiGallery => 'Galeria';

  @override
  String get diaryUiEntry => 'Registro';

  @override
  String get diaryUiDetails => 'Detalhes';

  @override
  String get diaryUiTime => 'Horário';

  @override
  String get diaryUiDone => 'Concluir';

  @override
  String get diaryUiSearchFoods => 'Buscar alimentos';

  @override
  String get diaryUiYourAccountChangedReopenTheDiary =>
      'Sua conta mudou. Abra o Diário novamente.';

  @override
  String get diaryUiDaySaved => 'Dia salvo';

  @override
  String get diaryUiTimeline => 'Linha do tempo';

  @override
  String get diaryUiDiary => 'Diário';

  @override
  String get diaryUiWhatHappenedToday => 'O que aconteceu hoje?';

  @override
  String get diaryUiWhatHappenedYesterday => 'O que aconteceu ontem?';

  @override
  String get diaryUiToday => 'Hoje';

  @override
  String get diaryUiYesterday => 'Ontem';

  @override
  String get diaryUiMoments2 => 'momentos';

  @override
  String get diaryUiYourDayBeginsWithAnEntry =>
      'Seu dia começa com um registro.';

  @override
  String get diaryUiNotes => 'Notas';

  @override
  String get diaryUiYouCanEditThePast7Days =>
      'Você pode editar os últimos 7 dias.';

  @override
  String get diaryUiCouldNotSavePleaseTryAgain =>
      'Não foi possível salvar. Tente novamente.';

  @override
  String get diaryUiYourDiary => 'Seu Diário';

  @override
  String get diaryUiThisDayIsReadOnly => 'Este dia está fechado para edição.';

  @override
  String get diaryUiThisDayChangedElsewhereCloseAndRefreshBeforeSaving =>
      'Este dia foi alterado em outro lugar. Feche e atualize antes de salvar.';

  @override
  String get diaryUiCouldNotSaveYourDraftIsStillHere =>
      'Não foi possível salvar. Seu rascunho continua aqui.';

  @override
  String get diaryUiYourHabits => 'Seus hábitos';

  @override
  String get diaryUiOf => 'de';

  @override
  String get diaryUiAddHabit => 'Adicionar hábito';

  @override
  String get diaryUiHowWasYourDay => 'Como foi o dia';

  @override
  String get diaryUiHowWasYourDay2 => 'Como foi o seu dia';

  @override
  String get diaryUiMoodEnergyStressAndASentence =>
      'Humor, disposição, estresse e uma frase';

  @override
  String get diaryUiThisDayIsClosedYouCanEditUpTo7DaysLater =>
      'Este dia já fechou. Dá para mudar só até 7 dias depois.';

  @override
  String get diaryUiRecord => 'Registrar';

  @override
  String get diaryUiCouldNotSaveYourChangesAreKeptHereRetryOrDiscardToLeave =>
      'Não foi possível salvar. Suas alterações continuam aqui. Tente novamente ou descarte para sair.';

  @override
  String get diaryUiDiscard => 'Descartar';

  @override
  String get diaryUiNo => 'Não';

  @override
  String get diaryUiYes => 'Sim';

  @override
  String get diaryUiAnswer => 'Responder';

  @override
  String get diaryUiASentenceAboutYourDay => 'Uma frase sobre o dia';

  @override
  String get diaryUiOnlyYouCanSeeThisHowWasYourDay =>
      'Só você vê. Como foi seu dia?';

  @override
  String get diaryUiTellUsAboutYourDayReviewBeforeSaving =>
      'Conte como foi. Ela marca tudo aqui para você.';

  @override
  String get diaryUiWrite => 'Escrever';

  @override
  String get diaryUiDidNotHappen => 'Não aconteceu';

  @override
  String get diaryValueRecorded => 'Feito';

  @override
  String get diaryValueDidNotHappen => 'Não aconteceu';

  @override
  String get diaryValueTimes => 'vezes';

  @override
  String get diaryValueCups => 'xícaras';

  @override
  String get diaryValueMeals => 'refeições';

  @override
  String get diaryValueOutOfTen => 'de 10';

  @override
  String get diaryPortionLight => 'Leve';

  @override
  String get diaryPortionNormal => 'Normal';

  @override
  String get diaryPortionHeavy => 'Pesado';

  @override
  String get diaryLoadFailed =>
      'Não foi possível carregar o Diário. Tente novamente.';

  @override
  String get diaryFatAbbreviation => 'G';

  @override
  String diaryDateRange(String start, String end) {
    return '$start a $end';
  }

  @override
  String diaryCatalogSearch(int count) {
    return 'Buscar entre $count';
  }

  @override
  String diaryChooseCount(int count) {
    return 'Escolha entre $count';
  }

  @override
  String get diaryGroupFood => 'Alimentação';

  @override
  String get diaryGroupSelfCare => 'Autocuidado';

  @override
  String get diaryGroupDrinks => 'Bebidas';

  @override
  String get diaryGroupMentalWellBeing => 'Bem-estar mental';

  @override
  String get diaryGroupSubstancesAndMedication => 'Drogas e medicação';

  @override
  String get diaryGroupMovement => 'Movimento';

  @override
  String get diaryGroupRecovery => 'Recuperação';

  @override
  String get diaryGroupMeals => 'Refeições';

  @override
  String get diaryGroupRoutineAndLeisure => 'Rotina e lazer';

  @override
  String get diaryGroupHealth => 'Saúde';

  @override
  String get diaryGroupHealthAndSymptoms => 'Saúde e sintomas';

  @override
  String get diaryGroupHormonalHealth => 'Saúde hormonal';

  @override
  String get diaryGroupSleepAndRhythm => 'Sono e ritmo';

  @override
  String get diaryGroupSupplements => 'Suplementos';

  @override
  String get diaryGroupScreensAndFocus => 'Telas e foco';

  @override
  String get diaryGroupYourHabits => 'Seus hábitos';

  @override
  String get diaryScaleAcordou0 => 'Muito cansado';

  @override
  String get diaryScaleAcordou1 => 'Cansado';

  @override
  String get diaryScaleAcordou2 => 'Ok';

  @override
  String get diaryScaleAcordou3 => 'Bem';

  @override
  String get diaryScaleAcordou4 => 'Ótimo';

  @override
  String get diaryScaleHumor0 => 'Muito mal';

  @override
  String get diaryScaleHumor1 => 'Mal';

  @override
  String get diaryScaleHumor2 => 'Neutro';

  @override
  String get diaryScaleHumor3 => 'Bem';

  @override
  String get diaryScaleHumor4 => 'Muito bem';

  @override
  String get diaryScaleEnergia0 => 'Sem energia';

  @override
  String get diaryScaleEnergia1 => 'Baixa';

  @override
  String get diaryScaleEnergia2 => 'Ok';

  @override
  String get diaryScaleEnergia3 => 'Boa';

  @override
  String get diaryScaleEnergia4 => 'Muita';

  @override
  String get diaryScaleEstresse0 => 'Muito alto';

  @override
  String get diaryScaleEstresse1 => 'Alto';

  @override
  String get diaryScaleEstresse2 => 'Médio';

  @override
  String get diaryScaleEstresse3 => 'Pouco';

  @override
  String get diaryScaleEstresse4 => 'Nenhum';

  @override
  String get diaryReferenceLettuce => 'Alface';

  @override
  String get diaryReferenceRice => 'Arroz';

  @override
  String get diaryReferenceWhiteRice => 'Arroz branco';

  @override
  String get diaryReferenceFries => 'Batata frita';

  @override
  String get diaryReferenceShoestringPotatoes => 'Batata palha';

  @override
  String get diaryReferenceSweetPotato => 'Batata-doce';

  @override
  String get diaryReferenceSteakWithOnions => 'Bife acebolado';

  @override
  String get diaryReferenceCarrotCakeWithFrosting =>
      'Bolo de cenoura com cobertura';

  @override
  String get diaryReferenceBroccoli => 'Brócolis';

  @override
  String get diaryReferenceCoffee => 'Café';

  @override
  String get diaryReferenceCoffeeWithMilk => 'Café com leite';

  @override
  String get diaryReferenceUnsweetenedCoffee => 'Café sem açúcar';

  @override
  String get diaryReferenceSautedCollardGreens => 'Couve refogada';

  @override
  String get diaryReferenceCouscousWithButter => 'Cuscuz com manteiga';

  @override
  String get diaryReferenceToastedCassavaFlour => 'Farofa';

  @override
  String get diaryReferenceBeans => 'Feijão';

  @override
  String get diaryReferenceBlackBeans => 'Feijão preto';

  @override
  String get diaryReferenceGrilledChicken => 'Frango grelhado';

  @override
  String get diaryReferenceBerries => 'Frutas vermelhas';

  @override
  String get diaryReferenceGinger => 'Gengibre';

  @override
  String get diaryReferenceBurger => 'Hambúrguer';

  @override
  String get diaryReferencePlainYogurt => 'Iogurte natural';

  @override
  String get diaryReferenceOrange => 'Laranja';

  @override
  String get diaryReferenceVegetables => 'Legumes';

  @override
  String get diaryReferenceLemon => 'Limão';

  @override
  String get diaryReferencePasta => 'Macarrão';

  @override
  String get diaryReferencePapaya => 'Mamão';

  @override
  String get diaryReferenceApple => 'Maçã';

  @override
  String get diaryReferenceSauce => 'Molho';

  @override
  String get diaryReferenceMeatSauce => 'Molho de carne';

  @override
  String get diaryReferenceStrawberry => 'Morango';

  @override
  String get diaryReferenceOmelet => 'Omelete';

  @override
  String get diaryReferenceBoiledEgg => 'Ovo cozido';

  @override
  String get diaryReferenceFriedEgg => 'Ovo frito';

  @override
  String get diaryReferenceScrambledEggs => 'Ovos mexidos';

  @override
  String get diaryReferenceCucumber => 'Pepino';

  @override
  String get diaryReferenceCalabreseSausagePizza => 'Pizza de calabresa';

  @override
  String get diaryReferenceBrazilianCheeseBread => 'Pão de queijo';

  @override
  String get diaryReferenceBreadRollWithButter => 'Pão francês com manteiga';

  @override
  String get diaryReferenceWholeWheatBread => 'Pão integral';

  @override
  String get diaryReferenceFreshWhiteCheese => 'Queijo branco';

  @override
  String get diaryReferenceCoalhoCheese => 'Queijo coalho';

  @override
  String get diaryReferenceGratedCheese => 'Queijo ralado';

  @override
  String get diaryReferenceTomatoSalad => 'Salada com tomate';

  @override
  String get diaryReferenceGreenSalad => 'Salada verde';

  @override
  String get diaryReferenceGrilledSalmon => 'Salmão grelhado';

  @override
  String get diaryReferenceFreshSandwich => 'Sanduíche natural';

  @override
  String get diaryReferenceSoySauce => 'Shoyu';

  @override
  String get diaryReferencePumpkinSoup => 'Sopa de abóbora';

  @override
  String get diaryReferenceBeefStroganoff => 'Strogonoff de carne';

  @override
  String get diaryReferenceJuice => 'Suco';

  @override
  String get diaryReferenceAssortedSushi => 'Sushi variado';

  @override
  String get diaryReferenceTapiocaWithEgg => 'Tapioca com ovo';

  @override
  String get diaryReferenceToast => 'Torrada';

  @override
  String get diaryReferenceGrapes => 'Uvas';

  @override
  String get diaryReference1Spoonful => '1 colher';

  @override
  String get diaryReference1Slice => '1 fatia';

  @override
  String get diaryReference1Egg => '1 ovo';

  @override
  String get diaryReference1Piece => '1 unidade';

  @override
  String get diaryReference1Cup => '1 xícara';

  @override
  String get diaryReference10Pieces => '10 peças';

  @override
  String get diaryReference2Slices => '2 fatias';

  @override
  String get diaryReference2Eggs => '2 ovos';

  @override
  String get diaryReference2Pieces => '2 unidades';

  @override
  String get diaryReference3Slices => '3 fatias';

  @override
  String get diaryReference3Eggs => '3 ovos';

  @override
  String get diaryReference3Pieces => '3 unidades';

  @override
  String get diaryReference4Segments => '4 gomos';

  @override
  String get diaryReference4Pieces => '4 unidades';

  @override
  String get diaryReferenceTheBeginning => 'O começo';

  @override
  String
  get diaryReferenceTheBandLearnsWhoYouAreOver11DaysHrvRangedFrom54To66MsThatIsWhereYourBaselineBegins =>
      'A pulseira aprende quem você é. Em 11 dias a VFC ficou entre 54 e 66 ms. É daí que nasce o seu normal.';

  @override
  String get diaryReferenceSep11ToSep2111Days => '11 set a 21 set · 11 dias';

  @override
  String get diaryReferenceAverageHrv => 'VFC média';

  @override
  String get diaryReferenceWorkouts => 'Treinos';

  @override
  String get diaryReferenceSleep => 'Sono';

  @override
  String get diaryReferenceYouSleepBetterAround11Pm =>
      'Você dorme melhor perto das 23h';

  @override
  String get diaryReferenceSep18ByndLearned => '18 set · A BYND aprendeu';

  @override
  String get diaryReferenceDay1StartedWithTheBand =>
      'Dia 1: começou com a pulseira';

  @override
  String get diaryReferenceSep11Milestone => '11 set · Marco';

  @override
  String get diaryReferenceTheCold => 'O resfriado';

  @override
  String
  get diaryReferenceYourBodyGaveAWarningTwoDaysEarlierBreathingRoseOnTheNightsOfSep23And24YourThroatOnlyF =>
      'O corpo avisou dois dias antes. A respiração subiu nas noites de 23 e 24/09; a garganta só arranhou em 25/09. Cinco dias sem treino.';

  @override
  String get diaryReferenceSep22ToSep298Days => '22 set a 29 set · 8 dias';

  @override
  String get diaryReferenceBreathing => 'Respiração';

  @override
  String get diaryReference164Rpm => '16,4rpm';

  @override
  String get diaryReferenceRecovery => 'Recuperação';

  @override
  String get diaryReferenceNoTraining => 'Sem treino';

  @override
  String get diaryReference5Days => '5dias';

  @override
  String get diaryReferenceBestNight => 'Melhor noite';

  @override
  String get diaryReferenceSep28 => '28 set';

  @override
  String get diaryReferenceColdSpotted2DaysEarlier =>
      'Resfriado, visto 2 dias antes';

  @override
  String get diaryReferenceSep23ToSep29Event => '23 set a 29 set · Evento';

  @override
  String get diaryReferenceBackStronger => 'De volta, mais forte';

  @override
  String
  get diaryReferenceTheBestStretchOfTheTwoMonthsRecoveryReached91OnOct1ItOnlyFellOnAThursdayAfterWineThat =>
      'A melhor fase dos dois meses. A recuperação chegou a 91 em 1 out. Só caiu numa quinta depois do vinho: foi quando a BYND achou esse padrão.';

  @override
  String get diaryReferenceSep30ToOct1516Days => '30 set a 15 out · 16 dias';

  @override
  String get diaryReferenceBest => 'Melhor';

  @override
  String get diaryReferenceRuns => 'Corridas';

  @override
  String get diaryReferenceNewPattern => 'Padrão novo';

  @override
  String get diaryReferenceWine => 'vinho';

  @override
  String get diaryReferenceBestRecovery => 'Melhor recuperação';

  @override
  String get diaryReferenceOct1 => '1 out';

  @override
  String get diaryReference30DaysByndLearnedYourBaseline =>
      '30 dias: a BYND aprendeu o seu normal';

  @override
  String get diaryReferenceOct10Milestone => '10 out · Marco';

  @override
  String get diaryReferenceWednesdayWineTakesItsTollOnThursday =>
      'O vinho de quarta cobra na quinta';

  @override
  String get diaryReferenceOct8ByndLearned => '8 out · A BYND aprendeu';

  @override
  String get diaryReferenceDeadlineWeek => 'A semana de entrega';

  @override
  String
  get diaryReferenceLittleSleepLotsOfCoffeeFourNightsPastMidnightAnd4CoffeesADayStressDoubledAndRecoveryF =>
      'Pouco sono, muito café. Quatro noites depois da meia-noite e 4 cafés por dia. O estresse dobrou e a recuperação caiu para 53.';

  @override
  String get diaryReferenceOct16ToOct227Days => '16 out a 22 out · 7 dias';

  @override
  String get diaryReferenceStress => 'Estresse';

  @override
  String get diaryReferenceYourCycleIsRegularAt28Days =>
      'Seu ciclo é regular, de 28 dias';

  @override
  String get diaryReferenceOct20ByndLearned => '20 out · A BYND aprendeu';

  @override
  String get diaryReferenceDeadlineWeekAtWork =>
      'Semana de entrega no trabalho';

  @override
  String get diaryReferenceOct16ToOct20Event => '16 out a 20 out · Evento';

  @override
  String get diaryReferenceThe14Km => 'Os 14 km';

  @override
  String
  get diaryReferenceRecordHrvAndYourLongestRunHrvReached73MsOnOct28ThenCameThreeHardWorkoutsInARowAndThe1 =>
      'Recorde de VFC e a corrida mais longa. A VFC bateu 73 ms em 28 out. Depois vieram três treinos fortes seguidos e os 14 km, e a VFC caiu para 46 na quinta.';

  @override
  String get diaryReferenceOct23ToNov514Days => '23 out a 5 nov · 14 dias';

  @override
  String get diaryReferenceRecordHrv => 'VFC recorde';

  @override
  String get diaryReferenceRun => 'Corrida';

  @override
  String get diaryReferenceOct28 => '28 out';

  @override
  String get diaryReferenceLongestRun => 'Corrida mais longa';

  @override
  String get diaryReferenceNov4 => '4 nov';

  @override
  String get diaryReferenceMostActiveDay => 'Dia mais ativo';

  @override
  String get diaryReference21950Steps => '21.950passos';

  @override
  String get diaryReferenceNightsOnSchedule => 'Noites no horário';

  @override
  String get diaryReferenceNov1 => '1 nov';

  @override
  String get diaryReference4Of8 => '4de 8';

  @override
  String get diaryReferenceThreeHardWorkoutsInARow =>
      'Três treinos fortes seguidos';

  @override
  String get diaryReferenceNov3ToNov5Event => '3 nov a 5 nov · Evento';

  @override
  String get diaryReferenceJoinedTheBedBy11PmChallenge =>
      'Entrou no desafio “Deitar até 23h”';

  @override
  String get diaryReferenceNov1Milestone => '1 nov · Marco';

  @override
  String get diaryReferenceStressRisesWithShortSleep =>
      'O estresse sobe com o sono curto';

  @override
  String get diaryReferenceOct23ByndLearned => '23 out · A BYND aprendeu';

  @override
  String get diaryReferenceWokeUp => 'Acordou';

  @override
  String get diaryReference7H42OfSleepScore82MeasuredByTheBand =>
      '7h42 de sono · nota 82 · medido pela pulseira';

  @override
  String get diaryReferenceLightWorkoutMobilityAndStrength =>
      'Treino leve · mobilidade e força';

  @override
  String get diaryReference35MinLoad28MeasuredByTheBand =>
      '35 min · carga 28 · medido pela pulseira';

  @override
  String get diaryReference74OutOf100ReadyToTrainMeasuredByTheBand =>
      '74 de 100 · boa para treinar · medido pela pulseira';

  @override
  String get diaryReferenceHalfwayToYourStepGoal => 'Metade da meta de passos';

  @override
  String get diaryReference5000StepsMeasuredByTheBand =>
      '5.000 passos · medido pela pulseira';

  @override
  String get diaryReferenceStressPeak => 'Pico de estresse';

  @override
  String get diaryReference57OutOf100After2HSittingMeasuredByTheBand =>
      '57 de 100 · depois de 2 h sentado · medido pela pulseira';

  @override
  String get diaryReferenceMomentOfCalm => 'Momento de calma';

  @override
  String get diaryReference12MinLowStressMeasuredByTheBand =>
      '12 min · estresse baixo · medido pela pulseira';

  @override
  String get diaryReferenceWalk => 'Caminhada';

  @override
  String get diaryReference24Min21KmMeasuredByTheBand =>
      '24 min · 2,1 km · medido pela pulseira';

  @override
  String get diaryReferenceBodyReadyForSleep => 'Corpo pronto para dormir';

  @override
  String get diaryReference364CTemperatureDroppingMeasuredByTheBand =>
      '36,4 °C · temperatura caindo · medido pela pulseira';

  @override
  String get diaryReference6H10OfSleepScore64MeasuredByTheBand =>
      '6h10 de sono · nota 64 · medido pela pulseira';

  @override
  String get diaryReference42MinLoad61MeasuredByTheBand =>
      '42 min · carga 61 · medido pela pulseira';

  @override
  String get diaryReferenceWentToBed => 'Foi dormir';

  @override
  String get diaryReference2240MeasuredByTheBand =>
      '22:40  · medido pela pulseira';

  @override
  String get diaryAutomaticWokeUp => 'Acordou';

  @override
  String get diaryAutomaticActivity => 'Atividade';

  @override
  String diaryChapterCount(int count) {
    return 'de $count capítulos';
  }

  @override
  String diaryDidNotHappenAction(String title) {
    return 'Não aconteceu: $title';
  }

  @override
  String diaryToggleAction(String title) {
    return 'Marcar $title';
  }

  @override
  String diaryBandAndEntries(int bandCount, int entryCount) {
    return '$bandCount da pulseira · $entryCount registros seus';
  }

  @override
  String diaryHowWasDate(String date) {
    return 'Como foi o dia $date?';
  }

  @override
  String get diarySpeechLanguageUnavailable =>
      'O reconhecimento de voz neste idioma não está disponível no aparelho. Você pode escrever.';

  @override
  String get diaryWhatHappenedOnThisDay => 'O que aconteceu neste dia?';
}
