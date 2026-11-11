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
}
