part of 'home_cubit.dart';


sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class ChangeValue extends HomeState {}
final class ChangeStepPrev extends HomeState {}
final class ChangeStepNext extends HomeState {}
final class FormsFetched extends HomeState {}
final class FormSelected extends HomeState {}
final class SendForm extends HomeState {}
final class SendPaymentForm extends HomeState {}
final class GetDepartment extends HomeState {}
final class SelectTitle extends HomeState {}
final class UploadfileLoading extends HomeState {}
final class UploadfileSuccess extends HomeState {}
final class UploadAdvancePaymentLoading extends HomeState {}
final class UploadElectronicInvoiceLoading extends HomeState {}
final class UploadCommertialRegestrationLoading extends HomeState {}
final class FetchEmails extends HomeState {}
final class AddToList extends HomeState {}
final class UploadAdvancePaymentSuccess extends HomeState {}
final class UploadElectronicInvoiceSuccess extends HomeState {}
final class UploadCommertialRegestrationSuccess extends HomeState {}
