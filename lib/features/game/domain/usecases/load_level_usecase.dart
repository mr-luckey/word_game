import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';

class LoadLevelUseCase {
  LoadLevelUseCase(this._repository);

  final LevelRepository _repository;

  Future<LevelEntity?> call(int levelId) => _repository.getLevelById(levelId);
}

class GetNextLevelUseCase {
  GetNextLevelUseCase(this._repository);

  final LevelRepository _repository;

  Future<LevelEntity?> call(int currentLevelId) =>
      _repository.getNextLevel(currentLevelId);
}

class SaveProgressUseCase {
  SaveProgressUseCase(this._repository);

  final ProgressRepository _repository;

  Future<void> call({
    required int levelId,
    required int stars,
    required int timeSeconds,
  }) =>
      _repository.saveProgress(
        levelId: levelId,
        stars: stars,
        timeSeconds: timeSeconds,
      );
}

class SpendCoinsUseCase {
  SpendCoinsUseCase(this._repository);

  final WalletRepository _repository;

  Future<bool> call(int amount) => _repository.spendCoins(amount);
}

class AddCoinsUseCase {
  AddCoinsUseCase(this._repository);

  final WalletRepository _repository;

  Future<void> call(int amount) => _repository.addCoins(amount);
}
