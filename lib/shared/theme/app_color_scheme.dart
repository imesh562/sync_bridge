import 'package:flutter/material.dart';

@immutable
final class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.primary,
    required this.primaryVariant,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.error,
    required this.onError,
    required this.textSecondary,
    required this.divider,
    required this.shimmerBase,
    required this.shimmerHighlight,
    // forge:constructor
  });

  final Color primary;
  final Color primaryVariant;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color error;
  final Color onError;
  final Color textSecondary;
  final Color divider;
  final Color shimmerBase;
  final Color shimmerHighlight;
  // forge:fields

  static const light = AppColorScheme(
    primary: Color(0xFF1A73E8),
    primaryVariant: Color(0xFF1558B0),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF34A853),
    onSecondary: Color(0xFFFFFFFF),
    background: Color(0xFFFFFFFF),
    onBackground: Color(0xFF202124),
    surface: Color(0xFFF8F9FA),
    onSurface: Color(0xFF202124),
    error: Color(0xFFEA4335),
    onError: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF5F6368),
    divider: Color(0xFFE0E0E0),
    shimmerBase: Color(0xFFE0E0E0),
    shimmerHighlight: Color(0xFFF5F5F5),
    // forge:light
  );

  static const dark = AppColorScheme(
    primary: Color(0xFF8AB4F8),
    primaryVariant: Color(0xFF669DF6),
    onPrimary: Color(0xFF1A1A1A),
    secondary: Color(0xFF81C995),
    onSecondary: Color(0xFF1A1A1A),
    background: Color(0xFF121212),
    onBackground: Color(0xFFE8EAED),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE8EAED),
    error: Color(0xFFFF6B6B),
    onError: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF9AA0A6),
    divider: Color(0xFF3C4043),
    shimmerBase: Color(0xFF2A2A2A),
    shimmerHighlight: Color(0xFF3A3A3A),
    // forge:dark
  );

  @override
  AppColorScheme copyWith({
    Color? primary,
    Color? primaryVariant,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? error,
    Color? onError,
    Color? textSecondary,
    Color? divider,
    Color? shimmerBase,
    Color? shimmerHighlight,
    // forge:copyWith-params
  }) => AppColorScheme(
    primary: primary ?? this.primary,
    primaryVariant: primaryVariant ?? this.primaryVariant,
    onPrimary: onPrimary ?? this.onPrimary,
    secondary: secondary ?? this.secondary,
    onSecondary: onSecondary ?? this.onSecondary,
    background: background ?? this.background,
    onBackground: onBackground ?? this.onBackground,
    surface: surface ?? this.surface,
    onSurface: onSurface ?? this.onSurface,
    error: error ?? this.error,
    onError: onError ?? this.onError,
    textSecondary: textSecondary ?? this.textSecondary,
    divider: divider ?? this.divider,
    shimmerBase: shimmerBase ?? this.shimmerBase,
    shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    // forge:copyWith-body
  );

  @override
  AppColorScheme lerp(AppColorScheme? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight:
          Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      // forge:lerp
    );
  }
}
