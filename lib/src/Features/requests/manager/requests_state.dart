part of 'requests_cubit.dart';

@immutable
sealed class RequestsState {}

final class RequestsInitial extends RequestsState {}
final class Search extends RequestsState {}
final class LoadingSentForms extends RequestsState {}
final class LoadingReceivedForms extends RequestsState {}
final class GetSentForms extends RequestsState {}
final class GetReceivedForms extends RequestsState {}
final class SignedByMe extends RequestsState {}
final class LoadingSave extends RequestsState {}
final class SaveSuccess extends RequestsState {}
final class ToggleVisibality extends RequestsState {}
