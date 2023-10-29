import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';

class AnalyticState extends BaseState {
  @override
  List<Object?> get props => [];
}

class GetTransactionHistoryState extends AnalyticState {
  final dynamic response;

  GetTransactionHistoryState({this.response});

  @override
  List<Object?> get props => [response];
}

class GetUniqueDatesTransactionsHistoryState extends AnalyticState {
  final dynamic response;

  GetUniqueDatesTransactionsHistoryState({this.response});

  @override
  List<Object?> get props => [response];
}

class TransactionToTopState extends AnalyticState {
  final dynamic isShow;
  TransactionToTopState({this.isShow});
  @override
  List<Object?> get props => [isShow];
}
