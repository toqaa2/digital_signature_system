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
final class GetAllForms extends HomeState {}
final class GetDepartment extends HomeState {}
final class SelectTitle extends HomeState {}
final class RemoveEmail extends HomeState {}
final class UploadFileLoading extends HomeState {}
final class UploadOtherFileLoading extends HomeState {}
final class UploadLoading extends HomeState {}
final class getAllFormsLoading extends HomeState {}
final class UploadOtherFileSuccess extends HomeState {}
final class UploadSuccess extends HomeState {}
final class UploadFileSuccess extends HomeState {}
final class UploadAdvancePaymentLoading extends HomeState {}
final class UploadElectronicInvoiceLoading extends HomeState {}
final class UploadCommercialRegistrationLoading extends HomeState {}
final class FetchEmails extends HomeState {}
final class AddToList extends HomeState {}
final class UploadAdvancePaymentSuccess extends HomeState {}
final class UploadElectronicInvoiceSuccess extends HomeState {}
final class UploadCommercialRegistrationSuccess extends HomeState {}
