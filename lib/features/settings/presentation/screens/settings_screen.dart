import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/glass_panel.dart';
import 'package:word_game/core/widgets/scenic_page.dart';
import 'package:word_game/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:word_game/injection.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(getIt()),
      child: ScenicPage(
        title: 'Settings',
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          children: [
            BlocBuilder<AppThemeBloc, AppThemeState>(
              builder: (context, themeState) {
                final colors = context.appColors;
                final isAuto =
                    themeState.mode == ThemeSelectionMode.autoDestination;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Theme mode',
                      style: AppTextStyles.sectionHeading(context),
                    ),
                    const SizedBox(height: AppSizes.paddingSm),
                    GlassPanel(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          RadioListTile<ThemeSelectionMode>(
                            title: const Text('Auto (match destination)'),
                            subtitle: const Text(
                              'Theme follows the destination you play',
                            ),
                            value: ThemeSelectionMode.autoDestination,
                            groupValue: themeState.mode,
                            activeColor: colors.gold,
                            onChanged: (_) =>
                                context.read<AppThemeBloc>().setAutoMode(),
                          ),
                          const Divider(height: 1),
                          RadioListTile<ThemeSelectionMode>(
                            title: const Text('Fixed theme'),
                            subtitle: const Text(
                              'Keep one look across the whole app',
                            ),
                            value: ThemeSelectionMode.fixed,
                            groupValue: themeState.mode,
                            activeColor: colors.gold,
                            onChanged: (_) {
                              context
                                  .read<AppThemeBloc>()
                                  .setPreset(themeState.fixedPreset);
                            },
                          ),
                        ],
                      ),
                    ),
                    if (!isAuto) ...[
                      const SizedBox(height: AppSizes.paddingMd),
                      Text(
                        'Choose theme',
                        style: AppTextStyles.sectionHeading(context),
                      ),
                      const SizedBox(height: AppSizes.paddingSm),
                      ...AppThemePreset.values.map((preset) {
                        final selected =
                            themeState.fixedPreset == preset;
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSizes.paddingSm,
                          ),
                          child: GlassPanel(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingMd,
                              vertical: AppSizes.paddingSm,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => context
                                  .read<AppThemeBloc>()
                                  .setPreset(preset),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      AssetPaths.themeSplash(preset),
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          gradient: preset
                                              .colors(dark: true)
                                              .primaryGradient,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      preset.label,
                                      style: AppTextStyles.wordList(context)
                                          .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colors.onScenic,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    selected
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                    color: selected
                                        ? colors.gold
                                        : colors.locked,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: AppSizes.paddingMd),
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return GlassPanel(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Sound effects'),
                        value: state.soundEnabled,
                        onChanged: (_) =>
                            context.read<SettingsCubit>().toggleSound(),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('Background music'),
                        value: state.musicEnabled,
                        onChanged: (_) =>
                            context.read<SettingsCubit>().toggleMusic(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
