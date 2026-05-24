import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Safe back — avoids GoError when the stack is empty (e.g. after [GoRouter.go]).
void journeyPop(
  BuildContext context, {
  Object? result,
  String fallback = '/home',
}) {
  if (context.canPop()) {
    context.pop(result);
  } else {
    context.go(fallback);
  }
}

void journeyPopFromGame(
  BuildContext context, {
  Object? result,
  int? themeId,
}) {
  if (context.canPop()) {
    context.pop(result);
  } else if (themeId != null) {
    context.go('/levels?themeId=$themeId');
  } else {
    context.go('/home');
  }
}

void journeyPopFromLevels(BuildContext context) {
  journeyPop(context, fallback: '/destinations');
}
