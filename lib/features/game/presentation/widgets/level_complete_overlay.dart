import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/glass_panel.dart';
import 'package:word_game/core/widgets/gradient_button.dart';
import 'package:word_game/features/game/domain/usecases/load_level_usecase.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/xp_cubit.dart';
import 'package:word_game/injection.dart';

class LevelCompleteOverlay extends StatefulWidget {
  const LevelCompleteOverlay({
    super.key,
    required this.stars,
    required this.coinsEarned,
    required this.xpEarned,
    required this.time,
    required this.hintsUsed,
    required this.levelId,
    required this.displayNumber,
    required this.onHome,
    required this.onReplay,
    required this.onNext,
    this.isDailyChallenge = false,
    this.wordsFound,
    this.wordsTotal,
  });

  final int stars;
  final int coinsEarned;
  final int xpEarned;
  final Duration time;
  final int hintsUsed;
  final int levelId;
  final int displayNumber;
  final VoidCallback onHome;
  final VoidCallback onReplay;
  final VoidCallback onNext;
  final bool isDailyChallenge;
  final int? wordsFound;
  final int? wordsTotal;

  @override
  State<LevelCompleteOverlay> createState() => _LevelCompleteOverlayState();
}

class _LevelCompleteOverlayState extends State<LevelCompleteOverlay> {
  late final ConfettiController _confettiController;
  int _displayCoins = 0;
  int _displayXp = 0;
  bool _coinsDoubled = false;
  bool _xpDoubled = false;
  bool _coinsAdLoading = false;
  bool _xpAdLoading = false;
  bool _rewardsGranted = false;

  @override
  void initState() {
    super.initState();
    _displayCoins = widget.coinsEarned;
    _displayXp = widget.xpEarned;
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    )..play();
    _grantBaseRewards();
  }

  Future<void> _grantBaseRewards() async {
    if (_rewardsGranted) return;
    _rewardsGranted = true;
    if (widget.coinsEarned > 0) {
      await getIt<AddCoinsUseCase>()(widget.coinsEarned);
    }
    if (widget.xpEarned > 0) {
      await getIt<AddXpUseCase>()(widget.xpEarned);
    }
    if (mounted) {
      context.read<CoinCubit>().refresh();
      context.read<XpCubit>().refresh();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _watchAdForDoubleCoins() async {
    if (_coinsDoubled || _coinsAdLoading || widget.coinsEarned <= 0) return;
    setState(() => _coinsAdLoading = true);

    var granted = false;
    final ok = await getIt<AdService>().showDoubleCoinsAd(
      levelCoins: widget.coinsEarned,
      onGranted: () => granted = true,
    );

    if (!mounted) return;

    if (ok && granted) {
      await context.read<CoinCubit>().add(widget.coinsEarned);
      setState(() {
        _displayCoins = widget.coinsEarned * 2;
        _coinsDoubled = true;
        _coinsAdLoading = false;
      });
      _confettiController.play();
    } else {
      setState(() => _coinsAdLoading = false);
    }
  }

  Future<void> _watchAdForDoubleXp() async {
    if (_xpDoubled || _xpAdLoading || widget.xpEarned <= 0) return;
    setState(() => _xpAdLoading = true);

    var granted = false;
    final ok = await getIt<AdService>().showDoubleXpAd(
      xpAmount: widget.xpEarned,
      onGranted: () => granted = true,
    );

    if (!mounted) return;

    if (ok && granted) {
      await context.read<XpCubit>().add(widget.xpEarned);
      setState(() {
        _displayXp = widget.xpEarned * 2;
        _xpDoubled = true;
        _xpAdLoading = false;
      });
      _confettiController.play();
    } else {
      setState(() => _xpAdLoading = false);
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
                      textAlign: TextAlign.center,
                      style: AppTextStyles.levelName(context).copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: colors.gold,
                      ),
                    ),
                    Text(
                      'Level ${widget.displayNumber}',
                      style: AppTextStyles.bodyMuted(context),
                    ),
                    const SizedBox(height: AppSizes.paddingSm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        return Icon(
                          i < widget.stars
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: colors.gold,
                          size: 32,
                        );
                      }),
                    ),
                    const SizedBox(height: AppSizes.paddingSm),
                    _RewardChip(
                      icon: Icons.bolt_rounded,
                      label: '+$_displayXp XP',
                      color: colors.primary,
                      doubled: _xpDoubled,
                    ),
                    const SizedBox(height: 8),
                    _RewardChip(
                      icon: Icons.monetization_on_rounded,
                      label: '+$_displayCoins Coins',
                      color: colors.gold,
                      doubled: _coinsDoubled,
                    ),
                    const SizedBox(height: AppSizes.paddingMd),
                    if (!_xpDoubled && widget.xpEarned > 0)
                      _AdButton(
                        label: 'Watch Ad — Double XP',
                        loading: _xpAdLoading,
                        onPressed: _watchAdForDoubleXp,
                      ),
                    if (!_coinsDoubled && widget.coinsEarned > 0) ...[
                      const SizedBox(height: 8),
                      _AdButton(
                        label: 'Watch Ad — Double Coins',
                        loading: _coinsAdLoading,
                        onPressed: _watchAdForDoubleCoins,
                      ),
                    ],
                    const SizedBox(height: AppSizes.paddingMd),
                    GradientButton(
                      label: 'Continue',
                      expanded: true,
                      useGold: true,
                      compact: true,
                      onPressed: widget.onNext,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: widget.onHome,
                            child: Text(widget.isDailyChallenge ? 'Done' : 'Home'),
                          ),
                        ),
                        if (!widget.isDailyChallenge) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: widget.onReplay,
                              child: const Text('Replay'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardChip extends StatelessWidget {
  const _RewardChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.doubled,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool doubled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: doubled ? 0.35 : 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.coinsScore(context).copyWith(
              color: color,
              fontSize: 18,
            ),
          ),
          if (doubled) ...[
            const SizedBox(width: 6),
            Text('2×', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ],
      ),
    );
  }
}

class _AdButton extends StatelessWidget {
  const _AdButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: loading ? null : onPressed,
        icon: loading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: colors.gold),
              )
            : Icon(Icons.play_circle_outline_rounded, color: colors.gold),
        label: Text(label, style: TextStyle(color: colors.onScenic)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.gold.withValues(alpha: 0.6)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
