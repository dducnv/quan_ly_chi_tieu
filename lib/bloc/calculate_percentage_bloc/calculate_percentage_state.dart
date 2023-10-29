import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';

class CalculatePercentageState extends BaseState {
  @override
  List<Object?> get props => [];
}

class CalculatePercentageOfANumberState extends CalculatePercentageState {
  final dynamic result;

  CalculatePercentageOfANumberState({this.result});
  @override
  List<Object?> get props => [result];
}

class CalculatePercentageBetweenTwoNumbersState
    extends CalculatePercentageState {
  final dynamic result;

  CalculatePercentageBetweenTwoNumbersState({this.result});
  @override
  List<Object?> get props => [result];
}

class CalculatePercentageIncreaseDecreaseOfANumberState
    extends CalculatePercentageState {
  final dynamic result;

  CalculatePercentageIncreaseDecreaseOfANumberState({this.result});
  @override
  List<Object?> get props => [DateTime.now().microsecondsSinceEpoch, result];
}
