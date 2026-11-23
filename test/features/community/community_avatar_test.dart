import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/features/community/presentation/community_avatar.dart';

void main() {
  testWidgets('对象存储 key 不作为网络地址，显示姓名首字母', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CommunityAvatar(name: 'Ana', avatarUrl: 'avatars/user/photo.jpg'),
      ),
    );
    expect(find.text('A'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('网络头像加载和失败时始终回退到字母，避免返回图片自身', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CommunityAvatar(
          name: 'Beatriz',
          avatarUrl: 'https://example.invalid/avatar.png',
        ),
      ),
    );
    final image = tester.widget<Image>(find.byType(Image));
    final context = tester.element(find.byType(Image));
    final placeholder = image.loadingBuilder!(
      context,
      const SizedBox(),
      const ImageChunkEvent(cumulativeBytesLoaded: 1, expectedTotalBytes: 10),
    );
    final failure = image.errorBuilder!(
      context,
      Exception('image unavailable'),
      StackTrace.empty,
    );
    expect(placeholder, isA<Text>());
    expect((placeholder as Text).data, 'B');
    expect(failure, isA<Text>());
    expect((failure as Text).data, 'B');
    await tester.pumpAndSettle();
    expect(find.text('B'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
