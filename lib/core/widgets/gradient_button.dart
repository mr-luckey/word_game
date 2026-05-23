import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
    this.useGold = false,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;
  final bool useGold;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final gradient =
        useGold ? colors.playButtonGradient : colors.primaryGradient;
    final shadowColor = useGold ? colors.gold : colors.primary;

    final child = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.45),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? AppSizes.paddingMd : AppSizes.paddingLg,
              vertical: compact ? AppSizes.paddingSm : AppSizes.paddingMd + 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: colors.onPrimary, size: compact ? 20 : 28),
                  SizedBox(width: compact ? 4 : AppSizes.paddingSm),
                ],
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.button(context).copyWith(
                      fontSize: compact ? 14 : 18,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final sized = expanded ? SizedBox(width: double.infinity, child: child) : child;
    return sized.animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
