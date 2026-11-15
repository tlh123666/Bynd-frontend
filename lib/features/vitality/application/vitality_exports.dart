import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import '../domain/vitality_models.dart';

abstract final class VitalityExports {
  static String _cell(Object? value) =>
      '"${(value ?? '').toString().replaceAll('"', '""')}"';
  static Uint8List csv(VitalitySnapshot s) => Uint8List.fromList([
    0xef,
    0xbb,
    0xbf,
    ...utf8.encode(
      [
        [
          'BYND',
          s.kind.name,
          vitalityDate(s.date),
          'source',
          s.demo ? 'reference_demo' : 'rules_estimate',
          'algorithm_version',
          1,
        ],
        ['date', 'score'],
        for (final p in s.trend) [vitalityDate(p.at), p.score],
        [],
        ['observed_at', 'estimated_score'],
        for (final p in s.observations)
          [p.at.toUtc().toIso8601String(), p.score],
        [],
        ['metric', 'value'],
        for (final entry in s.metrics.entries) [entry.key, entry.value],
      ].map((row) => row.map(_cell).join(',')).join('\r\n'),
    ),
  ]);
  static Future<Uint8List> pdf({
    required String title,
    required String explanation,
    required List<List<String>> rows,
  }) async {
    final font = pw.Font.ttf(await rootBundle.load('assets/fonts/Geist.ttf'));
    final document = pw.Document(title: 'BYND · $title', author: 'BYND');
    document.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: font, bold: font),
        build: (_) => [
          pw.Text('BYND · $title', style: const pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 12),
          pw.Text(explanation),
          pw.SizedBox(height: 20),
          for (final row in rows)
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 5),
              child: pw.Row(
                children: [
                  pw.Expanded(child: pw.Text(row[0])),
                  pw.Text(row[1]),
                ],
              ),
            ),
        ],
      ),
    );
    return document.save();
  }
}
