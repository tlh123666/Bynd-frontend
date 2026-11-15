import 'package:flutter/widgets.dart';
import '../../heart/domain/heart_models.dart';
import '../../heart/presentation/pages/heart_page.dart';
import '../../sleep/presentation/pages/sleep_page.dart';
import '../application/home_controller.dart';
import '../domain/home_models.dart';
import 'pages/home_signal_detail_page.dart';

Widget homeSignalDestination(
  HomeController controller,
  HomeSignal signal, {
  ValueChanged<int>? onDestinationSelected,
}) {
  if (signal == HomeSignal.sleep) {
    return SleepPage(date: controller.date, demo: controller.demoData);
  }
  if ([
    HomeSignal.rhr,
    HomeSignal.hrv,
    HomeSignal.oxygen,
    HomeSignal.respiration,
  ].contains(signal)) {
    return HeartPage(
      date: controller.date,
      demo: controller.demoData,
      onDestinationSelected: onDestinationSelected,
      initialMetric: switch (signal) {
        HomeSignal.hrv => HeartMetric.hrv,
        HomeSignal.oxygen => HeartMetric.oxygen,
        HomeSignal.respiration => HeartMetric.respiration,
        _ => null,
      },
    );
  }
  return HomeSignalDetailPage(controller: controller, signal: signal);
}
