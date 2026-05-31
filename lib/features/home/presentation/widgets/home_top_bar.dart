import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
      child: Row(
        children: [
          _CircleBtn(
            icon: Icons.settings_rounded,
            onTap: () => context.push('/settings'),
          ),
          const Spacer(),
          BlocBuilder<CoinCubit, CoinState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.fromLTRB(8, 5, 5, 5),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: colors.glassBorder, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on_rounded,
                        color: colors.gold, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      '${state.coins}',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.gold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.push('/shop'),
                        customBorder: const CircleBorder(),
                        child: Ink(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                spec.dailyBonusAccent.withValues(alpha: 0.2),
                            border: Border.all(color: spec.dailyBonusAccent),
                          ),
                          child: Icon(Icons.add,
                              size: 14, color: spec.dailyBonusAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surface.withValues(alpha: 0.85),
            border: Border.all(color: colors.glassBorder, width: 1.5),
          ),
          child: Icon(icon, color: colors.gold, size: 22),
        ),
      ),
    );
  }
}
