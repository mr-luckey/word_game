import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
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
    required this.onHome,
    required this.onReplay,
    required this.onNext,
    this.wordsFound,
    this.wordsTotal,
  });

  final int stars;
  final int coinsEarned;
  final Duration time;
  final int hintsUsed;
  final int levelId;
  final VoidCallback onHome;
  final VoidCallback onReplay;
  final VoidCallback onNext;
  final int? wordsFound;
  final int? wordsTotal;

  @override
  State<LevelCompleteOverlay> createState() => _LevelCompleteOverlayState();
}

class _LevelCompleteOverlayState extends State<LevelCompleteOverlay> {
  late final ConfettiController _confettiController;
  int _displayCoins = 0;
  bool _coinsDoubled = false;
  bool _adLoading = false;

  @override
  void initState() {
    super.initState();
    _displayCoins = widget.coinsEarned;
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

  Future<void> _watchAdForDouble() async {
    if (_coinsDoubled || _adLoading) return;
    setState(() => _adLoading = true);

    final rewarded = await getIt<AdService>().showRewardedAd(
      onReward: (_) {},
      onFail: () {},
    );

    if (!mounted) return;

    if (rewarded) {
      await context.read<CoinCubit>().add(widget.coinsEarned);
      setState(() {
        _displayCoins = widget.coinsEarned * 2;
        _coinsDoubled = true;
        _adLoading = false;
      });
      _confettiController.play();
    } else {
      setState(() => _adLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad not available. Try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 28,
            colors: [
              colors.gold,
              colors.primary,
              colors.secondary,
              colors.onPrimary,
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 360,
              maxHeight: MediaQuery.sizeOf(context).height * 0.88,
            ),
            child: SingleChildScrollView(
              child: GlassPanel(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 72,
                      child: Lottie.asset(
                        AssetPaths.starBurstLottie,
                        repeat: false,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    Text(
                      'LEVEL COMPLETE!',
                      style: AppTextStyles.levelName(context).copyWith(
                        fontSize: 20,
                        color: colors.tertiary,
                      ),
                    ).animate().fadeIn().scale(
                          begin: const Offset(0.85, 0.85),
                          end: const Offset(1, 1),
                        ),
                    const SizedBox(height: AppSizes.paddingSm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        final filled = i < widget.stars;
                        return Icon(
                          filled ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: colors.gold,
                          size: 32,
                        )
                            .animate(delay: (i * 100).ms)
                            .scale(
                              begin: const Offset(0, 0),
                              end: const Offset(1, 1),
                              curve: Curves.elasticOut,
                              duration: 500.ms,
                            );
                      }),
                    ),
                    const SizedBox(height: AppSizes.paddingSm),
                    _StatRow(
                      context: context,
                      icon: Icons.timer_rounded,
                      label: 'Time',
                      value: _formatTime(widget.time),
                    ),
                    if (widget.wordsTotal != null)
                      _StatRow(
                        context: context,
                        icon: Icons.spellcheck_rounded,
                        label: 'Words',
                        value:
                            '${widget.wordsFound ?? widget.wordsTotal}/${widget.wordsTotal}',
                      ),
                    _StatRow(
                      context: context,
                      icon: Icons.lightbulb_rounded,
                      label: 'Hints',
                      value: '${widget.hintsUsed} used',
                    ),
                    const SizedBox(height: AppSizes.paddingSm),
                    _CoinRewardDisplay(
                      displayCoins: _displayCoins,
                      doubled: _coinsDoubled,
                    ),
                    const SizedBox(height: AppSizes.paddingMd),
                    _RewardedAdButton(
                      loading: _adLoading,
                      doubled: _coinsDoubled,
                      onPressed: _watchAdForDouble,
                    ),
                    const SizedBox(height: AppSizes.paddingMd),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: widget.onHome,
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text('Home'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: widget.onReplay,
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text('Replay'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GradientButton(
                      label: 'Next Level',
                      expanded: true,
                      useGold: true,
                      compact: true,
                      onPressed: widget.onNext,
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 350.ms)
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
                curve: Curves.easeOutBack,
              ),
        ],
      ),
    );
  }
}

class _CoinRewardDisplay extends StatelessWidget {
  const _CoinRewardDisplay({
    required this.displayCoins,
    required this.doubled,
  });

  final int displayCoins;
  final bool doubled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AnimatedContainer(
      duration: 400.ms,
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: doubled
              ? [colors.gold, colors.goldDark]
              : [
                  colors.gold.withValues(alpha: 0.25),
                  colors.gold.withValues(alpha: 0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: doubled
            ? [
                BoxShadow(
                  color: colors.gold.withValues(alpha: 0.5),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.monetization_on_rounded,
            color: doubled ? colors.onPrimary : colors.goldDark,
            size: 28,
          )
              .animate(target: doubled ? 1 : 0)
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.3, 1.3),
                duration: 400.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: 500.ms,
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: anim,
              child: child,
            ),
            child: Text(
              '+ $displayCoins coins',
              key: ValueKey(displayCoins),
              style: AppTextStyles.coinsScore(context).copyWith(
                fontSize: doubled ? 22 : 18,
                color: doubled ? colors.onPrimary : colors.goldDark,
              ),
            ),
          ),
          if (doubled) ...[
            const SizedBox(width: 8),
            Text(
              '2×',
              style: AppTextStyles.button(context).copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ).animate().fadeIn().slideX(begin: 0.3, end: 0),
          ],
        ],
      ),
    )
        .animate(target: doubled ? 1 : 0)
        .shake(hz: 3, duration: 400.ms);
  }
}

class _RewardedAdButton extends StatelessWidget {
  const _RewardedAdButton({
    required this.loading,
    required this.doubled,
    required this.onPressed,
  });

  final bool loading;
  final bool doubled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (doubled) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, color: colors.success, size: 20),
          const SizedBox(width: 6),
          Text(
            'Coins doubled!',
            style: AppTextStyles.wordList(context).copyWith(
              color: colors.success,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ).animate().fadeIn().scale();
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: loading ? null : onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            gradient: colors.playButtonGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.goldLight, width: 2),
            boxShadow: [
              BoxShadow(
                color: colors.gold.withValues(alpha: 0.45),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading)
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.onPrimary,
                    ),
                  )
                else
                  Icon(Icons.play_circle_filled_rounded,
                      color: colors.onPrimary, size: 28)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.12, 1.12),
                        duration: 800.ms,
                      ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'WATCH AD',
                      style: AppTextStyles.button(context).copyWith(
                        fontSize: 15,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Double your coins!',
                      style: AppTextStyles.button(context).copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: colors.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.onPrimary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '2×',
                    style: AppTextStyles.button(context).copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(
          duration: 2.seconds,
          color: colors.onPrimary.withValues(alpha: 0.35),
        )
        .then()
        .shake(hz: 0.5, duration: 2.seconds);
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.context,
    required this.icon,
    required this.label,
    required this.value,
  });

  final BuildContext context;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext ctx) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: colors.locked),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: AppTextStyles.wordList(context).copyWith(fontSize: 13),
          ),
          Text(
            value,
            style: AppTextStyles.wordList(context).copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
