import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_event.dart';

class CurrencyConversionEvent extends BaseEvent {
  @override
  List<Object?> get props => [];
}

class SelectFirstCurrencyEvent extends CurrencyConversionEvent {
  final String currency;

  SelectFirstCurrencyEvent({required this.currency});
  @override
  List<Object?> get props => [currency];
}

class SelectSecondCurrencyEvent extends CurrencyConversionEvent {
  final String currency;

  SelectSecondCurrencyEvent({required this.currency});
  @override
  List<Object?> get props => [currency];
}

class GetDefaultCurrencyEvent extends CurrencyConversionEvent {
  @override
  List<Object?> get props => [];
}

class EnterAmountEvent extends CurrencyConversionEvent {
  final String amount;

  EnterAmountEvent({required this.amount});
  @override
  List<Object?> get props => [amount];
}

class BlackSpaceEvent extends CurrencyConversionEvent {
  @override
  List<Object> get props => [];
}

class ClearAmountEnteredEvent extends CurrencyConversionEvent {
  @override
  List<Object> get props => [];
}

class HandleConversionEvent extends CurrencyConversionEvent {
  @override
  List<Object?> get props => [];
}

class ReverseCurrencyEvent extends CurrencyConversionEvent {
  @override
  List<Object?> get props => [];
}
