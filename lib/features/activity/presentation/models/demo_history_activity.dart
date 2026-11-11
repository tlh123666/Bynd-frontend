/// 历史页面使用的静态示例；数值不来自设备或真实健康算法。
enum DemoActivityKind { strength, sauna }

class DemoHistoryActivity {
  const DemoHistoryActivity({
    required this.kind,
    required this.isToday,
    required this.start,
    required this.end,
    required this.duration,
    required this.calories,
    required this.averageHeartRate,
    required this.maximumHeartRate,
    required this.load,
    required this.heartRateSamples,
    required this.zoneMinutes,
    this.typeId,
    this.dayOffset,
    this.isRegistrationPreview = false,
  });

  /// 登记预览保留目录中的稳定 ID 和所选日期。
  final String? typeId;
  final int? dayOffset;
  final bool isRegistrationPreview;
  final DemoActivityKind kind;
  final bool isToday;
  final String start, end;
  final int duration, calories, averageHeartRate, maximumHeartRate, load;
  final List<int> heartRateSamples;

  /// 示例分区时长，和真实设备的心率分区计算无关。
  final List<int> zoneMinutes;

  /// 仅调整内存中的示例时间，分区按原示例比例缩放。
  DemoHistoryActivity withTime(String newStart, int newDuration) {
    final parts = newStart.split(':');
    final endMinutes =
        (int.parse(parts[0]) * 60 + int.parse(parts[1]) + newDuration) % 1440;
    final newEnd =
        '${(endMinutes ~/ 60).toString().padLeft(2, '0')}:${(endMinutes % 60).toString().padLeft(2, '0')}';
    final zones = zoneMinutes
        .map((value) => (value * newDuration / duration).floor())
        .toList();
    final used = zones.fold<int>(0, (sum, value) => sum + value);
    final largest = zoneMinutes.indexOf(
      zoneMinutes.reduce((a, b) => a > b ? a : b),
    );
    zones[largest] += newDuration - used;
    return DemoHistoryActivity(
      kind: kind,
      typeId: typeId,
      dayOffset: dayOffset,
      isRegistrationPreview: isRegistrationPreview,
      isToday: isToday,
      start: newStart,
      end: newEnd,
      duration: newDuration,
      calories: calories,
      averageHeartRate: averageHeartRate,
      maximumHeartRate: maximumHeartRate,
      load: load,
      heartRateSamples: heartRateSamples,
      zoneMinutes: List.unmodifiable(zones),
    );
  }

  /// 使用固定示例心率绘制登记预览；输入字段由用户选择，指标并非设备测量。
  factory DemoHistoryActivity.registrationPreview({
    required String typeId,
    required int dayOffset,
    required int startMinutes,
    required int duration,
    required int load,
  }) {
    String time(int minutes) =>
        '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';
    // 示例比例随时长缩放，并将余数分配到主要分区，保持总时长一致。
    final zone0 = (duration * 3 / 45).floor();
    final zone1 = (duration * 8 / 45).floor();
    final zone3 = (duration * 4 / 45).floor();
    return DemoHistoryActivity(
      kind: DemoActivityKind.strength,
      typeId: typeId,
      dayOffset: dayOffset,
      isRegistrationPreview: true,
      isToday: dayOffset == 0,
      start: time(startMinutes),
      end: time((startMinutes + duration) % 1440),
      duration: duration,
      calories: 364,
      averageHeartRate: 124,
      maximumHeartRate: 144,
      load: load,
      zoneMinutes: [
        zone0,
        zone1,
        duration - zone0 - zone1 - zone3,
        zone3,
        0,
        0,
      ],
      heartRateSamples: const [
        84,
        85,
        96,
        110,
        116,
        125,
        137,
        125,
        126,
        138,
        125,
        126,
        138,
        124,
        126,
        138,
        124,
        126,
        144,
        124,
        126,
        138,
        125,
        126,
        138,
        125,
        126,
        138,
        124,
        126,
        138,
        125,
        126,
        138,
        125,
        126,
        138,
        125,
        126,
        138,
        125,
        126,
        144,
        125,
        126,
        138,
        110,
        106,
      ],
    );
  }

  static const examples = <DemoHistoryActivity>[
    DemoHistoryActivity(
      kind: DemoActivityKind.strength,
      isToday: true,
      start: '07:50',
      end: '08:25',
      duration: 35,
      calories: 170,
      averageHeartRate: 97,
      maximumHeartRate: 112,
      load: 28,
      zoneMinutes: [20, 10, 5, 0, 0, 0],
      heartRateSamples: [
        80,
        85,
        90,
        93,
        96,
        97,
        98,
        99,
        102,
        104,
        106,
        112,
        105,
        100,
        97,
        95,
        93,
        91,
        90,
        87,
      ],
    ),
    DemoHistoryActivity(
      kind: DemoActivityKind.sauna,
      isToday: false,
      start: '19:40',
      end: '20:00',
      duration: 20,
      calories: 25,
      averageHeartRate: 83,
      maximumHeartRate: 88,
      load: 6,
      zoneMinutes: [20, 0, 0, 0, 0, 0],
      heartRateSamples: [
        78,
        79,
        81,
        80,
        82,
        84,
        85,
        84,
        83,
        85,
        88,
        86,
        84,
        83,
        82,
        81,
        81,
        82,
        76,
        71,
      ],
    ),
  ];
}
