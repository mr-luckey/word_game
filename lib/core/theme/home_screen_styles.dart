import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';

enum HomeFeaturedLayout { fullBleed, splitGlass }

/// Per-theme tokens from [deisgn/home] mockups.
class HomeScreenSpec {
  const HomeScreenSpec({
    required this.featuredLayout,
    required this.journeyWordColor,
    required this.searchWordColor,
    required this.taglineColor,
    required this.featuredLine1Color,
    required this.featuredLine2Color,
    required this.playButtonGradient,
    required this.playButtonTextColor,
    required this.playButtonGlow,
    required this.cardFill,
    required this.cardBorderWidth,
    required this.useNeonCardGlow,
    required this.useGlassCards,
    required this.dailyBonusAccent,
    required this.achievementAccent,
    required this.featuredLabelIcon,
    this.playUsesCompass = false,
    this.playIconLight = true,
  });

  final HomeFeaturedLayout featuredLayout;
  final Color journeyWordColor;
  final Color searchWordColor;
  final Color taglineColor;
  final Color featuredLine1Color;
  final Color featuredLine2Color;
  final Gradient playButtonGradient;
  final Color playButtonTextColor;
  final Color playButtonGlow;
  final Color cardFill;
  final double cardBorderWidth;
  final bool useNeonCardGlow;
  final bool useGlassCards;
  final Color dailyBonusAccent;
  final Color achievementAccent;
  final IconData featuredLabelIcon;
  final bool playUsesCompass;
  final bool playIconLight;
}

extension HomeScreenSpecX on AppThemePreset {
  String get homeBackgroundAsset =>
      'assets/images/themes/$folder/grid_full.webp';

  HomeScreenSpec get homeSpec => switch (this) {
        AppThemePreset.worldTour => const HomeScreenSpec(
              featuredLayout: HomeFeaturedLayout.fullBleed,
              journeyWordColor: Color(0xFFFFC107),
              searchWordColor: Color(0xFF1B3A6E),
              taglineColor: Color(0xFF1B3A6E),
              featuredLine1Color: Color(0xFF1B3A6E),
              featuredLine2Color: Color(0xFFFFFFFF),
              playButtonGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFE566), Color(0xFFFFC107), Color(0xFFE6A800)],
              ),
              playButtonTextColor: Color(0xFF1B3A6E),
              playButtonGlow: Color(0xFFFFD54F),
              cardFill: Color(0xCC1B3A6E),
              cardBorderWidth: 1.5,
              useNeonCardGlow: false,
              useGlassCards: true,
              dailyBonusAccent: Color(0xFFFFC107),
              achievementAccent: Color(0xFFFFC107),
              featuredLabelIcon: Icons.flight_rounded,
              playUsesCompass: true,
              playIconLight: false,
            ),
        AppThemePreset.classicTravel => const HomeScreenSpec(
              featuredLayout: HomeFeaturedLayout.fullBleed,
              journeyWordColor: Color(0xFFD4AF37),
              searchWordColor: Color(0xFFFFFFFF),
              taglineColor: Color(0xFFD4AF37),
              featuredLine1Color: Color(0xFFFFFFFF),
              featuredLine2Color: Color(0xFFFFFFFF),
              playButtonGradient: LinearGradient(
                colors: [Color(0xFFFFE566), Color(0xFFD4AF37), Color(0xFFB8860B)],
              ),
              playButtonTextColor: Color(0xFF001021),
              playButtonGlow: Color(0xFFFFD700),
              cardFill: Color(0xCC0A1628),
              cardBorderWidth: 1.5,
              useNeonCardGlow: false,
              useGlassCards: true,
              dailyBonusAccent: Color(0xFFD4AF37),
              achievementAccent: Color(0xFFD4AF37),
              featuredLabelIcon: Icons.flight_rounded,
              playIconLight: true,
            ),
        AppThemePreset.forestQuest => const HomeScreenSpec(
              featuredLayout: HomeFeaturedLayout.fullBleed,
              journeyWordColor: Color(0xFFC5A059),
              searchWordColor: Color(0xFFF5F0E1),
              taglineColor: Color(0xFFC5A059),
              featuredLine1Color: Color(0xFFF5F0E1),
              featuredLine2Color: Color(0xFFF5F0E1),
              playButtonGradient: LinearGradient(
                colors: [Color(0xFFE8D5A3), Color(0xFFC5A059), Color(0xFF8D6E3A)],
              ),
              playButtonTextColor: Color(0xFF051A05),
              playButtonGlow: Color(0xFFC5A059),
              cardFill: Color(0xCC051A05),
              cardBorderWidth: 1.5,
              useNeonCardGlow: false,
              useGlassCards: true,
              dailyBonusAccent: Color(0xFFC5A059),
              achievementAccent: Color(0xFFC5A059),
              featuredLabelIcon: Icons.eco_rounded,
              playUsesCompass: true,
              playIconLight: false,
            ),
        AppThemePreset.neonCity => const HomeScreenSpec(
              featuredLayout: HomeFeaturedLayout.splitGlass,
              journeyWordColor: Color(0xFFFF00FF),
              searchWordColor: Color(0xFFFFFFFF),
              taglineColor: Color(0xFFE1BEE7),
              featuredLine1Color: Color(0xFFFFFFFF),
              featuredLine2Color: Color(0xFFFF00FF),
              playButtonGradient: LinearGradient(
                colors: [Color(0xFFFF00FF), Color(0xFF9C27B0)],
              ),
              playButtonTextColor: Color(0xFFFFFFFF),
              playButtonGlow: Color(0xFFFF00FF),
              cardFill: Color(0xB312122A),
              cardBorderWidth: 2,
              useNeonCardGlow: true,
              useGlassCards: true,
              dailyBonusAccent: Color(0xFFFF00FF),
              achievementAccent: Color(0xFFFF00FF),
              featuredLabelIcon: Icons.flight_rounded,
            ),
        AppThemePreset.sunsetSafari => const HomeScreenSpec(
              featuredLayout: HomeFeaturedLayout.splitGlass,
              journeyWordColor: Color(0xFFF0A500),
              searchWordColor: Color(0xFFFFFFFF),
              taglineColor: Color(0xFFE0D0B0),
              featuredLine1Color: Color(0xFFFFFFFF),
              featuredLine2Color: Color(0xFFFFFFFF),
              playButtonGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFDB813), Color(0xFFE65100)],
              ),
              playButtonTextColor: Color(0xFF2B1D14),
              playButtonGlow: Color(0xFFF0A500),
              cardFill: Color(0xCC2B1D14),
              cardBorderWidth: 1.5,
              useNeonCardGlow: false,
              useGlassCards: true,
              dailyBonusAccent: Color(0xFFF0A500),
              achievementAccent: Color(0xFFF0A500),
              featuredLabelIcon: Icons.flight_rounded,
              playIconLight: true,
            ),
        AppThemePreset.winterAlps => const HomeScreenSpec(
              featuredLayout: HomeFeaturedLayout.splitGlass,
              journeyWordColor: Color(0xFFE3F2FD),
              searchWordColor: Color(0xFFE3F2FD),
              taglineColor: Color(0xFFB3E5FC),
              featuredLine1Color: Color(0xFFFFFFFF),
              featuredLine2Color: Color(0xFFFFFFFF),
              playButtonGradient: LinearGradient(
                colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC), Color(0xFF81D4FA)],
              ),
              playButtonTextColor: Color(0xFF0B2347),
              playButtonGlow: Color(0xFF81D4FA),
              cardFill: Color(0x661A3A5F),
              cardBorderWidth: 2,
              useNeonCardGlow: false,
              useGlassCards: true,
              dailyBonusAccent: Color(0xFF81D4FA),
              achievementAccent: Color(0xFF81D4FA),
              featuredLabelIcon: Icons.flight_rounded,
              playIconLight: false,
            ),
        AppThemePreset.darkLuxury => const HomeScreenSpec(
              featuredLayout: HomeFeaturedLayout.splitGlass,
              journeyWordColor: Color(0xFFD4AF37),
              searchWordColor: Color(0xFFFFFFFF),
              taglineColor: Color(0xFFB0BEC5),
              featuredLine1Color: Color(0xFFFFFFFF),
              featuredLine2Color: Color(0xFFD4AF37),
              playButtonGradient: LinearGradient(
                colors: [Color(0xFFF9E29C), Color(0xFFD4AF37), Color(0xFF8B6914)],
              ),
              playButtonTextColor: Color(0xFF0A0A0A),
              playButtonGlow: Color(0xFFD4AF37),
              cardFill: Color(0xCC0A0A0A),
              cardBorderWidth: 1.5,
              useNeonCardGlow: false,
              useGlassCards: true,
              dailyBonusAccent: Color(0xFFD4AF37),
              achievementAccent: Color(0xFFD4AF37),
              featuredLabelIcon: Icons.flight_rounded,
              playIconLight: false,
            ),
        AppThemePreset.oceanEscape => const HomeScreenSpec(
              featuredLayout: HomeFeaturedLayout.splitGlass,
              journeyWordColor: Color(0xFFFFD700),
              searchWordColor: Color(0xFFFFFFFF),
              taglineColor: Color(0xFFB2EBF2),
              featuredLine1Color: Color(0xFFFFFFFF),
              featuredLine2Color: Color(0xFFFFFFFF),
              playButtonGradient: LinearGradient(
                colors: [Color(0xFFFFE082), Color(0xFFFFD700), Color(0xFFFF8F00)],
              ),
              playButtonTextColor: Color(0xFF004B57),
              playButtonGlow: Color(0xFFFFD700),
              cardFill: Color(0xB3004B57),
              cardBorderWidth: 2,
              useNeonCardGlow: false,
              useGlassCards: true,
              dailyBonusAccent: Color(0xFFFFD700),
              achievementAccent: Color(0xFFFFD700),
              featuredLabelIcon: Icons.star_rounded,
              playIconLight: true,
            ),
      };

  (String, String) splitDestinationTitle(String name) {
    final upper = name.toUpperCase();
    final parts = upper.split(' ');
    if (parts.length <= 1) return (upper, '');
    if (parts.length == 2) return (parts[0], parts[1]);
    final mid = parts.length ~/ 2;
    return (parts.sublist(0, mid).join(' '), parts.sublist(mid).join(' '));
  }
}
