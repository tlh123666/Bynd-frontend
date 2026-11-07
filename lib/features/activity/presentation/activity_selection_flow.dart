import 'package:flutter/material.dart';

import 'pages/activity_preparation_page.dart';
import 'widgets/activity_selection_sheet.dart';

/// 从任一快捷操作入口打开统一目录，并按原型分流到准备页或力量训练入口。
Future<void> openActivitySelection(BuildContext context) async {
  final selected = await ActivitySelectionSheet.show(context);
  if (!context.mounted || selected == null) return;

  final page = selected.id == 'musculacao'
      ? StrengthStartPage(activity: selected)
      : ActivityPreparationPage(initialActivity: selected);
  await Navigator.of(
    context,
  ).push<void>(MaterialPageRoute<void>(builder: (_) => page));
}
