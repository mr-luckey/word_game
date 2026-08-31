import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/navigation/shell_back_handler.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/widgets/ads/shell_banner_ad.dart';
import 'package:word_game/core/widgets/shell_nav_metrics.dart';
import 'package:word_game/injection.dart';

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
    final mediaQuery = MediaQuery.of(context);
    final ads = getIt<AdService>();
    final reserveBanner = !ads.adsRemoved;
    final shellPadding = mediaQuery.padding.copyWith(
      bottom: ShellNavMetrics.contentBottomPadding(
        context,
        reserveBanner: reserveBanner,
      ),
    );

    return ShellBackHandler(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: MediaQuery(
          data: mediaQuery.copyWith(padding: shellPadding),
          child: child,
        ),
        bottomNavigationBar: ShellBottomDock(
          bannerPlacement: ShellBannerAd.placementForLocation(location),
          selectedIndex: selectedIndex,
          onSelected: (i) {
            switch (i) {
              case 0:
                if (selectedIndex != 0) context.go('/home');
              case 1:
                if (selectedIndex != 1) context.go('/destinations');
              case 2:
                if (selectedIndex != 2) context.go('/shop');
              case 3:
                if (selectedIndex != 3) context.go('/profile');
            }
          },
        ),
      ),
    );
  }
}
