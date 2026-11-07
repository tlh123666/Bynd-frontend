import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

abstract final class AppRadii {
  static const small = 8.0;
  static const control = 16.0;
  static const card = 24.0;
  static const sheet = 32.0;
  static const pill = 999.0;

  static const cardBorder = BorderRadius.all(Radius.circular(card));
  static const controlBorder = BorderRadius.all(Radius.circular(control));
  static const pillBorder = BorderRadius.all(Radius.circular(pill));
}

abstract final class AppBorders {
  static const hairline = 1.0;
  static const focused = 1.5;
  static const glass = BorderSide(
    color: AppColors.glassBorder,
    width: hairline,
  );
  static const divider = BorderSide(color: AppColors.divider, width: hairline);
  static const selected = BorderSide(
    color: AppColors.textPrimary,
    width: focused,
  );
}

abstract final class AppSizes {
  static const iconSmall = 16.0;
  static const icon = 24.0;
  static const iconLarge = 32.0;
  static const touchTarget = 48.0;
  static const buttonSmall = 40.0;
  static const buttonRegular = 52.0;
  static const glassBlur = 16.0;
}
