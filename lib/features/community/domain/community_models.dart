/// 社区模块的领域模型，字段与后端 `internal/module/community/dto` 一一对应。
///
/// 后端的 DTO 是唯一事实来源；这里只做「JSON → 强类型」，
/// 不加业务判断，业务判断放在 repository 与页面里。
library;

List<String> _stringList(Object? value) =>
    (value as List<Object?>?)?.cast<String>() ?? const [];

String? _optString(Object? value) => value is String && value.isNotEmpty ? value : null;

/// 群组摘要，对应 `GroupData`。
class CommunityGroup {
  const CommunityGroup({
    required this.id,
    required this.name,
    this.description = '',
    this.avatarUrl,
    required this.visibility,
    required this.membershipState,
    required this.role,
    required this.memberCount,
    required this.unreadCount,
    required this.messageMuted,
    this.members = const [],
  });

  factory CommunityGroup.fromJson(Map<String, dynamic> json) => CommunityGroup(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    avatarUrl: _optString(json['avatarUrl']),
    visibility: json['visibility'] as String? ?? 'private',
    membershipState: json['membershipState'] as String? ?? '',
    role: json['role'] as String? ?? 'member',
    memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
    unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    messageMuted: json['messageMuted'] as bool? ?? false,
    members: (json['members'] as List<Object?>? ?? const [])
        .map((e) => CommunityMember.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  final String id;
  final String name;
  final String description;
  final String? avatarUrl;
  final String visibility;
  final String membershipState;
  final String role;
  final int memberCount;
  final int unreadCount;
  final bool messageMuted;

  /// 列表接口直接携带的成员头像栈（前 5 个活跃成员）。
  final List<CommunityMember> members;
}

/// 群成员，对应 `GroupMemberData`。
class CommunityMember {
  const CommunityMember({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.role,
    required this.isMe,
  });

  factory CommunityMember.fromJson(Map<String, dynamic> json) => CommunityMember(
    userId: json['userId'] as String,
    displayName: json['displayName'] as String? ?? '',
    avatarUrl: _optString(json['avatarUrl']),
    role: json['role'] as String? ?? 'member',
    isMe: json['isMe'] as bool? ?? false,
  );

  final String userId;
  final String displayName;
  final String? avatarUrl;
  final String role;
  final bool isMe;
}

/// 群消息，对应 `GroupMessageData`。
class CommunityMessage {
  const CommunityMessage({
    required this.id,
    required this.groupId,
    required this.authorUserId,
    required this.authorDisplayName,
    this.authorAvatarUrl,
    required this.content,
    required this.createdAt,
    required this.isMine,
    required this.isRecalled,
    required this.canRecall,
    required this.mentionsMe,
  });

  factory CommunityMessage.fromJson(Map<String, dynamic> json) => CommunityMessage(
    id: json['id'] as String,
    groupId: json['groupId'] as String? ?? '',
    authorUserId: json['authorUserId'] as String? ?? '',
    authorDisplayName: json['authorDisplayName'] as String? ?? '',
    authorAvatarUrl: _optString(json['authorAvatarUrl']),
    content: json['content'] as String? ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
    isMine: json['isMine'] as bool? ?? false,
    isRecalled: json['isRecalled'] as bool? ?? false,
    canRecall: json['canRecall'] as bool? ?? false,
    mentionsMe: json['mentionsMe'] as bool? ?? false,
  );

  final String id;
  final String groupId;
  final String authorUserId;
  final String authorDisplayName;
  final String? authorAvatarUrl;
  final String content;
  final DateTime createdAt;
  final bool isMine;
  final bool isRecalled;
  final bool canRecall;
  final bool mentionsMe;
}

/// 收到的入群邀请，对应 `GroupInvitationData`。
class CommunityInvitation {
  const CommunityInvitation({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.inviterName,
    required this.createdAt,
  });

  factory CommunityInvitation.fromJson(Map<String, dynamic> json) => CommunityInvitation(
    id: json['id'] as String,
    groupId: json['groupId'] as String? ?? '',
    groupName: json['groupName'] as String? ?? '',
    inviterName: json['inviterName'] as String? ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
  );

  final String id;
  final String groupId;
  final String groupName;
  final String inviterName;
  final DateTime createdAt;
}

/// 精选挑战的单日任务，对应 `CuratedChallengeDayData`。
class ChallengeDay {
  const ChallengeDay({
    required this.dayNumber,
    required this.title,
    required this.action,
    required this.completed,
  });

  factory ChallengeDay.fromJson(Map<String, dynamic> json) => ChallengeDay(
    dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 0,
    title: json['title'] as String? ?? '',
    action: json['action'] as String? ?? '',
    completed: json['completed'] as bool? ?? false,
  );

  final int dayNumber;
  final String title;
  final String action;
  final bool completed;
}

/// 精选挑战，对应 `CuratedChallengeData`。
class CuratedChallenge {
  const CuratedChallenge({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.domain,
    required this.durationDays,
    required this.status,
    required this.enrollmentStatus,
    required this.premiumRequired,
    required this.days,
  });

  factory CuratedChallenge.fromJson(Map<String, dynamic> json) => CuratedChallenge(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    summary: json['summary'] as String? ?? '',
    description: json['description'] as String? ?? '',
    domain: json['domain'] as String? ?? '',
    durationDays: (json['durationDays'] as num?)?.toInt() ?? 0,
    status: json['status'] as String? ?? '',
    enrollmentStatus: json['enrollmentStatus'] as String? ?? '',
    premiumRequired: json['premiumRequired'] as bool? ?? false,
    days: (json['days'] as List<Object?>?)
        ?.map((e) => ChallengeDay.fromJson(e as Map<String, dynamic>))
        .toList() ??
        const [],
  );

  final String id;
  final String title;
  final String summary;
  final String description;
  final String domain;
  final int durationDays;
  final String status;
  final String enrollmentStatus;
  final bool premiumRequired;
  final List<ChallengeDay> days;

  bool get enrolled => enrollmentStatus.isNotEmpty && enrollmentStatus != 'none';

  /// 今天要做的那一天：第一个未完成日；全部完成则取最后一天。
  ChallengeDay? get today {
    for (final day in days) {
      if (!day.completed) return day;
    }
    return days.isEmpty ? null : days.last;
  }
}

/// 群 Atlas 洞察，对应 `GroupAtlasInsightData`。
class CommunityAtlasInsight {
  const CommunityAtlasInsight({
    required this.insightId,
    required this.type,
    required this.title,
    required this.summary,
    required this.actionableSteps,
  });

  factory CommunityAtlasInsight.fromJson(Map<String, dynamic> json) => CommunityAtlasInsight(
    insightId: json['insightId'] as String,
    type: json['type'] as String? ?? '',
    title: json['title'] as String? ?? '',
    summary: json['summary'] as String? ?? '',
    actionableSteps: _stringList(json['actionableSteps']),
  );

  final String insightId;
  final String type;
  final String title;
  final String summary;
  final List<String> actionableSteps;
}

/// 群内排名条目，对应 `GroupGoalRankingEntryData`。
class CommunityRankingEntry {
  const CommunityRankingEntry({
    required this.rank,
    required this.userId,
    required this.displayName,
    required this.currentValue,
    required this.progressPercent,
    required this.isMe,
  });

  factory CommunityRankingEntry.fromJson(Map<String, dynamic> json) => CommunityRankingEntry(
    rank: (json['rank'] as num?)?.toInt() ?? 0,
    userId: json['userId'] as String? ?? '',
    displayName: json['displayName'] as String? ?? '',
    currentValue: (json['currentValue'] as num?)?.toDouble() ?? 0,
    progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0,
    isMe: json['isMe'] as bool? ?? false,
  );

  final int rank;
  final String userId;
  final String displayName;
  final double currentValue;
  final double progressPercent;
  final bool isMe;
}

/// 群目标，对应 `GroupGoalData`。排名与「谁完成了今天」都挂在目标上。
class CommunityGoal {
  const CommunityGoal({
    required this.id,
    required this.groupId,
    required this.title,
    required this.category,
    required this.metric,
    required this.targetValue,
    required this.unit,
    required this.status,
    required this.myCurrentValue,
    required this.myProgressPercent,
    required this.teamProgressPercent,
    required this.participatingCount,
    required this.canManage,
  });

  factory CommunityGoal.fromJson(Map<String, dynamic> json) => CommunityGoal(
    id: json['id'] as String,
    groupId: json['groupId'] as String? ?? '',
    title: json['title'] as String? ?? '',
    category: json['category'] as String? ?? '',
    metric: json['metric'] as String? ?? '',
    targetValue: (json['targetValue'] as num?)?.toDouble() ?? 0,
    unit: json['unit'] as String? ?? '',
    status: json['status'] as String? ?? '',
    myCurrentValue: (json['myCurrentValue'] as num?)?.toDouble() ?? 0,
    myProgressPercent: (json['myProgressPercent'] as num?)?.toDouble() ?? 0,
    teamProgressPercent: (json['teamProgressPercent'] as num?)?.toDouble() ?? 0,
    participatingCount: (json['participatingCount'] as num?)?.toInt() ?? 0,
    canManage: json['canManage'] as bool? ?? false,
  );

  final String id;
  final String groupId;
  final String title;
  final String category;
  final String metric;
  final double targetValue;
  final String unit;
  final String status;
  final double myCurrentValue;
  final double myProgressPercent;
  final double teamProgressPercent;
  final int participatingCount;
  final bool canManage;
}
