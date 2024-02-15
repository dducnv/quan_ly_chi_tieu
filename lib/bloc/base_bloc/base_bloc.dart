import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/resource/enum.dart';

import 'base_event.dart';
import 'base_state.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  BaseBloc() : super(InitialedState()) {
    on<LoadingEvent>((event, emit) => emit(LoadingState()));
    on<LoadedEvent>((event, emit) => emit(LoadedState()));
    on<HomePageIndexChangeEvent>((event, emit) => emit(
        HomePageIndexChangedState(event.homeIndexTab.inInt, event.ranValue)));
  }
}
