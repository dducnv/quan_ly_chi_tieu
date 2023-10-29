import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_event.dart';

class CalculatePercentageEvent extends BaseEvent {
  @override
  List<Object?> get props => [];
}

class CalculatePercentageOfANumberEvent extends CalculatePercentageEvent {
  final double number;
  final double percent;

  CalculatePercentageOfANumberEvent(
      {required this.number, required this.percent});
  @override
  List<Object?> get props => [];
}

class CalculatePercentageBetweenTwoNumbersEvent
    extends CalculatePercentageEvent {
  final double firstNumber;
  final double secondNumber;

  CalculatePercentageBetweenTwoNumbersEvent(
      {required this.firstNumber, required this.secondNumber});
  @override
  List<Object?> get props => [];
}

class CalculatePercentageIncreaseDecreaseOfANumber
    extends CalculatePercentageEvent {
  final double number;
  final double percent;
  final bool isIncrease;

  CalculatePercentageIncreaseDecreaseOfANumber(
      {required this.number, required this.percent, required this.isIncrease});
  @override
  List<Object?> get props => [
        number,
        percent,
        isIncrease,
      ];
}
