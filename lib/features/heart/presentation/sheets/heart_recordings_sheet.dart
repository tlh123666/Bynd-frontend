import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/app_sheet_controls.dart';
import '../../application/heart_controller.dart';
import '../../domain/heart_models.dart';
import '../heart_copy.dart';
import '../widgets/heart_account_guard.dart';
import 'heart_recording_report.dart';

class HeartRecordingsSheet extends StatefulWidget {
  const HeartRecordingsSheet({
    required this.controller,
    this.initialId,
    this.onNewRecording,
    super.key,
  });
  final HeartController controller;
  final String? initialId;
  final Future<void> Function()? onNewRecording;
  @override
  State<HeartRecordingsSheet> createState() => _HeartRecordingsSheetState();
}

class _HeartRecordingsSheetState extends State<HeartRecordingsSheet> {
  final _records = <HeartRecording>[];
  String? _next;
  bool _loading = false;
  Object? _error;
  @override
  void initState() {
    super.initState();
    _load();
    if (widget.initialId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _open(widget.initialId!);
      });
    }
  }

  Future<void> _load({bool more = false}) async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await widget.controller.repository.recordings(
        cursor: more ? _next : null,
      );
      if (mounted && !widget.controller.accountChanged) {
        setState(() {
          if (!more) _records.clear();
          for (final row in page.items) {
            if (!_records.any((r) => r.id == row.id)) _records.add(row);
          }
          _next = page.next;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _open(String id) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: AppHealthStyle.canvas,
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: AppHealthStyle.background,
            ),
            child: SafeArea(
              child: HeartAccountGuard(
                controller: widget.controller,
                child: _RecordingLoader(
                  repository: widget.controller.repository,
                  id: id,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    if (mounted && !widget.controller.accountChanged) await _load();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      AppSheetHeader(
        title: heartText(
          context,
          'Histórico de ECG e pulso',
          'ECG and pulse history',
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            if (_records.isEmpty && !_loading && _error == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 44),
                child: Text(
                  heartText(
                    context,
                    'Nenhuma leitura registrada.',
                    'No recordings yet.',
                  ),
                  style: AppHeartStyle.body,
                ),
              ),
            if (_records.isNotEmpty) ...[
              AppHealthHero(
                value: '${_records.length}',
                label: heartText(
                  context,
                  'leituras carregadas',
                  'loaded recordings',
                ),
              ),
              const SizedBox(height: 18),
              Text(
                heartText(
                  context,
                  'Batimentos registrados',
                  'Recorded heart rates',
                ),
                style: AppHealthStyle.title,
              ),
              const SizedBox(height: 16),
              AppHealthTrend(
                points: [
                  for (final record in _records.reversed)
                    (
                      date: record.measuredAt,
                      value: record.number('heartRate'),
                    ),
                ],
                selected: _records.first.measuredAt,
                minimum: 40,
                maximum: 120,
                marker: AppHealthStyle.pulse,
                connect: false,
                unit: 'bpm',
              ),
              if (_records.any((record) => record.number('heartRate') != null))
                AppChartLegend([
                  (
                    AppHealthStyle.pulse,
                    heartText(
                      context,
                      'Batimento medido',
                      'Recorded heart rate',
                    ),
                  ),
                ]),
              for (final (index, record) in _records.indexed) ...[
                if (index == 0 ||
                    _records[index - 1].measuredAt.month !=
                        record.measuredAt.month ||
                    _records[index - 1].measuredAt.year !=
                        record.measuredAt.year) ...[
                  const SizedBox(height: 24),
                  AppHealthSection(
                    DateFormat.yMMMM(
                      Localizations.localeOf(context).toLanguageTag(),
                    ).format(record.measuredAt),
                    Icons.monitor_heart_outlined,
                  ),
                ],
                AppHealthRow(
                  label: heartShortDate(context, record.measuredAt),
                  subtitle:
                      '${record.label} · ${heartClock(record.measuredAt)}',
                  value: record.number('heartRate') == null
                      ? '—'
                      : '${record.number('heartRate')} bpm',
                  onTap: () => _open(record.id),
                ),
              ],
            ],
            if (_loading) const Center(child: AppLoadingIndicator()),
            if (_error != null)
              AppGlassPill(
                label: heartText(context, 'Tentar novamente', 'Retry'),
                onPressed: () =>
                    _load(more: _records.isNotEmpty && _next != null),
              ),
            if (!_loading && _next != null)
              AppGlassPill(
                label: heartText(context, 'Carregar mais', 'Load more'),
                onPressed: () => _load(more: true),
              ),
          ],
        ),
      ),
      if (widget.onNewRecording != null)
        AppSheetSaveButton(
          label: heartText(context, 'Fazer ECG', 'Record ECG'),
          onPressed: () async {
            await widget.onNewRecording!();
            if (mounted && !widget.controller.accountChanged) await _load();
          },
        ),
    ],
  );
}

class _RecordingLoader extends StatefulWidget {
  const _RecordingLoader({required this.repository, required this.id});
  final HeartRepository repository;
  final String id;
  @override
  State<_RecordingLoader> createState() => _RecordingLoaderState();
}

class _RecordingLoaderState extends State<_RecordingLoader> {
  late Future<HeartRecording> _future = widget.repository.recording(widget.id);
  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _future,
    builder: (context, s) {
      if (s.hasData) {
        return HeartRecordingReport(
          repository: widget.repository,
          record: s.data!,
          onDeleted: () {},
        );
      }
      return Column(
        children: [
          AppSheetHeader(title: 'ECG'),
          Expanded(
            child: Center(
              child: s.hasError
                  ? AppGlassPill(
                      label: heartText(context, 'Tentar novamente', 'Retry'),
                      onPressed: () => setState(
                        () => _future = widget.repository.recording(widget.id),
                      ),
                    )
                  : const AppLoadingIndicator(),
            ),
          ),
        ],
      );
    },
  );
}
