import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/widgets/journey_bottom_nav.dart';
import 'package:word_game/core/widgets/world_tour_persistent_nav.dart';

/// Wraps main tab routes with persistent bottom navigation.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _profileNavIndex = 3;

  static int _routeIndex(String location) {
    if (location.startsWith('/destinations') ||
        location.startsWith('/levels')) {
      return 1;
    }
    if (location.startsWith('/profile')) return -1;
    if (location.startsWith('/shop')) return 2;
    return 0;
  }

  int _selectedIndex(String location, bool worldTour) {
    final routeIndex = _routeIndex(location);
    if (routeIndex >= 0) return routeIndex;
    if (location.startsWith('/profile')) return _profileNavIndex;
    return 0;
  }

  void _onWorldTourSelected(BuildContext context, int index) {
    if (index == 2 || index == 3) {
      setState(() => _profileNavIndex = index);
    }
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        context.go('/destinations');
      case 2:
      case 3:
        context.go('/profile');
    }
  }

  void _onClassicSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        context.go('/destinations');
      case 2:
        context.go('/shop');
      case 3:
        context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return BlocBuilder<AppThemeBloc, AppThemeState>(
      buildWhen: (p, c) => p.activePreset != c.activePreset,
      builder: (context, themeState) {
        final worldTour = themeState.activePreset == AppThemePreset.worldTour;
        final selectedIndex = _selectedIndex(location, worldTour);

        return Scaffold(
          body: widget.child,
          bottomNavigationBar: worldTour
              ? WorldTourPersistentNav(
                  selectedIndex: selectedIndex.clamp(0, 3),
                  onSelected: (i) => _onWorldTourSelected(context, i),
                )
              : JourneyBottomNav(
                  selectedIndex: selectedIndex.clamp(0, 3),
                  onSelected: (i) => _onClassicSelected(context, i),
                ),
        );
      },
    );
  }
}
