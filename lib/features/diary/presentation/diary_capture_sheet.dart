import '../../../l10n/app_localizations_context.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../design_system/design_system.dart';
import '../../../design_system/tokens/app_diary_style.dart';
import '../../../shared/widgets/app_sheet_controls.dart';
import '../domain/diary_models.dart';
import 'diary_widgets.dart';

class DiaryCaptureSheet extends StatefulWidget {
  const DiaryCaptureSheet({
    required this.repository,
    required this.date,
    this.startVoice = false,
    super.key,
  });
  final DiaryRepository repository;
  final DateTime date;
  final bool startVoice;
  @override
  State<DiaryCaptureSheet> createState() => _DiaryCaptureSheetState();
}

class _DiaryCaptureSheetState extends State<DiaryCaptureSheet> {
  final _text = TextEditingController();
  final _speech = SpeechToText();
  List<DiaryMoment>? _review;
  bool _loading = false, _listening = false, _voice = false;
  String? _error;
  String? _locale;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final first = _locale == null;
    _locale = Localizations.localeOf(context).toLanguageTag();
    if (first && widget.startVoice) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_listen());
      });
    }
  }

  Future<void> _listen() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    try {
      final ready = await _speech.initialize(
        onError: (e) {
          if (mounted) {
            setState(() {
              _listening = false;
              _error = e.errorMsg.startsWith('error_language_')
                  ? context.l10n.diarySpeechLanguageUnavailable
                  : context.l10n.diaryUiCouldNotHearYouYouCanTypeBelow;
            });
          }
        },
        onStatus: (s) {
          if (mounted) setState(() => _listening = s == 'listening');
        },
      );
      if (!mounted) return;
      if (!ready) {
        setState(
          () => _error = context
              .l10n
              .diaryUiSpeechIsUnavailableOrPermissionWasDeniedYouCanType,
        );
        return;
      }
      final locales = await _speech.locales();
      if (!mounted) return;
      final speechLocale =
          diarySpeechLocale(_locale!, locales.map((l) => l.localeId)) ??
          _locale!;
      // Android's locale list can omit online recognition languages. In that
      // case request the app language explicitly and let the engine decide.
      _voice = true;
      await _speech.listen(
        listenOptions: SpeechListenOptions(localeId: speechLocale),
        onResult: (r) {
          if (mounted) setState(() => _text.text = r.recognizedWords);
        },
      );
    } catch (e) {
      if (mounted) {
        setState(
          () => _error = context.l10n.diaryUiCouldNotStartSpeechYouCanType,
        );
      }
    }
  }

  Future<void> _parse() async {
    if (_text.text.trim().isEmpty || _loading) return;
    await _speech.stop();
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.repository.parse(
        _text.text.trim(),
        widget.date,
        _locale!,
        voice: _voice,
      );
      if (mounted) setState(() => _review = result);
    } catch (e) {
      if (mounted) {
        setState(
          () => _error = context
              .l10n
              .diaryUiCouldNotInterpretThisTryAgainYourTextIsStillHere,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: Column(
      children: [
        AppSheetHeader(title: context.l10n.diaryUiRecordWithAI),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                _review == null
                    ? context.l10n.diaryUiTellUsAboutYourDay
                    : context.l10n.diaryUiReviewBeforeAdding,
                style: AppDiaryStyle.title,
              ),
              const SizedBox(height: 14),
              Text(
                context
                    .l10n
                    .diaryUiAICanMakeMistakesReviewTheEntriesAndRemoveAnythingThatDidNotHappen,
                style: AppDiaryStyle.caption,
              ),
              const SizedBox(height: 24),
              TextField(
                key: const Key('diary-capture-text'),
                controller: _text,
                maxLength: 1000,
                maxLines: 6,
                onChanged: (_) => setState(() => _review = null),
                style: AppDiaryStyle.label,
                decoration: InputDecoration(
                  hintText:
                      context.l10n.diaryUiIHad2CoffeesAndWalkedFor20Minutes,
                ),
              ),
              const SizedBox(height: 12),
              AppGlassPill(
                label: _listening
                    ? context.l10n.diaryUiStopListening
                    : context.l10n.diaryUiSpeak,
                onPressed: _listen,
              ),
              if (_review != null) ...[
                const SizedBox(height: 24),
                if (_review!.isEmpty)
                  Text(
                    context
                        .l10n
                        .diaryUiNoEntriesIdentifiedTryDescribingItDifferently,
                    style: AppDiaryStyle.caption,
                  ),
                for (final m in _review!)
                  DiarySurface(
                    child: ListTile(
                      title: Text(
                        diaryMomentLabel(context, m),
                        style: AppDiaryStyle.label,
                      ),
                      subtitle: Text(m.note, style: AppDiaryStyle.caption),
                      trailing: IconButton(
                        tooltip: context.l10n.diaryUiRemove,
                        onPressed: () => setState(() => _review!.remove(m)),
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ),
                  ),
              ],
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _error!,
                    style: AppDiaryStyle.caption.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
        AppSheetSaveButton(
          label: _review == null
              ? context.l10n.diaryUiReviewEntries
              : context.l10n.diaryUiAddToDay,
          loading: _loading,
          onPressed: _review == null
              ? _parse
              : _review!.isEmpty
              ? null
              : () => Navigator.pop(context, _review),
        ),
      ],
    ),
  );
}
