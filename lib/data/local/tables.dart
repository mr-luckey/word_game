import 'package:drift/drift.dart';

class UserProgressTable extends Table {
  IntColumn get levelId => integer()();
  IntColumn get stars => integer().withDefault(const Constant(0))();
  IntColumn get timeSeconds => integer().withDefault(const Constant(0))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {levelId};
}

class KeyValueTable extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class DailyProgressTable extends Table {
  TextColumn get date => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get streak => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {date};
}

class AchievementTable extends Table {
  TextColumn get id => text()();
  BoolColumn get unlocked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
