import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/capital_city_model.dart';
import '../../services/capital_city_service.dart';
import 'capital_city_event.dart';
import 'capital_city_state.dart';

class CapitalCityBloc extends Bloc<CapitalCityEvent, CapitalCityState> {
  final CapitalCityService _capitalCityService;
  List<CapitalCity> _capitals = [];
  bool _hasFetchedData = false; // Flag to track if data has been fetched

  CapitalCityBloc(this._capitalCityService) : super(CapitalCityLoading()) {
    on<FetchCapitalCities>(_onFetchCapitalCities);
    on<SelectCity>(_onSelectCity);
  }

  Future<void> _onFetchCapitalCities(
      FetchCapitalCities event,
      Emitter<CapitalCityState> emit,
      ) async {
    if (_hasFetchedData) {
      emit(CapitalCityLoaded(capitals: _capitals, hasMore: false));
      return;
    }

    emit(CapitalCityLoading());
    try {
      final capitals = await _capitalCityService.fetchCapitalCities();
      _capitals = capitals;
      _hasFetchedData = true; // Mark data as fetched
      emit(
        CapitalCityLoaded(
          capitals: capitals,
          hasMore: false,
        ),
      );
    } catch (e) {
      emit(CapitalCityError(message: e.toString()));
    }
  }

  void _onSelectCity(SelectCity event, Emitter<CapitalCityState> emit) {
    if (state is CapitalCityLoaded) {
      final loadSuccessState = state as CapitalCityLoaded;
      emit(CapitalCityLoaded(capitals: loadSuccessState.capitals, hasMore: loadSuccessState.hasMore, selectedCity: event.city));
    }
  }
}
