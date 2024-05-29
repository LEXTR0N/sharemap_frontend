import 'package:equatable/equatable.dart';
import '../../models/capital_city_model.dart';

abstract class CapitalCityState extends Equatable {
  const CapitalCityState();

  @override
  List<Object?> get props => [];
}

class CapitalCityLoading extends CapitalCityState {}

class CapitalCityLoaded extends CapitalCityState {
  final List<CapitalCity> capitals;
  final bool hasMore;
  final CapitalCity? selectedCity;

  const CapitalCityLoaded({required this.capitals, required this.hasMore, this.selectedCity});

  @override
  List<Object?> get props => [capitals, hasMore, selectedCity];
}

class CapitalCityError extends CapitalCityState {
  final String message;

  const CapitalCityError({required this.message});

  @override
  List<Object?> get props => [message];
}
