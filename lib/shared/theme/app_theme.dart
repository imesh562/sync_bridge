import 'package:flutter/material.dart';

import 'app_color_scheme.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(AppColorScheme.light, Brightness.light);

  static ThemeData get dark => _build(AppColorScheme.dark, Brightness.dark);

  static ThemeData _build(AppColorScheme scheme, Brightness brightness) =>
      ThemeData(
        useMaterial3: true,
        brightness: brightness,
        colorScheme: ColorScheme.fromSeed(
          seedColor: scheme.primary,
          brightness: brightness,
        ),
        scaffoldBackgroundColor: scheme.background,
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.background,
          foregroundColor: scheme.onBackground,
          elevation: 0,
          centerTitle: false,
        ),
        extensions: [scheme],
      );
}
