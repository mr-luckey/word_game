import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_game/core/theme/app_sizes.dart';
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
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              children: [
                GlassPanel(
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
            );
          },
        ),
      ),
    );
  }
}
