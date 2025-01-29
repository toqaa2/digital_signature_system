part of 'home_cubit.dart';


sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class ChangeValue extends HomeState {}
final class ChangeStepPrev extends HomeState {}
final class ChangeStepNext extends HomeState {}
