import 'package:equatable/equatable.dart';
import 'package:quan_ly_chi_tieu/resource/enum.dart';

abstract class BaseEvent extends Equatable {}

class LoadingEvent extends BaseEvent {
  @override
  List<Object> get props => [];
}

class LoadedEvent extends BaseEvent {
  @override
  List<Object> get props => [];
}

class HomePageIndexChangeEvent extends BaseEvent {
  final HomeIndexTab homeIndexTab;

  ///random value
  final int ranValue;

  HomePageIndexChangeEvent(this.homeIndexTab, this.ranValue);

  @override
  List<Object> get props => [ranValue, homeIndexTab];
}
