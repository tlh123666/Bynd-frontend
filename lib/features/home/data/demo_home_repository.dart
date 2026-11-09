import '../domain/home_models.dart';
import '../domain/home_repository.dart';

/// Explicit config/demo.json only. Samples mirror the reference prototype.
class DemoHomeRepository implements HomeRepository {
  final Map<String, List<HomeDiaryEvent>> _events = {};
  @override
  Future<HomeSnapshot> fetch(DateTime date, String locale) async {
    final past = homeDay(date).isBefore(homeDay(DateTime.now()));
    final en = locale.startsWith('en');
    const values = [
      462,
      6240,
      58,
      54,
      97,
      43,
      4600,
      1299,
      38,
      1394,
      399,
      14.2,
      .3,
    ];
    final captions = en
        ? [
            'goal 8h',
            'goal 8,000',
            'above 51 – 56',
            'below 55 – 67',
            'within 95 – 100',
            'great for 30–39',
          ]
        : [
            'meta 8h',
            'meta 8.000',
            'acima de 51 – 56',
            'abaixo de 55 – 67',
            'dentro de 95 – 100',
            'ótimo p/ 30–39',
          ];
    return HomeSnapshot(
      date: date,
      userId: 'demo',
      firstName: 'Clara',
      patterns: past ? null : 3,
      title: en
          ? (past
                ? 'The direction was to recover.'
                : 'The direction is to recover.')
          : (past ? 'A direção era recuperar.' : 'A direção é recuperar.'),
      paragraphs: [
        en
            ? (past
                  ? 'Recovery was 51 (your normal is 67 to 85), after 6h14 of sleep with a score of 72. You trained legs and glutes at 07:15 (55 min), took 5,944 steps and had your stress peak at 14:00. The next day, recovery rose to 57.'
                  : 'It was a light day, as your body needed: 6,240 steps by the afternoon and just a short workout. Tonight counts the most: over the last 3 nights you missed 4h04 of sleep. Slow down now and go to bed at 23h. If you do, tomorrow recovery should be close to 66.')
            : (past
                  ? 'A recuperação veio em 51 (seu normal é 67 a 85), depois de 6h14 de sono com nota 72. Você fez força · pernas e glúteos às 07:15 (55 min), deu 5.944 passos, teve o pico de estresse às 14:00. No dia seguinte, a recuperação subiu para 57.'
                  : 'O dia foi leve, como o corpo pedia: 6.240 passos até a tarde e só um treino curto. Esta noite é a que mais conta: nas últimas 3 noites faltaram 4h04 de sono. Desacelere agora e deite às 23h. Se fizer isso, amanhã a recuperação deve ficar perto de 66.'),
      ],
      recommendation: en
          ? 'Slow down now and go to bed at 23h.'
          : 'Desacelere agora e deite às 23h.',
      measurements: {
        for (final signal in HomeSignal.values)
          signal: HomeMeasurement(
            signal,
            value: values[signal.index],
            caption: signal.index < 6 ? captions[signal.index] : '',
            status:
                [
                  HomeSignal.steps,
                  HomeSignal.rhr,
                  HomeSignal.hrv,
                ].contains(signal)
                ? HomeSignalStatus.attention
                : HomeSignalStatus.good,
          ),
      },
    );
  }

  @override
  Future<List<HomeHistoryPoint>> history(
    HomeSignal signal,
    DateTime date,
    String locale,
  ) async {
    final snapshot = await fetch(date, locale);
    final value = snapshot.measurement(signal).value!;
    return List.generate(
      7,
      (i) => HomeHistoryPoint(
        homeDay(date, 6 - i),
        signal == HomeSignal.sleep
            ? [360, 397, 411, 442, 374, 466, 462][i]
            : value * [0.92, 0.96, 0.89, 1.02, 0.97, 1.01, 1][i],
      ),
    );
  }

  @override
  Future<List<HomeDiaryEvent>> diary(DateTime date, String locale) async =>
      List.unmodifiable(_events[homeDateKey(date)] ?? []);
  @override
  Future<void> saveDiary(
    DateTime date,
    String locale, {
    required String category,
    required String label,
    required String note,
  }) async {
    (_events[homeDateKey(date)] ??= []).add(
      HomeDiaryEvent(
        id: '${DateTime.now().microsecondsSinceEpoch}',
        label: label,
        category: category,
        note: note,
        occurredAt: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {}
}
