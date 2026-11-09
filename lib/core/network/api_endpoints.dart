/// Central API endpoint constants.
///
/// All HTTP endpoint paths should be defined here to avoid duplication
/// and make backend URL changes a single-point modification.
class ApiEndpoints {
  ApiEndpoints._();

  static const intelligenceToday = '/api/v1/intelligence/context/today';
  static const mapaOverview = '/api/v1/mapa/overview';
  static const mapaRelationships = '/api/v1/mapa/relationships';
  static const mapaDiscoveries = '/api/v1/mapa/discoveries';
  static const mapaWhatIfOptions = '/api/v1/mapa/what-if/options';
  static const mapaWhatIfSimulate = '/api/v1/mapa/what-if/simulate';
  static const mapaExperiments = '/api/v1/mapa/experiments';
  static String mapaRelationship(String id) =>
      '$mapaRelationships/${Uri.encodeComponent(id)}';
  static String mapaDiscovery(String id) =>
      '$mapaDiscoveries/${Uri.encodeComponent(id)}';
  static String mapaExperiment(String id) =>
      '$mapaExperiments/${Uri.encodeComponent(id)}';

  // ── Auth ──
  static const String authEmailCode = '/api/v1/auth/email/code';
  static const String authEmailLogin = '/api/v1/auth/email/login';
  static const String authGoogle = '/api/v1/auth/google';
  static const String authRefresh = '/api/v1/auth/refresh';
  static const String authLogout = '/api/v1/auth/logout';
  static const String meAccount = '/api/v1/me/account';

  // ── Push ──
  /// FCM token 注册与注销（POST / DELETE 同一路径）。
  static const String pushToken = '/api/v1/me/push/token';

  // ── User ──
  static const String userProfile = '/api/v1/me/profile';
  static const String userUpdate = '/api/v1/me/profile';
  static const String userAvatar = '/api/v1/me/avatar';
  static const String profileCompleteness = '/api/v1/me/profile/completeness';
  static const String healthConditions = '/api/v1/me/conditions';
  static String healthCondition(String id) =>
      '/api/v1/me/conditions/${Uri.encodeComponent(id)}';
  static const String bodyMeasurements = '/api/v1/me/measurements';
  static String bodyMeasurement(String id) =>
      '/api/v1/me/measurements/${Uri.encodeComponent(id)}';
  static const String userGoals = '/api/v1/me/goals';
  static const String femaleHealthSettings =
      '/api/v1/me/female-health-settings';
  static const String femaleHealthSymptoms =
      '/api/v1/me/female-health-symptoms';
  static String femaleHealthSymptom(String id) =>
      '/api/v1/me/female-health-symptoms/${Uri.encodeComponent(id)}';

  // Product-facing cycle API aliases.
  static const String cycleSettings = '/api/v1/me/cycle/settings';
  static const String cycleRecords = '/api/v1/me/cycle/records';
  static String cycleRecord(String id) =>
      '/api/v1/me/cycle/records/${Uri.encodeComponent(id)}';
  static const String cycleSymptoms = '/api/v1/me/cycle/symptoms';
  static String cycleSymptom(String id) =>
      '/api/v1/me/cycle/symptoms/${Uri.encodeComponent(id)}';
  static const String cycleTrends = '/api/v1/me/cycle/trends';
  static const String cycleTemperatureInsights =
      '/api/v1/me/cycle/temperature-insights';
  static const String cycleHormoneInsights =
      '/api/v1/me/cycle/hormone-insights';

  // ── Device ──
  static const String deviceList = '/api/v1/me/devices';
  static const String deviceBind = '/api/v1/me/devices/bind';
  static String device(String deviceId) =>
      '/api/v1/me/devices/${Uri.encodeComponent(deviceId)}';

  // ── Sedentary reminder ──
  static const String sedentaryReminder = '/api/v1/me/sedentary-reminder';
  static const String sedentaryReminderEnabled =
      '/api/v1/me/sedentary-reminder/enabled';
  static const String sedentaryReminderEvaluations =
      '/api/v1/me/sedentary-reminder/evaluations';
  static const String sedentaryReminderTest =
      '/api/v1/me/sedentary-reminder/test';
  static const String sedentaryReminderEvents =
      '/api/v1/me/sedentary-reminders';
  static String sedentaryReminderEvent(String reminderId) =>
      '/api/v1/me/sedentary-reminders/${Uri.encodeComponent(reminderId)}';

  // ── Sleep ──
  static const String sleepSessions = '/api/v1/me/sleep/sessions';
  static String sleepSession(String sessionId) =>
      '/api/v1/me/sleep/sessions/${Uri.encodeComponent(sessionId)}';
  static const String sleepTrend = '/api/v1/me/sleep/trend';
  static const String sleepInsight = '/api/v1/me/sleep/insight';
  static const String sleepExperience = '/api/v1/me/sleep/experience';
  static const String sleepPreferences = '/api/v1/me/sleep/preferences';

  // ── Sleep plans (bedtime reminders) ──
  static const String sleepPlans = '/api/v1/me/sleep-plans';
  static String sleepPlan(String planId) =>
      '/api/v1/me/sleep-plans/${Uri.encodeComponent(planId)}';
  static String sleepPlanEnabled(String planId) =>
      '/api/v1/me/sleep-plans/${Uri.encodeComponent(planId)}/enabled';

  // ── Diary (BYND body story + optional real-life context) ──
  static const String diary = '/api/v1/me/diary';
  static String diaryDay(String date) =>
      '/api/v1/me/diary/${Uri.encodeComponent(date)}';
  static String diaryContext(String date) => '${diaryDay(date)}/context';
  static String diaryGenerate(String date) => '${diaryDay(date)}/generate';
  static const String diaryGeneratePending =
      '/api/v1/me/diary/generate-pending';
  static const String diaryParseEvents = '/api/v1/me/diary/events/parse';
  static const String diarySaveEvents = '/api/v1/me/diary/events/batch';
  static String diaryEvent(String eventId) =>
      '/api/v1/me/diary/events/${Uri.encodeComponent(eventId)}';
  static const String diaryTrackers = '/api/v1/me/diary/trackers';

  // ── 14-day body foundations guide ──
  static const String bodyGuide = '/api/v1/me/guidance/body-foundations';
  static const String bodyGuideStart = '$bodyGuide/start';
  static const String bodyGuideQuestionnaire = '$bodyGuide/questionnaire';
  static const String bodyGuideQuestionnaireSkip =
      '$bodyGuide/questionnaire/skip';
  static String bodyGuideDay(int day) => '$bodyGuide/days/$day';
  static const String bodyGuideDismiss = '$bodyGuide/dismiss';

  // Long-term health journey.
  static const String journeyOverview = '/api/v1/me/journey';
  static const String healthMilestones = '/api/v1/me/milestones';
  static const String latestHealthReport = '/api/v1/me/reports/latest';

  // Kept only while the unreachable legacy feature source remains in the
  // project. No route or UI uses these old endpoints.
  @Deprecated('Use diary endpoints')
  static const String journals = '/api/v1/me/journals';
  @Deprecated('Use diary endpoints')
  static String journal(String id) =>
      '/api/v1/me/journals/${Uri.encodeComponent(id)}';

  // ── Health ──
  static const String heartRateSamples = '/api/v1/me/heart-rate/samples';
  static const String heartRateTrend = '/api/v1/me/heart-rate/trend';
  static const String heartRateSettings = '/api/v1/me/heart-rate/settings';
  static const String ecgRecords = '/api/v1/me/heart-rate/ecg/records';
  static const String longevityOverview = '/api/v1/me/longevity';

  // ── Workout ──
  // 目录对所有人一样；最近使用是个人数据，分两个接口。
  static const String workoutActivities = '/api/v1/workout-activities';
  static const String recentWorkoutActivities =
      '/api/v1/me/workouts/recent-activities';

  /// 提交一次已结束的训练（v2 协议：带有效时段、原始轨迹与心率采样）。
  /// 幂等键是请求体里的 `clientRequestId`，重试必须复用同一个。
  static const String workouts = '/api/v1/me/workouts';
  static const String workoutPreview = '/api/v1/me/workouts/preview';

  /// 单次训练的正式详情。
  ///
  /// 注意与 [recentWorkoutActivities] 是同层级的静态段，别让按路径前缀分支的
  /// 假客户端把两者匹配混了。
  static String workout(String workoutId) =>
      '/api/v1/me/workouts/${Uri.encodeComponent(workoutId)}';

  static String workoutRoute(String workoutId) => '${workout(workoutId)}/route';
  static const String healthDailySummary =
      '/api/v1/me/health-data/daily-summary';
  static const String healthSyncConfig = '/api/v1/me/health-data/sync-config';
  static const String healthDataBatches = '/api/v1/me/health-data/batches';
  static String healthDataBatch(String batchId) =>
      '/api/v1/me/health-data/batches/${Uri.encodeComponent(batchId)}';
  static const String healthTodayDirection =
      '/api/v1/me/health-data/today-direction';
  static String healthSignalDetail(String type) =>
      '/api/v1/me/health-data/signals/${Uri.encodeComponent(type)}/detail';
  static String healthAlertDetail(String alertId) =>
      '/api/v1/me/health-data/alerts/${Uri.encodeComponent(alertId)}/detail';
  static const String healthRealtimeWs = '/api/v1/me/health-data/realtime/ws';
  static const String healthMetrics = '/api/v1/health/metrics';
  static const String healthHeartRate = '/api/v1/health/heart-rate';
  static const String healthSleep = '/api/v1/health/sleep';
  static const String healthActivity = '/api/v1/health/activity';
  static String healthDaily(String date) => '/api/v1/health/daily/$date';

  // ── Membership ──
  static const String exploreModules = '/api/v1/explore/modules';
  static const String membershipPaywall = '/api/v1/membership/paywall';
  static const String membershipRevenueCatSync =
      '/api/v1/membership/revenuecat/sync';

  // Community.
  static const String community = '/api/v1/me/community';
  static const String communityGroups = '$community/groups';
  static String communityGroup(String groupId) =>
      '$communityGroups/${Uri.encodeComponent(groupId)}';
  static String communityGroupAvatar(String groupId) =>
      '${communityGroup(groupId)}/avatar';
  static String communityGroupVisibility(String groupId) =>
      '${communityGroup(groupId)}/visibility';
  static String communityGroupJoin(String groupId) =>
      '$communityGroups/${Uri.encodeComponent(groupId)}/join';
  static String communityGroupMembership(String groupId) =>
      '$communityGroups/${Uri.encodeComponent(groupId)}/membership';
  static String communityGroupMember(String groupId, String userId) =>
      '${communityGroup(groupId)}/members/${Uri.encodeComponent(userId)}';
  static String communityGroupMemberRole(String groupId, String userId) =>
      '${communityGroupMember(groupId, userId)}/role';
  static String communityGroupInvitations(String groupId) =>
      '${communityGroup(groupId)}/invitations';
  static String communityGroupInvitationPreview(String groupId) =>
      '${communityGroupInvitations(groupId)}/preview';
  static const String communityInvitations = '$community/group-invitations';
  static String communityInvitationResponse(String invitationId) =>
      '$communityInvitations/${Uri.encodeComponent(invitationId)}/respond';
  static String communityGroupGoals(String groupId) =>
      '${communityGroup(groupId)}/goals';
  static String communityGroupGoal(String groupId, String goalId) =>
      '${communityGroupGoals(groupId)}/${Uri.encodeComponent(goalId)}';
  static String communityGroupGoalRanking(String groupId, String goalId) =>
      '${communityGroupGoal(groupId, goalId)}/ranking';
  static String communityGroupGoalEnd(String groupId, String goalId) =>
      '${communityGroupGoal(groupId, goalId)}/end';
  static String communityGroupGoalParticipation(
    String groupId,
    String goalId,
  ) => '${communityGroupGoal(groupId, goalId)}/participation';
  static String communityGroupGoalProgress(String groupId, String goalId) =>
      '${communityGroupGoal(groupId, goalId)}/progress';
  static String communityGroupAtlas(String groupId) =>
      '${communityGroup(groupId)}/atlas';
  static String communityGroupMessages(String groupId) =>
      '$communityGroups/${Uri.encodeComponent(groupId)}/messages';
  static String communityGroupMessage(String groupId, String messageId) =>
      '${communityGroupMessages(groupId)}/${Uri.encodeComponent(messageId)}';
  static String communityGroupMessageRecall(String groupId, String messageId) =>
      '${communityGroupMessage(groupId, messageId)}/recall';
  static String communityGroupMessagesRead(String groupId) =>
      '${communityGroupMessages(groupId)}/read';
  static String communityGroupNotificationSettings(String groupId) =>
      '${communityGroup(groupId)}/notification-settings';
  static const String communityMessageNotifications =
      '$community/message-notifications';
  static const String communityChallenges = '$community/challenges';
  static String communityChallenge(String challengeId) =>
      '$communityChallenges/${Uri.encodeComponent(challengeId)}';
  static String communityChallengeJoin(String challengeId) =>
      '${communityChallenge(challengeId)}/join';
  static String communityChallengeMembership(String challengeId) =>
      '${communityChallenge(challengeId)}/membership';
  static String communityChallengeSyncWorkouts(String challengeId) =>
      '${communityChallenge(challengeId)}/sync-workouts';
  static String communityChallengeDayProgress(
    String challengeId,
    int dayNumber,
  ) => '${communityChallenge(challengeId)}/days/$dayNumber/progress';
  static const String communityClubs = '$community/clubs';
  static String communityClub(String clubId) =>
      '$communityClubs/${Uri.encodeComponent(clubId)}';
  static String communityClubJoin(String clubId) =>
      '${communityClub(clubId)}/join';
  static String communityClubMembership(String clubId) =>
      '${communityClub(clubId)}/membership';
  static String communityClubEvents(String clubId) =>
      '${communityClub(clubId)}/events';
  static String communityClubEvent(String clubId, String eventId) =>
      '${communityClubEvents(clubId)}/${Uri.encodeComponent(eventId)}';
  static String communityClubEventRegistration(String clubId, String eventId) =>
      '${communityClubEvent(clubId, eventId)}/registration';
  static const String communityClubApplications =
      '$community/club-applications';
  static const String communityReviews = '$community/reviews';

  // AI assistant.
  static const String assistantWorkspace = '/api/v1/me/ai/workspace';
  static const String assistantReview = '/api/v1/me/ai/review';
  static const String assistantReviewExplanation =
      '/api/v1/me/ai/review/explanation';
  static const String assistantUsage = '/api/v1/me/ai/usage';
  static const String assistantConversations = '/api/v1/me/ai/conversations';
  static String assistantConversation(String id) =>
      '/api/v1/me/ai/conversations/${Uri.encodeComponent(id)}';
  static String assistantConversationPin(String id) =>
      '${assistantConversation(id)}/pin';
  static String assistantMessages(String conversationId) =>
      '${assistantConversation(conversationId)}/messages';
  static String assistantCancelGeneration(String conversationId) =>
      '${assistantConversation(conversationId)}/cancel';
  static String assistantMessageFeedback(String messageId) =>
      '/api/v1/me/ai/messages/${Uri.encodeComponent(messageId)}/feedback';

  // 权益、来源状态与记忆管理。这些接口都不计主动互动。
  static const String assistantCapabilities = '/api/v1/me/ai/capabilities';
  /// ATLAS 可展示洞察列表（internal/module/aiinsight/route/routes.go）。
  /// 后端已在服务端过滤候选态与过期条目并隐藏读取窗口参数，客户端不要再传
  /// windowDays —— 传了也会被忽略。
  static const String insights = '/api/v1/me/insights';
  static const String assistantSettings = '/api/v1/me/ai/settings';
  static const String assistantConsents = '/api/v1/me/ai/consents';
  static const String assistantMemories = '/api/v1/me/ai/memories';
  static String assistantMemory(String id) =>
      '$assistantMemories/${Uri.encodeComponent(id)}';
  static String assistantMemoryConfirm(String id) =>
      '${assistantMemory(id)}/confirm';
  static String assistantRequestStatus(String clientRequestId) =>
      '/api/v1/me/ai/requests/${Uri.encodeComponent(clientRequestId)}';

  // Reading catalog and synchronized reading state.
  static const String readingCatalog = '/api/v1/readings/catalog';
  static const String readingPublications = '/api/v1/readings/publications';
  static String readingPublication(String id) =>
      '$readingPublications/${Uri.encodeComponent(id)}';
  static String readingContent(String id) =>
      '${readingPublication(id)}/content';
  static const String readingLibrary = '/api/v1/me/readings/library';
  static String readingLibraryItem(String id) =>
      '$readingLibrary/${Uri.encodeComponent(id)}';
  static const String readingProgress = '/api/v1/me/readings/progress';
  static String readingProgressItem(String id) =>
      '$readingProgress/${Uri.encodeComponent(id)}';
  static String readingAnnotations(String publicationId) =>
      '/api/v1/me/readings/publications/${Uri.encodeComponent(publicationId)}/annotations';
  static String readingAnnotation(String annotationId) =>
      '/api/v1/me/readings/annotations/${Uri.encodeComponent(annotationId)}';
}
