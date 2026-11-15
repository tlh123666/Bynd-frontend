import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations_context.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/diary_models.dart';
import 'diary_builtin_copy.dart';
import 'diary_reference_copy.dart';

final _english = lookupAppLocalizations(const Locale('en'));

String diaryDisplayDate(BuildContext context, DateTime date) =>
    DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(date);

/// Native recognizers use different separators and may expose only a region variant.
/// Never silently recognize English with a Portuguese system default, or vice versa.
String? diarySpeechLocale(String requested, Iterable<String> available) {
  String normalized(String value) => value.toLowerCase().replaceAll('_', '-');
  final target = normalized(requested);
  for (final locale in available) {
    if (normalized(locale) == target) return locale;
  }
  final language = target.split('-').first;
  for (final locale in available) {
    if (normalized(locale).split('-').first == language) return locale;
  }
  return null;
}

// Translate reference copy only. IDs, API values and user-authored text stay intact.
String _builtinLabel(BuildContext context, String key, String raw) {
  final copy = diaryBuiltinCopy(context.l10n, key);
  if (copy == null) return raw;
  final english = diaryBuiltinCopy(_english, key)!;
  return raw == copy.sourceLabel || raw == english.label ? copy.label : raw;
}

String diaryTrackerLabel(BuildContext context, DiaryTracker tracker) =>
    tracker.json['custom'] == true
    ? tracker.label
    : _builtinLabel(context, tracker.key, tracker.label);

String diaryTrackerPrompt(BuildContext context, DiaryTracker tracker) {
  if (tracker.json['custom'] == true) return tracker.prompt;
  final copy = diaryBuiltinCopy(context.l10n, tracker.key);
  if (copy == null) return tracker.prompt;
  final english = diaryBuiltinCopy(_english, tracker.key)!;
  if (tracker.prompt == copy.sourcePrompt || tracker.prompt == english.prompt) {
    return copy.prompt;
  }
  return _builtinLabel(context, tracker.key, tracker.prompt);
}

String diaryMomentLabel(BuildContext context, DiaryMoment moment) {
  if (moment.automatic) {
    return switch (moment.label) {
      'Acordou' || 'Woke up' => context.l10n.diaryAutomaticWokeUp,
      'Atividade' || 'Activity' => context.l10n.diaryAutomaticActivity,
      _ => diaryReferenceCopy(context.l10n, moment.label) ?? moment.label,
    };
  }
  return _builtinLabel(context, moment.key, moment.label);
}

String diaryGroupLabel(BuildContext context, String group) {
  final l = context.l10n;
  return switch (group) {
    'Alimentação' => l.diaryGroupFood,
    'Autocuidado' => l.diaryGroupSelfCare,
    'Bebidas' => l.diaryGroupDrinks,
    'Bem-estar mental' => l.diaryGroupMentalWellBeing,
    'Drogas e medicação' => l.diaryGroupSubstancesAndMedication,
    'Movimento' => l.diaryGroupMovement,
    'Recuperação' => l.diaryGroupRecovery,
    'Refeições' => l.diaryGroupMeals,
    'Rotina e lazer' => l.diaryGroupRoutineAndLeisure,
    'Saúde' => l.diaryGroupHealth,
    'Saúde e sintomas' => l.diaryGroupHealthAndSymptoms,
    'Saúde hormonal' => l.diaryGroupHormonalHealth,
    'Sono e ritmo' => l.diaryGroupSleepAndRhythm,
    'Suplementos' => l.diaryGroupSupplements,
    'Telas e foco' => l.diaryGroupScreensAndFocus,
    'Seus hábitos' => l.diaryGroupYourHabits,
    _ => group,
  };
}

String diaryUnit(BuildContext context, String unit) => switch (unit) {
  'vezes' || 'times' => context.l10n.diaryValueTimes,
  'xícaras' || 'cups' => context.l10n.diaryValueCups,
  'refeições' || 'meals' => context.l10n.diaryValueMeals,
  'de 10' || 'out of 10' => context.l10n.diaryValueOutOfTen,
  _ => unit,
};

String diaryPortionLabel(BuildContext context, String portion) =>
    switch (portion) {
      'Leve' => context.l10n.diaryPortionLight,
      'Normal' => context.l10n.diaryPortionNormal,
      'Pesado' => context.l10n.diaryPortionHeavy,
      _ => portion,
    };

String diaryNumber(BuildContext context, num value) => NumberFormat(
  '0.##########',
  Localizations.localeOf(context).toLanguageTag(),
).format(value);

String diaryMomentValue(BuildContext context, DiaryMoment moment) {
  if (!moment.happened) return context.l10n.diaryValueDidNotHappen;
  if (moment.kind == 'quantity' && moment.value == null) {
    return moment.timeLabel;
  }
  if (moment.kind == 'meal') {
    final calories = moment.details['calories'];
    return calories is num
        ? '${diaryNumber(context, calories)} kcal'
        : moment.note;
  }
  if (moment.value != null) {
    final unit = moment.kind == 'scale'
        ? '/ 10'
        : diaryBuiltinCopy(context.l10n, moment.key) != null
        ? diaryUnit(context, moment.unit)
        : moment.unit;
    return '${diaryNumber(context, moment.value!)} $unit'.trimRight();
  }
  if (moment.automatic) {
    return diaryReferenceCopy(context.l10n, moment.note) ?? moment.note;
  }
  return context.l10n.diaryValueRecorded;
}

List<String> diaryScaleLabels(BuildContext context, DiaryTracker? tracker) {
  if (tracker == null || tracker.json['custom'] == true) {
    return tracker?.scaleLabels ?? [];
  }
  final l = context.l10n;
  return switch (tracker.key) {
    'acordou' => [
      l.diaryScaleAcordou0,
      l.diaryScaleAcordou1,
      l.diaryScaleAcordou2,
      l.diaryScaleAcordou3,
      l.diaryScaleAcordou4,
    ],
    'humor' => [
      l.diaryScaleHumor0,
      l.diaryScaleHumor1,
      l.diaryScaleHumor2,
      l.diaryScaleHumor3,
      l.diaryScaleHumor4,
    ],
    'energia' => [
      l.diaryScaleEnergia0,
      l.diaryScaleEnergia1,
      l.diaryScaleEnergia2,
      l.diaryScaleEnergia3,
      l.diaryScaleEnergia4,
    ],
    'estresse' => [
      l.diaryScaleEstresse0,
      l.diaryScaleEstresse1,
      l.diaryScaleEstresse2,
      l.diaryScaleEstresse3,
      l.diaryScaleEstresse4,
    ],
    _ => tracker.scaleLabels,
  };
}

String diaryChapterPeriod(BuildContext context, Map<String, dynamic> chapter) {
  if (chapter['period'] case final String period when period.isNotEmpty) {
    return period;
  }
  String date(Object? raw) {
    final value = DateTime.tryParse('$raw');
    return value == null
        ? ''
        : DateFormat.yMMMd(
            Localizations.localeOf(context).toLanguageTag(),
          ).format(value);
  }

  return context.l10n.diaryDateRange(
    date(chapter['startDate']),
    date(chapter['endDate']),
  );
}

Map<String, dynamic> diaryReferenceChapter(
  BuildContext context,
  Map<String, dynamic> raw,
) {
  if (!'${raw['id']}'.startsWith('reference-')) return raw;
  String text(Object? value) =>
      diaryReferenceCopy(context.l10n, '$value') ?? '$value';
  return {
    ...raw,
    for (final key in ['title', 'body', 'period']) key: text(raw[key]),
    'sections': [
      for (final section in raw['sections'] as List)
        [
          for (final row in section as List)
            {
              ...Map<String, dynamic>.from(row as Map),
              for (final key in ['label', 'note', 'value']) key: text(row[key]),
            },
        ],
    ],
  };
}

/// Reference meals are copied for presentation; source macros and identifiers are preserved.
Map<String, dynamic> diaryMealTemplate(BuildContext context, Map raw) => {
  ...Map<String, dynamic>.from(raw),
  'it': [
    for (final pair in raw['it'] as List)
      [
        for (final text in pair as List)
          diaryReferenceCopy(context.l10n, '$text') ?? '$text',
      ],
  ],
};
