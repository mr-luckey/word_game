import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/game_screen_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/game/presentation/widgets/game_screen_metrics.dart';

/// Circular action button with neon ring and a colored label capsule.
class GameActionButton extends StatelessWidget {
  const GameActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.glowColor,
    required this.onPressed,
    this.subtitle,
    this.showCoin = false,
    this.disabled = false,
    this.large = false,
  });

  final String label;
  final IconData icon;
  final Color glowColor;
  final VoidCallback? onPressed;
  final String? subtitle;
  final bool showCoin;
  final bool disabled;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final light = context.themePreset.gameSpec.lightAtmosphere;
    final m = GameScreenScope.of(context);
    final buttonSize = m.s(large ? 44 : 38);
    final ringWidth = m.s(2);
    final iconSize = m.s(large ? 20 : 18);

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: BorderRadius.circular(m.s(40)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.55),
                      blurRadius: m.s(10),
                      spreadRadius: m.s(0.4),
                    ),
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.22),
                      blurRadius: m.s(16),
                    ),
                  ],
                ),
                child: Container(
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: light
                        ? const Color(0xF2F4FAFF)
                        : const Color(0xE6101018),
                    border: Border.all(
                      color: glowColor,
                      width: ringWidth,
                    ),
                  ),
                  child: Icon(icon, color: glowColor, size: iconSize),
                ),
              ),
              SizedBox(height: m.s(4)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: m.s(8),
                  vertical: m.s(3),
                ),
                decoration: BoxDecoration(
                  color: light
                      ? Colors.white.withValues(alpha: 0.92)
                      : glowColor.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(m.s(10)),
                  border: Border.all(
                    color: glowColor.withValues(alpha: 0.75),
                    width: m.s(1.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.28),
                      blurRadius: m.s(8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.subtitle(context).copyWith(
                        fontSize: m.s(10),
                        fontWeight: FontWeight.w800,
                        color: light
                            ? const Color(0xFF0D2137)
                            : colors.onScenic,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: m.s(1)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showCoin) ...[
                            Icon(
                              Icons.monetization_on_rounded,
                              color: colors.gold,
                              size: m.s(9),
                            ),
                            SizedBox(width: m.s(3)),
                          ],
                          Text(
                            subtitle!,
                            style: AppTextStyles.bodyMuted(context).copyWith(
                              fontSize: m.s(8),
                              fontWeight: FontWeight.w600,
                              color: light
                                  ? const Color(0xFF1E3A5F)
                                  : colors.onScenic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
