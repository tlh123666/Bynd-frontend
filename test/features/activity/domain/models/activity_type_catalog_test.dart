import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/features/activity/domain/models/activity_type.dart';
import 'package:new_jcvital/features/activity/domain/models/activity_type_catalog.dart';

void main() {
  group('ActivityTypeCatalog', () {
    test('包含网页原型中的全部 140 个活动且 ID 唯一', () {
      final ids = ActivityTypeCatalog.all.map((type) => type.id).toSet();
      final localizationKeys = ActivityTypeCatalog.all
          .map((type) => type.localizationKey)
          .toSet();

      expect(ActivityTypeCatalog.all, hasLength(140));
      expect(ids, hasLength(ActivityTypeCatalog.all.length));
      expect(localizationKeys, hasLength(ActivityTypeCatalog.all.length));
      expect(ActivityTypeCatalog.byId, hasLength(140));
    });

    test('未知活动 ID 返回 null，不会静默选择其他活动', () {
      expect(ActivityTypeCatalog.findById('unknown-activity'), isNull);
    });

    test('活动分组和实时页家族数量与源码映射一致', () {
      int countCategory(ActivityCategory category) => ActivityTypeCatalog.all
          .where((type) => type.category == category)
          .length;
      int countPage(ActivityLivePageFamily family) => ActivityTypeCatalog.all
          .where((type) => type.livePageFamily == family)
          .length;

      expect(countCategory(ActivityCategory.cardio), 27);
      expect(countCategory(ActivityCategory.strength), 14);
      expect(countCategory(ActivityCategory.sports), 39);
      expect(countCategory(ActivityCategory.combat), 11);
      expect(countCategory(ActivityCategory.aquatic), 12);
      expect(countCategory(ActivityCategory.mindBody), 11);
      expect(countCategory(ActivityCategory.recovery), 7);
      expect(countCategory(ActivityCategory.other), 19);

      expect(countPage(ActivityLivePageFamily.map), 24);
      expect(countPage(ActivityLivePageFamily.eventStages), 3);
      expect(countPage(ActivityLivePageFamily.pool), 1);
      expect(countPage(ActivityLivePageFamily.match), 48);
      expect(countPage(ActivityLivePageFamily.cardio), 17);
      expect(countPage(ActivityLivePageFamily.calm), 7);
      expect(countPage(ActivityLivePageFamily.stress), 5);
      expect(countPage(ActivityLivePageFamily.daily), 17);
      expect(countPage(ActivityLivePageFamily.strength), 9);
      expect(countPage(ActivityLivePageFamily.overview), 9);
      expect(
        ActivityTypeCatalog.all.where((type) => type.hasRouteToggle),
        hasLength(26),
      );
    });

    test('保留容易因分组而误判的页面分流例外', () {
      expect(
        ActivityTypeCatalog.findById('hyrox')?.livePageFamily,
        ActivityLivePageFamily.eventStages,
      );
      expect(
        ActivityTypeCatalog.findById('box-fitness')?.livePageFamily,
        ActivityLivePageFamily.match,
      );
      expect(
        ActivityTypeCatalog.findById('zumba')?.livePageFamily,
        ActivityLivePageFamily.cardio,
      );
      expect(
        ActivityTypeCatalog.findById('yoga')?.livePageFamily,
        ActivityLivePageFamily.calm,
      );
    });

    test('路线开关只影响地图页活动，不覆盖赛事页面', () {
      final running = ActivityTypeCatalog.findById('corrida')!;
      final triathlon = ActivityTypeCatalog.findById('triatlo')!;
      final yoga = ActivityTypeCatalog.findById('yoga')!;

      expect(running.hasRouteToggle, isTrue);
      expect(
        running.resolveLivePageFamily(routeRecordingEnabled: true),
        ActivityLivePageFamily.map,
      );
      expect(
        running.resolveLivePageFamily(routeRecordingEnabled: false),
        ActivityLivePageFamily.overview,
      );
      expect(
        triathlon.resolveLivePageFamily(routeRecordingEnabled: false),
        ActivityLivePageFamily.eventStages,
      );
      expect(
        yoga.resolveLivePageFamily(routeRecordingEnabled: true),
        ActivityLivePageFamily.calm,
      );
    });

    test('力量组能力与活动分组分开表达', () {
      final weightTraining = ActivityTypeCatalog.findById('musculacao')!;
      final hyrox = ActivityTypeCatalog.findById('hyrox')!;

      expect(weightTraining.category, ActivityCategory.strength);
      expect(weightTraining.usesStrengthSets, isTrue);
      expect(hyrox.category, ActivityCategory.strength);
      expect(hyrox.usesStrengthSets, isFalse);
    });

    test('训练与非训练会话使用不同的结束反馈', () {
      expect(ActivityTypeCatalog.findById('corrida')!.isTraining, isTrue);
      expect(ActivityTypeCatalog.findById('sauna')!.isTraining, isFalse);
      expect(ActivityTypeCatalog.findById('games')!.isTraining, isFalse);
    });

    test('本地化键从稳定 ID 派生且不包含连字符', () {
      final type = ActivityTypeCatalog.findById('mountain-bike')!;

      expect(type.localizationKey, 'activity_type_mountain_bike');
    });
  });
}
