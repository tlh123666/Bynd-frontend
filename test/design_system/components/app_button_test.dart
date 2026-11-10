import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/design_system.dart';

Color? background(WidgetTester tester, String key) => tester
    .widget<Material>(
      find
          .descendant(
            of: find.byKey(ValueKey(key)),
            matching: find.byType(Material),
          )
          .first,
    )
    .color;

Color? foreground(WidgetTester tester, String label) =>
    DefaultTextStyle.of(tester.element(find.text(label))).style.color;

Future<void> mount(WidgetTester tester, List<Widget> buttons) =>
    tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(body: Column(children: buttons)),
      ),
    );

void main() {
  testWidgets('native buttons inherit neutral colors without page overrides', (
    tester,
  ) async {
    await mount(tester, [
      FilledButton(
        key: const ValueKey('filled'),
        onPressed: () {},
        child: const Text('filled'),
      ),
      FilledButton.tonal(
        key: const ValueKey('tonal'),
        onPressed: () {},
        child: const Text('tonal'),
      ),
      ElevatedButton(
        key: const ValueKey('elevated'),
        onPressed: () {},
        child: const Text('elevated'),
      ),
      OutlinedButton(
        key: const ValueKey('outlined'),
        onPressed: () {},
        child: const Text('outlined'),
      ),
      TextButton(
        key: const ValueKey('text'),
        onPressed: () {},
        child: const Text('text'),
      ),
      const FilledButton(
        key: ValueKey('disabled'),
        onPressed: null,
        child: Text('disabled'),
      ),
    ]);

    // Fixed reference values prevent the shared action token drifting orange.
    expect(background(tester, 'filled'), const Color(0xFFF4F5F7));
    expect(background(tester, 'elevated'), const Color(0xFFF4F5F7));
    expect(foreground(tester, 'filled'), AppColors.onAction);
    expect(foreground(tester, 'elevated'), AppColors.onAction);
    expect(background(tester, 'tonal'), AppColors.surfaceRaised);
    expect(foreground(tester, 'tonal'), AppColors.textPrimary);
    expect(background(tester, 'outlined'), AppColors.glass);
    expect(foreground(tester, 'outlined'), AppColors.textPrimary);
    expect(background(tester, 'text'), Colors.transparent);
    expect(foreground(tester, 'text'), AppColors.textPrimary);
    expect(background(tester, 'disabled'), AppColors.buttonDisabledBackground);
    expect(foreground(tester, 'disabled'), AppColors.textDim);
  });

  testWidgets(
    'AppButton variants, loading and disabled states stay consistent',
    (tester) async {
      var taps = 0;
      await mount(tester, [
        AppButton(
          key: const ValueKey('primary'),
          label: 'primary',
          onPressed: () => taps++,
        ),
        AppButton(
          key: const ValueKey('secondary'),
          label: 'secondary',
          variant: AppButtonVariant.secondary,
          onPressed: () {},
        ),
        AppButton(
          key: const ValueKey('ghost'),
          label: 'ghost',
          variant: AppButtonVariant.ghost,
          onPressed: () {},
        ),
        AppButton(
          key: const ValueKey('danger'),
          label: 'danger',
          variant: AppButtonVariant.danger,
          onPressed: () {},
        ),
        const AppButton(
          key: ValueKey('disabled'),
          label: 'disabled',
          onPressed: null,
        ),
        AppButton(
          key: const ValueKey('loading'),
          label: 'loading',
          loading: true,
          onPressed: () => taps++,
        ),
      ]);

      expect(background(tester, 'primary'), const Color(0xFFF4F5F7));
      expect(foreground(tester, 'primary'), AppColors.onAction);
      expect(background(tester, 'secondary'), AppColors.glass);
      expect(background(tester, 'ghost'), Colors.transparent);
      expect(background(tester, 'danger'), AppColors.error);
      expect(
        background(tester, 'disabled'),
        AppColors.buttonDisabledBackground,
      );
      expect(background(tester, 'loading'), AppColors.buttonDisabledBackground);
      expect(foreground(tester, 'disabled'), AppColors.textDim);
      await tester.tap(find.text('primary'));
      await tester.tap(find.byKey(const ValueKey('loading')));
      await tester.pump();
      expect(taps, 1);
      expect(tester.takeException(), isNull);
    },
  );
}
