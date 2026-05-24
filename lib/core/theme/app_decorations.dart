import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';

/// Centralized decorations — all screens access styling from here.
class JourneyDecorations {
  JourneyDecorations._();

  static BoxDecoration primaryButtonDecoration(BuildContext context) {
    final colors = context.appColors;
    final preset = context.themePreset;
    return BoxDecoration(
      gradient: _playGradient(preset, colors),
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      boxShadow: [
        BoxShadow(
          color: (preset.useNeonGlow ? colors.primary : colors.gold)
              .withValues(alpha: 0.45),
          blurRadius: preset.useNeonGlow ? 16 : 12,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: colors.glassBorder.withValues(alpha: 0.6),
        width: preset == AppThemePreset.darkLuxury ? 1.5 : 1,
      ),
    );
  }

  static BoxDecoration shopPriceButtonDecoration(BuildContext context) {
    final colors = context.appColors;
    return BoxDecoration(
      color: colors.shopPriceButton,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: colors.shopPriceButton.withValues(alpha: 0.35),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration featuredCardDecoration(BuildContext context) {
    final colors = context.appColors;
    final preset = context.themePreset;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(preset.cardRadius),
      border: Border.all(color: colors.glassBorder, width: 1),
    );
  }

  static BoxDecoration levelTileDecoration(
    BuildContext context, {
    required bool locked,
    required bool isActive,
    required bool completed,
  }) {
    final colors = context.appColors;
    if (locked) {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.levelLockedStart, colors.levelLockedEnd],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.glassBorder.withValues(alpha: 0.25)),
      );
    }
    if (isActive) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.primary, colors.shopPriceButton],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.45),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      );
    }
    if (completed) {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.levelCompleteStart, colors.levelCompleteEnd],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.gold.withValues(alpha: 0.45)),
      );
    }
    return BoxDecoration(
      color: colors.surface.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: colors.glassBorder.withValues(alpha: 0.35)),
    );
  }

  static BoxDecoration wordChipDecoration(
    BuildContext context, {
    required bool found,
  }) {
    final colors = context.appColors;
    return BoxDecoration(
      color:
          found ? colors.success.withValues(alpha: 0.25) : colors.glassSurface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color:
            found ? colors.success : colors.glassBorder.withValues(alpha: 0.5),
      ),
    );
  }

  static Gradient _playGradient(AppThemePreset preset, dynamic colors) {
    return switch (preset.playButtonStyle) {
      PlayButtonStyle.neonGradient => colors.playButtonGradient,
      PlayButtonStyle.icyBlue => colors.playButtonGradient,
      PlayButtonStyle.tealSolid => colors.playButtonGradient,
      _ => colors.playButtonGradient,
    };
  }

  static Widget shopPriceButton(
    BuildContext context, {
    required String price,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: shopPriceButtonDecoration(context),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 72),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                price,
                textAlign: TextAlign.center,
                style: AppTextStyles.button(context).copyWith(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget bestValueBadge(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.warning,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Best Value',
        style: AppTextStyles.wordChip(context).copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}
