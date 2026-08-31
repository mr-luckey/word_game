import 'package:flutter/foundation.dart';

/// Debug-only switches. Release builds ignore these even if a flag is true.
class DebugFlags {
  DebugFlags._();

  /// Unlock every destination and sequential level.
  static const bool unlockAllLevels = false;

  /// Schedule five local test notifications (10s apart) on debug launch.
  static const bool scheduleTestNotifications = false;

  static bool get unlockAllContent => kDebugMode && unlockAllLevels;

  static bool get sendTestNotifications =>
      kDebugMode && scheduleTestNotifications;
}
