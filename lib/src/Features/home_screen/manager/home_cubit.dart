import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/enums/form_enum.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);
  final List<String> stepNames = ['Choose From','Fill From', 'Send Request'];
  final List<String> stepNames4 = ['Choose From','Fill From',"Upload Documents", 'Send Request'];
  final List<String> dropdownItems = ['Program Lunch Memo', 'Campaign Memo', 'Internal Committee Memo','Merchant Onboarding Memo','Payment Request Memo'];
  final List<String> limitList = ['Less than 5K', 'Above 5K', 'Above 30K',];
  final List<String> paymentType = ['Invoice', 'Petty Cash'];
  String? selectedItem;
  String? selectedPaymentType;
  String? selectedListLimit;
  int currentStep = 0;
  FormType? formType ;


  void selectItem(String? newValue) {
    switch (newValue){
      case  'Program Lunch Memo' :formType= FormType.programLunchMemo;
      case  'Campaign Memo' :formType= FormType.campaignMemo;
      case  'Internal Committee Memo' :formType= FormType.internalCommitteeMemo;
      case  'Merchant Onboarding Memo' :formType= FormType.merchantOnboardingMemo;
      case  'Payment Request Memo' :formType= FormType.paymentRequestMemo;
    }
    selectedItem = newValue!;
    emit(ChangeValue());
  }
  void selectPaymentType(String? newValue) {
    selectedPaymentType = newValue!;
    emit(ChangeValue());
  }
  void selectListLimit(String? newValue) {
    selectedListLimit = newValue!;
    emit(ChangeValue());
  }
  void changeStepPrev() {
    currentStep--;
    emit(ChangeStepPrev());
  }
  void changeStepNext() {

    currentStep++;
    emit(ChangeStepNext());
  }
}
