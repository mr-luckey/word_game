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
    this.highlight = false,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;
  final bool highlight;

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
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: highlight
                    ? colors.playButtonGradient
                    : LinearGradient(
                        colors: [colors.surface, colors.cellAlt],
                      ),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: highlight ? colors.gold : colors.cellBorder,
                ),
              ),
              child: Icon(
                icon,
                color: highlight ? colors.onPrimary : colors.primary,
                size: 26,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.wordList(context).copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.onScenic,
          ),
        ),
        Text(
          subtitle,
          style: AppTextStyles.wordList(context).copyWith(
            fontSize: 9,
            color: colors.onScenicMuted,
          ),
        ),
      ],
    );
  }
}
