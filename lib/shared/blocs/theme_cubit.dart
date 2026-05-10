import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(_load(_prefs));

  static const _kKey = 'theme_mode';
  final SharedPreferences _prefs;

  static ThemeMode _load(SharedPreferences prefs) {
    return switch (prefs.getString(_kKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  bool get isLight => state == ThemeMode.light;
  bool get isDark => state == ThemeMode.dark;
  bool get isSystem => state == ThemeMode.system;

  void setTheme(ThemeMode mode) {
    if (state == mode) return;
    _prefs.setString(_kKey, mode.name);
    emit(mode);
  }

  void reset() {
    _prefs.remove(_kKey);
    emit(ThemeMode.system);
  }
}
