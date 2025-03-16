part of 'requests_cubit.dart';

@immutable
sealed class RequestsState {}

final class RequestsInitial extends RequestsState {}
final class GetSentForms extends RequestsState {}
final class SignedByMe extends RequestsState {}
final class LoadingSave extends RequestsState {}
final class SaveSuccess extends RequestsState {}
