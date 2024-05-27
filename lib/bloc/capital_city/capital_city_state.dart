import 'package:equatable/equatable.dart';

import '../../models/capital_city_model.dart';

abstract class CapitalCityState extends Equatable {
  const CapitalCityState();

  @override
  List<Object> get props => [];
}

class CapitalCityInitial extends CapitalCityState {}

class CapitalCityLoading extends CapitalCityState {}

class CapitalCityLoaded extends CapitalCityState {
  final List<CapitalCity> capitals;

  const CapitalCityLoaded(this.capitals);

  @override
  List<Object> get props => [capitals];
}

class CapitalCityError extends CapitalCityState {
  final String message;

  const CapitalCityError(this.message);

  @override
  List<Object> get props => [message];
}
