import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/services/daily_challenge_service.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/home/presentation/widgets/home_side_action_card.dart';
import 'package:word_game/injection.dart';

class HomeTreasureBox extends StatefulWidget {
  const HomeTreasureBox({
    super.key,
    this.onTap,
    this.height,
    this.compact = false,
    this.dense = false,
  });

  final VoidCallback? onTap;
  final double? height;
  final bool compact;
  final bool dense;

  @override
  State<HomeTreasureBox> createState() => _HomeTreasureBoxState();
}

class _HomeTreasureBoxState extends State<HomeTreasureBox> {
  Timer? _timer;
  late DailyChallengeService _daily;

  @override
  void initState() {
    super.initState();
    _daily = getIt<DailyChallengeService>();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final canClaim = _daily.canClaimNow();
    final cooldown = _daily.cooldownRemaining();
    final reward = _daily.todayRewardCoins;
    final iconSize = widget.dense ? 38.0 : (widget.compact ? 42.0 : 48.0);

    return HomeSideActionCard(
      onTap: widget.onTap,
      height: widget.height,
      title: 'TREASURE',
      subtitle: canClaim
          ? (widget.dense ? 'Claim daily reward!' : 'Tap to open daily rewards')
          : 'Opens again soon',
      accentColor: spec.dailyBonusAccent,
      leading: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: iconSize + 8,
            height: iconSize + 8,
            child: _TreasureVisual(
              size: iconSize,
              accent: spec.dailyBonusAccent,
              animate: canClaim,
            ),
          ),
          if (!canClaim && cooldown != null)
            Positioned(
              bottom: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.gold, width: 1),
                ),
                child: Text(
                  DailyChallengeService.formatCountdown(cooldown),
                  style: GoogleFonts.montserrat(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: colors.gold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: const SizedBox.shrink(),
      footer: Row(
        children: [
          Icon(
            canClaim ? Icons.card_giftcard_rounded : Icons.schedule_rounded,
            size: 13,
            color: colors.accentCoin,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              canClaim
                  ? 'Reward: +$reward coins'
                  : (cooldown != null
                      ? DailyChallengeService.formatCountdown(cooldown)
                      : 'Locked'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: widget.dense ? 8 : 9,
                fontWeight: FontWeight.w600,
                color: colors.accentCoin,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TreasureVisual extends StatelessWidget {
  const _TreasureVisual({
    required this.size,
    required this.accent,
    required this.animate,
  });

  final double size;
  final Color accent;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      Icons.inventory_2_rounded,
      size: size,
      color: accent,
    );

    Widget child = Lottie.asset(
      AssetPaths.treasureChestLottie,
      width: size + 12,
      height: size + 12,
      fit: BoxFit.contain,
      repeat: animate,
      errorBuilder: (_, __, ___) => icon,
    );

    if (animate) {
      child = child
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.08, 1.08),
            duration: 900.ms,
          )
          .shimmer(
            duration: 1800.ms,
            color: accent.withValues(alpha: 0.35),
          );
    }

    return child;
  }
}
