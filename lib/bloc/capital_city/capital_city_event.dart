import 'package:equatable/equatable.dart';
import '../../models/capital_city_model.dart';

abstract class CapitalCityEvent extends Equatable {
  const CapitalCityEvent();

  @override
  List<Object> get props => [];
}

class FetchCapitalCities extends CapitalCityEvent {}

class SelectCity extends CapitalCityEvent {
  final CapitalCity city;

  SelectCity(this.city);

  @override
  List<Object> get props => [city];
}
