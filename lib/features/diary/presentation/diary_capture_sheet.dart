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
    if (_locale != null) return;
    _locale = Localizations.localeOf(context).toLanguageTag();
    if (widget.startVoice) {
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
              _error = diaryText(
                context,
                'Não foi possível ouvir. Você pode escrever abaixo.',
                'Could not hear you. You can type below.',
              );
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
          () => _error = diaryText(
            context,
            'A fala não está disponível ou a permissão foi negada. Você pode escrever.',
            'Speech is unavailable or permission was denied. You can type.',
          ),
        );
        return;
      }
      _voice = true;
      await _speech.listen(
        listenOptions: SpeechListenOptions(localeId: _locale),
        onResult: (r) {
          if (mounted) setState(() => _text.text = r.recognizedWords);
        },
      );
    } catch (e) {
      if (mounted) {
        setState(
          () => _error = diaryText(
            context,
            'Não foi possível iniciar a fala. Você pode escrever.',
            'Could not start speech. You can type.',
          ),
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
          () => _error = diaryText(
            context,
            'Não foi possível interpretar. Tente novamente. Seu texto está salvo aqui.',
            'Could not interpret this. Try again. Your text is still here.',
          ),
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
        AppSheetHeader(
          title: diaryText(context, 'Registrar com a IA', 'Record with AI'),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                _review == null
                    ? diaryText(
                        context,
                        'Conte como foi o seu dia.',
                        'Tell us about your day.',
                      )
                    : diaryText(
                        context,
                        'Confira antes de adicionar.',
                        'Review before adding.',
                      ),
                style: AppDiaryStyle.title,
              ),
              const SizedBox(height: 14),
              Text(
                diaryText(
                  context,
                  'A IA pode errar. Revise os registros e remova o que não aconteceu.',
                  'AI can make mistakes. Review the entries and remove anything that did not happen.',
                ),
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
                  hintText: diaryText(
                    context,
                    'Tomei 2 cafés e caminhei por 20 minutos…',
                    'I had 2 coffees and walked for 20 minutes…',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AppGlassPill(
                label: _listening
                    ? diaryText(context, 'Parar de ouvir', 'Stop listening')
                    : diaryText(context, 'Falar', 'Speak'),
                onPressed: _listen,
              ),
              if (_review != null) ...[
                const SizedBox(height: 24),
                if (_review!.isEmpty)
                  Text(
                    diaryText(
                      context,
                      'Nenhum registro identificado. Tente descrever de outra forma.',
                      'No entries identified. Try describing it differently.',
                    ),
                    style: AppDiaryStyle.caption,
                  ),
                for (final m in _review!)
                  DiarySurface(
                    child: ListTile(
                      title: Text(m.label, style: AppDiaryStyle.label),
                      subtitle: Text(m.note, style: AppDiaryStyle.caption),
                      trailing: IconButton(
                        tooltip: diaryText(context, 'Remover', 'Remove'),
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
              ? diaryText(context, 'Revisar registros', 'Review entries')
              : diaryText(context, 'Adicionar ao dia', 'Add to day'),
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
