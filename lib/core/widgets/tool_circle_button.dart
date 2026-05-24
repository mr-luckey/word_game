import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';

class ToolCircleButton extends StatelessWidget {
  const ToolCircleButton({
    super.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Ink(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surface.withValues(alpha: 0.9),
                border: Border.all(
                  color: colors.glassBorder.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: colors.gold, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.wordList(context).copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: colors.onScenic,
          ),
        ),
        Text(
          '$subtitle coins',
          style: AppTextStyles.bodyMuted(context).copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
