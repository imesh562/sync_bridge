import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:sync_bridge/core/storage/preferences_service.dart';
import 'package:sync_bridge/features/tasks/data/datasources/tasks_local_datasource.dart';

@lazySingleton
final class LocalPushService {
  LocalPushService(this._prefs);

  final PreferencesService _prefs;

  final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    final stored = _prefs.fcmToken;
    if (stored != null) {
      print('[FCM] Stored push token: $stored');
    }

    await _requestPermission();

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(initSettings);

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    try {
      if (Platform.isIOS) {
        String? apns;
        for (int i = 0; i < 10 && apns == null; i++) {
          apns = await FirebaseMessaging.instance.getAPNSToken();
          if (apns == null) {
            await Future<void>.delayed(const Duration(seconds: 1));
          }
        }
        if (apns == null) {
          print(
            '[FCM] APNS token unavailable — simulator or missing push entitlement.',
          );
          return;
        }
      }
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        print('[FCM] Push token: $token');
        await _prefs.setFcmToken(token);
      }
      FirebaseMessaging.instance.onTokenRefresh.listen((t) {
        print('[FCM] Push token refreshed: $t');
        _prefs.setFcmToken(t);
      });
    } catch (e) {
      print('[FCM] Failed to get push token: $e');
    }
  }

  Future<void> _requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('[FCM] Notification permission: ${settings.authorizationStatus}');
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    if (message.data.isNotEmpty) {
      await TasksLocalDatasource.updateFromFcm(message.data);
    }
    await _showForegroundNotification(message);
  }

  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    if (message.data.isNotEmpty) {
      await TasksLocalDatasource.updateFromFcm(message.data);
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    if (notification == null || android == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          importance: _androidChannel.importance,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.data.isNotEmpty) {
    await TasksLocalDatasource.updateFromFcm(message.data);
  }
}
