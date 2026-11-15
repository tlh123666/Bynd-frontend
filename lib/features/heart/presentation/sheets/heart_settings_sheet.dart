import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/app_sheet_controls.dart';
import '../../../../shared/widgets/day_calendar.dart';
import '../../application/heart_controller.dart';
import '../../application/heart_exports.dart';
import '../../domain/heart_models.dart';
import '../heart_copy.dart';
import '../widgets/heart_widgets.dart';

class HeartSettingsSheet extends StatefulWidget {
  const HeartSettingsSheet({required this.controller, super.key});
  final HeartController controller;
  @override
  State<HeartSettingsSheet> createState() => _HeartSettingsSheetState();
}

class _HeartSettingsSheetState extends State<HeartSettingsSheet> {
  late HeartPreferences _preferences = widget.controller.snapshot!.preferences;
  bool _saving = false, _exporting = false;
  String? _error;
  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    final okay = await widget.controller.savePreferences(_preferences);
    if (!mounted) return;
    if (okay) {
      Navigator.pop(context);
    } else {
      setState(() {
        _saving = false;
        _error = heartText(
          context,
          'Não foi possível salvar. Suas escolhas continuam aqui.',
          'Could not save. Your choices are kept here.',
        );
      });
    }
  }

  Rect? _origin() {
    final box = context.findRenderObject();
    return box is RenderBox ? box.localToGlobal(Offset.zero) & box.size : null;
  }

  Future<void> _export(bool csv) async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      final data = widget.controller.snapshot!;
      if (csv) {
        await HeartExports.shareCsv(
          HeartExports.dayCsv(data),
          'bynd-heart-${heartDate(data.date)}.csv',
          origin: _origin(),
        );
      } else {
        await HeartExports.shareText(
          'BYND · ${heartDate(data.date)}\n${data.format(HeartMetric.pulse)} bpm\n${heartText(context, 'FC em repouso', 'Resting HR')}: ${data.format(HeartMetric.resting)} bpm',
          origin: _origin(),
        );
      }
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    final data = widget.controller.snapshot;
    if (data == null) return const SizedBox.shrink();
    final unavailable = data.unavailable.contains('preferences');
    return PopScope(
      canPop: !_saving && !_exporting,
      child: Column(
        children: [
          AppSheetHeader(
            title: heartText(context, 'Ajustes', 'Settings'),
            canClose: !_saving && !_exporting,
          ),
          Expanded(
            child: AbsorbPointer(
              absorbing: _saving || _exporting,
              child: ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  Text(
                    heartText(
                      context,
                      'Os avisos e medidas do Coração.',
                      'Heart measurements and notices.',
                    ),
                    style: AppHeartStyle.body,
                  ),
                  const SizedBox(height: 28),
                  if (unavailable)
                    Text(
                      heartText(
                        context,
                        'Os ajustes não puderam ser carregados. Atualize e tente novamente.',
                        'Settings could not be loaded. Refresh and retry.',
                      ),
                      style: AppHeartStyle.body,
                    )
                  else ...[
                    HeartLabel(
                      heartText(
                        context,
                        'Mostrar na página',
                        'Show on this page',
                      ),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        heartText(
                          context,
                          'Pressão estimada',
                          'Estimated blood pressure',
                        ),
                        style: AppHeartStyle.body,
                      ),
                      subtitle: Text(
                        heartText(
                          context,
                          'junto com a leitura do sensor',
                          'alongside the sensor recording',
                        ),
                        style: AppHeartStyle.caption,
                      ),
                      value: _preferences.pressure,
                      onChanged: (v) => setState(
                        () => _preferences = _preferences.copy(
                          'showEstimatedPressure',
                          v,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    HeartLabel(heartText(context, 'Avisos', 'Notices')),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        heartText(
                          context,
                          'Frequência alta em repouso',
                          'Elevated resting heart rate',
                        ),
                        style: AppHeartStyle.body,
                      ),
                      subtitle: Text(
                        heartText(
                          context,
                          'noites acima do seu intervalo pessoal',
                          'nights above your personal baseline',
                        ),
                        style: AppHeartStyle.caption,
                      ),
                      value: _preferences.high,
                      onChanged: (v) => setState(
                        () => _preferences = _preferences.copy(
                          'notifyHighResting',
                          v,
                        ),
                      ),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        heartText(
                          context,
                          'Ritmo irregular',
                          'Irregular rhythm',
                        ),
                        style: AppHeartStyle.body,
                      ),
                      subtitle: Text(
                        heartText(
                          context,
                          'preferência salva; classificação de ritmo ainda indisponível',
                          'preference saved; rhythm classification is not available yet',
                        ),
                        style: AppHeartStyle.caption,
                      ),
                      value: _preferences.irregular,
                      onChanged: (v) => setState(
                        () => _preferences = _preferences.copy(
                          'notifyIrregularRhythm',
                          v,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  HeartLabel(heartText(context, 'Dados', 'Data')),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      heartText(context, 'Calendário', 'Calendar'),
                      style: AppHeartStyle.body,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final now = DateTime.now(),
                          selected = DateTime(now.year, now.month, now.day)
                              .difference(DateUtils.dateOnly(data.date))
                              .inDays
                              .clamp(0, 364);
                      final day = await showDayCalendar(
                        context: context,
                        selectedDay: selected,
                        daysCount: 365,
                        tone: DayStripTone.neutral,
                      );
                      if (context.mounted && day != null) {
                        Navigator.pop(
                          context,
                          DateTime(now.year, now.month, now.day - day),
                        );
                      }
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      heartText(
                        context,
                        'Compartilhar resumo',
                        'Share summary',
                      ),
                      style: AppHeartStyle.body,
                    ),
                    trailing: const Icon(Icons.ios_share, size: 20),
                    onTap: () => _export(false),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      heartText(context, 'Exportar CSV', 'Export CSV'),
                      style: AppHeartStyle.body,
                    ),
                    subtitle: Text(
                      heartText(
                        context,
                        'amostras exibidas neste dia · intervalo de 1 minuto',
                        'displayed samples for this day · 1-minute buckets',
                      ),
                      style: AppHeartStyle.caption,
                    ),
                    trailing: const Icon(Icons.download_outlined),
                    onTap: () => _export(true),
                  ),
                  if (_error != null)
                    Text(
                      _error!,
                      style: AppHeartStyle.body.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!unavailable)
            AppSheetSaveButton(
              label: heartText(context, 'Salvar', 'Save'),
              loading: _saving,
              onPressed: _exporting ? null : _save,
            ),
        ],
      ),
    );
  }
}
