import 'package:flutter/foundation.dart';

/// Tracks the unread notification badge count across the app.
final class NotificationProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }

  void updateCount(int newCount) {
    _count = newCount;
    notifyListeners();
  }
}
