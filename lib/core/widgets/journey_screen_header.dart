import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';

/// Top bar matching mockups: settings gear (left), coin pill (right).
class JourneyScreenHeader extends StatelessWidget {
  const JourneyScreenHeader({
    super.key,
    this.showSettings = true,
    this.showCoins = true,
    this.leading,
  });

  final bool showSettings;
  final bool showCoins;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
      child: Row(
        children: [
          if (leading != null)
            leading!
          else if (showSettings)
            IconButton(
              icon: Icon(Icons.settings_outlined, color: colors.gold, size: 24),
              onPressed: () => context.push('/settings'),
            )
          else
            const SizedBox(width: 48),
          const Spacer(),
          if (showCoins)
            BlocBuilder<CoinCubit, CoinState>(
              builder: (context, state) =>
                  CoinDisplay(coins: state.coins, light: true),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}
