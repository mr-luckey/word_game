import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/widgets/glass_panel.dart';
import 'package:word_game/core/widgets/gradient_button.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class LevelCompleteOverlay extends StatefulWidget {
  const LevelCompleteOverlay({
    super.key,
    required this.stars,
    required this.coinsEarned,
    required this.time,
    required this.hintsUsed,
    required this.levelId,
    this.wordsFound,
    this.wordsTotal,
  });

  final int stars;
  final int coinsEarned;
  final Duration time;
  final int hintsUsed;
  final int levelId;
  final int? wordsFound;
  final int? wordsTotal;

  @override
  State<LevelCompleteOverlay> createState() => _LevelCompleteOverlayState();
}

class _LevelCompleteOverlayState extends State<LevelCompleteOverlay> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    )..play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 32,
              colors: const [
                AppColors.gold,
                AppColors.primaryBlue,
                AppColors.oceanBlue,
                Colors.white,
              ],
            ),
          ),
          GlassPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 90,
                  child: Lottie.asset(
                    AssetPaths.starBurstLottie,
                    repeat: false,
                    errorBuilder: (_, __, ___) => Lottie.asset(
                      AssetPaths.confettiLottie,
                      repeat: false,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ),
                Text(
                  'LEVEL COMPLETE!',
                  style: AppTextStyles.levelName.copyWith(
                    fontSize: 26,
                    color: AppColors.darkNavy,
                  ),
                )
                    .animate()
                    .fadeIn()
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                const SizedBox(height: AppSizes.paddingMd),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final filled = i < widget.stars;
                    return Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: AppColors.gold,
                      size: 44,
                    )
                        .animate(delay: (i * 120).ms)
                        .scale(
                          begin: const Offset(0, 0),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                          duration: 600.ms,
                        )
                        .shake(hz: 2, duration: 200.ms);
                  }),
                ),
                const SizedBox(height: AppSizes.paddingMd),
                _StatRow(
                  icon: Icons.timer_rounded,
                  label: 'Time',
                  value: _formatTime(widget.time),
                ),
                if (widget.wordsTotal != null)
                  _StatRow(
                    icon: Icons.spellcheck_rounded,
                    label: 'Words',
                    value:
                        '${widget.wordsFound ?? widget.wordsTotal}/${widget.wordsTotal}',
                  ),
                _StatRow(
                  icon: Icons.lightbulb_rounded,
                  label: 'Hints',
                  value: '${widget.hintsUsed} used',
                ),
                const SizedBox(height: AppSizes.paddingSm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.gold.withValues(alpha: 0.25),
                        AppColors.gold.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '+ ${widget.coinsEarned} coins',
                    style: AppTextStyles.coinsScore.copyWith(fontSize: 24),
                  ),
                )
                    .animate()
                    .shimmer(duration: 1.5.seconds, color: AppColors.gold.withValues(alpha: 0.4)),
                const SizedBox(height: AppSizes.paddingMd),
                OutlinedButton.icon(
                  onPressed: () async {
                    final ad = getIt<AdService>();
                    await ad.showRewardedAd(
                      onReward: (bonus) {
                        context
                            .read<CoinCubit>()
                            .add(bonus + widget.coinsEarned);
                      },
                      onFail: () {},
                    );
                  },
                  icon: const Icon(Icons.play_circle_outline_rounded),
                  label: const Text('Watch ad for 2x coins'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingMd),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.go('/home');
                        },
                        child: const Text('Home'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.pushReplacement(
                            '/game?levelId=${widget.levelId}',
                          );
                        },
                        child: const Text('Replay'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GradientButton(
                        label: 'Next',
                        expanded: true,
                        useGold: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.pushReplacement(
                            '/game?levelId=${widget.levelId + 1}',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: AppColors.lockedGray),
          const SizedBox(width: 8),
          Text('$label: ', style: AppTextStyles.wordList),
          Text(
            value,
            style: AppTextStyles.wordList.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
