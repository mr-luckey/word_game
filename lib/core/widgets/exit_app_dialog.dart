import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_game/core/widgets/journey_prompt_dialog.dart';

/// Shows a confirmation dialog before closing the app.
Future<bool> showExitAppDialog(BuildContext context) async {
  final result = await showJourneyPromptDialog(
    context,
    kind: JourneyPromptKind.exit,
  );
  return result == true;
}

Future<void> exitAppIfConfirmed(BuildContext context) async {
  final exit = await showExitAppDialog(context);
  if (exit && context.mounted) {
    await SystemNavigator.pop();
  }
}
