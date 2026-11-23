import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/sleep_models.dart';

Future<Uint8List> buildSleepReport(
  SleepTrend trend, {
  required bool portuguese,
  required bool demo,
}) async {
  final font = pw.Font.ttf(await rootBundle.load('assets/fonts/Geist.ttf'));
  final title = portuguese ? 'Relatório de sono' : 'Sleep report';
  final document = pw.Document(title: 'BYND · $title', author: 'BYND');
  final recorded = trend.days.where((day) => day['hasData'] == true);
  final headings = portuguese
      ? ['Data', 'Sono', 'Acordado', 'Leve', 'Profundo', 'REM', 'Nota']
      : ['Date', 'Sleep', 'Awake', 'Light', 'Deep', 'REM', 'Score'];
  const stages = [
    'sleepMinutes',
    'awakeMinutes',
    'lightSleepMinutes',
    'deepSleepMinutes',
    'remSleepMinutes',
  ];
  document.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(base: font, bold: font),
      build: (_) => [
        pw.Text('BYND · $title', style: const pw.TextStyle(fontSize: 24)),
        pw.SizedBox(height: 12),
        pw.Text(
          demo
              ? (portuguese
                    ? 'Demonstração · Dados simulados'
                    : 'Demonstration · Simulated data')
              : (portuguese
                    ? 'Noites registradas no período disponível.'
                    : 'Recorded nights in the available period.'),
        ),
        pw.SizedBox(height: 18),
        pw.TableHelper.fromTextArray(
          headers: headings,
          data: [
            for (final night in recorded)
              [
                night['statDate'] ?? night['date'] ?? '—',
                for (final field in stages)
                  if (night[field] case final num minutes)
                    '${minutes.round()} min'
                  else
                    '—',
                if (night['sleepScore'] case final num score)
                  '${score.round()}'
                else
                  '—',
              ],
          ],
        ),
      ],
    ),
  );
  return document.save();
}
