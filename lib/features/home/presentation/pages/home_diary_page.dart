import 'package:flutter/material.dart';
import '../../../diary/presentation/diary_page.dart';
import '../../application/home_controller.dart';

/// Home keeps its selected date; all diary behavior belongs to the diary feature.
class HomeDiaryPage extends StatelessWidget {
  const HomeDiaryPage({
    required this.controller,
    this.openRecord = false,
    this.initialTracker,
    super.key,
  });
  final HomeController controller;
  final bool openRecord;
  final String? initialTracker;
  @override
  Widget build(BuildContext context) => DiaryPage(
    date: controller.date,
    openRecord: openRecord,
    initialTracker: initialTracker,
  );
}
