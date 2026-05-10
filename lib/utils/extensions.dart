import 'package:flutter/material.dart';
import 'package:sync_bridge/shared/theme/app_color_scheme.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  AppColorScheme get appColors => Theme.of(this).extension<AppColorScheme>()!;
}
