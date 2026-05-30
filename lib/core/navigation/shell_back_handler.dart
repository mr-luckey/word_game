import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/widgets/exit_app_dialog.dart';

/// Handles Android/iOS system back inside [MainShell] tab routes.
class ShellBackHandler extends StatelessWidget {
  const ShellBackHandler({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack(context);
      },
      child: child,
    );
  }

  Future<void> _handleBack(BuildContext context) async {
    final path = GoRouterState.of(context).uri.path;

    if (path.startsWith('/levels')) {
      if (context.mounted) context.go('/destinations');
      return;
    }
    if (path.startsWith('/destinations')) {
      if (context.mounted) context.go('/home');
      return;
    }
    if (path.startsWith('/shop') || path.startsWith('/profile')) {
      if (context.mounted) context.go('/home');
      return;
    }
    if (path.startsWith('/home')) {
      await exitAppIfConfirmed(context);
      return;
    }
    if (context.mounted) context.go('/home');
  }
}
