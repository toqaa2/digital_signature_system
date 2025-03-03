import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/enums/form_enum.dart';
import '../../../core/models/form_model.dart';

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
  FormModel? selectedFormModel;
  List<String> requiredEmails = [];



  List<FormModel> forms = [];

// Fetch forms from Firestore
  Future<void> fetchForms() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('forms').get();
      forms = snapshot.docs.map((doc) => FormModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
      emit(FormsFetched());
    } catch (error) {
      print("Error fetching forms: $error");
    }
  }

// Select a form from the dropdown
  void selectForm(String? formId) {
    selectedItem = formId; // Update the selected form ID
    if (formId != null) {
      print(formId);
      selectedFormModel = forms.firstWhere((form) => form.formID == formId);
      requiredEmails = selectedFormModel?.requiredToSign ?? [];
    } else {
      selectedFormModel = null;
      requiredEmails.clear();
    }

    emit(FormSelected());
  }

  Future<void> sendToRequiredEmails({
    required String sentBy,
    required String userID,
  }) async {
    if (selectedFormModel == null) {
      print("No form selected");
      return;
    }
    String formID = selectedFormModel!.formID!;
    List<String> selectedEmails = List.from(requiredEmails);
    DocumentReference formReference =
    FirebaseFirestore.instance.collection('users')
        .doc(userID)
        .collection("sent_forms").doc(formID);


    for (String email in selectedEmails) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('received_forms')
          .doc(formID)
          .set({
        "formRef" : formReference

      }).then((_) {

      }).catchError((error) {
      });
    }
    emit(SendForm());
  }
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

  Future<void> sendForm(
      {required String userId,
        required String formName,
        required String formID,
        required String sentBy,
        required List<String> selectedEmails,

      }) async {
    await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('sent_forms')
          .doc(formName)
          .set({
        'formID': formID,
        'formName': formName,
        'formLink': "form.formLink",
        'sentTo': selectedEmails,
        'sentBy': sentBy,
        'sentDate':DateTime.now(),
      'isFullySigned':false,
      'formTitle':"title"


      }).then((_) {
        emit(SendForm());
        print("Form sent successfully!");
      });

  }
  String? commercialRegistration;
  String? electronicInvoice;
  String? advancePayment;
  String? taxID;
  String? bankName;
  String? invoiceNumber;
  String? bankAccountNumber;
  String? serviceType;

  Future<void> sendPaymentForm(
      {required String userId,
        required String formName,
        required String formID,
        required String sentBy,
        required String commercialRegistration,
        required String paymentType,
        required String limitOfRequest,
        required String electronicInvoice,
        required String advancePayment,
        required String taxID,
        required String bankName,
        required String invoiceNumber,
        required String bankAccountNumber,
        required String serviceType,
        required List<String> selectedEmails,

      }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('sent_forms')
        .doc(formName)
        .set({
      'formID': formID,
      'formName': formName,
      'formLink': "form.formLink",
      'sentTo': selectedEmails,
      'sentBy': sentBy,
      'sentDate':DateTime.now(),
      'isFullySigned':false,
      'formTitle':"title",
      'paymentType': paymentType,
      'limitOfRequest':limitOfRequest,
      'commercialRegistration':commercialRegistration,
      'electronicInvoice':electronicInvoice,
      'advancePayment':advancePayment,
      'taxID':taxID,
      'bankName':bankName,
      'invoiceNumber':invoiceNumber,
      'bankAccountNumber':bankAccountNumber,
      'serviceType':serviceType,



    }).then((_) {
      emit(SendPaymentForm());
      print("Form sent successfully!");
    });

  }



}
