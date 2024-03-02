import 'package:drift/drift.dart';
import 'package:quan_ly_chi_tieu/core/local/global_db.dart';
import 'package:quan_ly_chi_tieu/core/local/seed_data_local.dart';
part 'expense_management_db.g.dart';
int schemaVersionGlobal = 1;
class TransactionsHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  RealColumn get amount => real()();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => DateTime.now())();
}

class SpendingLimit extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get dateCreatedUntil =>
      dateTime().clientDefault(() => DateTime.now())();
}

class Balance extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => DateTime.now())();
}

class CategoryTransaction extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => DateTime.now())();
}

@DriftDatabase(
    tables: [TransactionsHistory, SpendingLimit, Balance, CategoryTransaction])
class ExpenseManagementDb extends _$ExpenseManagementDb {
  ExpenseManagementDb(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
  Expression<bool> isOnDay(
      GeneratedColumn<DateTime> dateColumn, DateTime date) {
    return dateColumn.isBetweenValues(
        DateTime(date.year, date.month, date.day),
        DateTime(date.year, date.month, date.day + 1)
            .subtract(const Duration(milliseconds: 1)));
  }

  Expression<bool> onlyShowBasedOnTimeRange(
      $TransactionsHistoryTable tbl, DateTime? startDate, DateTime? endDate,
      {bool? allTime = false}) {
    return allTime == true || (startDate == null && endDate == null)
        ? const Constant(true)
        : startDate == null && endDate != null
            ? isOnDay(transactionsHistory.dateCreated, endDate) |
                transactionsHistory.dateCreated.isSmallerOrEqualValue(endDate)
            : startDate != null && endDate == null
                ? isOnDay(transactionsHistory.dateCreated, startDate) |
                    transactionsHistory.dateCreated
                        .isBiggerOrEqualValue(startDate)
                : isOnDay(transactionsHistory.dateCreated, endDate!) |
                    isOnDay(transactionsHistory.dateCreated, startDate!) |
                    transactionsHistory.dateCreated
                        .isBetweenValues(startDate, endDate);
  }

  Stream<BalanceData> watchBalance() {
    return (select(balance)..where((tbl) => tbl.id.equals(1))).watchSingle();
  }

  Future<BalanceData> getBalance() {
    return (select(balance)..where((tbl) => tbl.id.equals(1))).getSingle();
  }

  Future<int> createOrUpdateBalance(BalanceData balanceData) {
    if (balanceData.amount > MAX_AMOUNT) {
      balanceData = balanceData.copyWith(amount: MAX_AMOUNT - 1);
    }
    return into($BalanceTable(attachedDatabase))
        .insertOnConflictUpdate(balanceData);
  }

  Future<int> createTransaction(TransactionsHistoryCompanion transaction) {
    return into($TransactionsHistoryTable(attachedDatabase))
        .insertOnConflictUpdate(transaction);
  }

  Future<List<TransactionsHistoryData>> watchTransactionsHistory(
      {int? limit,
      String? searchTerm,
      DateTime? startDate,
      DateTime? endDate}) {
    return (select(transactionsHistory)
          ..where((tbl) => searchTerm == null
              ? const Constant(true)
              : tbl.name.lower().like("%${searchTerm.toLowerCase()}%"))
          ..where((tbl) => onlyShowBasedOnTimeRange(tbl, startDate, endDate))
          ..orderBy([(t) => OrderingTerm.desc(t.dateCreated)])
          ..limit(limit ?? DEFAULT_LIMIT))
        .get();
  }

  Stream<List<DateTime?>> getUniqueDatesTransactionsHistory(
      {DateTime? start, DateTime? end}) {
    DateTime? startDate =
        start == null ? null : DateTime(start.year, start.month, start.day);
    DateTime? endDate =
        end == null ? null : DateTime(end.year, end.month, end.day);
    final query = selectOnly(transactionsHistory, distinct: true)
      ..where(onlyShowBasedOnTimeRange(transactionsHistory, startDate, endDate))
      ..addColumns([transactionsHistory.dateCreated])
      ..where(transactionsHistory.dateCreated.isNotNull());

    return query
        .map((row) => row.read(transactionsHistory.dateCreated))
        .watch();
  }

  Stream<Map<String, double>> getTotalIncomeAndExpenseByMonth({
    DateTime? startDate,
    DateTime? endDate,
  }) async* {
    // Start and end dates must be equal to or less than the current date.
    startDate ??= DateTime.now();
    endDate ??= DateTime.now();
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date must be less than or equal to end date.');
    }

    // Create a SQL query to group transactions by type and calculate the total amount for each type.
    final query = selectOnly(transactionsHistory, distinct: true)
      ..addColumns([
        transactionsHistory.type,
        transactionsHistory.amount.sum(),
      ])
      ..where(onlyShowBasedOnTimeRange(transactionsHistory, startDate, endDate))
      ..where(transactionsHistory.type.contains('income') |
          transactionsHistory.type.contains('expense'))
      ..groupBy([transactionsHistory.type]);

    Map<String, double> groupedTransactions = {};

    // Execute the query and yield the results.
    for (final row in await query.get()) {
      final type = row.read(transactionsHistory.type) as String;
      final total = row.read(transactionsHistory.amount.sum()) as double;
      groupedTransactions.addEntries([
        MapEntry<String, double>(type, total),
      ]);
    }
    yield groupedTransactions;
  }

  Stream<List<Map<dynamic, dynamic>>> getTotalTransactionGroupByCategoryName({
    DateTime? startDate,
    DateTime? endDate,
  }) async* {
    startDate ??= DateTime.now();
    endDate ??= DateTime.now();
    // Create a query to get the total amount of transactions by name.
    final query = selectOnly(transactionsHistory, distinct: true)
      ..addColumns([
        transactionsHistory.type,
        transactionsHistory.name.lower().count(),
        transactionsHistory.name.lower(),
        transactionsHistory.amount.sum(),
      ])
      ..where(onlyShowBasedOnTimeRange(transactionsHistory, startDate, endDate))
      ..groupBy([transactionsHistory.name.lower()]);

    // Execute the query and get the results.

    // Convert the results to a list of maps.
    final List<Map<dynamic, dynamic>> groupedTransactions = [];
    for (final row in await query.get()) {
      final type = row.read(transactionsHistory.type) as String;
      final name = row.read(transactionsHistory.name.lower()) as String;
      final count = row.read(transactionsHistory.name.lower().count()) as int;
      final total = row.read(transactionsHistory.amount.sum()) as double;
      groupedTransactions.add(
        {
          'count': count,
          'type': type,
          'name': name,
          'total': total,
        },
      );
    }

    // Close the transaction.

    yield groupedTransactions;
  }

  Stream<List<TransactionsHistoryData>> getTransactionWithDay(DateTime date) {
    final SimpleSelectStatement<$TransactionsHistoryTable,
        TransactionsHistoryData> query = (select(transactionsHistory)
      ..where((tbl) => isOnDay(tbl.dateCreated, date))
      ..orderBy([(t) => OrderingTerm.desc(t.dateCreated)]));
    return query.watch();
  }

  Stream<double> getTotalExpenseByDay(DateTime dateTime) async* {
    final query = selectOnly(transactionsHistory, distinct: true)
      ..addColumns([
        transactionsHistory.type,
        transactionsHistory.amount.sum(),
      ])
      ..where(transactionsHistory.type.contains('expense') &
          isOnDay(transactionsHistory.dateCreated, dateTime));

    for (final row in await query.get()) {
      final total = row.read(transactionsHistory.amount.sum()) as double;
      yield total;
    }
  }

  Future<TransactionsHistoryData> getTransactionsHistory(int id) {
    return (select(transactionsHistory)..where((tbl) => tbl.id.equals(1)))
        .getSingle();
  }

  Future<int> createSpendingLimit(SpendingLimitData spendingLimitData) {
    return into($SpendingLimitTable(attachedDatabase))
        .insertOnConflictUpdate(spendingLimitData);
  }

  Stream<SpendingLimitData> watchSpendingLimit() {
    return (select(spendingLimit)..where((tbl) => tbl.id.equals(1)))
        .watchSingle();
  }

  Future<SpendingLimitData> getSpendingLimit() {
    return (select(spendingLimit)..where((tbl) => tbl.id.equals(1)))
        .getSingle();
  }

  Future<int> createOrUpdateSpendingLimit(SpendingLimitData spendingLimit) {
    if (spendingLimit.amount > MAX_AMOUNT) {
      spendingLimit = spendingLimit.copyWith(amount: MAX_AMOUNT - 1);
    }
    return into($SpendingLimitTable(attachedDatabase))
        .insertOnConflictUpdate(spendingLimit);
  }

  Stream<double?> totalSpendAfterDay(DateTime day) {
    final totalAmt = transactionsHistory.amount.sum();
    final JoinedSelectStatement<$TransactionsHistoryTable,
        TransactionsHistoryData> query;
    query = selectOnly(transactionsHistory)
      ..where(transactionsHistory.type.contains("expense"))
      ..where(transactionsHistory.dateCreated.isBiggerThanValue(day))
      ..addColumns([totalAmt]);

    return query.map((row) => row.read(totalAmt)).watchSingleOrNull();
  }

  Future<List<CategoryTransactionData>> getCategory() {
    return (select(categoryTransaction)
          ..orderBy([(t) => OrderingTerm.desc(t.dateCreated)]))
        .get();
  }

  Future<int> addCategory(
      CategoryTransactionCompanion categoryTransactionData) {
    return into(categoryTransaction).insert(categoryTransactionData);
  }

  Future<int> deleteCategory(int id) {
    return (delete(categoryTransaction)..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<void> initCategory() async {
    await batch((batch) {
      batch.insertAll(categoryTransaction, [...listCategory]);
    });
  }
}
