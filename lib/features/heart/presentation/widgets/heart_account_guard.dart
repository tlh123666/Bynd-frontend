import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../application/heart_controller.dart';
import '../heart_copy.dart';

class HeartAccountGuard extends StatelessWidget {
  const HeartAccountGuard({
    required this.controller,
    required this.child,
    super.key,
  });
  final HeartController controller;
  final Widget child;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (c, _) => controller.accountChanged
        ? Center(
            child: Text(
              heartText(
                context,
                'Sua conta mudou. Abra o Coração novamente.',
                'Your account changed. Reopen Heart.',
              ),
              style: AppHeartStyle.body,
            ),
          )
        : child,
  );
}
