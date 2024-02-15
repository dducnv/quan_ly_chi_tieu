import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_event.dart';
import 'package:quan_ly_chi_tieu/resource/enum.dart';

class HomeEvent extends BaseEvent {
  @override
  List<Object> get props => [];
}

///add value to amount entered
class EnterValueEvent extends HomeEvent {
  final String value;

  EnterValueEvent(this.value);

  @override
  List<Object> get props => [value];
}

class BlackSpaceEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class ClearAmountEnteredEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

///enter transaction name
class EnterTransactionNameEvent extends HomeEvent {
  final String value;

  EnterTransactionNameEvent(this.value);

  @override
  List<Object> get props => [value];
}

class QuickSelectTransactionNameEvent extends HomeEvent {
  final String value;

  QuickSelectTransactionNameEvent(this.value);

  @override
  List<Object> get props => [value];
}

///Save transaction
class SaveTransactionEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class GetBalanceEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class IncrementBalanceEvent extends HomeEvent {
  IncrementBalanceEvent();

  @override
  List<Object> get props => [];
}

///Spending Limit
class SaveSpendingLimitEvent extends HomeEvent {
  final double amount;
  final DateTime startDate;
  final DateTime endDate;

  SaveSpendingLimitEvent({
    required this.amount,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [amount];
}

class GetSpendingLimitEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class GetListCategoryTransaction extends HomeEvent {
  @override
  List<Object> get props => [DateTime.now().microsecondsSinceEpoch];
}

class SelectTypeOfCategoryEvent extends HomeEvent {
  final TransactionType type;

  SelectTypeOfCategoryEvent(this.type);

  @override
  List<Object> get props => [type];
}

class SaveCategoryTransactionEvent extends HomeEvent {
  final String name;
  final String type;

  SaveCategoryTransactionEvent({
    required this.name,
    required this.type,
  });

  @override
  List<Object> get props => [name, type];
}

class DeleteCategoryTransactionEvent extends HomeEvent {
  final int id;

  DeleteCategoryTransactionEvent(this.id);

  @override
  List<Object> get props => [id];
}
