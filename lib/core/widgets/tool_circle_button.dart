import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_text_styles.dart';

class ToolCircleButton extends StatelessWidget {
  const ToolCircleButton({
    super.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    this.highlight = false,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Ink(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: highlight
                    ? AppColors.playButtonGradient
                    : const LinearGradient(
                        colors: [Colors.white, Color(0xFFF5F5F5)],
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: highlight
                      ? AppColors.gold
                      : AppColors.cellBorder,
                ),
              ),
              child: Icon(
                icon,
                color: highlight ? Colors.white : AppColors.primaryBlue,
                size: 26,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.wordList.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          subtitle,
          style: AppTextStyles.wordList.copyWith(
            fontSize: 9,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
