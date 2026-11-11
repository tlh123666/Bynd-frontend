import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../domain/community_models.dart';

/// 社区模块唯一的数据通道：所有调用都走 `ApiClient.request`，
/// 路径来自 `ApiEndpoints` 里同事铺好的常量，不在这里拼字符串。
class RemoteCommunityRepository {
  RemoteCommunityRepository(this.client);

  final ApiClient client;

  Future<Map<String, dynamic>> _call(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) =>
      client.request(method, path, body: body);

  // ---- 汇总 ----

  /// 社区 Hub：后端按能力门控返回可用分区。
  Future<Map<String, dynamic>> hub() => _call('GET', ApiEndpoints.community);

  // ---- 群组 ----

  Future<List<CommunityGroup>> listGroups() async {
    final data = await _call('GET', ApiEndpoints.communityGroups);
    return (data['items'] as List<Object?>? ?? const [])
        .map((e) => CommunityGroup.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CommunityGroup> createGroup({
    required String name,
    String description = '',
    String visibility = 'private',
  }) async {
    final data = await _call('POST', ApiEndpoints.communityGroups, body: {
      'name': name,
      'description': description,
      'visibility': visibility,
    });
    return CommunityGroup.fromJson(data);
  }

  Future<List<CommunityMember>> groupMembers(String groupId) async {
    final data = await _call('GET', ApiEndpoints.communityGroup(groupId));
    return (data['members'] as List<Object?>? ?? const [])
        .map((e) => CommunityMember.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> joinGroup(String groupId, {bool consent = true}) => _call(
    'POST',
    ApiEndpoints.communityGroupJoin(groupId),
    body: {'consent': consent},
  );

  Future<void> leaveGroup(String groupId) =>
      _call('DELETE', ApiEndpoints.communityGroupMembership(groupId));

  Future<void> inviteMember(String groupId, String email) => _call(
    'POST',
    ApiEndpoints.communityGroupInvitations(groupId),
    body: {'email': email},
  );

  // ---- 邀请 ----

  Future<List<CommunityInvitation>> listInvitations() async {
    final data = await _call('GET', ApiEndpoints.communityInvitations);
    return (data['items'] as List<Object?>? ?? const [])
        .map((e) => CommunityInvitation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> respondInvitation(String invitationId, {required bool accept}) =>
      _call(
        'POST',
        ApiEndpoints.communityInvitationResponse(invitationId),
        body: {'accept': accept},
      );

  // ---- 消息 ----

  Future<List<CommunityMessage>> listMessages(String groupId) async {
    final data = await _call('GET', ApiEndpoints.communityGroupMessages(groupId));
    return (data['items'] as List<Object?>? ?? const [])
        .map((e) => CommunityMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CommunityMessage> sendMessage(String groupId, String content) async {
    final data = await _call('POST', ApiEndpoints.communityGroupMessages(groupId), body: {
      'content': content,
    });
    return CommunityMessage.fromJson(data);
  }

  Future<void> markMessagesRead(String groupId) =>
      _call('POST', ApiEndpoints.communityGroupMessagesRead(groupId), body: const {});

  Future<void> recallMessage(String groupId, String messageId) => _call(
    'POST',
    ApiEndpoints.communityGroupMessageRecall(groupId, messageId),
    body: const {},
  );

  // ---- 精选挑战 ----

  Future<List<CuratedChallenge>> listChallenges() async {
    final data = await _call('GET', ApiEndpoints.communityChallenges);
    return (data['items'] as List<Object?>? ?? const [])
        .map((e) => CuratedChallenge.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CuratedChallenge> challengeDetail(String challengeId) async {
    final data = await _call('GET', ApiEndpoints.communityChallenge(challengeId));
    return CuratedChallenge.fromJson(data);
  }

  Future<void> joinChallenge(String challengeId) =>
      _call('POST', ApiEndpoints.communityChallengeJoin(challengeId), body: const {});

  Future<void> leaveChallenge(String challengeId) =>
      _call('DELETE', ApiEndpoints.communityChallengeMembership(challengeId));

  /// 打卡：把某一天标记为完成（原型里的「Marcar」）。
  Future<void> markChallengeDay(
    String challengeId,
    int dayNumber, {
    required bool completed,
    String note = '',
  }) =>
      _call(
        'PUT',
        ApiEndpoints.communityChallengeDayProgress(challengeId, dayNumber),
        body: {'completed': completed, 'note': note},
      );

  // ---- 群 Atlas 与排名 ----

  Future<List<CommunityAtlasInsight>> groupAtlas(String groupId) async {
    final data = await _call('GET', ApiEndpoints.communityGroupAtlas(groupId));
    return (data['items'] as List<Object?>? ?? const [])
        .map((e) => CommunityAtlasInsight.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 群目标排名：需要先知道 goalId，见 [firstGoalId]。
  Future<List<CommunityRankingEntry>> goalRanking(String groupId, String goalId) async {
    final data = await _call(
      'GET',
      ApiEndpoints.communityGroupGoalRanking(groupId, goalId),
    );
    return (data['items'] as List<Object?>? ?? const [])
        .map((e) => CommunityRankingEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 群目标列表（排名的 goalId 从这里来）。
  Future<List<Map<String, dynamic>>> groupGoals(String groupId) async {
    final data = await _call('GET', ApiEndpoints.communityGroupGoals(groupId));
    return (data['items'] as List<Object?>? ?? const [])
        .cast<Map<String, dynamic>>();
  }
}
