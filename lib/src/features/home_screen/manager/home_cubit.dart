import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature_system/src/core/functions/app_functions.dart';

import '../../../core/constants/constants.dart';
import '../../../core/helper/enums/form_enum.dart';

import '../../../core/models/form_model.dart';
import 'package:web/web.dart' show window;
import 'package:firebase_storage/firebase_storage.dart';

import 'package:intl/intl.dart' show DateFormat;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);
  final List<String> stepNames = ['Choose From', 'Fill From', 'Send Request'];
  final List<String> stepNames4 = [
    'Choose From',
    'Fill From',
    "Upload Documents",
    'Send Request'
  ];
  final List<String> dropdownItems = [
    'Program Lunch Memo',
    'Campaign Memo',
    'Internal Committee Memo',
    'Merchant Onboarding Memo',
    'Payment Request Memo'
  ];
  final List<String> limitList = [
    'Less than 5K',
    'Above 5K',
    'Above 30K',
  ];
  final List<String> paymentType = ['Invoice', 'Petty Cash'];
  String? selectedItem;
  String? selectedTitleName;
  String? selectedPaymentType;
  String? selectedListLimit;
  int currentStep = 0;
  FormType? formType;

  FormModel? selectedFormModel;
  List<String> requiredEmails = [];
  List<FormModel> forms = [];

  TextEditingController docNameController = TextEditingController();

  void downloadFile(String url, String fileName) {
    window.open(url, fileName);
  }

  Uint8List? docFile;
  String downloadURLOFUploadedDocument = '';
  bool? isLoadingForm;

  Future<void> pickAndUploadDocument(String userID, String formName) async {
    isLoadingForm = true;
    emit(UploadFileLoading());
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      docFile = result.files.single.bytes;
      if (docFile != null) {
        final storageRef = FirebaseStorage.instance.ref();
        Reference pdfRef = storageRef.child(
            'sent_forms/$userID/$formName${DateFormat('yyy-MM-dd-hh:mm').format(DateTime.now())}.pdf');

        UploadTask uploadTask = pdfRef.putData(
            docFile!, SettableMetadata(contentType: 'application/pdf'));
        await uploadTask;

        downloadURLOFUploadedDocument = await pdfRef.getDownloadURL();
        debugPrint('Download URL: $downloadURLOFUploadedDocument');
        isLoadingForm = false;
        emit(UploadFileSuccess());
      }
    }
  }

  Future<void> fetchForms() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('forms').get();
      forms = snapshot.docs
          .map((doc) => FormModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      if (Constants.userModel!.userId == "m.ghoneim@waseela-cf.com") {
        bool formExists = forms.any((form) => form.formID == "System Update");
        if (!formExists) {
          FormModel uniqueForm = FormModel(
            formID: "System Update",
            formName: "System Update",
            formLink:
                "https://firebasestorage.googleapis.com/v0/b/e-document-70241.firebasestorage.app/o/forms%2FDigitalization.docx?alt=media&token=3986a236-4fbc-40eb-9d3a-d26e82081faa",
            requiredToSign: [
              "m.ghoneim@waseela-cf.com",
              "a.elghandakly@aur-consumerfinance.com"
            ],
          );
          forms.add(uniqueForm);
        }
      }

      emit(FormsFetched());
    } catch (error) {
      debugPrint("Error fetching forms: $error");
    }
  }

  void selectedTitle(String? newValue) {
    selectedTitleName = newValue!;
    emit(SelectTitle());
  }

  String formID = '';

  void selectForm(String? formId) {
    selectedItem = formId;
    if (formId != null) {
      selectedFormModel = forms.firstWhere((form) => form.formID == formId);
      // requiredEmails = selectedFormModel?.requiredToSign ?? [];
      formID = selectedFormModel!.formID! + DateTime.now().toString();
    } else {
      selectedFormModel = null;
      requiredEmails.clear();
    }

    emit(FormSelected());
  }

  String uploadOtherDoc = '';

  Future<void> pickAndUploadOtherDocument(
      String userID, String formName) async {
    emit(UploadOtherFileLoading());
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      docFile = result.files.single.bytes;
      if (docFile != null) {
        final storageRef = FirebaseStorage.instance.ref();
        Reference pdfRef = storageRef.child(
            'other_Document/$userID/$formName${DateFormat('yyy-MM-dd-hh:mm').format(DateTime.now())}.pdf');

        UploadTask uploadTask = pdfRef.putData(
            docFile!, SettableMetadata(contentType: 'application/pdf'));
        await uploadTask;

        uploadOtherDoc = await pdfRef.getDownloadURL();

        emit(UploadOtherFileSuccess());
      }
    }
  }

  String uploadProcurment = '';

  Future<void> pickAndUploadProcurment({required String userID, required String formName}) async {
    isLoadingProcurement = true;
    emit(UploadOtherFileLoading());
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      docFile = result.files.single.bytes;
      if (docFile != null) {
        final storageRef = FirebaseStorage.instance.ref();
        Reference pdfRef = storageRef.child(
            'Procurement/$userID/$formName${DateFormat('yyy-MM-dd-hh:mm').format(DateTime.now())}.pdf');

        UploadTask uploadTask = pdfRef.putData(
            docFile!, SettableMetadata(contentType: 'application/pdf'));
        await uploadTask;

        uploadProcurment = await pdfRef.getDownloadURL();
        isLoadingProcurement = false;
        emit(UploadOtherFileSuccess());
      }
    }
  }

  bool? isLoadingOtherDocument;
  bool? isLoadingProcurement;

  Future<String> uploadDocument({
    required String userID,
    required String formName,
  }) async {
    isLoadingOtherDocument = true;

    emit(UploadLoading());

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      String fileName = result.files.single.name;
      final String fileType = fileName.split('.').last.toLowerCase();
      docFile = result.files.single.bytes;
      if (docFile != null) {
        final storageRef = FirebaseStorage.instance.ref();
        Reference pdfRef = storageRef.child(
            '$fileName/$userID/$formName${DateFormat('yyy-MM-dd-hh:mm').format(DateTime.now())}.$fileType');
        await pdfRef.putData(
            docFile!, SettableMetadata(contentType: 'application/$fileType'));
        // await uploadTask;
        // documentType = ;
        // controller?.text = documentType ?? "";
        // print('Download URL: $documentType');
        // print('Download URL: $uploadOtherDoc');
        emit(UploadSuccess());
        isLoadingOtherDocument = false;

        return (await pdfRef.getDownloadURL());
      }
    }
    return 'No Link';
  }

  Future<void> sendToRequiredEmails({
    // required String formID,
    required String sentBy,
    required String userID,
  }) async {
    if (selectedFormModel == null) {
      return;
    }
    List<String> selectedEmails = List.from(requiredEmails);
    DocumentReference formReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection("sent_forms")
        .doc(formID);

    for (String email in selectedEmails) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('received_forms')
          .doc(formID)
          .set({"formRef": formReference})
          .then((_) {})
          .catchError((error) {});
    }
    emit(SendForm());
  }

  void selectItem(String? newValue) {
    switch (newValue) {
      case 'Program Lunch Memo':
        formType = FormType.programLunchMemo;
      case 'Campaign Memo':
        formType = FormType.campaignMemo;
      case 'Internal Committee Memo':
        formType = FormType.internalCommitteeMemo;
      case 'Merchant Onboarding Memo':
        formType = FormType.merchantOnboardingMemo;
      case 'Payment Request Memo':
        formType = FormType.paymentRequestMemo;
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

  DocumentReference<Map<String, dynamic>>? formReference;

  Future<void> sendForm({
    required BuildContext context,
    required String userId,
    required String formName,
    required String pathURL,
    required String downloadLink,
    required String sentBy,
  }) async {
    requiredEmails = requiredEmails.reversed.toList();
    await addMeToSign(email: Constants.userModel!.email!, context: context);
    requiredEmails += selectedFormModel?.requiredToSign ?? [];
    print(requiredEmails);
    String formIDWithDate = formName + DateTime.now().toString();
    formReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('sent_forms')
        .doc(formID);
    await formReference!.set({
      'form_reference': formReference,
      'formID': formID,
      'otherDocument': uploadOtherDoc,
      'formName': formName,
      'pathURL': pathURL,
      'downloadLink': downloadLink,
      'formLink': downloadURLOFUploadedDocument,
      'sentTo': requiredEmails,
      'sentBy': sentBy,
      'sentDate': DateTime.now(),
      'isFullySigned': false,
      'formTitle': selectedTitleName ?? ""
    }).then((_) async {
      await FirebaseFirestore.instance.collection('sentForms').add({
        'ref': formReference,
      });

      await AppFunctions.sendEmailTo(
          toEmail: requiredEmails[0], fromEmail: sentBy);
      emit(SendForm());
    });
    formSent = true;
  }

  List<String> userEmails = [];
  String? selectedEmail;

  Future<void> fetchUserEmails() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    userEmails = snapshot.docs.map((doc) => doc['email'] as String).toList();
    emit(FetchEmails());
  }

  Future<void> addToRequiredToSign({
    required String email,
    required BuildContext context,
  }) async {
    if (requiredEmails.contains(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This email is already exists.')),
      );
      return;
    }

    requiredEmails.insert(0, email);

    emit(AddToList());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('email $email is added successfully')),
    );
  }

  Future<void> addMeToSign({
    required String email,
    required BuildContext context,
  }) async {
    requiredEmails.insert(0, email);

    emit(AddToList());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You Should Sign It Firstly')),
    );
  }

  Future<void> removeEmail({
    required String email,
    required BuildContext context,
  }) async {
    requiredEmails.remove(email);
    emit(RemoveEmail());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Email $email removed Successfully')),
    );
  }

  TextEditingController commercialRegistrationController =
      TextEditingController();
  TextEditingController electronicInvoiceController = TextEditingController();
  TextEditingController advancePaymentController = TextEditingController();
  TextEditingController pettyCashDocument = TextEditingController();
  TextEditingController taxIDController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();
  TextEditingController commentPettyCash = TextEditingController();
  TextEditingController bankAccountNumberController = TextEditingController();
  TextEditingController serviceTypeController = TextEditingController();
  final List<String> typeOfService = ['Service', 'Product'];
  String? selectedItemTypeofService;

  DocumentReference<Map<String, dynamic>>? formPaymentReference;

  bool formSent = false;

  Future<FormModel?> getForm() async {
    DocumentReference<Map<String, dynamic>?>? ref =
        selectedItem!.contains('PaymentRequest')
            ? formPaymentReference
            : formReference;
    await ref?.get().then((onValue) {
      return FormModel.fromJson(onValue.data());
    });
    return null;
  }

  Future<void> sendPaymentForm({
    required BuildContext context,
    required String userId,
    required String formName,
    required String pathURL,
    required String downloadLink,
    required String sentBy,
    required String paymentType,
    required String taxID,
    required String formLink,
    required String bankName,
    required String invoiceNumber,
    required String bankAccountNumber,
    required String serviceType,
  }) async {
    requiredEmails = requiredEmails.reversed.toList();
    await addMeToSign(email: Constants.userModel!.email!, context: context);
    requiredEmails += selectedFormModel?.requiredToSign ?? [];
    formPaymentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('sent_forms')
        .doc(formID);
    await formPaymentReference!.set({
      'form_reference': formPaymentReference,
      'formID': formID,
      'commentPettyCash':commentPettyCash.text,
      'pettyCashDocument': pettyCashDocument.text,
      'pathURL': pathURL,
      'downloadLink': downloadLink,
      'uploadProcurment': uploadProcurment,
      'formName': formName,
      'formLink': downloadURLOFUploadedDocument,
      'sentTo': requiredEmails,
      'sentBy': sentBy,
      'sentDate': DateTime.now(),
      'isFullySigned': false,
      'formTitle': selectedTitleName,
      'paymentType': paymentType,
      'commercialRegistration': commercialRegistrationController.text,
      'electronicInvoice': electronicInvoiceController.text,
      'advancePayment': advancePaymentController.text,
      'taxID': taxID,
      'bankName': bankName,
      'invoiceNumber': invoiceNumber,
      'bankAccountNumber': bankAccountNumber,
      'serviceType': serviceType,
    }).then((_) async {
      formSent = true;
      emit(SendPaymentForm());
      await FirebaseFirestore.instance
          .collection('sentForms')
          .add({'ref': formPaymentReference});

      await AppFunctions.sendEmailTo(
          toEmail: requiredEmails[0], fromEmail: sentBy);
    });
  }
}
