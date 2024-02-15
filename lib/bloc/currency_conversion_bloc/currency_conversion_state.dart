import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';

class CurrencyConversionState extends BaseState {
  @override
  List<Object?> get props => [];
}

class SelectFirstCurrencyState extends CurrencyConversionState {
  final String currency;

  SelectFirstCurrencyState({required this.currency});
  @override
  List<Object?> get props => [currency];
}

class SelectSecondCurrencyState extends CurrencyConversionState {
  final String currency;

  SelectSecondCurrencyState({required this.currency});
  @override
  List<Object?> get props => [currency];
}

class GetDefaultCurrencyState extends CurrencyConversionState {
  final dynamic response;
  GetDefaultCurrencyState({required this.response});
  @override
  List<Object?> get props => [DateTime.now().millisecondsSinceEpoch, response];
}

class EnterAmountState extends CurrencyConversionState {
  final String amount;

  EnterAmountState({required this.amount});
  @override
  List<Object?> get props => [DateTime.now().millisecondsSinceEpoch, amount];
}

class HandleConversionState extends CurrencyConversionState {
  @override
  List<Object?> get props => [DateTime.now().millisecondsSinceEpoch];
}

class ReverseCurrencyState extends CurrencyConversionState {
  @override
  List<Object?> get props => [DateTime.now().millisecondsSinceEpoch];
}
