import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/gradient_button.dart';
import 'package:word_game/features/game/domain/usecases/load_level_usecase.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InsufficientCoinsDialog extends StatelessWidget {
  const InsufficientCoinsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const InsufficientCoinsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AlertDialog(
      backgroundColor: colors.navSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Not enough coins',
        style: AppTextStyles.sectionHeading(context),
      ),
      content: Text(
        'You need more coins to use this feature. Earn coins by completing levels, achievements, or watch an ad for ${GameConfig.rewardedBonusCoins} coins.',
        style: AppTextStyles.bodyMuted(context),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: colors.onScenicMuted)),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            var granted = false;
            await getIt<AdService>().showRewardedAd(
              onReward: (coins) async {
                granted = true;
                await getIt<AddCoinsUseCase>()(coins);
              },
              onFail: () {},
            );
            if (granted && context.mounted) {
              context.read<CoinCubit>().refresh();
            }
          },
          child: Text(
            'Watch Ad (+${GameConfig.rewardedBonusCoins})',
            style: TextStyle(color: colors.gold),
          ),
        ),
        GradientButton(
          label: 'Go to Shop',
          compact: true,
          onPressed: () {
            Navigator.of(context).pop();
            context.go('/shop');
          },
        ),
      ],
    );
  }
}
