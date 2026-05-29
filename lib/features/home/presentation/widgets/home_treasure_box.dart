import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/services/daily_challenge_service.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/treasure_chest_image.dart';
import 'package:word_game/features/home/presentation/widgets/home_vertical_action_card.dart';
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
    final chestSize = widget.dense ? 48.0 : (widget.compact ? 56.0 : 64.0);

    return HomeVerticalActionCard(
      onTap: widget.onTap,
      height: widget.height,
      compact: widget.compact,
      dense: widget.dense,
      title: 'TREASURE',
      subtitle: canClaim
          ? (widget.dense ? 'Claim reward' : 'Tap for daily rewards')
          : 'Opens again soon',
      accentColor: spec.dailyBonusAccent,
      hero: TreasureChestImage(
        size: chestSize,
        animate: canClaim,
        glowColor: spec.dailyBonusAccent,
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            canClaim ? Icons.card_giftcard_rounded : Icons.schedule_rounded,
            size: widget.dense ? 12 : 14,
            color: colors.accentCoin,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              canClaim
                  ? '+$reward coins'
                  : (cooldown != null
                      ? DailyChallengeService.formatCountdown(cooldown)
                      : 'Locked'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: widget.dense ? 7.5 : 8.5,
                fontWeight: FontWeight.w700,
                color: colors.accentCoin,
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.05, end: 0);
  }
}
