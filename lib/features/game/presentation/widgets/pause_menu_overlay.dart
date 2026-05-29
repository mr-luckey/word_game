import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/data/game_content_registry.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';
import 'package:word_game/injection.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';

enum _PauseButtonStyle { primary, secondary, danger }

class PauseMenuOverlay extends StatelessWidget {
  const PauseMenuOverlay({
    super.key,
    required this.state,
    required this.onResume,
    required this.onRestart,
    required this.onSettings,
    required this.onQuit,
  });

  final GameInProgress state;
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onSettings;
  final VoidCallback onQuit;

  int get _dailyLevelId => getIt<GameContentRegistry>().dailyChallenge.levelId;

  String get _title {
    if (state.levelId == _dailyLevelId) return 'DAILY BONUS';
    final name = state.levelTheme.trim();
    if (name.isEmpty) return 'ADVENTURE';
    return '${name.toUpperCase()} ADVENTURE';
  }

  String get _subtitle {
    if (state.levelId == _dailyLevelId) return 'Daily Challenge';
    return 'Level ${state.levelId}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return Material(
      color: colors.scrim.withValues(alpha: 0.72),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: SafeArea(
          child: JourneyContentWidth(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _CircleIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: onQuit,
                      ),
                      const Spacer(),
                      BlocBuilder<CoinCubit, CoinState>(
                        builder: (context, coinState) =>
                            CoinDisplay(coins: coinState.coins, light: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    _title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cinzel(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      letterSpacing: 0.8,
                      color: colors.onScenic,
                      shadows: JourneyThemeKit.textGlow(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _subtitle,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.onScenicMuted,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.accentCoin.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colors.accentCoin.withValues(alpha: 0.55),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.pause_rounded,
                              size: 14,
                              color: colors.accentCoin,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Paused',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: colors.accentCoin,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _PauseMenuButton(
                    label: 'RESUME',
                    icon: Icons.play_arrow_rounded,
                    style: _PauseButtonStyle.primary,
                    gradient: spec.playButtonGradient,
                    textColor: spec.playButtonTextColor,
                    glow: spec.playButtonGlow,
                    onPressed: onResume,
                  ),
                  const SizedBox(height: 12),
                  _PauseMenuButton(
                    label: 'RESTART',
                    icon: Icons.refresh_rounded,
                    style: _PauseButtonStyle.secondary,
                    onPressed: onRestart,
                  ),
                  const SizedBox(height: 12),
                  _PauseMenuButton(
                    label: 'SETTINGS',
                    icon: Icons.settings_rounded,
                    style: _PauseButtonStyle.secondary,
                    onPressed: onSettings,
                  ),
                  const SizedBox(height: 12),
                  _PauseMenuButton(
                    label: 'QUIT LEVEL',
                    icon: Icons.logout_rounded,
                    style: _PauseButtonStyle.danger,
                    onPressed: onQuit,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.onScenic.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: colors.primary, size: 22),
        ),
      ),
    );
  }
}

class _PauseMenuButton extends StatelessWidget {
  const _PauseMenuButton({
    required this.label,
    required this.icon,
    required this.style,
    required this.onPressed,
    this.gradient,
    this.textColor,
    this.glow,
  });

  final String label;
  final IconData icon;
  final _PauseButtonStyle style;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final Color? textColor;
  final Color? glow;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    late List<Color> bgColors;
    late Color fg;
    late Color iconBg;
    List<BoxShadow>? shadows;

    switch (style) {
      case _PauseButtonStyle.primary:
        bgColors = (gradient as LinearGradient?)?.colors ??
            spec.playButtonGradient.colors;
        fg = textColor ?? spec.playButtonTextColor;
        iconBg = fg.withValues(alpha: 0.15);
        shadows = [
          BoxShadow(
            color: (glow ?? spec.playButtonGlow).withValues(alpha: 0.45),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ];
      case _PauseButtonStyle.secondary:
        bgColors = [
          colors.glassSurface.withValues(alpha: 0.95),
          colors.surface.withValues(alpha: 0.88),
        ];
        fg = colors.primary;
        iconBg = colors.primary.withValues(alpha: 0.1);
      case _PauseButtonStyle.danger:
        bgColors = [
          colors.timerDanger,
          colors.timerDanger.withValues(alpha: 0.82),
        ];
        fg = Colors.white;
        iconBg = Colors.white.withValues(alpha: 0.2);
        shadows = [
          BoxShadow(
            color: colors.timerDanger.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: bgColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: style == _PauseButtonStyle.secondary
                ? Border.all(
                    color: colors.glassBorder.withValues(alpha: 0.65),
                    width: 1.2,
                  )
                : null,
            boxShadow: shadows,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconBg,
                  ),
                  child: Icon(icon, color: fg, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: GoogleFonts.cinzel(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
