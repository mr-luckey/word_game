import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/theme/destination_catalog.dart';
import 'package:word_game/features/home/presentation/cubit/destinations_cubit.dart';
import 'package:word_game/features/home/presentation/widgets/world_tour/world_tour_branding.dart';
import 'package:word_game/features/home/presentation/widgets/world_tour/world_tour_journey_card.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

/// World Tour home — matches design mockup (splash bg + journey card only).
class WorldTourHomeScreen extends StatelessWidget {
  const WorldTourHomeScreen({super.key});

  void _goLevels(BuildContext context, int themeId) {
    getIt<AppThemeBloc>().setDestinationContext(themeId);
    context.go('/levels?themeId=$themeId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FF),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AssetPaths.worldTourSplashBg,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          SafeArea(
            child: Column(
              children: [
                _CoinsBar(),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: WorldTourBranding(compact: true),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: BlocBuilder<DestinationsCubit, DestinationsState>(
                    builder: (context, state) {
                      if (state.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final theme =
                          state.themes.isNotEmpty ? state.themes.first : null;
                      final featured = DestinationCatalog.forPreset(
                        AppThemePreset.worldTour,
                      ).where((d) => d.unlockOrder == 1).first;
                      final meta = (theme != null
                              ? DestinationCatalog.byId(theme.id)
                              : null) ??
                          featured;
                      final completed = state.featuredCompleted;
                      final total =
                          state.featuredTotal > 0 ? state.featuredTotal : 20;
                      final level = total > 0
                          ? (completed < total ? completed + 1 : total)
                          : 1;

                      return Align(
                        alignment: Alignment.topCenter,
                        child: WorldTourJourneyCard(
                          title: theme?.name ?? meta.name,
                          level: level,
                          completed: completed,
                          total: total,
                          onContinue: () =>
                              _goLevels(context, theme?.id ?? meta.id),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Row(
        children: [
          const Spacer(),
          BlocBuilder<CoinCubit, CoinState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFE566), Color(0xFFFFC107)],
                        ),
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Color(0xFF1B3A6E),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${state.coins}',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: WorldTourBranding.titleBlue,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
