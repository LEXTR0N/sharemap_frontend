import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/list_model.dart';
import '../../services/database_repository.dart';


part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DatabaseRepository _databaseRepository;

  HomeBloc(this._databaseRepository) : super(HomeInitial()) {
    on<LocationSelected>(_onLocationSelected);
    on<ListSelected>(_onListSelected);
    on<HomeInitialEvent>(_onHomeInitial);
    on<FetchLists>(_onFetchLists);
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

  void _onFetchLists(FetchLists event, Emitter<HomeState> emit) async {
    try {
      final lists = await _databaseRepository.getLists();
      emit(ListsLoaded(lists: lists));
    } catch (e) {
      emit(HomeError(error: e.toString())); // Handle errors gracefully
    }
  }
}
