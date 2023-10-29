import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_event.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_state.dart';

class CalculatePercentageBloc extends BaseBloc {
  CalculatePercentageBloc() {
    on<CalculatePercentageOfANumberEvent>((event, emit) => emit(
        CalculatePercentageOfANumberState(
            result: event.number * event.percent / 100)));

    on<CalculatePercentageBetweenTwoNumbersEvent>((event, emit) => emit(
        CalculatePercentageBetweenTwoNumbersState(
            result: (event.firstNumber / event.secondNumber) * 100)));

    on<CalculatePercentageIncreaseDecreaseOfANumber>((event, emit) {
      if (event.isIncrease == true) {
        emit(CalculatePercentageIncreaseDecreaseOfANumberState(
            result: event.number + (event.number * event.percent / 100)));
      } else {
        emit(CalculatePercentageIncreaseDecreaseOfANumberState(
            result: event.number - (event.number * event.percent / 100)));
      }
    });
  }
}
