// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserProgressTableTable extends UserProgressTable
    with TableInfo<$UserProgressTableTable, UserProgressTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _levelIdMeta =
      const VerificationMeta('levelId');
  @override
  late final GeneratedColumn<int> levelId = GeneratedColumn<int>(
      'level_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
      'stars', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _timeSecondsMeta =
      const VerificationMeta('timeSeconds');
  @override
  late final GeneratedColumn<int> timeSeconds = GeneratedColumn<int>(
      'time_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [levelId, stars, timeSeconds, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserProgressTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('level_id')) {
      context.handle(_levelIdMeta,
          levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta));
    }
    if (data.containsKey('stars')) {
      context.handle(
          _starsMeta, stars.isAcceptableOrUnknown(data['stars']!, _starsMeta));
    }
    if (data.containsKey('time_seconds')) {
      context.handle(
          _timeSecondsMeta,
          timeSeconds.isAcceptableOrUnknown(
              data['time_seconds']!, _timeSecondsMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {levelId};
  @override
  UserProgressTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressTableData(
      levelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level_id'])!,
      stars: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stars'])!,
      timeSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time_seconds'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $UserProgressTableTable createAlias(String alias) {
    return $UserProgressTableTable(attachedDatabase, alias);
  }
}

class UserProgressTableData extends DataClass
    implements Insertable<UserProgressTableData> {
  final int levelId;
  final int stars;
  final int timeSeconds;
  final DateTime? completedAt;
  const UserProgressTableData(
      {required this.levelId,
      required this.stars,
      required this.timeSeconds,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['level_id'] = Variable<int>(levelId);
    map['stars'] = Variable<int>(stars);
    map['time_seconds'] = Variable<int>(timeSeconds);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  UserProgressTableCompanion toCompanion(bool nullToAbsent) {
    return UserProgressTableCompanion(
      levelId: Value(levelId),
      stars: Value(stars),
      timeSeconds: Value(timeSeconds),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory UserProgressTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressTableData(
      levelId: serializer.fromJson<int>(json['levelId']),
      stars: serializer.fromJson<int>(json['stars']),
      timeSeconds: serializer.fromJson<int>(json['timeSeconds']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'levelId': serializer.toJson<int>(levelId),
      'stars': serializer.toJson<int>(stars),
      'timeSeconds': serializer.toJson<int>(timeSeconds),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  UserProgressTableData copyWith(
          {int? levelId,
          int? stars,
          int? timeSeconds,
          Value<DateTime?> completedAt = const Value.absent()}) =>
      UserProgressTableData(
        levelId: levelId ?? this.levelId,
        stars: stars ?? this.stars,
        timeSeconds: timeSeconds ?? this.timeSeconds,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  UserProgressTableData copyWithCompanion(UserProgressTableCompanion data) {
    return UserProgressTableData(
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      stars: data.stars.present ? data.stars.value : this.stars,
      timeSeconds:
          data.timeSeconds.present ? data.timeSeconds.value : this.timeSeconds,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressTableData(')
          ..write('levelId: $levelId, ')
          ..write('stars: $stars, ')
          ..write('timeSeconds: $timeSeconds, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(levelId, stars, timeSeconds, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressTableData &&
          other.levelId == this.levelId &&
          other.stars == this.stars &&
          other.timeSeconds == this.timeSeconds &&
          other.completedAt == this.completedAt);
}

class UserProgressTableCompanion
    extends UpdateCompanion<UserProgressTableData> {
  final Value<int> levelId;
  final Value<int> stars;
  final Value<int> timeSeconds;
  final Value<DateTime?> completedAt;
  const UserProgressTableCompanion({
    this.levelId = const Value.absent(),
    this.stars = const Value.absent(),
    this.timeSeconds = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  UserProgressTableCompanion.insert({
    this.levelId = const Value.absent(),
    this.stars = const Value.absent(),
    this.timeSeconds = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  static Insertable<UserProgressTableData> custom({
    Expression<int>? levelId,
    Expression<int>? stars,
    Expression<int>? timeSeconds,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (levelId != null) 'level_id': levelId,
      if (stars != null) 'stars': stars,
      if (timeSeconds != null) 'time_seconds': timeSeconds,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  UserProgressTableCompanion copyWith(
      {Value<int>? levelId,
      Value<int>? stars,
      Value<int>? timeSeconds,
      Value<DateTime?>? completedAt}) {
    return UserProgressTableCompanion(
      levelId: levelId ?? this.levelId,
      stars: stars ?? this.stars,
      timeSeconds: timeSeconds ?? this.timeSeconds,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (levelId.present) {
      map['level_id'] = Variable<int>(levelId.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (timeSeconds.present) {
      map['time_seconds'] = Variable<int>(timeSeconds.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressTableCompanion(')
          ..write('levelId: $levelId, ')
          ..write('stars: $stars, ')
          ..write('timeSeconds: $timeSeconds, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $KeyValueTableTable extends KeyValueTable
    with TableInfo<$KeyValueTableTable, KeyValueTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeyValueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'key_value_table';
  @override
  VerificationContext validateIntegrity(Insertable<KeyValueTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  KeyValueTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeyValueTableData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $KeyValueTableTable createAlias(String alias) {
    return $KeyValueTableTable(attachedDatabase, alias);
  }
}

class KeyValueTableData extends DataClass
    implements Insertable<KeyValueTableData> {
  final String key;
  final String value;
  const KeyValueTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  KeyValueTableCompanion toCompanion(bool nullToAbsent) {
    return KeyValueTableCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory KeyValueTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeyValueTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  KeyValueTableData copyWith({String? key, String? value}) => KeyValueTableData(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  KeyValueTableData copyWithCompanion(KeyValueTableCompanion data) {
    return KeyValueTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeyValueTableData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeyValueTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class KeyValueTableCompanion extends UpdateCompanion<KeyValueTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const KeyValueTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeyValueTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<KeyValueTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeyValueTableCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return KeyValueTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeyValueTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyProgressTableTable extends DailyProgressTable
    with TableInfo<$DailyProgressTableTable, DailyProgressTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
      'streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [date, completed, streak];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_progress_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DailyProgressTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('streak')) {
      context.handle(_streakMeta,
          streak.isAcceptableOrUnknown(data['streak']!, _streakMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailyProgressTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyProgressTableData(
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      streak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak'])!,
    );
  }

  @override
  $DailyProgressTableTable createAlias(String alias) {
    return $DailyProgressTableTable(attachedDatabase, alias);
  }
}

class DailyProgressTableData extends DataClass
    implements Insertable<DailyProgressTableData> {
  final String date;
  final bool completed;
  final int streak;
  const DailyProgressTableData(
      {required this.date, required this.completed, required this.streak});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['completed'] = Variable<bool>(completed);
    map['streak'] = Variable<int>(streak);
    return map;
  }

  DailyProgressTableCompanion toCompanion(bool nullToAbsent) {
    return DailyProgressTableCompanion(
      date: Value(date),
      completed: Value(completed),
      streak: Value(streak),
    );
  }

  factory DailyProgressTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyProgressTableData(
      date: serializer.fromJson<String>(json['date']),
      completed: serializer.fromJson<bool>(json['completed']),
      streak: serializer.fromJson<int>(json['streak']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'completed': serializer.toJson<bool>(completed),
      'streak': serializer.toJson<int>(streak),
    };
  }

  DailyProgressTableData copyWith(
          {String? date, bool? completed, int? streak}) =>
      DailyProgressTableData(
        date: date ?? this.date,
        completed: completed ?? this.completed,
        streak: streak ?? this.streak,
      );
  DailyProgressTableData copyWithCompanion(DailyProgressTableCompanion data) {
    return DailyProgressTableData(
      date: data.date.present ? data.date.value : this.date,
      completed: data.completed.present ? data.completed.value : this.completed,
      streak: data.streak.present ? data.streak.value : this.streak,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyProgressTableData(')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('streak: $streak')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, completed, streak);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyProgressTableData &&
          other.date == this.date &&
          other.completed == this.completed &&
          other.streak == this.streak);
}

class DailyProgressTableCompanion
    extends UpdateCompanion<DailyProgressTableData> {
  final Value<String> date;
  final Value<bool> completed;
  final Value<int> streak;
  final Value<int> rowid;
  const DailyProgressTableCompanion({
    this.date = const Value.absent(),
    this.completed = const Value.absent(),
    this.streak = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyProgressTableCompanion.insert({
    required String date,
    this.completed = const Value.absent(),
    this.streak = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyProgressTableData> custom({
    Expression<String>? date,
    Expression<bool>? completed,
    Expression<int>? streak,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (completed != null) 'completed': completed,
      if (streak != null) 'streak': streak,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyProgressTableCompanion copyWith(
      {Value<String>? date,
      Value<bool>? completed,
      Value<int>? streak,
      Value<int>? rowid}) {
    return DailyProgressTableCompanion(
      date: date ?? this.date,
      completed: completed ?? this.completed,
      streak: streak ?? this.streak,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyProgressTableCompanion(')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('streak: $streak, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementTableTable extends AchievementTable
    with TableInfo<$AchievementTableTable, AchievementTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedMeta =
      const VerificationMeta('unlocked');
  @override
  late final GeneratedColumn<bool> unlocked = GeneratedColumn<bool>(
      'unlocked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("unlocked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, unlocked, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievement_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AchievementTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('unlocked')) {
      context.handle(_unlockedMeta,
          unlocked.isAcceptableOrUnknown(data['unlocked']!, _unlockedMeta));
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AchievementTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      unlocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}unlocked'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at']),
    );
  }

  @override
  $AchievementTableTable createAlias(String alias) {
    return $AchievementTableTable(attachedDatabase, alias);
  }
}

class AchievementTableData extends DataClass
    implements Insertable<AchievementTableData> {
  final String id;
  final bool unlocked;
  final DateTime? unlockedAt;
  const AchievementTableData(
      {required this.id, required this.unlocked, this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['unlocked'] = Variable<bool>(unlocked);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    return map;
  }

  AchievementTableCompanion toCompanion(bool nullToAbsent) {
    return AchievementTableCompanion(
      id: Value(id),
      unlocked: Value(unlocked),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
    );
  }

  factory AchievementTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementTableData(
      id: serializer.fromJson<String>(json['id']),
      unlocked: serializer.fromJson<bool>(json['unlocked']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'unlocked': serializer.toJson<bool>(unlocked),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
    };
  }

  AchievementTableData copyWith(
          {String? id,
          bool? unlocked,
          Value<DateTime?> unlockedAt = const Value.absent()}) =>
      AchievementTableData(
        id: id ?? this.id,
        unlocked: unlocked ?? this.unlocked,
        unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
      );
  AchievementTableData copyWithCompanion(AchievementTableCompanion data) {
    return AchievementTableData(
      id: data.id.present ? data.id.value : this.id,
      unlocked: data.unlocked.present ? data.unlocked.value : this.unlocked,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementTableData(')
          ..write('id: $id, ')
          ..write('unlocked: $unlocked, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, unlocked, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementTableData &&
          other.id == this.id &&
          other.unlocked == this.unlocked &&
          other.unlockedAt == this.unlockedAt);
}

class AchievementTableCompanion extends UpdateCompanion<AchievementTableData> {
  final Value<String> id;
  final Value<bool> unlocked;
  final Value<DateTime?> unlockedAt;
  final Value<int> rowid;
  const AchievementTableCompanion({
    this.id = const Value.absent(),
    this.unlocked = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementTableCompanion.insert({
    required String id,
    this.unlocked = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<AchievementTableData> custom({
    Expression<String>? id,
    Expression<bool>? unlocked,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unlocked != null) 'unlocked': unlocked,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementTableCompanion copyWith(
      {Value<String>? id,
      Value<bool>? unlocked,
      Value<DateTime?>? unlockedAt,
      Value<int>? rowid}) {
    return AchievementTableCompanion(
      id: id ?? this.id,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (unlocked.present) {
      map['unlocked'] = Variable<bool>(unlocked.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementTableCompanion(')
          ..write('id: $id, ')
          ..write('unlocked: $unlocked, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProgressTableTable userProgressTable =
      $UserProgressTableTable(this);
  late final $KeyValueTableTable keyValueTable = $KeyValueTableTable(this);
  late final $DailyProgressTableTable dailyProgressTable =
      $DailyProgressTableTable(this);
  late final $AchievementTableTable achievementTable =
      $AchievementTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [userProgressTable, keyValueTable, dailyProgressTable, achievementTable];
}

typedef $$UserProgressTableTableCreateCompanionBuilder
    = UserProgressTableCompanion Function({
  Value<int> levelId,
  Value<int> stars,
  Value<int> timeSeconds,
  Value<DateTime?> completedAt,
});
typedef $$UserProgressTableTableUpdateCompanionBuilder
    = UserProgressTableCompanion Function({
  Value<int> levelId,
  Value<int> stars,
  Value<int> timeSeconds,
  Value<DateTime?> completedAt,
});

class $$UserProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get levelId => $composableBuilder(
      column: $table.levelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stars => $composableBuilder(
      column: $table.stars, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timeSeconds => $composableBuilder(
      column: $table.timeSeconds, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$UserProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get levelId => $composableBuilder(
      column: $table.levelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stars => $composableBuilder(
      column: $table.stars, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timeSeconds => $composableBuilder(
      column: $table.timeSeconds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get levelId =>
      $composableBuilder(column: $table.levelId, builder: (column) => column);

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<int> get timeSeconds => $composableBuilder(
      column: $table.timeSeconds, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$UserProgressTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProgressTableTable,
    UserProgressTableData,
    $$UserProgressTableTableFilterComposer,
    $$UserProgressTableTableOrderingComposer,
    $$UserProgressTableTableAnnotationComposer,
    $$UserProgressTableTableCreateCompanionBuilder,
    $$UserProgressTableTableUpdateCompanionBuilder,
    (
      UserProgressTableData,
      BaseReferences<_$AppDatabase, $UserProgressTableTable,
          UserProgressTableData>
    ),
    UserProgressTableData,
    PrefetchHooks Function()> {
  $$UserProgressTableTableTableManager(
      _$AppDatabase db, $UserProgressTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> levelId = const Value.absent(),
            Value<int> stars = const Value.absent(),
            Value<int> timeSeconds = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
          }) =>
              UserProgressTableCompanion(
            levelId: levelId,
            stars: stars,
            timeSeconds: timeSeconds,
            completedAt: completedAt,
          ),
          createCompanionCallback: ({
            Value<int> levelId = const Value.absent(),
            Value<int> stars = const Value.absent(),
            Value<int> timeSeconds = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
          }) =>
              UserProgressTableCompanion.insert(
            levelId: levelId,
            stars: stars,
            timeSeconds: timeSeconds,
            completedAt: completedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProgressTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProgressTableTable,
    UserProgressTableData,
    $$UserProgressTableTableFilterComposer,
    $$UserProgressTableTableOrderingComposer,
    $$UserProgressTableTableAnnotationComposer,
    $$UserProgressTableTableCreateCompanionBuilder,
    $$UserProgressTableTableUpdateCompanionBuilder,
    (
      UserProgressTableData,
      BaseReferences<_$AppDatabase, $UserProgressTableTable,
          UserProgressTableData>
    ),
    UserProgressTableData,
    PrefetchHooks Function()>;
typedef $$KeyValueTableTableCreateCompanionBuilder = KeyValueTableCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$KeyValueTableTableUpdateCompanionBuilder = KeyValueTableCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$KeyValueTableTableFilterComposer
    extends Composer<_$AppDatabase, $KeyValueTableTable> {
  $$KeyValueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$KeyValueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $KeyValueTableTable> {
  $$KeyValueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$KeyValueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $KeyValueTableTable> {
  $$KeyValueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$KeyValueTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KeyValueTableTable,
    KeyValueTableData,
    $$KeyValueTableTableFilterComposer,
    $$KeyValueTableTableOrderingComposer,
    $$KeyValueTableTableAnnotationComposer,
    $$KeyValueTableTableCreateCompanionBuilder,
    $$KeyValueTableTableUpdateCompanionBuilder,
    (
      KeyValueTableData,
      BaseReferences<_$AppDatabase, $KeyValueTableTable, KeyValueTableData>
    ),
    KeyValueTableData,
    PrefetchHooks Function()> {
  $$KeyValueTableTableTableManager(_$AppDatabase db, $KeyValueTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeyValueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeyValueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeyValueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KeyValueTableCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              KeyValueTableCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KeyValueTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KeyValueTableTable,
    KeyValueTableData,
    $$KeyValueTableTableFilterComposer,
    $$KeyValueTableTableOrderingComposer,
    $$KeyValueTableTableAnnotationComposer,
    $$KeyValueTableTableCreateCompanionBuilder,
    $$KeyValueTableTableUpdateCompanionBuilder,
    (
      KeyValueTableData,
      BaseReferences<_$AppDatabase, $KeyValueTableTable, KeyValueTableData>
    ),
    KeyValueTableData,
    PrefetchHooks Function()>;
typedef $$DailyProgressTableTableCreateCompanionBuilder
    = DailyProgressTableCompanion Function({
  required String date,
  Value<bool> completed,
  Value<int> streak,
  Value<int> rowid,
});
typedef $$DailyProgressTableTableUpdateCompanionBuilder
    = DailyProgressTableCompanion Function({
  Value<String> date,
  Value<bool> completed,
  Value<int> streak,
  Value<int> rowid,
});

class $$DailyProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $DailyProgressTableTable> {
  $$DailyProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnFilters(column));
}

class $$DailyProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyProgressTableTable> {
  $$DailyProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnOrderings(column));
}

class $$DailyProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyProgressTableTable> {
  $$DailyProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);
}

class $$DailyProgressTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyProgressTableTable,
    DailyProgressTableData,
    $$DailyProgressTableTableFilterComposer,
    $$DailyProgressTableTableOrderingComposer,
    $$DailyProgressTableTableAnnotationComposer,
    $$DailyProgressTableTableCreateCompanionBuilder,
    $$DailyProgressTableTableUpdateCompanionBuilder,
    (
      DailyProgressTableData,
      BaseReferences<_$AppDatabase, $DailyProgressTableTable,
          DailyProgressTableData>
    ),
    DailyProgressTableData,
    PrefetchHooks Function()> {
  $$DailyProgressTableTableTableManager(
      _$AppDatabase db, $DailyProgressTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyProgressTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyProgressTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> date = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyProgressTableCompanion(
            date: date,
            completed: completed,
            streak: streak,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String date,
            Value<bool> completed = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyProgressTableCompanion.insert(
            date: date,
            completed: completed,
            streak: streak,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyProgressTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyProgressTableTable,
    DailyProgressTableData,
    $$DailyProgressTableTableFilterComposer,
    $$DailyProgressTableTableOrderingComposer,
    $$DailyProgressTableTableAnnotationComposer,
    $$DailyProgressTableTableCreateCompanionBuilder,
    $$DailyProgressTableTableUpdateCompanionBuilder,
    (
      DailyProgressTableData,
      BaseReferences<_$AppDatabase, $DailyProgressTableTable,
          DailyProgressTableData>
    ),
    DailyProgressTableData,
    PrefetchHooks Function()>;
typedef $$AchievementTableTableCreateCompanionBuilder
    = AchievementTableCompanion Function({
  required String id,
  Value<bool> unlocked,
  Value<DateTime?> unlockedAt,
  Value<int> rowid,
});
typedef $$AchievementTableTableUpdateCompanionBuilder
    = AchievementTableCompanion Function({
  Value<String> id,
  Value<bool> unlocked,
  Value<DateTime?> unlockedAt,
  Value<int> rowid,
});

class $$AchievementTableTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementTableTable> {
  $$AchievementTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get unlocked => $composableBuilder(
      column: $table.unlocked, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));
}

class $$AchievementTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementTableTable> {
  $$AchievementTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get unlocked => $composableBuilder(
      column: $table.unlocked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));
}

class $$AchievementTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementTableTable> {
  $$AchievementTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get unlocked =>
      $composableBuilder(column: $table.unlocked, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);
}

class $$AchievementTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AchievementTableTable,
    AchievementTableData,
    $$AchievementTableTableFilterComposer,
    $$AchievementTableTableOrderingComposer,
    $$AchievementTableTableAnnotationComposer,
    $$AchievementTableTableCreateCompanionBuilder,
    $$AchievementTableTableUpdateCompanionBuilder,
    (
      AchievementTableData,
      BaseReferences<_$AppDatabase, $AchievementTableTable,
          AchievementTableData>
    ),
    AchievementTableData,
    PrefetchHooks Function()> {
  $$AchievementTableTableTableManager(
      _$AppDatabase db, $AchievementTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<bool> unlocked = const Value.absent(),
            Value<DateTime?> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementTableCompanion(
            id: id,
            unlocked: unlocked,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<bool> unlocked = const Value.absent(),
            Value<DateTime?> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementTableCompanion.insert(
            id: id,
            unlocked: unlocked,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AchievementTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AchievementTableTable,
    AchievementTableData,
    $$AchievementTableTableFilterComposer,
    $$AchievementTableTableOrderingComposer,
    $$AchievementTableTableAnnotationComposer,
    $$AchievementTableTableCreateCompanionBuilder,
    $$AchievementTableTableUpdateCompanionBuilder,
    (
      AchievementTableData,
      BaseReferences<_$AppDatabase, $AchievementTableTable,
          AchievementTableData>
    ),
    AchievementTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProgressTableTableTableManager get userProgressTable =>
      $$UserProgressTableTableTableManager(_db, _db.userProgressTable);
  $$KeyValueTableTableTableManager get keyValueTable =>
      $$KeyValueTableTableTableManager(_db, _db.keyValueTable);
  $$DailyProgressTableTableTableManager get dailyProgressTable =>
      $$DailyProgressTableTableTableManager(_db, _db.dailyProgressTable);
  $$AchievementTableTableTableManager get achievementTable =>
      $$AchievementTableTableTableManager(_db, _db.achievementTable);
}
