import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:word_game/injection.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(getIt()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return ListView(
              children: [
                SwitchListTile(
                  title: const Text('Sound effects'),
                  value: state.soundEnabled,
                  onChanged: (_) =>
                      context.read<SettingsCubit>().toggleSound(),
                ),
                SwitchListTile(
                  title: const Text('Background music'),
                  value: state.musicEnabled,
                  onChanged: (_) =>
                      context.read<SettingsCubit>().toggleMusic(),
                ),
                const ListTile(
                  title: Text('Privacy Policy'),
                  subtitle: Text('https://example.com/privacy'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
