import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../domain/heart_models.dart';

class HeartExports {
  static String _cell(Object? value) =>
      '"${(value ?? '').toString().replaceAll('"', '""')}"';
  static Uint8List csvBytes(List<List<Object?>> rows) => Uint8List.fromList([
    0xef,
    0xbb,
    0xbf,
    ...utf8.encode(rows.map((r) => r.map(_cell).join(',')).join('\r\n')),
  ]);
  static Uint8List dayCsv(HeartSnapshot data) => csvBytes([
    [
      'BYND',
      'date',
      heartDate(data.date),
      'source',
      data.demo ? 'demo' : 'stored measurements',
    ],
    ['measuredAt', 'bpm'],
    for (final p in data.points) [p.at.toUtc().toIso8601String(), p.bpm],
  ]);
  static Uint8List recordingCsv(HeartRecording record) => csvBytes([
    [
      'BYND',
      'record',
      record.id,
      'signal',
      record.kind,
      'source',
      record.json['source'],
    ],
    [
      'measuredAt',
      record.measuredAt.toUtc().toIso8601String(),
      'durationMillis',
      record.duration,
    ],
    ['context', record.context, 'symptoms', record.symptoms.join(';')],
    [
      'sampleIndex',
      'rawValue',
      if (record.number('sampleRateHz') != null) 'offsetSeconds',
    ],
    for (var i = 0; i < record.samples.length; i++)
      [
        i,
        record.samples[i],
        if (record.number('sampleRateHz') != null)
          i / record.number('sampleRateHz')!,
      ],
  ]);
  static Future<void> shareCsv(
    Uint8List bytes,
    String filename, {
    Rect? origin,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(bytes, mimeType: 'text/csv')],
        fileNameOverrides: [filename],
        sharePositionOrigin: origin,
      ),
    );
  }

  static Future<void> shareText(String text, {Rect? origin}) async {
    await SharePlus.instance.share(
      ShareParams(text: text, sharePositionOrigin: origin),
    );
  }

  static Future<Uint8List> recordingPdf(
    HeartRecording record, {
    required bool portuguese,
  }) async {
    final font = pw.Font.ttf(await rootBundle.load('assets/fonts/Geist.ttf'));
    final pdf = pw.Document(title: 'BYND - ${record.label}', author: 'BYND');
    final samples = record.samples;
    final chunks = <List<int>>[];
    final part = math.max(1, (samples.length / 3).ceil());
    for (var start = 0; start < samples.length; start += part) {
      chunks.add(
        samples.sublist(start, math.min(start + part, samples.length)),
      );
    }
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: font),
        build: (context) => [
          pw.Text('BYND · ${record.label}', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 12),
          pw.Text(
            '${record.measuredAt.toIso8601String()} · ${record.json['timezone'] ?? ''}',
          ),
          pw.Text(
            '${record.number('heartRate') ?? '—'} bpm · ${(record.duration / 1000).toStringAsFixed(1)} s',
          ),
          pw.Text(
            '${portuguese ? 'Tipo de sinal' : 'Signal type'}: ${record.kind.toUpperCase()}',
          ),
          pw.Text(
            portuguese
                ? 'Ritmo não classificado. Este relatório não diagnostica arritmias.'
                : 'Rhythm unclassified. This report does not diagnose arrhythmias.',
          ),
          if (record.kind == 'ppg')
            pw.Text(
              portuguese
                  ? 'O traçado é uma onda óptica de pulso (PPG), não um ECG elétrico.'
                  : 'The trace is an optical pulse wave (PPG), not an electrical ECG.',
            ),
          if (record.json['source'] == 'demo')
            pw.Text(
              portuguese
                  ? 'DEMONSTRAÇÃO · DADOS SIMULADOS'
                  : 'DEMONSTRATION · SIMULATED DATA',
            ),
          pw.SizedBox(height: 16),
          if (!record.available)
            pw.Text(
              portuguese
                  ? 'O traçado está indisponível ou expirou.'
                  : 'The waveform is unavailable or has expired.',
            ),
          for (var index = 0; index < chunks.length; index++) ...[
            pw.Text(
              '${portuguese ? 'Trecho' : 'Segment'} ${index + 1} · ${portuguese ? 'amplitude relativa' : 'relative amplitude'}',
            ),
            pw.SizedBox(height: 5),
            pw.CustomPaint(
              size: const PdfPoint(480, 100),
              painter: (canvas, size) {
                final values = chunks[index],
                    low = values.reduce(math.min),
                    high = values.reduce(math.max),
                    range = math.max(1, high - low),
                    count = math.min(1200, values.length);
                canvas.setColor(PdfColors.grey300);
                canvas.setLineWidth(.4);
                for (var x = 0.0; x < size.x; x += 12) {
                  canvas.moveTo(x, 0);
                  canvas.lineTo(x, size.y);
                }
                for (var y = 0.0; y < size.y; y += 12) {
                  canvas.moveTo(0, y);
                  canvas.lineTo(size.x, y);
                }
                canvas.strokePath();
                canvas.setColor(PdfColors.black);
                canvas.setLineWidth(.7);
                for (var i = 0; i < count; i++) {
                  final value =
                          values[(i *
                                  (values.length - 1) /
                                  math.max(1, count - 1))
                              .round()],
                      x = i / math.max(1, count - 1) * size.x,
                      y = 10 + (value - low) / range * 80;
                  if (i == 0) {
                    canvas.moveTo(x, y);
                  } else {
                    canvas.lineTo(x, y);
                  }
                }
                canvas.strokePath();
              },
            ),
            pw.SizedBox(height: 14),
          ],
          pw.Text('${portuguese ? 'Contexto' : 'Context'}: ${record.context}'),
          pw.Text(
            '${portuguese ? 'Sintomas informados' : 'Reported symptoms'}: ${record.symptoms.isEmpty ? '—' : record.symptoms.join(', ')}',
          ),
          pw.Text(
            '${portuguese ? 'Dispositivo' : 'Device'}: ${record.json['deviceSerial']}',
          ),
          pw.Text(
            '${portuguese ? 'Amostras' : 'Samples'}: ${record.number('sampleCount') ?? samples.length} · ${record.number('sampleRateHz') == null ? (portuguese ? 'taxa de amostragem não informada' : 'sample rate not supplied') : '${record.number('sampleRateHz')} Hz'}',
          ),
          pw.SizedBox(height: 12),
          pw.Text(
            portuguese
                ? 'Não foi aplicada calibração em mm/mV. O CSV preserva os valores brutos do sensor.'
                : 'No mm/mV calibration was applied. The CSV preserves raw sensor values.',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
    return pdf.save();
  }

  static Future<void> sharePdf(
    HeartRecording record, {
    required bool portuguese,
    bool Function()? canShare,
  }) async {
    final bytes = await recordingPdf(record, portuguese: portuguese);
    if (canShare != null && !canShare()) return;
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'bynd-${record.label.toLowerCase()}-${record.id}.pdf',
    );
  }
}
