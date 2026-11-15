import 'package:flutter/material.dart';
import '../../../../core/auth/auth_session.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/app_sheet_controls.dart';
import '../../application/heart_exports.dart';
import '../../domain/heart_models.dart';
import '../heart_copy.dart';
import '../widgets/heart_charts.dart';
import '../widgets/heart_widgets.dart';

class HeartRecordingReport extends StatefulWidget {
  const HeartRecordingReport({
    required this.repository,
    required this.record,
    this.onDeleted,
    super.key,
  });
  final HeartRepository repository;
  final HeartRecording record;
  final VoidCallback? onDeleted;
  @override
  State<HeartRecordingReport> createState() => _HeartRecordingReportState();
}

class _HeartRecordingReportState extends State<HeartRecordingReport> {
  late HeartRecording _record = widget.record;
  late String _context = widget.record.context;
  late Set<String> _symptoms = widget.record.symptoms.toSet();
  bool _saving = false, _exporting = false;
  bool _discarding = false, _allowClose = false;
  bool get _dirty =>
      _context != _record.context ||
      _symptoms.length != _record.symptoms.length ||
      !_symptoms.containsAll(_record.symptoms);
  String? _error;
  Future<void> _close() async {
    if (_saving || _exporting || _discarding) return;
    _discarding = true;
    final close =
        !_dirty ||
        await AppConfirmationSheet.show(
          context,
          title: heartText(
            context,
            'Descartar observações?',
            'Discard observations?',
          ),
          message: heartText(
            context,
            'Suas alterações ainda não foram salvas.',
            'Your changes have not been saved yet.',
          ),
          confirmLabel: heartText(context, 'Descartar', 'Discard'),
          cancelLabel: heartText(context, 'Continuar', 'Continue'),
        );
    _discarding = false;
    if (!mounted || !close) return;
    setState(() => _allowClose = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context);
    });
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final updated = await widget.repository.annotate(
        _record.id,
        _context,
        _symptoms.toList(),
      );
      if (mounted) setState(() => _record = updated);
    } catch (e) {
      if (mounted) {
        setState(
          () => _error = heartText(
            context,
            'Não foi possível salvar. Suas escolhas continuam aqui.',
            'Could not save. Your changes are kept here.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Rect? _origin() {
    final box = context.findRenderObject();
    return box is RenderBox ? box.localToGlobal(Offset.zero) & box.size : null;
  }

  Future<void> _export(bool pdf) async {
    if (_exporting) return;
    if (_dirty) {
      await _save();
      if (!mounted || _dirty) return;
    }
    setState(() {
      _exporting = true;
      _error = null;
    });
    final token = AuthSession.instance.accessToken;
    try {
      if (pdf) {
        await HeartExports.sharePdf(
          _record,
          portuguese: Localizations.localeOf(context).languageCode == 'pt',
          canShare: () => mounted && AuthSession.instance.accessToken == token,
        );
      } else {
        await HeartExports.shareCsv(
          HeartExports.recordingCsv(_record),
          'bynd-${_record.kind}-${_record.id}.csv',
          origin: _origin(),
        );
      }
    } catch (e, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: stack,
          library: 'heart report export',
        ),
      );
      if (mounted) {
        setState(
          () => _error = heartText(
            context,
            'Não foi possível exportar. Tente novamente.',
            'Could not export. Please retry.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await AppConfirmationSheet.show(
      context,
      title: heartText(context, 'Excluir leitura?', 'Delete recording?'),
      message: heartText(
        context,
        'O relatório e seu traçado serão removidos da sua conta.',
        'The report and its waveform will be removed from your account.',
      ),
      confirmLabel: heartText(context, 'Excluir', 'Delete'),
      cancelLabel: heartText(context, 'Cancelar', 'Cancel'),
    );
    if (!confirmed || !mounted) return;
    setState(() => _saving = true);
    try {
      await widget.repository.deleteRecording(_record.id);
      if (mounted) {
        widget.onDeleted?.call();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => _error = heartText(
            context,
            'Não foi possível excluir. Tente novamente.',
            'Could not delete. Please retry.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final record = _record, isDemo = record.json['source'] == 'demo';
    return PopScope(
      canPop: !_saving && !_exporting && (!_dirty || _allowClose),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _close();
      },
      child: Column(
        children: [
          AppSheetHeader(
            title: record.kind == 'ppg'
                ? heartText(context, 'Leitura do pulso', 'Pulse recording')
                : record.label,
            canClose: !_saving && !_exporting,
            onClose: _close,
          ),
          Expanded(
            child: AbsorbPointer(
              absorbing: _saving || _exporting,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 38),
                children: [
                  Text(
                    heartNumber(record.number('heartRate')),
                    style: AppHeartStyle.number,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'bpm · ${heartShortDate(context, record.measuredAt)} · ${heartClock(record.measuredAt)}',
                    style: AppHeartStyle.caption,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    heartText(
                      context,
                      'Seu sinal foi registrado.',
                      'Your signal was recorded.',
                    ),
                    style: AppHeartStyle.title,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    heartText(
                      context,
                      'Ritmo não classificado. Não foi fornecida uma análise validada de arritmias para esta leitura.',
                      'Rhythm unclassified. No validated arrhythmia analysis was supplied for this recording.',
                    ),
                    style: AppHeartStyle.body,
                  ),
                  if (isDemo) ...[
                    const SizedBox(height: 14),
                    Text(
                      heartText(
                        context,
                        'DEMONSTRAÇÃO · DADOS SIMULADOS',
                        'DEMONSTRATION · SIMULATED DATA',
                      ),
                      style: AppHeartStyle.kicker,
                    ),
                  ],
                  if (record.kind == 'ppg') ...[
                    const SizedBox(height: 14),
                    Text(
                      heartText(
                        context,
                        'O sensor registrou uma onda de pulso óptica (PPG). Este traçado não é um ECG elétrico.',
                        'The sensor recorded an optical pulse wave (PPG). This trace is not an electrical ECG.',
                      ),
                      style: AppHeartStyle.body,
                    ),
                  ],
                  const SizedBox(height: 26),
                  AppMetricCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HeartLabel(
                          heartText(context, 'O traçado', 'The trace'),
                        ),
                        const SizedBox(height: 14),
                        if (record.available)
                          HeartWaveform(samples: record.samples, height: 170)
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              record.status == 'expired'
                                  ? heartText(
                                      context,
                                      'O prazo de retenção do traçado terminou. O resumo continua disponível.',
                                      'The waveform retention period has ended. The summary remains available.',
                                    )
                                  : heartText(
                                      context,
                                      'Traçado indisponível.',
                                      'Waveform unavailable.',
                                    ),
                              style: AppHeartStyle.caption,
                            ),
                          ),
                        Text(
                          heartText(
                            context,
                            'Amplitude relativa · sem calibração em mm/mV',
                            'Relative amplitude · no mm/mV calibration',
                          ),
                          style: AppHeartStyle.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  HeartLabel(
                    heartText(context, 'Como você estava?', 'How were you?'),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final entry in heartContexts.entries)
                        ChoiceChip(
                          label: Text(
                            heartText(context, entry.value.$1, entry.value.$2),
                          ),
                          selected: _context == entry.key,
                          selectedColor: AppColors.glassBorderStrong,
                          onSelected: (_) =>
                              setState(() => _context = entry.key),
                        ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  HeartLabel(
                    heartText(
                      context,
                      'Sentiu algo?',
                      'Did you feel anything?',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final entry in heartSymptoms.entries)
                        FilterChip(
                          label: Text(
                            heartText(context, entry.value.$1, entry.value.$2),
                          ),
                          selected: _symptoms.contains(entry.key),
                          selectedColor: AppColors.glassBorderStrong,
                          onSelected: (on) => setState(() {
                            if (entry.key == 'none') {
                              _symptoms = on ? {'none'} : {};
                            } else {
                              _symptoms.remove('none');
                              if (on) {
                                _symptoms.add(entry.key);
                              } else {
                                _symptoms.remove(entry.key);
                              }
                            }
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  AppButton(
                    label: heartText(
                      context,
                      'Salvar observações',
                      'Save observations',
                    ),
                    loading: _saving,
                    onPressed: _exporting ? null : _save,
                  ),
                  const SizedBox(height: 28),
                  HeartLabel(
                    heartText(
                      context,
                      'Detalhes da leitura',
                      'Recording details',
                    ),
                  ),
                  HeartReadingRow(
                    heartText(context, 'Duração', 'Duration'),
                    '${(record.duration / 1000).toStringAsFixed(1)} s',
                  ),
                  HeartReadingRow(
                    heartText(context, 'Tipo de sinal', 'Signal type'),
                    record.kind.toUpperCase(),
                  ),
                  HeartReadingRow(
                    heartText(context, 'Amostras', 'Samples'),
                    '${record.number('sampleCount') ?? record.samples.length}',
                  ),
                  HeartReadingRow(
                    heartText(context, 'Taxa de amostragem', 'Sample rate'),
                    record.number('sampleRateHz') == null
                        ? '—'
                        : '${record.number('sampleRateHz')} Hz',
                  ),
                  HeartReadingRow(
                    'VFC / HRV',
                    record.number('hrvMs') == null
                        ? '—'
                        : '${record.number('hrvMs')} ms',
                  ),
                  const SizedBox(height: 22),
                  AppButton(
                    label: heartText(
                      context,
                      'Salvar PDF para o médico',
                      'Export report PDF',
                    ),
                    onPressed: _exporting || _saving
                        ? null
                        : () => _export(true),
                    loading: _exporting,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: heartText(
                      context,
                      'Exportar amostras CSV',
                      'Export samples CSV',
                    ),
                    variant: AppButtonVariant.secondary,
                    onPressed: _exporting || _saving
                        ? null
                        : () => _export(false),
                  ),
                  if (widget.onDeleted != null) ...[
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _saving || _exporting ? null : _delete,
                      icon: const Icon(Icons.delete_outline),
                      label: Text(
                        heartText(
                          context,
                          'Excluir leitura',
                          'Delete recording',
                        ),
                      ),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 18),
                    Text(
                      _error!,
                      style: AppHeartStyle.body.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
