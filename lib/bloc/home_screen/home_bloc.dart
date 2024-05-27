import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeInitial()) {
    on<LocationSelected>(_onLocationSelected);
    on<ListSelected>(_onListSelected);
    on<HomeInitialEvent>(_onHomeInitial);
  }

  void _onLocationSelected(LocationSelected event, Emitter<HomeState> emit) {
    emit(LocationSelectedState());
  }

  void _onListSelected(ListSelected event, Emitter<HomeState> emit) {
    emit(ListSelectedState());
  }

  void _onHomeInitial(HomeInitialEvent event, Emitter<HomeState> emit) {
    emit(HomeInitial());
  }

}
