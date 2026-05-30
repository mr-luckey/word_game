import 'package:flutter/material.dart';
import 'package:word_game/core/navigation/journey_nav.dart';

/// Standard system-back for full-screen routes pushed on the root navigator.
class RouteBackHandler extends StatelessWidget {
  const RouteBackHandler({
    super.key,
    required this.child,
    this.fallback = '/home',
    this.onPop,
  });

  final Widget child;
  final String fallback;
  final VoidCallback? onPop;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (onPop != null) {
          onPop!();
        } else {
          journeyPop(context, fallback: fallback);
        }
      },
      child: child,
    );
  }
}
