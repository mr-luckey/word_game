import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:word_game/core/services/analytics_service.dart';
import 'package:word_game/core/services/audio_service.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
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

  GameBloc buildBloc() => GameBloc(
        loadLevel: loadLevel,
        getNextLevel: getNextLevel,
        saveProgress: saveProgress,
        spendCoins: MockSpendCoins(),
        addCoins: MockAddCoins(),
        wallet: wallet,
        audio: audio,
        analytics: analytics,
      );

  setUp(() {
    loadLevel = MockLoadLevel();
    getNextLevel = MockGetNextLevel();
    saveProgress = MockSaveProgress();
    wallet = MockWallet();
    audio = MockAudio();
    analytics = MockAnalytics();
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
