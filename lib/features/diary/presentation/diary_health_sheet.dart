import 'package:flutter/material.dart';

import '../../../core/auth/auth_session.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';
import '../domain/diary_models.dart';
import 'diary_page.dart';
import 'diary_record_sheet.dart';
import 'diary_widgets.dart';

enum DiaryHealthTopic { heart, sleep, recovery, energy }

typedef DiaryHealthGroup = ({
  String title,
  String englishTitle,
  String icon,
  List<String> keys,
});

List<DiaryHealthGroup> diaryHealthGroups(DiaryHealthTopic topic) {
  DiaryHealthGroup group(String pt, String en, String icon, String keys) =>
      (title: pt, englishTitle: en, icon: icon, keys: keys.split(' '));
  return switch (topic) {
    DiaryHealthTopic.heart => [
      group(
        'Bebidas',
        'Drinks',
        'copo',
        'c_alctarde c_ressaca c_cafe c_cafetarde c_energ c_agua',
      ),
      group('Cabeça', 'Mind', 'nota', 'c_estres c_ans c_sobrec'),
      group(
        'Corpo e saúde',
        'Body and health',
        'alvo',
        'c_doente c_febre c_gripe c_cansaco',
      ),
      group('Sono', 'Sleep', 'relo', 'c_madrugada c_tela c_calornoite'),
    ],
    DiaryHealthTopic.sleep => [
      group(
        'Sono',
        'Sleep',
        'estrela',
        'c_horario c_rotina c_banhonoite c_soneca c_madrugada c_banheiro c_pesadelo c_cochilotarde c_sofa c_despert',
      ),
      group(
        'Quarto',
        'Bedroom',
        'lua',
        'c_quarto c_fresco c_calornoite c_arcond c_ventil c_barulho c_ruido c_musicadorm c_tampao c_cobertor c_fitaboca c_dividiu c_ronco c_petcama c_filho',
      ),
      group(
        'Luz e telas',
        'Light and screens',
        'sol',
        'c_sol c_luz c_oculos c_tela c_celmadr c_celnoite c_redes c_serie',
      ),
      group(
        'Bebida e comida',
        'Food and drink',
        'prato',
        'c_cafetarde c_energ c_alctarde c_pesada c_tarde c_bebquente c_camomila',
      ),
      group(
        'Remédios e suplementos',
        'Medication and supplements',
        'nota',
        'c_melat c_remed c_mag c_glicina c_teanina c_valeriana',
      ),
      group('Cabeça', 'Mind', 'nota', 'c_estres c_ans c_acelerado'),
    ],
    DiaryHealthTopic.recovery => [
      group(
        'Recuperação',
        'Recovery',
        'estrela',
        'c_descanso c_massa c_pistola c_rolo c_bolinha c_compress c_pernas c_drenagem c_sauna c_banhoq c_ofuro c_gelo c_banheira c_crio c_contraste c_luzverm c_hiperb c_fisio c_quiro c_acup',
      ),
      group(
        'Bebida e comida',
        'Food and drink',
        'prato',
        'c_alctarde c_ressaca c_cafetarde c_energ c_pesada c_tarde c_agua c_eletro',
      ),
      group(
        'Sono',
        'Sleep',
        'relo',
        'c_tela c_luz c_madrugada c_cochilotarde c_calornoite',
      ),
      group(
        'Corpo e saúde',
        'Body and health',
        'alvo',
        'c_musc c_lesao c_cansaco c_doente c_gripe c_febre c_garganta',
      ),
      group('Cabeça', 'Mind', 'nota', 'c_sobrec c_ans'),
      group('Viagem', 'Travel', 'env', 'c_voo c_fuso'),
    ],
    DiaryHealthTopic.energy => [
      group(
        'Bebidas',
        'Drinks',
        'copo',
        'c_agua c_aguamanha c_cafe c_cafetarde c_energ c_refri',
      ),
      group(
        'Comida',
        'Food',
        'prato',
        'c_cafem c_protcafe c_alm c_lanche c_pesada c_acucar c_jejum',
      ),
      group(
        'Movimento e luz',
        'Movement and light',
        'sol',
        'c_sol c_arlivre c_passos c_escadas c_along c_sentado c_pausa',
      ),
      group('Descanso', 'Rest', 'lua', 'c_cochilotarde c_medit c_resp'),
      group(
        'Como você está',
        'How you feel',
        'mente',
        'c_disposicao c_foco c_cansaco c_olhos',
      ),
    ],
  };
}

class DiaryHealthEntry extends StatelessWidget {
  const DiaryHealthEntry({
    required this.topic,
    required this.repository,
    required this.date,
    required this.title,
    required this.subtitle,
    super.key,
  });
  final DiaryHealthTopic topic;
  final DiaryRepository repository;
  final DateTime date;
  final String title, subtitle;

  @override
  Widget build(BuildContext context) => AppHealthPanel(
    child: AppHealthRow(
      label: diaryText(context, 'Marcar no Diário', 'Log in Diary'),
      subtitle: subtitle,
      icon: Icons.receipt_long_outlined,
      divider: false,
      onTap: () {
        final token = AuthSession.instance.accessToken;
        showAppContentSheet<void>(
          context,
          (_) => DiarySessionGuard(
            token: token,
            child: _DiaryHealthSheet(
              topic: topic,
              repository: repository,
              date: date,
              title: title,
            ),
          ),
          glass: true,
          heightFactor: .88,
          dismissible: false,
          enableDrag: false,
        );
      },
    ),
  );
}

class _DiaryHealthSheet extends StatefulWidget {
  const _DiaryHealthSheet({
    required this.topic,
    required this.repository,
    required this.date,
    required this.title,
  });
  final DiaryHealthTopic topic;
  final DiaryRepository repository;
  final DateTime date;
  final String title;

  @override
  State<_DiaryHealthSheet> createState() => _DiaryHealthSheetState();
}

class _DiaryHealthSheetState extends State<_DiaryHealthSheet> {
  late Future<DiaryDay> _day = widget.repository.load(widget.date);

  @override
  Widget build(BuildContext context) => FutureBuilder<DiaryDay>(
    future: _day,
    builder: (context, result) {
      if (result.hasData) {
        return DiaryRecordSheet(
          repository: widget.repository,
          day: result.data!,
          healthTopic: widget.topic,
          title: widget.title,
        );
      }
      return Column(
        children: [
          AppPageHeader(
            title: Text(widget.title, style: AppHealthStyle.section),
            leading: const CloseButton(),
          ),
          Expanded(
            child: Center(
              child: result.hasError
                  ? AppGlassPill(
                      label: context.l10n.diaryUiRetry,
                      onPressed: () => setState(
                        () => _day = widget.repository.load(widget.date),
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
