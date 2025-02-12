part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}
final class Loading extends LoginState {}
final class NotLoading extends LoginState {}
