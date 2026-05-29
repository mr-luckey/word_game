import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:word_game/core/constants/asset_paths.dart';

import 'package:word_game/core/constants/profile_config.dart';

import 'package:word_game/core/services/leaderboard_service.dart';

import 'package:word_game/core/theme/app_sizes.dart';

import 'package:word_game/core/theme/app_text_styles.dart';

import 'package:word_game/core/theme/theme_context.dart';

import 'package:word_game/core/widgets/coin_display.dart';

import 'package:word_game/core/widgets/journey_theme_kit.dart';

import 'package:word_game/core/widgets/scenic_background.dart';

import 'package:word_game/core/widgets/shell_nav_metrics.dart';

import 'package:word_game/core/widgets/sign_in_gate_overlay.dart';

import 'package:word_game/features/auth/presentation/cubit/auth_cubit.dart';

import 'package:word_game/features/profile/presentation/cubit/profile_cubit.dart';

import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';

import 'package:word_game/injection.dart';



class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});



  @override

  State<ProfileScreen> createState() => _ProfileScreenState();

}



class _ProfileScreenState extends State<ProfileScreen> {

  LeaderboardSnapshot? _leaderboard;

  bool _rankLoading = true;



  @override

  void initState() {

    super.initState();

    _loadRanking();

  }



  Future<void> _loadRanking() async {

    final snapshot = await getIt<LeaderboardService>().buildSnapshot();

    if (!mounted) return;

    setState(() {

      _leaderboard = snapshot;

      _rankLoading = false;

    });

  }



  Future<void> _editName(BuildContext context, AuthCubit auth) async {

    final controller = TextEditingController(text: auth.state.displayName);

    final colors = context.appColors;

    final name = await showDialog<String>(

      context: context,

      builder: (ctx) => AlertDialog(

        backgroundColor: colors.glassSurface,

        title: Text('Your name', style: TextStyle(color: colors.onScenic)),

        content: TextField(

          controller: controller,

          autofocus: true,

          decoration: InputDecoration(

            hintText: 'Enter display name',

            hintStyle: TextStyle(color: colors.onScenicMuted),

          ),

          style: TextStyle(color: colors.onScenic),

        ),

        actions: [

          TextButton(

            onPressed: () => Navigator.pop(ctx),

            child: Text('Cancel', style: TextStyle(color: colors.onScenicMuted)),

          ),

          FilledButton(

            onPressed: () => Navigator.pop(ctx, controller.text.trim()),

            child: const Text('Save'),

          ),

        ],

      ),

    );

    if (name != null && name.isNotEmpty) {

      await auth.updateDisplayName(name);

      await _loadRanking();

    }

  }



  @override

  Widget build(BuildContext context) {

    return MultiBlocProvider(

      providers: [

        BlocProvider(create: (_) => ProfileCubit(getIt(), getIt())),

      ],

      child: BlocListener<AuthCubit, AuthState>(

        listenWhen: (a, b) => a.isSignedIn != b.isSignedIn,

        listener: (context, state) {
          _loadRanking();
          if (state.isSignedIn) {
            context.read<ProfileCubit>().load();
            context.read<CoinCubit>().refresh();
          }
        },

        child: Scaffold(

          extendBodyBehindAppBar: true,

          body: ScenicBackground(

            imageAsset: AssetPaths.themeSplash(context.themePreset),

            darken: 0.5,

            blurSigma: 1,

            child: SafeArea(

              bottom: false,

              child: JourneyContentWidth(

                child: Stack(

                  children: [

                    _ProfileBody(

                      rankLoading: _rankLoading,

                      leaderboard: _leaderboard,

                      onEditName: (ctx, auth) => _editName(ctx, auth),

                    ),

                    BlocBuilder<AuthCubit, AuthState>(

                      builder: (context, auth) {

                        if (auth.isSignedIn) return const SizedBox.shrink();

                        return const SignInGateOverlay();

                      },

                    ),

                  ],

                ),

              ),

            ),

          ),

        ),

      ),

    );

  }

}



class _ProfileBody extends StatelessWidget {

  const _ProfileBody({

    required this.rankLoading,

    required this.leaderboard,

    required this.onEditName,

  });



  final bool rankLoading;

  final LeaderboardSnapshot? leaderboard;

  final void Function(BuildContext, AuthCubit) onEditName;



  @override

  Widget build(BuildContext context) {

    return Column(

      children: [

        Padding(

          padding: const EdgeInsets.symmetric(

            horizontal: AppSizes.paddingMd,

            vertical: AppSizes.paddingSm,

          ),

          child: JourneyPanel(

            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),

            radius: 20,

            child: Row(

              children: [

                JourneyIconBadge(

                  size: 42,

                  icon: Icons.person_rounded,

                  accent: context.appColors.gold,

                ),

                const SizedBox(width: 12),

                const Expanded(

                  child: JourneySectionTitle(

                    title: 'PROFILE',

                    subtitle: 'Your journey stats',

                  ),

                ),

                BlocBuilder<CoinCubit, CoinState>(

                  builder: (context, coinState) =>

                      CoinDisplay(coins: coinState.coins, light: true),

                ),

                BlocBuilder<AuthCubit, AuthState>(

                  builder: (context, auth) {

                    if (!auth.isSignedIn) return const SizedBox.shrink();

                    return IconButton(

                      tooltip: 'Sign out',

                      onPressed: () => context.read<AuthCubit>().signOut(),

                      icon: Icon(Icons.logout_rounded, color: context.appColors.gold),

                    );

                  },

                ),

              ],

            ),

          ),

        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.08, end: 0),

        Expanded(

          child: BlocBuilder<ProfileCubit, ProfileState>(

            builder: (context, profileState) {

              final colors = context.appColors;

              if (profileState.loading) {

                return Center(

                  child: CircularProgressIndicator(color: colors.gold),

                );

              }

              return BlocBuilder<AuthCubit, AuthState>(

                builder: (context, auth) {

                  return BlocBuilder<CoinCubit, CoinState>(

                    builder: (context, coinState) {

                      final profileLevel = coinState.coins ~/

                              ProfileConfig.coinsPerProfileLevel +

                          1;

                      return ListView(

                        padding: EdgeInsets.fromLTRB(

                          AppSizes.paddingMd,

                          AppSizes.paddingMd,

                          AppSizes.paddingMd,

                          ShellNavMetrics.listBottomPadding(context),

                        ),

                        children: [

                          _UserProfileCard(

                            displayName: auth.displayName,

                            profileLevel: profileLevel,

                            isSignedIn: auth.isSignedIn,

                            onEditName: auth.isSignedIn

                                ? () => onEditName(context, context.read<AuthCubit>())

                                : null,

                          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08, end: 0),

                          const SizedBox(height: AppSizes.paddingMd),

                          _RankingSection(

                            loading: rankLoading,

                            snapshot: leaderboard,

                            isSignedIn: auth.isSignedIn,

                          ).animate(delay: 120.ms).fadeIn(),

                        ],

                      );

                    },

                  );

                },

              );

            },

          ),

        ),

      ],

    );

  }

}



class _UserProfileCard extends StatelessWidget {

  const _UserProfileCard({

    required this.displayName,

    required this.profileLevel,

    required this.isSignedIn,

    this.onEditName,

  });



  final String displayName;

  final int profileLevel;

  final bool isSignedIn;

  final VoidCallback? onEditName;



  @override

  Widget build(BuildContext context) {

    final colors = context.appColors;

    final spec = context.themePreset.homeSpec;

    final initials = displayName.isNotEmpty

        ? displayName.trim().substring(0, 1).toUpperCase()

        : '?';



    return JourneyPanel(

      child: Column(

        children: [

          Container(

            width: 96,

            height: 96,

            decoration: BoxDecoration(

              shape: BoxShape.circle,

              border: Border.all(color: colors.gold, width: 2.5),

              boxShadow: [

                BoxShadow(

                  color: spec.playButtonGlow.withValues(alpha: 0.35),

                  blurRadius: 16,

                ),

              ],

            ),

            child: ClipOval(

              child: _AvatarFallback(initials: initials),

            ),

          ),

          const SizedBox(height: 14),

          InkWell(

            onTap: onEditName,

            borderRadius: BorderRadius.circular(8),

            child: Padding(

              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

              child: Row(

                mainAxisSize: MainAxisSize.min,

                children: [

                  Text(

                    isSignedIn ? displayName.toUpperCase() : 'GUEST PLAYER',

                    style: AppTextStyles.greeting(context).copyWith(

                      fontSize: 20,

                      letterSpacing: 1.2,

                      shadows: JourneyThemeKit.textGlow(context),

                    ),

                  ),

                  if (onEditName != null) ...[

                    const SizedBox(width: 6),

                    Icon(Icons.edit_rounded, size: 16, color: colors.gold),

                  ],

                ],

              ),

            ),

          ),

          const SizedBox(height: 4),

          Text(

            'Level $profileLevel',

            style: AppTextStyles.bodyMuted(context).copyWith(

              color: colors.accentCoin,

              fontSize: 13,

              fontWeight: FontWeight.w700,

            ),

          ),

        ],

      ),

    );

  }

}



class _AvatarFallback extends StatelessWidget {

  const _AvatarFallback({required this.initials});



  final String initials;



  @override

  Widget build(BuildContext context) {

    final colors = context.appColors;

    final spec = context.themePreset.homeSpec;

    return DecoratedBox(

      decoration: BoxDecoration(

        gradient: LinearGradient(

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [

            spec.playButtonGlow.withValues(alpha: 0.45),

            colors.primary.withValues(alpha: 0.85),

          ],

        ),

      ),

      child: Center(

        child: Text(

          initials,

          style: AppTextStyles.greeting(context).copyWith(

            fontSize: 36,

            color: colors.onScenic,

          ),

        ),

      ),

    );

  }

}



class _RankingSection extends StatelessWidget {

  const _RankingSection({

    required this.loading,

    required this.snapshot,

    required this.isSignedIn,

  });



  final bool loading;

  final LeaderboardSnapshot? snapshot;

  final bool isSignedIn;



  @override

  Widget build(BuildContext context) {

    final colors = context.appColors;



    return Column(

      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [

        Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Text(

              'GLOBAL RANKING (COINS)',

              style: AppTextStyles.sectionHeading(context)

                  .copyWith(fontSize: 17, letterSpacing: 1),

            ),

            if (isSignedIn && snapshot?.userRank != null)

              Container(

                padding:

                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                decoration: BoxDecoration(

                  color: colors.gold.withValues(alpha: 0.15),

                  borderRadius: BorderRadius.circular(14),

                  border: Border.all(color: colors.gold.withValues(alpha: 0.5)),

                ),

                child: Text(

                  'Your rank #${snapshot!.userRank}',

                  style: AppTextStyles.wordList(context).copyWith(

                    color: colors.gold,

                    fontWeight: FontWeight.w800,

                    fontSize: 12,

                  ),

                ),

              ),

          ],

        ),

        const SizedBox(height: AppSizes.paddingSm),

        if (loading)

          Center(

            child: Padding(

              padding: const EdgeInsets.all(24),

              child: CircularProgressIndicator(color: colors.gold),

            ),

          )

        else if (!isSignedIn)

          JourneyPanel(

            child: Text(

              'Sign in to see your rank on the leaderboard.',

              style: AppTextStyles.bodyMuted(context),

            ),

          )

        else if (snapshot == null ||

            snapshot!.entries.isEmpty ||

            snapshot!.loadFailed)

          JourneyPanel(

            child: Text(

              snapshot?.loadFailed == true

                  ? 'Could not load ranking. Check your connection.'

                  : 'No players on the leaderboard yet.',

              style: AppTextStyles.bodyMuted(context),

            ),

          )

        else

          ...snapshot!.entries.take(8).map(

                (entry) => Padding(

                  padding: const EdgeInsets.only(bottom: 8),

                  child: JourneyPanel(

                    padding: const EdgeInsets.symmetric(

                      horizontal: 14,

                      vertical: 10,

                    ),

                    child: Row(

                      children: [

                        Container(

                          width: 32,

                          height: 32,

                          alignment: Alignment.center,

                          decoration: BoxDecoration(

                            shape: BoxShape.circle,

                            color: entry.isCurrentUser

                                ? colors.gold.withValues(alpha: 0.2)

                                : colors.surface.withValues(alpha: 0.5),

                            border: Border.all(

                              color: entry.isCurrentUser

                                  ? colors.gold

                                  : colors.glassBorder,

                            ),

                          ),

                          child: Text(

                            '#${entry.rank}',

                            style: AppTextStyles.wordList(context).copyWith(

                              fontSize: 11,

                              fontWeight: FontWeight.w800,

                              color: entry.isCurrentUser

                                  ? colors.gold

                                  : colors.onScenicMuted,

                            ),

                          ),

                        ),

                        const SizedBox(width: 12),

                        Expanded(

                          child: Text(

                            entry.name,

                            style: AppTextStyles.levelName(context).copyWith(

                              fontSize: 14,

                              color: entry.isCurrentUser

                                  ? colors.gold

                                  : colors.onScenic,

                            ),

                          ),

                        ),

                        Text(

                          '${entry.coins}',

                          style: AppTextStyles.coinsScore(context).copyWith(

                            fontSize: 14,

                            color: colors.accentCoin,

                          ),

                        ),

                      ],

                    ),

                  ),

                ),

              ),

      ],

    );

  }

}

