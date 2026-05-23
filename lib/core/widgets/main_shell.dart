import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/widgets/journey_bottom_nav.dart';

/// Wraps main tab routes with persistent bottom navigation.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static int indexForLocation(String location) {
    if (location.startsWith('/destinations') || location.startsWith('/levels')) {
      return 1;
    }
    if (location.startsWith('/shop')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = indexForLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: JourneyBottomNav(
        selectedIndex: selectedIndex,
        onSelected: (i) {
          switch (i) {
            case 0:
              context.go('/home');
            case 1:
              context.go('/destinations');
            case 2:
              context.go('/shop');
            case 3:
              context.go('/profile');
          }
        },
      ),
    );
  }
}
