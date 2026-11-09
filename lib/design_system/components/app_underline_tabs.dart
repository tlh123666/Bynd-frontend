import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_motion.dart';
import '../tokens/app_typography.dart';

class AppUnderlineTabs extends StatelessWidget {
  const AppUnderlineTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.deviceDivider)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(width: 26),
            Semantics(
              selected: selectedIndex == i,
              button: true,
              child: InkWell(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  height: 32,
                  duration: AppMotion.enabled(context)
                      ? AppMotion.feedback
                      : Duration.zero,
                  padding: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: selectedIndex == i
                            ? AppColors.textPrimary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontFamily: AppFontFamilies.geist,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                      height: 1.2,
                      color: selectedIndex == i
                          ? AppColors.textPrimary
                          : AppColors.textInactive,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
