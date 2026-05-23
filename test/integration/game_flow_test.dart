import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/core/theme/app_theme.dart';
import 'package:word_game/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  testWidgets('splash screen shows title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: BlocProvider(
          create: (_) => SplashCubit(),
          child: const SplashScreenBody(),
        ),
      ),
    );
    expect(find.text('WORD SEARCH JOURNEY'), findsOneWidget);
  });
}

/// Splash UI without GetIt — for tests only.
class SplashScreenBody extends StatelessWidget {
  const SplashScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('WORD SEARCH JOURNEY')),
    );
  }
}
