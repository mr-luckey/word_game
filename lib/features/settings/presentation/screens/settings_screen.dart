import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/app_theme_cubit.dart';
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
            BlocBuilder<AppThemeCubit, AppThemeState>(
              builder: (context, themeState) {
                final colors = context.appColors;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GlassPanel(
                      padding: EdgeInsets.zero,
                      child: SwitchListTile(
                        title: const Text('Dark mode'),
                        subtitle: const Text('Easier on the eyes at night'),
                        value: themeState.darkMode,
                        onChanged: (_) =>
                            context.read<AppThemeCubit>().toggleDarkMode(),
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingMd),
                    Text(
                      'Color theme',
                      style: AppTextStyles.levelName(context),
                    ),
                    const SizedBox(height: AppSizes.paddingSm),
                    ...AppThemePreset.values.map((preset) {
                      final selected = themeState.preset == preset;
                      final preview = preset.colors(dark: themeState.darkMode);
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
                                .read<AppThemeCubit>()
                                .setPreset(preset),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: preset.usesScenicImages
                                        ? preview.primaryGradient
                                        : preview.solidBackground ??
                                            preview.primaryGradient,
                                    border: Border.all(
                                      color: colors.glassBorder,
                                    ),
                                  ),
                                  child: preset.usesScenicImages
                                      ? Icon(
                                          Icons.landscape_rounded,
                                          color: colors.onPrimary,
                                          size: 22,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        preset.label,
                                        style: AppTextStyles.wordList(context)
                                            .copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        preset.usesScenicImages
                                            ? 'Photo backgrounds'
                                            : 'Solid color backgrounds',
                                        style: AppTextStyles.wordList(context)
                                            .copyWith(
                                          fontSize: 12,
                                          color: colors.locked,
                                        ),
                                      ),
                                    ],
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
            const SizedBox(height: AppSizes.paddingMd),
            GlassPanel(
              child: const ListTile(
                title: Text('Privacy Policy'),
                subtitle: Text('https://example.com/privacy'),
                trailing: Icon(Icons.open_in_new_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
