// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_management_db.dart';

// ignore_for_file: type=lint
class $TransactionsHistoryTable extends TransactionsHistory
    with TableInfo<$TransactionsHistoryTable, TransactionsHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [id, name, type, amount, dateCreated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransactionsHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionsHistoryData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
    );
  }

  @override
  $TransactionsHistoryTable createAlias(String alias) {
    return $TransactionsHistoryTable(attachedDatabase, alias);
  }
}

class TransactionsHistoryData extends DataClass
    implements Insertable<TransactionsHistoryData> {
  final int id;
  final String name;
  final String type;
  final double amount;
  final DateTime dateCreated;
  const TransactionsHistoryData(
      {required this.id,
      required this.name,
      required this.type,
      required this.amount,
      required this.dateCreated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  TransactionsHistoryCompanion toCompanion(bool nullToAbsent) {
    return TransactionsHistoryCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      amount: Value(amount),
      dateCreated: Value(dateCreated),
    );
  }

  factory TransactionsHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsHistoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  TransactionsHistoryData copyWith(
          {int? id,
          String? name,
          String? type,
          double? amount,
          DateTime? dateCreated}) =>
      TransactionsHistoryData(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('TransactionsHistoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, amount, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsHistoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.dateCreated == this.dateCreated);
}

class TransactionsHistoryCompanion
    extends UpdateCompanion<TransactionsHistoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<double> amount;
  final Value<DateTime> dateCreated;
  const TransactionsHistoryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  TransactionsHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    required double amount,
    this.dateCreated = const Value.absent(),
  })  : name = Value(name),
        type = Value(type),
        amount = Value(amount);
  static Insertable<TransactionsHistoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  TransactionsHistoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? type,
      Value<double>? amount,
      Value<DateTime>? dateCreated}) {
    return TransactionsHistoryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsHistoryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $SpendingLimitTable extends SpendingLimit
    with TableInfo<$SpendingLimitTable, SpendingLimitData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpendingLimitTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _dateCreatedUntilMeta =
      const VerificationMeta('dateCreatedUntil');
  @override
  late final GeneratedColumn<DateTime> dateCreatedUntil =
      GeneratedColumn<DateTime>('date_created_until', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, amount, dateCreated, dateCreatedUntil];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spending_limit';
  @override
  VerificationContext validateIntegrity(Insertable<SpendingLimitData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    if (data.containsKey('date_created_until')) {
      context.handle(
          _dateCreatedUntilMeta,
          dateCreatedUntil.isAcceptableOrUnknown(
              data['date_created_until']!, _dateCreatedUntilMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpendingLimitData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpendingLimitData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
      dateCreatedUntil: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_created_until'])!,
    );
  }

  @override
  $SpendingLimitTable createAlias(String alias) {
    return $SpendingLimitTable(attachedDatabase, alias);
  }
}

class SpendingLimitData extends DataClass
    implements Insertable<SpendingLimitData> {
  final int id;
  final double amount;
  final DateTime dateCreated;
  final DateTime dateCreatedUntil;
  const SpendingLimitData(
      {required this.id,
      required this.amount,
      required this.dateCreated,
      required this.dateCreatedUntil});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['date_created'] = Variable<DateTime>(dateCreated);
    map['date_created_until'] = Variable<DateTime>(dateCreatedUntil);
    return map;
  }

  SpendingLimitCompanion toCompanion(bool nullToAbsent) {
    return SpendingLimitCompanion(
      id: Value(id),
      amount: Value(amount),
      dateCreated: Value(dateCreated),
      dateCreatedUntil: Value(dateCreatedUntil),
    );
  }

  factory SpendingLimitData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpendingLimitData(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      dateCreatedUntil: serializer.fromJson<DateTime>(json['dateCreatedUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'dateCreatedUntil': serializer.toJson<DateTime>(dateCreatedUntil),
    };
  }

  SpendingLimitData copyWith(
          {int? id,
          double? amount,
          DateTime? dateCreated,
          DateTime? dateCreatedUntil}) =>
      SpendingLimitData(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        dateCreated: dateCreated ?? this.dateCreated,
        dateCreatedUntil: dateCreatedUntil ?? this.dateCreatedUntil,
      );
  @override
  String toString() {
    return (StringBuffer('SpendingLimitData(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateCreatedUntil: $dateCreatedUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, dateCreated, dateCreatedUntil);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpendingLimitData &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.dateCreated == this.dateCreated &&
          other.dateCreatedUntil == this.dateCreatedUntil);
}

class SpendingLimitCompanion extends UpdateCompanion<SpendingLimitData> {
  final Value<int> id;
  final Value<double> amount;
  final Value<DateTime> dateCreated;
  final Value<DateTime> dateCreatedUntil;
  const SpendingLimitCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateCreatedUntil = const Value.absent(),
  });
  SpendingLimitCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    this.dateCreated = const Value.absent(),
    this.dateCreatedUntil = const Value.absent(),
  }) : amount = Value(amount);
  static Insertable<SpendingLimitData> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateCreatedUntil,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateCreatedUntil != null) 'date_created_until': dateCreatedUntil,
    });
  }

  SpendingLimitCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<DateTime>? dateCreated,
      Value<DateTime>? dateCreatedUntil}) {
    return SpendingLimitCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      dateCreated: dateCreated ?? this.dateCreated,
      dateCreatedUntil: dateCreatedUntil ?? this.dateCreatedUntil,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateCreatedUntil.present) {
      map['date_created_until'] = Variable<DateTime>(dateCreatedUntil.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpendingLimitCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateCreatedUntil: $dateCreatedUntil')
          ..write(')'))
        .toString();
  }
}

class $BalanceTable extends Balance with TableInfo<$BalanceTable, BalanceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BalanceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [id, amount, dateCreated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'balance';
  @override
  VerificationContext validateIntegrity(Insertable<BalanceData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BalanceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BalanceData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
    );
  }

  @override
  $BalanceTable createAlias(String alias) {
    return $BalanceTable(attachedDatabase, alias);
  }
}

class BalanceData extends DataClass implements Insertable<BalanceData> {
  final int id;
  final double amount;
  final DateTime dateCreated;
  const BalanceData(
      {required this.id, required this.amount, required this.dateCreated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  BalanceCompanion toCompanion(bool nullToAbsent) {
    return BalanceCompanion(
      id: Value(id),
      amount: Value(amount),
      dateCreated: Value(dateCreated),
    );
  }

  factory BalanceData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BalanceData(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  BalanceData copyWith({int? id, double? amount, DateTime? dateCreated}) =>
      BalanceData(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('BalanceData(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BalanceData &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.dateCreated == this.dateCreated);
}

class BalanceCompanion extends UpdateCompanion<BalanceData> {
  final Value<int> id;
  final Value<double> amount;
  final Value<DateTime> dateCreated;
  const BalanceCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  BalanceCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    this.dateCreated = const Value.absent(),
  }) : amount = Value(amount);
  static Insertable<BalanceData> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  BalanceCompanion copyWith(
      {Value<int>? id, Value<double>? amount, Value<DateTime>? dateCreated}) {
    return BalanceCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BalanceCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $CategoryTransactionTable extends CategoryTransaction
    with TableInfo<$CategoryTransactionTable, CategoryTransactionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTransactionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [id, name, type, dateCreated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_transaction';
  @override
  VerificationContext validateIntegrity(
      Insertable<CategoryTransactionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryTransactionData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryTransactionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
    );
  }

  @override
  $CategoryTransactionTable createAlias(String alias) {
    return $CategoryTransactionTable(attachedDatabase, alias);
  }
}

class CategoryTransactionData extends DataClass
    implements Insertable<CategoryTransactionData> {
  final int id;
  final String name;
  final String type;
  final DateTime dateCreated;
  const CategoryTransactionData(
      {required this.id,
      required this.name,
      required this.type,
      required this.dateCreated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  CategoryTransactionCompanion toCompanion(bool nullToAbsent) {
    return CategoryTransactionCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      dateCreated: Value(dateCreated),
    );
  }

  factory CategoryTransactionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryTransactionData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  CategoryTransactionData copyWith(
          {int? id, String? name, String? type, DateTime? dateCreated}) =>
      CategoryTransactionData(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('CategoryTransactionData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryTransactionData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.dateCreated == this.dateCreated);
}

class CategoryTransactionCompanion
    extends UpdateCompanion<CategoryTransactionData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<DateTime> dateCreated;
  const CategoryTransactionCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  CategoryTransactionCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    this.dateCreated = const Value.absent(),
  })  : name = Value(name),
        type = Value(type);
  static Insertable<CategoryTransactionData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  CategoryTransactionCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? type,
      Value<DateTime>? dateCreated}) {
    return CategoryTransactionCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTransactionCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

abstract class _$ExpenseManagementDb extends GeneratedDatabase {
  _$ExpenseManagementDb(QueryExecutor e) : super(e);
  late final $TransactionsHistoryTable transactionsHistory =
      $TransactionsHistoryTable(this);
  late final $SpendingLimitTable spendingLimit = $SpendingLimitTable(this);
  late final $BalanceTable balance = $BalanceTable(this);
  late final $CategoryTransactionTable categoryTransaction =
      $CategoryTransactionTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [transactionsHistory, spendingLimit, balance, categoryTransaction];
}
