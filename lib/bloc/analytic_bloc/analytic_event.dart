import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_event.dart';

class AnalyticEvent extends BaseEvent {
  @override
  List<Object> get props => [];
}

class GetTransactionHistoryEvent extends AnalyticEvent {
  @override
  List<Object> get props => [];
}

class SearchTransactionHistoryEvent extends AnalyticEvent {
  final String value;

  SearchTransactionHistoryEvent(this.value);

  @override
  List<Object> get props => [value];
}

class FilterByDateEvent extends AnalyticEvent {
  final DateTime dateTime;

  FilterByDateEvent({required this.dateTime});

  @override
  List<Object> get props => [DateTime.now().microsecondsSinceEpoch];
}

class GetUniqueDatesTransactionsHistoryEvent extends AnalyticEvent {
  final DateTime uniqueDates;

  GetUniqueDatesTransactionsHistoryEvent({required this.uniqueDates});
}

class TransactionPageToTopEvent extends AnalyticEvent {
  final bool isShow;

  TransactionPageToTopEvent({required this.isShow});
}
