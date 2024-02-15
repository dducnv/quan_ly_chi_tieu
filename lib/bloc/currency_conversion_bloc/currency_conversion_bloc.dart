import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/currency_conversion_bloc/currency_conversion_event.dart';
import 'package:quan_ly_chi_tieu/bloc/currency_conversion_bloc/currency_conversion_state.dart';
import 'package:quan_ly_chi_tieu/core/utils/debug.dart';
import 'package:quan_ly_chi_tieu/models/currency_conversion_model.dart';
import 'package:quan_ly_chi_tieu/services/api_service.dart';
import 'package:quan_ly_chi_tieu/services/currency_service.dart';

class CurrencyConversionBloc extends BaseBloc {
  List<CurrencyConversionModel> currencyConversionModels = [];
  late CurrencyConversionModel currencyConversionModel;
  String firstCurrency = 'USD';
  String secondCurrency = 'VND';
  String enteredAmount = '1';
  String resultRate = '0';

  CurrencyConversionBloc() {
    on<SelectFirstCurrencyEvent>(
        (event, emit) => _handleSelectFirstCurrency(event, emit));
    on<SelectSecondCurrencyEvent>(
        (event, emit) => _handleSelectSecondCurrency(event, emit));
    on<GetDefaultCurrencyEvent>(
        (event, emit) => _handleGetDefaultCurrency(event, emit));
    on<EnterAmountEvent>((event, emit) => _handleEnterAmount(event, emit));
    on<BlackSpaceEvent>((event, emit) => _handleBackspace(event, emit));
    on<ClearAmountEnteredEvent>(
        (event, emit) => _handleClearAmountEntered(event, emit));
    on<HandleConversionEvent>((event, emit) => _handleConversion(event, emit));
    on<ReverseCurrencyEvent>(
        (event, emit) => _handleReverseCurrency(event, emit));
  }

  void _handleSelectFirstCurrency(
      SelectFirstCurrencyEvent event, Emitter emit) async {
    firstCurrency = event.currency;
    emit(SelectFirstCurrencyState(currency: event.currency));
    add(GetDefaultCurrencyEvent());
    add(HandleConversionEvent());
  }

  void _handleSelectSecondCurrency(
      SelectSecondCurrencyEvent event, Emitter emit) {
    secondCurrency = event.currency;
    emit(SelectSecondCurrencyState(currency: event.currency));
    add(HandleConversionEvent());
  }

  Future<void> _handleGetDefaultCurrency(
      GetDefaultCurrencyEvent event, Emitter emit) async {
    if (currencyConversionModels
        .where((element) => element.baseCode == firstCurrency)
        .isEmpty) {
      currencyConversionModels
          .add(await ApiService().getConversionRatesByCurrencyCode(
        currencyCode: firstCurrency,
      ));
      currencyConversionModel = currencyConversionModels
          .where((element) => element.baseCode == firstCurrency)
          .first;
    } else {
      currencyConversionModel = currencyConversionModels
          .where((element) => element.baseCode == firstCurrency)
          .first;
    }
    emit(GetDefaultCurrencyState(response: currencyConversionModel));
    add(HandleConversionEvent());
  }

  void _handleEnterAmount(EnterAmountEvent event, Emitter emit) {
    enteredAmount += event.amount;
    emit(EnterAmountState(amount: event.amount));
    add(HandleConversionEvent());
  }

  void _handleBackspace(BlackSpaceEvent event, Emitter emit) {
    if (enteredAmount.isEmpty || enteredAmount == '0') {
      enteredAmount = '0';
    } else {
      enteredAmount = enteredAmount.substring(0, enteredAmount.length - 1);
    }
    emit(EnterAmountState(amount: enteredAmount));
    add(HandleConversionEvent());
  }

  void _handleClearAmountEntered(ClearAmountEnteredEvent event, Emitter emit) {
    enteredAmount = '0';
    resultRate = "0";
    emit(EnterAmountState(amount: enteredAmount));
    add(HandleConversionEvent());
  }

  void _handleConversion(HandleConversionEvent event, Emitter emit) {
    Debug.logMessage(message: "HandleConversionEvent is called");
    if (enteredAmount == '' || enteredAmount == '0') {
      resultRate = "0";
      emit(HandleConversionState());
      return;
    }
    final oCcy = NumberFormat("#,##0.00");
    resultRate = oCcy
        .format(double.parse(enteredAmount) *
            (currencyConversionModel.conversionRates?[secondCurrency]))
        .replaceAll(",", "");

    emit(HandleConversionState());
  }

  void _handleReverseCurrency(ReverseCurrencyEvent event, Emitter emit) {
    String temp = firstCurrency;
    String tempResult = resultRate.toString();

    firstCurrency = secondCurrency;
    secondCurrency = temp;

    enteredAmount = tempResult;
    resultRate = "0";
    add(GetDefaultCurrencyEvent());
    add(HandleConversionEvent());
    emit(SelectFirstCurrencyState(currency: firstCurrency));
    emit(SelectSecondCurrencyState(currency: secondCurrency));
    emit(ReverseCurrencyState());
  }
}
