import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

enum JourneyPromptKind { exit, rating, update }

class JourneyPromptConfig {
  const JourneyPromptConfig({
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.secondaryLabel,
  });

  final IconData icon;
  final String title;
  final String message;
  final String primaryLabel;
  final String secondaryLabel;

  static JourneyPromptConfig forKind(JourneyPromptKind kind) {
    return switch (kind) {
      JourneyPromptKind.exit => const JourneyPromptConfig(
            icon: Icons.exit_to_app_rounded,
            title: 'Quit game?',
            message: 'Do you want to quit the game?',
            primaryLabel: 'Quit',
            secondaryLabel: 'Keep playing',
          ),
      JourneyPromptKind.rating => const JourneyPromptConfig(
            icon: Icons.favorite_rounded,
            title: 'Enjoying the app?',
            message:
                'Do you like Word Search Journey? Rate us on the Play Store!',
            primaryLabel: 'Rate now',
            secondaryLabel: 'Not now',
          ),
      JourneyPromptKind.update => const JourneyPromptConfig(
            icon: Icons.system_update_rounded,
            title: 'Update available',
            message:
                'A new version is available on the Play Store. Do you want to update the app?',
            primaryLabel: 'Update',
            secondaryLabel: 'Later',
          ),
    };
  }
}

/// Theme-aware prompt dialog used for exit, rating, and update flows.
/// Returns `true` when the user taps the primary action, `false` for secondary.
Future<bool?> showJourneyPromptDialog(
  BuildContext context, {
  required JourneyPromptKind kind,
}) {
  final config = JourneyPromptConfig.forKind(kind);
  return showDialog<bool>(
    context: context,
    barrierDismissible: kind != JourneyPromptKind.exit,
    builder: (ctx) => _JourneyPromptDialog(config: config),
  );
}

class _JourneyPromptDialog extends StatelessWidget {
  const _JourneyPromptDialog({required this.config});

  final JourneyPromptConfig config;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final cardFill = spec.cardFill.withValues(alpha: 0.98);
    final onCard = JourneyThemeKit.readableOn(
      cardFill,
      colors.onScenic,
      colors.onSurface,
    );
    final onCardMuted = onCard.withValues(alpha: 0.78);
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 360;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: compact ? 20 : 28),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: compact ? 340 : 400),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardFill,
                colors.scrim.withValues(alpha: 0.9),
              ],
            ),
            border: Border.all(
              color: colors.glassBorder.withValues(alpha: 0.75),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.scrim.withValues(alpha: 0.45),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: spec.playButtonGlow.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              compact ? 18 : 22,
              compact ? 20 : 24,
              compact ? 18 : 22,
              compact ? 18 : 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: compact ? 54 : 60,
                  height: compact ? 54 : 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [colors.gold, spec.playButtonGlow],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.gold.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    config.icon,
                    color: JourneyThemeKit.readableOn(
                      colors.gold,
                      Colors.white,
                      colors.onSurface,
                    ),
                    size: compact ? 28 : 30,
                  ),
                ),
                SizedBox(height: compact ? 14 : 16),
                Text(
                  config.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.gameTitle(context).copyWith(
                    fontSize: compact ? 20 : 22,
                    color: onCard,
                    height: 1.15,
                    shadows: JourneyThemeKit.textGlow(context, strength: 0.6),
                  ),
                ),
                SizedBox(height: compact ? 8 : 10),
                Text(
                  config.message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle(context).copyWith(
                    color: onCardMuted,
                    fontSize: compact ? 13 : 14,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: compact ? 18 : 22),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.gold,
                      foregroundColor: JourneyThemeKit.readableOn(
                        colors.gold,
                        colors.scrim,
                        colors.onSurface,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      config.primaryLabel,
                      style: AppTextStyles.button(context).copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: JourneyThemeKit.readableOn(
                          colors.gold,
                          colors.scrim,
                          colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      config.secondaryLabel,
                      style: AppTextStyles.button(context).copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: onCardMuted,
                      ),
                    ),
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
