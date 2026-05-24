import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';

/// Full-width PLAY NOW button — gold gradient, dark play icon, 52dp height.
class JourneyPlayButton extends StatelessWidget {
  const JourneyPlayButton({
    super.key,
    required this.onPressed,
    this.label = 'PLAY NOW',
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
  return SizedBox(
      width: double.infinity,
      height: 52,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: JourneyDecorations.primaryButtonDecoration(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow_rounded, color: colors.onPrimary, size: 28),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.button(context).copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: colors.onPrimary,
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
