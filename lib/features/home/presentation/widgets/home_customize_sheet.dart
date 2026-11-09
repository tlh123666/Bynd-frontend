import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../application/home_controller.dart';
import '../../domain/home_models.dart';

class HomeCustomizeSheet extends StatefulWidget {
  const HomeCustomizeSheet({required this.controller, super.key});
  final HomeController controller;
  @override
  State<HomeCustomizeSheet> createState() => _HomeCustomizeSheetState();
}

class _HomeCustomizeSheetState extends State<HomeCustomizeSheet> {
  late final List<HomeSignal> _selected = [...widget.controller.signals];
  bool _saving = false, _limit = false;
  String? _error;
  void _toggle(HomeSignal signal) {
    if (_saving) return;
    setState(() {
      if (_selected.contains(signal)) {
        _selected.remove(signal);
        _limit = false;
      } else if (_selected.length < 6) {
        _selected.add(signal);
        _limit = false;
      } else {
        _limit = true;
      }
      _error = null;
    });
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.controller.saveSignals(_selected);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = context.l10n.homePreferenceFailed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return PopScope(
      canPop: !_saving,
      child: Column(
        children: [
          SizedBox(
            height: 46,
            child: Row(
              children: [
                IconButton(
                  tooltip: s.close,
                  onPressed: _saving ? null : () => Navigator.pop(context),
                  icon: const AppSvgIcon(AppSvgAssets.close, size: 22),
                ),
                Expanded(
                  child: Text(
                    s.homeCustomize,
                    textAlign: TextAlign.center,
                    style: AppTypography.title.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -.19,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: s.homeSave,
                  onPressed: _selected.length == 6 && !_saving ? _save : null,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 20,
                          child: AppLoadingIndicator(
                            size: 20,
                            showLabel: false,
                          ),
                        )
                      : Icon(
                          Icons.check,
                          color: _selected.length == 6
                              ? AppColors.textPrimary
                              : AppColors.textDim,
                        ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 20),
            child: Text(
              s.homeCustomizeHelp,
              style: AppTypography.body.copyWith(
                fontSize: 13,
                height: 1.45,
                color: AppColors.textHalf,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _heading(
                  s.homeOnHome,
                  '${_selected.length} ${s.homeSelectedCount}',
                ),
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  itemCount: _selected.length,
                  onReorderItem: (oldIndex, newIndex) {
                    if (_saving) return;
                    setState(() {
                      _selected.insert(newIndex, _selected.removeAt(oldIndex));
                    });
                  },
                  itemBuilder: (context, index) =>
                      _row(_selected[index], index: index),
                ),
                const SizedBox(height: 24),
                _heading(s.homeOtherSignals, ''),
                for (final signal in HomeSignal.values.where(
                  (signal) => !_selected.contains(signal),
                ))
                  _row(signal),
                const SizedBox(height: 24),
              ],
            ),
          ),
          if (_limit || _error != null)
            Padding(
              padding: const EdgeInsets.all(22),
              child: Text(
                _error ?? s.homeSixSlots,
                style: AppTypography.caption.copyWith(
                  color: AppColors.signalAttention,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _heading(String label, String count) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.kicker.copyWith(color: AppColors.textMuted),
          ),
        ),
        Text(
          count,
          style: AppTypography.caption.copyWith(
            fontSize: 11,
            height: 1.27,
            color: AppColors.textHalf,
          ),
        ),
      ],
    ),
  );
  Widget _row(HomeSignal signal, {int? index}) {
    final s = context.l10n;
    final value = widget.controller.snapshot?.measurement(signal).value;
    return Padding(
      key: ValueKey(signal),
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: _saving ? null : () => _toggle(signal),
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.only(left: 14, right: 6),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 22,
                    child: Checkbox(
                      value: index != null,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      shape: const CircleBorder(),
                      activeColor: AppColors.textPrimary,
                      checkColor: AppColors.homeCanvas,
                      onChanged: _saving ? null : (_) => _toggle(signal),
                    ),
                  ),
                  const SizedBox(width: 11),
                  AppSvgIcon(
                    signal.iconAsset,
                    size: 17,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      signal.label(s.localeName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.signalLabel,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 88),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text.rich(
                        TextSpan(
                          text: signal.format(value, s.localeName),
                          style: AppTypography.signalValue.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.w200,
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            if (value != null)
                              TextSpan(
                                text: signal.unit.isEmpty
                                    ? ''
                                    : ' ${signal.unit}',
                                style: AppTypography.caption.copyWith(
                                  fontSize: 11,
                                  color: AppColors.textInactive,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  SizedBox(
                    width: 18,
                    child: Text(
                      index == null ? '' : (index + 1).toString(),
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(
                        fontSize: 11,
                        color: AppColors.textDim,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 48,
                    child: index == null
                        ? null
                        : ReorderableDragStartListener(
                            index: index,
                            enabled: !_saving,
                            child: Semantics(
                              label: s.homeDrag,
                              child: const Icon(
                                Icons.drag_handle,
                                size: 18,
                                color: AppColors.textHalf,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
