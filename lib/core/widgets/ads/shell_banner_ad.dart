import 'package:flutter/material.dart';
import 'package:word_game/core/config/app_ads_config.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/widgets/ads/banner_ad_slot.dart';
import 'package:word_game/core/widgets/journey_bottom_nav.dart';
import 'package:word_game/injection.dart';

/// Standard banner strip for shell tabs — sits just above the floating nav.
class ShellBannerAd extends StatelessWidget {
  const ShellBannerAd({super.key, required this.placement});

  final String placement;

  static String placementForLocation(String location) {
    if (location.startsWith('/levels')) return AdPlacements.bannerLevelSelect;
    if (location.startsWith('/shop')) return AdPlacements.bannerShop;
    if (location.startsWith('/profile')) return AdPlacements.bannerProfile;
    if (location.startsWith('/destinations')) {
      return AdPlacements.bannerDestinations;
    }
    return AdPlacements.bannerHome;
  }

  @override
  Widget build(BuildContext context) {
    final ads = getIt<AdService>();
    if (ads.adsRemoved) return const SizedBox.shrink();

    return Center(
      child: BannerAdSlot(
        ads: ads,
        placement: placement,
        padding: EdgeInsets.zero,
        useSafeArea: false,
      ),
    );
  }
}

/// Banner + bottom nav as one attached bottom dock.
class ShellBottomDock extends StatelessWidget {
  const ShellBottomDock({
    super.key,
    required this.bannerPlacement,
    required this.selectedIndex,
    required this.onSelected,
  });

  final String bannerPlacement;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final ads = getIt<AdService>();
    final showBanner = !ads.adsRemoved;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showBanner) ShellBannerAd(placement: bannerPlacement),
        JourneyBottomNav(
          selectedIndex: selectedIndex,
          onSelected: onSelected,
        ),
      ],
    );
  }
}

/// Banner footer for full-screen routes outside [MainShell].
class ScreenFooterBanner extends StatelessWidget {
  const ScreenFooterBanner({
    super.key,
    required this.placement,
  });

  final String placement;

  @override
  Widget build(BuildContext context) {
    final ads = getIt<AdService>();
    if (ads.adsRemoved) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: Center(
        child: BannerAdSlot(
          ads: ads,
          placement: placement,
          padding: EdgeInsets.zero,
          useSafeArea: false,
        ),
      ),
    );
  }
}
