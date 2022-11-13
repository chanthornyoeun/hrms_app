import 'package:flutter/material.dart';

class NotificationBadgeCount extends ChangeNotifier {
  int _badgeCount = 0;

  void setBadgeCount(int badgeCount) {
    _badgeCount = badgeCount;
    notifyListeners();
  }

  int getBadgeCount() {
    return _badgeCount;
  }
}
