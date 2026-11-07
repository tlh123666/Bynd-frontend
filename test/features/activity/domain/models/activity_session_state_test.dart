import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/features/activity/domain/models/activity_session_state.dart';

void main() {
  group('ActivitySessionStateTransitions', () {
    test('覆盖准备、倒数、运行、暂停和结束的主路径', () {
      expect(
        ActivitySessionState.preparing.canTransitionTo(
          ActivitySessionState.countdown,
        ),
        isTrue,
      );
      expect(
        ActivitySessionState.countdown.canTransitionTo(
          ActivitySessionState.running,
        ),
        isTrue,
      );
      expect(
        ActivitySessionState.running.canTransitionTo(
          ActivitySessionState.paused,
        ),
        isTrue,
      );
      expect(
        ActivitySessionState.paused.canTransitionTo(
          ActivitySessionState.running,
        ),
        isTrue,
      );
      expect(
        ActivitySessionState.running.canTransitionTo(
          ActivitySessionState.finishing,
        ),
        isTrue,
      );
      expect(
        ActivitySessionState.finishing.canTransitionTo(
          ActivitySessionState.saved,
        ),
        isTrue,
      );
    });

    test('保存失败保留重试路径，终态不能重新打开', () {
      expect(
        ActivitySessionState.finishing.canTransitionTo(
          ActivitySessionState.saveFailed,
        ),
        isTrue,
      );
      expect(
        ActivitySessionState.saveFailed.canTransitionTo(
          ActivitySessionState.finishing,
        ),
        isTrue,
      );

      for (final terminal in [
        ActivitySessionState.saved,
        ActivitySessionState.cancelled,
        ActivitySessionState.discarded,
      ]) {
        for (final next in ActivitySessionState.values) {
          expect(terminal.canTransitionTo(next), isFalse);
        }
      }
    });

    test('非法跳转和自我跳转都会被拒绝', () {
      expect(
        ActivitySessionState.countdown.canTransitionTo(
          ActivitySessionState.saved,
        ),
        isFalse,
      );
      expect(
        ActivitySessionState.running.canTransitionTo(
          ActivitySessionState.running,
        ),
        isFalse,
      );
      expect(
        ActivitySessionState.saved.canTransitionTo(
          ActivitySessionState.running,
        ),
        isFalse,
      );
    });

    test('中断会话可恢复或由用户明确放弃', () {
      expect(
        ActivitySessionState.interrupted.canTransitionTo(
          ActivitySessionState.running,
        ),
        isTrue,
      );
      expect(
        ActivitySessionState.interrupted.canTransitionTo(
          ActivitySessionState.discarded,
        ),
        isTrue,
      );
    });
  });
}
