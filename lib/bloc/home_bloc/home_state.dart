import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';
import 'package:quan_ly_chi_tieu/resource/enum.dart';

class HomeState extends BaseState {
  @override
  List<Object?> get props => [];
}

class EnterValueState extends HomeState {
  final String value;

  EnterValueState(this.value);

  @override
  List<Object?> get props => [value];

  @override
  bool get stringify => true;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnterValueState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class EnterTransactionNameState extends HomeState {
  final String value;

  EnterTransactionNameState(this.value);

  @override
  List<Object?> get props => [value];

  @override
  bool get stringify => true;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnterTransactionNameState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class QuickSelectTransactionNameState extends HomeState {
  final String value;

  QuickSelectTransactionNameState(this.value);

  @override
  List<Object?> get props => [value];
}

class SaveTransactionState extends HomeState {}

class GetBalanceState extends HomeState {}

///Spending Limit

class SaveSpendingLimitState extends HomeState {
  final double value;

  SaveSpendingLimitState(this.value);

  @override
  List<Object?> get props => [value];
}

class GetSpendingLimitState extends HomeState {
  final dynamic response;

  GetSpendingLimitState(this.response);

  @override
  List<Object?> get props => [response];
}

class SelectTypeOfCategoryState extends HomeState {
  final TransactionType value;

  SelectTypeOfCategoryState(this.value);

  @override
  List<Object?> get props => [value];
}

class GetListCategoryTransactionState extends HomeState {}

class DeleteCategoryTransactionState extends HomeState {}
