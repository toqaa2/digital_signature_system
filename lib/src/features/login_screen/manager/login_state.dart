part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}
final class Loading extends LoginState {}
final class NotLoading extends LoginState {}
final class ChangePasswordLoading extends LoginState {}
final class ChangePasswordSuccess extends LoginState {}
final class UpdatePassword extends LoginState {}
final class ChangeVisibility extends LoginState {}
final class Error extends LoginState {
  final String error;
  Error(this.error);
}