import 'package:flutter/material.dart';

import '../tokens/app_motion.dart';

/// The reference app pushes pages from the right while the previous page
/// retreats slightly to the left. Applying this through the theme keeps the
/// same transition for every MaterialPageRoute in the app.
class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const AppPageTransitionsBuilder();

  @override
  Duration get transitionDuration => AppMotion.page;

  @override
  Duration get reverseTransitionDuration => AppMotion.page;

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (context != null && !AppMotion.enabled(context)) return child;

    final entering = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: AppMotion.pageCurve));
    final retreating =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-0.3, 0)).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: AppMotion.pageCurve,
          ),
        );

    return SlideTransition(
      position: retreating,
      child: Stack(
        children: [
          SlideTransition(
            position: entering,
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.75, end: 1).animate(animation),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x47000000),
                      blurRadius: 30,
                      offset: Offset(-10, 0),
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: FadeTransition(
                opacity: Tween<double>(
                  begin: 0,
                  end: 0.22,
                ).animate(secondaryAnimation),
                child: const ColoredBox(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
