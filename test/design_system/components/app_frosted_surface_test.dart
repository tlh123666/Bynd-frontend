import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/components/app_frosted_surface.dart';

void main() {
  testWidgets('加深底色能实际遮挡明亮的底层内容', (tester) async {
    tester.view.physicalSize = const Size(120, 120);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: RepaintBoundary(
          key: key,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: Colors.white),
              AppFrostedSurface.modalSheet(
                tintColor: const Color(0xe614181e),
                borderRadius: BorderRadius.zero,
                borderFadeHeight: 0,
                child: const SizedBox.expand(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1);
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      expect(data, isNotNull);
      final Uint8List bytes = data!.buffer.asUint8List();
      final offset = (60 * image.width + 60) * 4;
      expect(bytes[offset], lessThan(60));
      expect(bytes[offset + 1], lessThan(60));
      expect(bytes[offset + 2], lessThan(70));
      image.dispose();
    });
  });
}
