import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/glass_panel.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:word_game/injection.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(getIt(), getIt()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: ScenicBackground(
          imageAsset: AssetPaths.themeImage('tokyo_bg.jpg'),
          darken: 0.4,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingMd),
                  child: Text(
                    'Profile',
                    style: AppTextStyles.appBarTitle(context).copyWith(fontSize: 22),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      final colors = context.appColors;
                      if (state.loading) {
                        return Center(
                          child: CircularProgressIndicator(color: colors.gold),
                        );
                      }
                      return ListView(
                        padding: const EdgeInsets.all(AppSizes.paddingMd),
                        children: [
                          GlassPanel(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person_rounded,
                                  size: 64,
                                  color: colors.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Levels completed: ${state.completedLevels} / ${state.totalLevels}',
                                  style: AppTextStyles.levelName(context),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingLg),
                          Text(
                            'Achievements',
                            style: AppTextStyles.levelName(context),
                          ),
                          const SizedBox(height: AppSizes.paddingSm),
                          ...state.achievements.map(
                            (a) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSizes.paddingSm,
                              ),
                              child: GlassPanel(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.paddingMd,
                                  vertical: AppSizes.paddingSm,
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(
                                    a.unlocked
                                        ? Icons.emoji_events_rounded
                                        : Icons.lock_outline_rounded,
                                    color: a.unlocked
                                        ? colors.gold
                                        : colors.locked,
                                  ),
                                  title: Text(a.title),
                                  subtitle: Text(a.description),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
