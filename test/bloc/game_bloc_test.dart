import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:word_game/core/data/game_content_registry.dart';
import 'package:word_game/core/data/models/achievement_badge_config.dart';
import 'package:word_game/core/data/models/daily_challenge_config.dart';
import 'package:word_game/core/services/achievement_service.dart';
import 'package:word_game/core/services/daily_challenge_service.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/services/analytics_service.dart';
import 'package:word_game/core/services/audio_service.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/core/data/models/slots_config.dart';
import 'package:word_game/core/services/vip_service.dart';
import 'package:word_game/features/game/domain/usecases/load_level_usecase.dart';
import 'package:word_game/features/game/presentation/bloc/game_bloc.dart';
import 'package:word_game/features/game/presentation/bloc/game_event.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';

class MockLoadLevel extends Mock implements LoadLevelUseCase {}

class MockGetNextLevel extends Mock implements GetNextLevelUseCase {}

class MockSaveProgress extends Mock implements SaveProgressUseCase {}

class MockSpendCoins extends Mock implements SpendCoinsUseCase {}

class MockAddCoins extends Mock implements AddCoinsUseCase {}

class MockWallet extends Mock implements WalletRepository {}

class MockAudio extends Mock implements AudioService {}

class MockAnalytics extends Mock implements AnalyticsService {}

class MockAchievements extends Mock implements AchievementService {}

class MockDailyChallenge extends Mock implements DailyChallengeService {}

class MockThemeBloc extends Mock implements AppThemeBloc {}

class MockVip extends Mock implements VipService {}

void main() {
  const sampleLevel = LevelEntity(
    id: 101,
    themeId: 1,
    themeName: 'Paris',
    backgroundImage: 'paris_bg.jpg',
    difficultyIndex: 0,
    gridSize: 8,
    timeLimit: 180,
    hintsAllowed: 3,
    coinsReward: 30,
    words: ['CAT', 'DOG'],
  );

  late MockLoadLevel loadLevel;
  late MockGetNextLevel getNextLevel;
  late MockSaveProgress saveProgress;
  late MockWallet wallet;
  late MockAudio audio;
  late MockAnalytics analytics;
  late MockAchievements achievements;
  late MockDailyChallenge dailyChallenge;
  late MockThemeBloc themeBloc;
  late MockVip vip;
  late GameContentRegistry testContent;

  GameBloc buildBloc() => GameBloc(
        loadLevel: loadLevel,
        getNextLevel: getNextLevel,
        saveProgress: saveProgress,
        spendCoins: MockSpendCoins(),
        wallet: wallet,
        audio: audio,
        analytics: analytics,
        achievements: achievements,
        dailyChallenge: dailyChallenge,
        themeBloc: themeBloc,
        content: testContent,
        vip: vip,
      );

  setUp(() {
    loadLevel = MockLoadLevel();
    getNextLevel = MockGetNextLevel();
    saveProgress = MockSaveProgress();
    wallet = MockWallet();
    audio = MockAudio();
    analytics = MockAnalytics();
    achievements = MockAchievements();
    dailyChallenge = MockDailyChallenge();
    themeBloc = MockThemeBloc();
    vip = MockVip();
    testContent = GameContentRegistry(
      levelPacksBySlot: const {1: []},
      slotsConfig: const SlotsConfig(slotCount: 10),
      exploreByPreset: const {},
      dailyChallenge: DailyChallengeConfig(
        levelId: 9999,
        name: 'Daily',
        difficultyIndex: 1,
        gridSize: 10,
        timeLimit: 300,
        hintsAllowed: 2,
        backgroundImageTemplate: '{themeFolder}/grid_full.webp',
        coinSchedule: const [50, 100],
        wordPool: const ['TEST'],
        wordsPerDay: 1,
        games: const [],
      ),
      achievements: const AchievementsConfig(
        defaultBadges: [],
        themeBadges: {},
      ),
    );
    when(() => vip.applyLevelCoinBonus(any())).thenAnswer((i) => i.positionalArguments[0] as int);
    when(() => vip.applyLevelXpBonus(any())).thenAnswer((i) => i.positionalArguments[0] as int);
    when(() => vip.applyDailyCoinBonus(any())).thenAnswer((i) => i.positionalArguments[0] as int);
    when(() => dailyChallenge.todayRewardCoins).thenReturn(50);
    when(() => themeBloc.state).thenReturn(
      AppThemeState(
        mode: ThemeSelectionMode.fixed,
        fixedPreset: AppThemePreset.classicTravel,
        activePreset: AppThemePreset.classicTravel,
        activeDestinationId: 1,
        themeData: ThemeData(),
      ),
    );
    when(() => achievements.onWordFound()).thenAnswer((_) async => []);
    when(
      () => achievements.onLevelComplete(
        stars: any(named: 'stars'),
        timeSeconds: any(named: 'timeSeconds'),
        hintsUsed: any(named: 'hintsUsed'),
        revealsUsed: any(named: 'revealsUsed'),
        levelId: any(named: 'levelId'),
      ),
    ).thenAnswer((_) async => []);
    when(() => achievements.onBoardRotated()).thenAnswer((_) async => []);
    when(() => loadLevel(101)).thenAnswer((_) async => sampleLevel);
    when(() => wallet.getCoins()).thenAnswer((_) async => 250);
    when(
      () => saveProgress(
        levelId: any(named: 'levelId'),
        stars: any(named: 'stars'),
        timeSeconds: any(named: 'timeSeconds'),
      ),
    ).thenAnswer((_) async {});
    when(() => analytics.logLevelStart(any())).thenAnswer((_) async {});
    when(() => audio.playWordFound()).thenAnswer((_) async {});
  });

  blocTest<GameBloc, GameState>(
    'emits GameInProgress after LoadLevel',
    build: buildBloc,
    act: (b) => b.add(const LoadLevel(101)),
    wait: const Duration(milliseconds: 50),
    verify: (b) {
      expect(b.state, isA<GameInProgress>());
    },
  );
}
