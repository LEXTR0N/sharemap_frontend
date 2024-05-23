import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(InitialHomeState()) {
    on<LocationSelectedEvent>((event, emit) => emit(LocationSelectedState()));
    on<ListSelectedEvent>((event, emit) => emit(ListSelectedState()));
    on<InitialHomeStateEvent>((event, emit) => emit(InitialHomeState()));
  }
}
