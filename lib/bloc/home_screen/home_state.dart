part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}
class LocationSelectedState extends HomeState {}
class ListSelectedState extends HomeState {}

class HomeError extends HomeState {
  final String error;
  HomeError({required this.error});
}
