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
    this.compact = false,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final buttonSize = compact ? 42.0 : 56.0;
    final iconSize = compact ? 20.0 : 26.0;
    final labelGap = compact ? 3.0 : 6.0;
    final labelSize = compact ? 11.0 : 12.0;
    final subtitleSize = compact ? 9.0 : 10.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Ink(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surface.withValues(alpha: 0.9),
                border: Border.all(
                  color: colors.glassBorder.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: compact ? 6 : 10,
                    offset: Offset(0, compact ? 2 : 3),
                  ),
                ],
              ),
              child: Icon(icon, color: colors.gold, size: iconSize),
            ),
          ),
        ),
        SizedBox(height: labelGap),
        Text(
          label,
          style: AppTextStyles.wordList(context).copyWith(
            fontSize: labelSize,
            fontWeight: FontWeight.w700,
            color: colors.onScenic,
          ),
        ),
        Text(
          '$subtitle coins',
          style: AppTextStyles.bodyMuted(context).copyWith(fontSize: subtitleSize),
        ),
      ],
    );
  }
}
