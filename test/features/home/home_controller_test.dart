import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/core/auth/auth_session.dart';
import 'package:new_jcvital/core/auth/auth_token_store.dart';
import 'package:new_jcvital/features/home/application/home_controller.dart';
import 'package:new_jcvital/features/home/data/demo_home_repository.dart';
import 'package:new_jcvital/features/home/data/home_preferences.dart';
import 'package:new_jcvital/features/home/domain/home_models.dart';

class MemoryHomePreferences implements HomePreferences {
  int currentPhoto = 1;
  final selections = <String, List<HomeSignal>>{};
  bool fail = false;
  @override
  Future<int> photo() async => currentPhoto;
  @override
  Future<void> savePhoto(int photo) async {
    if (fail) throw StateError('storage');
    currentPhoto = photo;
  }

  @override
  Future<List<HomeSignal>> signals(String user) async =>
      selections[user] ?? HomeSignal.defaults;
  @override
  Future<void> saveSignals(String user, List<HomeSignal> signals) async {
    if (fail) throw StateError('storage');
    selections[user] = List.of(signals);
  }
}

class MemoryHomeAccessStorage implements AccessTokenStorage {
  String? token;
  @override
  Future<String?> read() async => token;
  @override
  Future<void> write(String value) async {
    token = value;
  }

  @override
  Future<void> delete() async {
    token = null;
  }
}

class _PendingRepository extends DemoHomeRepository {
  final requests = <Completer<HomeSnapshot>>[];
  final dates = <DateTime>[];
  @override
  Future<HomeSnapshot> fetch(DateTime date, String locale) {
    dates.add(date);
    final request = Completer<HomeSnapshot>();
    requests.add(request);
    return request.future;
  }
}

void main() {
  test(
    'account change clears private data immediately and rejects the previous response',
    () async {
      final session = AuthSession(storage: MemoryHomeAccessStorage());
      addTearDown(AuthTokenStore.instance.clear);
      await session.setAccessToken('account-a');
      final repository = _PendingRepository();
      final controller = HomeController(
        repository: repository,
        preferences: MemoryHomePreferences(),
        session: session,
      );
      final old = controller.initialize();
      await session.setAccessToken('account-b');
      expect(controller.snapshot, isNull);
      expect(controller.accountRevision, 1);
      final data = await DemoHomeRepository().fetch(DateTime.now(), 'pt');
      repository.requests.first.complete(data);
      await old;
      expect(controller.snapshot, isNull);
      repository.requests.last.complete(data);
      await Future<void>.delayed(Duration.zero);
      expect(controller.snapshot, isNotNull);
      controller.dispose();
      session.dispose();
    },
  );
  test(
    'rapid day changes cannot overwrite the selected day with a late response',
    () async {
      final repository = _PendingRepository();
      final controller = HomeController(
        repository: repository,
        preferences: MemoryHomePreferences(),
        clock: () => DateTime(2026, 11, 9),
      );
      final old = controller.initialize();
      final latest = controller.setDay(1);
      final samples = DemoHomeRepository();
      repository.requests[1].complete(
        await samples.fetch(DateTime(2026, 11, 8), 'pt'),
      );
      await latest;
      repository.requests[0].complete(
        await samples.fetch(DateTime(2026, 11, 9), 'pt'),
      );
      await old;
      expect(controller.day, 1);
      expect(controller.snapshot!.date, DateTime(2026, 11, 8));
      expect(controller.loading, false);
      controller.dispose();
    },
  );
  test(
    'signal preferences require six distinct entries and survive a reload',
    () async {
      final preferences = MemoryHomePreferences();
      final controller = HomeController(
        repository: DemoHomeRepository(),
        preferences: preferences,
      );
      await controller.initialize();
      await expectLater(
        controller.saveSignals([HomeSignal.steps]),
        throwsArgumentError,
      );
      await expectLater(
        controller.saveSignals(List.filled(6, HomeSignal.steps)),
        throwsArgumentError,
      );
      final selected = [
        HomeSignal.steps,
        HomeSignal.distance,
        HomeSignal.hrv,
        HomeSignal.rhr,
        HomeSignal.sleep,
        HomeSignal.temperature,
      ];
      await controller.saveSignals(selected);
      await controller.reload();
      expect(controller.signals, selected);
      preferences.fail = true;
      await expectLater(
        controller.saveSignals(HomeSignal.defaults),
        throwsStateError,
      );
      expect(controller.signals, selected);
      controller.dispose();
    },
  );
  test(
    'photo wraps through all 26 options and failed persistence keeps current photo',
    () async {
      final preferences = MemoryHomePreferences()..currentPhoto = 25;
      final controller = HomeController(
        repository: DemoHomeRepository(),
        preferences: preferences,
      );
      await controller.initialize();
      await controller.nextPhoto();
      expect(controller.photo, 0);
      preferences.fail = true;
      await expectLater(controller.nextPhoto(), throwsStateError);
      expect(controller.photo, 0);
      controller.dispose();
    },
  );
  test('disposed controller ignores a pending response', () async {
    final repository = _PendingRepository();
    final controller = HomeController(
      repository: repository,
      preferences: MemoryHomePreferences(),
    );
    final future = controller.initialize();
    controller.dispose();
    repository.requests.single.completeError(const ApiException('offline'));
    await future;
    expect(controller.snapshot, isNull);
  });
  test(
    'calendar-day arithmetic handles month boundaries without time drift',
    () {
      expect(homeDateKey(homeDay(DateTime(2026, 3, 1, 23), 1)), '2026-02-28');
      expect(HomeSignal.steps.format(0, 'pt'), '0');
      expect(HomeSignal.sleep.format(null, 'pt'), '—');
      expect(HomeSignal.sleep.format(462, 'pt'), '7h42');
    },
  );
}
