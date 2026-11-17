import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/features/community/data/remote_community_repository.dart';
import 'package:new_jcvital/features/community/presentation/community_page.dart';

/// 复现真机社区页黑屏：用与后端一致形状的响应 pump 真实 CommunityPage。
void main() {
  testWidgets('CommunityPage builds without exceptions on fixture data',
      (tester) async {
    final seen = <String>[];
    final api = ApiClient(
      baseUrl: Uri.parse('https://example.org/api/v1'),
      tokenProvider: () async => 'test-token',
      client: MockClient((request) async {
        seen.add('${request.method} ${request.url.path}');
        return http.Response(
          jsonEncode(_responses(request)),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    addTearDown(api.close);

    await tester.pumpWidget(
      MaterialApp(home: CommunityPage(repository: RemoteCommunityRepository(api))),
    );
    // 不用 pumpAndSettle：若存在每帧循环（比如异常反复抛出）它会永不停止；
    // 每泵一帧取一次异常，全部打印。
    final caught = <Object?>[];
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      final one = tester.takeException();
      if (one != null) caught.add(one);
    }
    // ignore: avoid_print
    print('CAUGHT ${caught.length} exceptions');
    for (final e in caught.toSet()) {
      // ignore: avoid_print
      print('EXCEPTION: $e');
    }
    expect(caught, isEmpty,
        reason: 'CommunityPage 每帧抛异常（真机上表现为整页黑屏）');
  });
}

Map<String, dynamic> _responses(http.Request request) {
  final path = request.url.path;
  if (path.endsWith('/community/groups')) return _groups;
  if (path.endsWith('/community/invitations')) return _invitations;
  if (path.endsWith('/community/challenges/g1-sono')) {
    return _challengeDetail;
  }
  if (path.endsWith('/community/challenges')) return _challenges;
  if (path.contains('/community/groups/g1/goals')) return _goals;
  if (path.contains('/community/groups/g1/atlas')) return _atlas;
  if (path.contains('/community/groups/g1/ranking') ||
      path.contains('ranking')) {
    return _ranking;
  }
  if (path.contains('/community/groups/g1/messages')) return _messages;
  return const {};
}

const _groups = {
  'items': [
    {
      'id': 'g1',
      'name': 'Corrida de sábado',
      'description': '',
      'visibility': 'private',
      'membershipState': 'joined',
      'role': 'member',
      'memberCount': 5,
      'unreadCount': 0,
      'messageMuted': false,
      'members': [
        {
          'userId': 'u-me',
          'displayName': 'Camila',
          'role': 'owner',
          'isMe': true,
        },
        {
          'userId': 'u-2',
          'displayName': 'Bruno',
          'role': 'member',
          'isMe': false,
        },
      ],
    },
  ],
};

const _invitations = {'items': []};

const _challenges = {
  'items': [
    {
      'id': 'g1-sono',
      'title': 'Dormir antes das 23h',
      'summary': '',
      'description': '',
      'domain': 'sleep',
      'durationDays': 21,
      'status': 'active',
      'enrollmentStatus': 'enrolled',
      'premiumRequired': false,
      'days': [],
    },
  ],
};

final _challengeDetail = {
  'id': 'g1-sono',
  'title': 'Dormir antes das 23h',
  'summary': '',
  'description': '',
  'domain': 'sleep',
  'durationDays': 21,
  'status': 'active',
  'enrollmentStatus': 'enrolled',
  'premiumRequired': false,
  'days': [
    {
      'dayNumber': 3,
      'title': 'Noite 3',
      'action': 'Deitar até 23h15',
      'completed': false,
      'date': '2026-11-17',
    },
  ],
};

const _goals = {'items': []};

const _atlas = {'items': []};

const _ranking = {'items': []};

const _messages = {
  'items': [
    {
      'id': 'm1',
      'groupId': 'g1',
      'authorUserId': 'u-2',
      'authorDisplayName': 'Bruno',
      'content': 'Check-in de hoje',
      'createdAt': '2026-11-17T10:40:00Z',
      'isMine': false,
      'isRecalled': false,
      'canRecall': false,
      'mentionsMe': false,
    },
  ],
};
