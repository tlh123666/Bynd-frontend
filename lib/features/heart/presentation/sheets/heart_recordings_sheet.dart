import 'package:flutter/material.dart';
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
    super.key,
  });
  final HeartController controller;
  final String? initialId;
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
    await showAppContentSheet<void>(
      context,
      (_) => HeartAccountGuard(
        controller: widget.controller,
        child: _RecordingLoader(
          repository: widget.controller.repository,
          id: id,
        ),
      ),
      glass: true,
      dismissible: false,
      enableDrag: false,
    );
    if (mounted && !widget.controller.accountChanged) await _load();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      AppSheetHeader(
        title: heartText(
          context,
          'Registros de ECG e pulso',
          'ECG and pulse recordings',
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
            for (final record in _records)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppMetricCard(
                  onTap: () => _open(record.id),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.monitor_heart_outlined,
                        color: AppHeartStyle.family,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${heartShortDate(context, record.measuredAt)} · ${heartClock(record.measuredAt)}',
                              style: AppHeartStyle.body,
                            ),
                            Text(
                              '${record.kind.toUpperCase()} · ${heartNumber(record.number('heartRate'))} bpm',
                              style: AppHeartStyle.caption,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppHeartStyle.muted,
                      ),
                    ],
                  ),
                ),
              ),
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
