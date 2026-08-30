import 'package:flutter/foundation.dart';

/// Debug-only switches. Release builds ignore these even if a flag is true.
class DebugFlags {
  DebugFlags._();

  /// Unlock every destination and sequential level.
  static const bool unlockAllLevels = true;

  static bool get unlockAllContent => kDebugMode && unlockAllLevels;
}
