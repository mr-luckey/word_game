import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_game/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:word_game/features/auth/presentation/widgets/auth_sheet.dart';

/// Returns true when the user is signed in (opens login sheet if needed).
Future<bool> ensureSignedInForPurchase(BuildContext context) async {
  final auth = context.read<AuthCubit>().state;
  if (auth.isSignedIn) return true;

  final result = await showAuthSheet(
    context,
    initialMode: AuthSheetMode.login,
  );
  if (!context.mounted) return false;

  if (result == true && context.read<AuthCubit>().state.isSignedIn) {
    return true;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Sign in to complete purchases and sync your progress.'),
    ),
  );
  return false;
}
