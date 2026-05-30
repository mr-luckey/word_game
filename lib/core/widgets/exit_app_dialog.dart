import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_game/core/theme/theme_context.dart';

/// Shows a confirmation dialog before closing the app.
Future<bool> showExitAppDialog(BuildContext context) async {
  final colors = context.appColors;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: colors.glassSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.glassBorder),
      ),
      title: Text(
        'Exit game?',
        style: TextStyle(
          color: colors.onScenic,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        'Are you sure you want to close Word Search Journey?',
        style: TextStyle(color: colors.onScenicMuted, height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text('Cancel', style: TextStyle(color: colors.onScenicMuted)),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: FilledButton.styleFrom(
            backgroundColor: colors.gold,
            foregroundColor: colors.scrim,
          ),
          child: const Text('Exit'),
        ),
      ],
    ),
  );
  return result == true;
}

Future<void> exitAppIfConfirmed(BuildContext context) async {
  final exit = await showExitAppDialog(context);
  if (exit && context.mounted) {
    await SystemNavigator.pop();
  }
}
