import 'package:flutter/material.dart';

/// Layout metrics for the floating [JourneyBottomNav] in [MainShell].
abstract final class ShellNavMetrics {
  static const horizontalMargin = 16.0;
  static const floatBottomMargin = 12.0;
  static const innerVerticalPadding = 8.0;
  static const iconSlotHeight = 36.0;
  static const labelGap = 2.0;
  static const labelHeight = 14.0;

  /// Nav pill height (icon row + label), excluding outer margins and safe area.
  static const pillHeight = innerVerticalPadding * 2 +
      iconSlotHeight +
      labelGap +
      labelHeight;

  /// Space the nav occupies above the home indicator (excludes safe area).
  static const overlayClearance = floatBottomMargin + pillHeight;

  /// Bottom inset for shell tab content — safe area + floating nav.
  static double contentBottomPadding(BuildContext context) {
    return MediaQuery.viewPaddingOf(context).bottom + overlayClearance;
  }

  /// ListView trailing padding when the parent skips bottom [SafeArea].
  static double listBottomPadding(BuildContext context) {
    return contentBottomPadding(context) + 8;
  }
}
