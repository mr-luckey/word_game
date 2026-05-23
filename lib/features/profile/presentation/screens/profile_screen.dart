import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:word_game/injection.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(getIt(), getIt()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingMd),
                    child: Column(
                      children: [
                        const Icon(Icons.person, size: 64),
                        const SizedBox(height: 8),
                        Text(
                          'Levels completed: ${state.completedLevels} / ${state.totalLevels}',
                          style: AppTextStyles.levelName,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.paddingLg),
                Text('Achievements', style: AppTextStyles.levelName),
                const SizedBox(height: AppSizes.paddingSm),
                ...state.achievements.map(
                  (a) => ListTile(
                    leading: Icon(
                      a.unlocked ? Icons.emoji_events : Icons.lock_outline,
                      color: a.unlocked
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).disabledColor,
                    ),
                    title: Text(a.title),
                    subtitle: Text(a.description),
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
