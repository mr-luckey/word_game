import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/data/local/tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [UserProgressTable, KeyValueTable, DailyProgressTable, AchievementTable],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<UserProgressTableData?> getProgress(int levelId) =>
      (select(userProgressTable)..where((t) => t.levelId.equals(levelId)))
          .getSingleOrNull();

  Future<List<UserProgressTableData>> getAllProgress() =>
      select(userProgressTable).get();

  Future<void> saveProgress({
    required int levelId,
    required int stars,
    required int timeSeconds,
  }) =>
      into(userProgressTable).insertOnConflictUpdate(
        UserProgressTableCompanion(
          levelId: Value(levelId),
          stars: Value(stars),
          timeSeconds: Value(timeSeconds),
          completedAt: Value(DateTime.now()),
        ),
      );

  Future<int> getCoins() async {
    final row = await (select(keyValueTable)
          ..where((t) => t.key.equals('coins')))
        .getSingleOrNull();
    return int.tryParse(row?.value ?? '') ?? GameConfig.initialCoins;
  }

  Future<void> setCoins(int coins) => into(keyValueTable).insertOnConflictUpdate(
        KeyValueTableCompanion(
          key: const Value('coins'),
          value: Value(coins.toString()),
        ),
      );

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final row = await (select(keyValueTable)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    if (row == null) return defaultValue;
    return row.value == 'true';
  }

  Future<void> setBool(String key, bool value) =>
      into(keyValueTable).insertOnConflictUpdate(
        KeyValueTableCompanion(
          key: Value(key),
          value: Value(value.toString()),
        ),
      );

  Future<void> unlockAchievement(String id) =>
      into(achievementTable).insertOnConflictUpdate(
        AchievementTableCompanion(
          id: Value(id),
          unlocked: const Value(true),
          unlockedAt: Value(DateTime.now()),
        ),
      );

  Future<List<AchievementTableData>> getAchievements() =>
      select(achievementTable).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'word_search.sqlite'));
    return NativeDatabase(file);
  });
}
