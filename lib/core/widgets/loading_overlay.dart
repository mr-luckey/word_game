import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, this.message = 'Loading...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ColoredBox(
      color: colors.cream.withValues(alpha: 0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: colors.gold),
            const SizedBox(height: 16),
            Text(message, style: AppTextStyles.wordList(context)),
          ],
        ),
      ),
    );
  }
}
