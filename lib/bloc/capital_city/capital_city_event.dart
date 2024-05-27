import 'package:equatable/equatable.dart';

abstract class CapitalCityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCapitalCities extends CapitalCityEvent {}
