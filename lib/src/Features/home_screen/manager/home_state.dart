part of 'home_cubit.dart';


sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class ChangeValue extends HomeState {}
final class ChangeStepPrev extends HomeState {}
final class ChangeStepNext extends HomeState {}
final class FormsFetched extends HomeState {}
final class FormSelected extends HomeState {}
final class SendForm extends HomeState {}
