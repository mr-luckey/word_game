import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLg,
              vertical: AppSizes.paddingMd,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: AppSizes.paddingSm),
                ],
                Text(label, style: AppTextStyles.button),
              ],
            ),
          ),
        ),
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: child) : child;
  }
}
