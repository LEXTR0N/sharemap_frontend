import 'package:bloc/bloc.dart';
import '../../services/capital_city_service.dart';
import 'capital_city_event.dart';
import 'capital_city_state.dart';

class CapitalCityBloc extends Bloc<CapitalCityEvent, CapitalCityState> {
  final CapitalCityService capitalCityService;

  CapitalCityBloc(this.capitalCityService) : super(CapitalCityInitial()) {
    on<FetchCapitalCities>(_onFetchCapitalCities);
  }

  void _onFetchCapitalCities(
      FetchCapitalCities event,
      Emitter<CapitalCityState> emit,
      ) async {
    try {
      if (state is CapitalCityLoading) return;
      emit(CapitalCityLoading());
      final capitals = await capitalCityService.fetchCapitalCities();
      emit(CapitalCityLoaded(capitals));
    } catch (e) {
      emit(CapitalCityError(e.toString()));
    }
  }
}
