import 'package:quan_ly_chi_tieu/bloc/analytic_bloc/analytic_event.dart';
import 'package:quan_ly_chi_tieu/bloc/analytic_bloc/analytic_state.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_bloc.dart';
import 'package:quan_ly_chi_tieu/core/local/database/expense_management_db.dart';
import 'package:quan_ly_chi_tieu/core/local/global_db.dart';

class AnalyticBloc extends BaseBloc {
  List<TransactionsHistoryData> transactionHistory = [];
  List<DateTime> uniqueDates = [];
  AnalyticBloc() {
    on<GetTransactionHistoryEvent>(
      (event, emit) async =>
          database.watchTransactionsHistory().then((value) => emit(
                GetTransactionHistoryState(response: value),
              )),
    );
    on<SearchTransactionHistoryEvent>(
      (event, emit) async => database
          .watchTransactionsHistory(
              limit: DEFAULT_LIMIT, searchTerm: event.value)
          .then((value) => emit(GetTransactionHistoryState(response: value))),
    );
    on<FilterByDateEvent>(
      (event, emit) async => database
          .watchTransactionsHistory(
            limit: DEFAULT_LIMIT,
            startDate: event.dateTime,
            endDate: DateTime(event.dateTime.year, event.dateTime.month + 1,
                event.dateTime.day - 1),
          )
          .then((value) => emit(GetTransactionHistoryState(response: value))),
    );

    on<GetUniqueDatesTransactionsHistoryEvent>(
      (event, emit) async => uniqueDates.clear(),
    );

    on<TransactionPageToTopEvent>(
      (event, emit) async => emit(TransactionToTopState(
        isShow: event.isShow,
      )),
    );
  }
  getUniqueDate(List<dynamic> list) {
    DateTime previousDate = DateTime(1900);

    for (DateTime? dateNullable in list.reversed) {
      DateTime date = dateNullable ?? DateTime.now();
      if (previousDate.day == date.day &&
          previousDate.month == date.month &&
          previousDate.year == date.year) {
        continue;
      }
      previousDate = date;
      return date;
    }
  }
}
