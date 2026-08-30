import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/navigation/route_back_handler.dart';
import 'package:word_game/core/widgets/scenic_page.dart';
import 'package:word_game/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:word_game/injection.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RouteBackHandler(
      child: BlocProvider(
      create: (_) => SettingsCubit(getIt()),
      child: ScenicPage(
        title: 'Settings',
        child: JourneyContentWidth(
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
                      const JourneySectionTitle(
                        title: 'Theme Mode',
                        subtitle: 'Choose how the journey changes style',
                      ),
                      const SizedBox(height: AppSizes.paddingSm),
                      JourneyPanel(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            _ThemeModeTile(
                              title: 'Auto (match destination)',
                              subtitle:
                                  'Theme follows the destination you play',
                              selected: themeState.mode ==
                                  ThemeSelectionMode.autoDestination,
                              onTap: () =>
                                  context.read<AppThemeBloc>().setAutoMode(),
                            ),
                            const Divider(height: 1),
                            _ThemeModeTile(
                              title: 'Fixed theme',
                              subtitle: 'Keep one look across the whole app',
                              selected:
                                  themeState.mode == ThemeSelectionMode.fixed,
                              onTap: () {
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
                        const JourneySectionTitle(
                          title: 'Choose Theme',
                          subtitle: 'Lock one of the seven visual worlds',
                        ),
                        const SizedBox(height: AppSizes.paddingSm),
                        ...AppThemePreset.values.map((preset) {
                          final selected = themeState.fixedPreset == preset;
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSizes.paddingSm,
                            ),
                            child: JourneyPanel(
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
                                        errorBuilder: (_, __, ___) => Container(
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
                  return JourneyPanel(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _SettingsSwitchTile(
                          title: 'Sound effects',
                          value: state.soundEnabled,
                          onChanged: (_) =>
                              context.read<SettingsCubit>().toggleSound(),
                        ),
                        const Divider(height: 1),
                        _SettingsSwitchTile(
                          title: 'Background music',
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
      ),
    ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.wordList(context).copyWith(
                color: colors.onScenic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colors.gold,
          ),
        ],
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? colors.gold : colors.onScenicMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.wordList(context).copyWith(
                      color: colors.onScenic,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMuted(context).copyWith(
                      fontSize: 12,
                      color: colors.onScenicMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
