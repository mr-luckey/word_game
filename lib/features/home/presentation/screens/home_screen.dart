import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/gradient_button.dart';
import 'package:word_game/features/home/presentation/widgets/destination_card.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WORD SEARCH'),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context.push('/settings'),
        ),
        actions: [
          BlocBuilder<CoinCubit, CoinState>(
            builder: (context, state) => Padding(
              padding: const EdgeInsets.only(right: AppSizes.paddingMd),
              child: Center(child: CoinDisplay(coins: state.coins)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.lightBlueBg, AppColors.cellDefault],
              ),
            ),
            child: CustomPaint(
              painter: _MapPainter(),
              size: Size.infinite,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Column(
              children: [
                const Spacer(),
                const DestinationCard(
                  title: 'PARIS ADVENTURE',
                  completed: 12,
                  total: 50,
                ),
                const SizedBox(height: AppSizes.paddingLg),
                GradientButton(
                  label: 'PLAY NOW',
                  icon: Icons.play_arrow,
                  onPressed: () => context.push('/levels?themeId=1'),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.03, 1.03),
                      duration: 900.ms,
                    ),
                const SizedBox(height: AppSizes.paddingMd),
                Text(
                  '240 / 1000 levels',
                  style: AppTextStyles.wordList,
                ),
                const SizedBox(height: AppSizes.paddingSm),
                TextButton.icon(
                  onPressed: () => context.push('/game?levelId=9999'),
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('Daily Bonus'),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              break;
            case 1:
              context.push('/destinations');
            case 2:
              context.push('/shop');
            case 3:
              context.push('/profile');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Levels'),
          NavigationDestination(icon: Icon(Icons.store), label: 'Shop'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.oceanBlue.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.3), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.5), 30, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.2), 25, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
