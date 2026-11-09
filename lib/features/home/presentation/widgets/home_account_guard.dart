import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../application/home_controller.dart';

/// Prevents an already-open history or form from retaining another account's
/// data or submitting its contents after the active account changes.
class HomeAccountGuard extends StatefulWidget {
  const HomeAccountGuard({
    required this.controller,
    required this.child,
    super.key,
  });
  final HomeController controller;
  final Widget child;
  @override
  State<HomeAccountGuard> createState() => _HomeAccountGuardState();
}

class _HomeAccountGuardState extends State<HomeAccountGuard> {
  late final int _revision = widget.controller.accountRevision;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) => _revision == widget.controller.accountRevision
        ? widget.child
        : ColoredBox(
            color: AppColors.homeCanvas,
            child: Column(
              children: [
                AppDetailHeader(
                  title: context.l10n.homeSignals,
                  onClose: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        context.l10n.homeAccountChanged,
                        textAlign: TextAlign.center,
                        style: AppTypography.body,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
  );
}
