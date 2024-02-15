import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {}

class InitialedState extends BaseState {
  @override
  List<Object> get props => [];
}

class LoadingState extends BaseState {
  @override
  List<Object> get props => [];
}

class LoadedState extends BaseState {
  @override
  List<Object> get props => [];
}

///HomePageIndex changed
class HomePageIndexChangedState extends BaseState {
  ///start from 0
  final int pageIndex;

  ///random value
  final int ranValue;

  HomePageIndexChangedState(this.pageIndex, this.ranValue);

  @override
  List<Object> get props => [pageIndex, ranValue];
}
