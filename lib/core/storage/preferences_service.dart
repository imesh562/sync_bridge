import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
final class PreferencesService {
  PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  // ── Auth ──────────────────────────────────────────────────────────────────

  String? get authToken => _prefs.getString('auth_token');
  Future<void> setAuthToken(String token) =>
      _prefs.setString('auth_token', token);
  Future<void> clearAuthToken() => _prefs.remove('auth_token');

  // ── FCM push token ────────────────────────────────────────────────────────

  String? get fcmToken => _prefs.getString('fcm_token');
  Future<void> setFcmToken(String token) =>
      _prefs.setString('fcm_token', token);

  // ── Generic typed helpers ─────────────────────────────────────────────────

  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);
  Future<void> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  int? getInt(String key) => _prefs.getInt(key);
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);

  Future<void> remove(String key) => _prefs.remove(key);
  Future<void> clear() => _prefs.clear();
}
