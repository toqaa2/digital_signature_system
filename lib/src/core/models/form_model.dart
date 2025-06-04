import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/models/comment_model.dart';

class FormModel {
  String? formID;
  String? formLink;
  String? uploadProcurment;
  String? otherDocument;
  String? pettyCashDocument;
  String? commentPettyCash;
  String? formName;
  List<String>? requiredToSign;
  List<CommentModel>? comments;
  List<String>? sentTo;
  String? sentBy;
  List<SignatureModel>? signedBy;
  String? serviceType;
  String? pathURL;
  bool? isFullySigned;
  Timestamp? sentDate;
  Timestamp? signedDate;
  String? formTitle;
  String? paymentType;
  String? commercialRegistration;
  String? electronicInvoice;
  String? advancePayment;
  String? taxID;

  String? bankDetails;
  String? invoiceNumber;
  DocumentReference<Map<String, dynamic>>? formReference;

  FormModel({
    required this.formID,
    required this.formLink,
    required this.formName,
    required this.requiredToSign,
    this.otherDocument,
    this.uploadProcurment,
    this.sentTo,
    this.comments,
    this.commentPettyCash,
    this.pettyCashDocument,
    this.pathURL,
    this.formReference,
    this.sentBy,
    this.signedBy,
    this.serviceType,
    this.isFullySigned,
    this.sentDate,
    this.signedDate,
    this.formTitle,
    this.paymentType,
    this.commercialRegistration,
    this.electronicInvoice,
    this.advancePayment,
    this.taxID,
    this.bankDetails,
    this.invoiceNumber,
  });

  Map<String, dynamic> toMap() => {
        'form_reference': formReference,
        'comments': comments,
        'otherDocument': otherDocument ?? '',
        if (formID != null) 'formID': formID,
        if (formLink != null) 'formLink': formLink,
        if (formName != null) 'formName': formName,
        'requiredToSign': List.generate(
          requiredToSign?.length ?? 0,
          (index) => requiredToSign?[index],
        ),
        'sentTo': List.generate(
          sentTo?.length ?? 0,
          (index) => sentTo?[index],
        ),
        if (sentBy != null) 'sentBy': sentBy,
        'signedBy': List.generate(
          signedBy?.length ?? 0,
          (index) => signedBy?[index],
        ),
        'serviceType': List.generate(
          serviceType?.length ?? 0,
          (index) => serviceType?[index],
        ),
        if (isFullySigned != null) 'isFullySigned': isFullySigned,
        if (sentDate != null) 'sentDate': sentDate,
        if (pathURL != null) 'pathURL': pathURL,
        if (uploadProcurment != null) 'uploadProcurment': uploadProcurment,
        if (signedDate != null) 'signedDate': signedDate,
        if (formTitle != null) 'formTitle': formTitle,
        if (paymentType != null) 'paymentType': paymentType,
        if (commercialRegistration != null) 'commercialRegistration': commercialRegistration,
        if (electronicInvoice != null) 'electronicInvoice': electronicInvoice,
        if (advancePayment != null) 'advancePayment': advancePayment,
        if (taxID != null) 'taxID': taxID,
        if (bankDetails != null) 'bankDetails': bankDetails,
        if (invoiceNumber != null) 'invoiceNumber': invoiceNumber,

      };

  FormModel.fromJson(Map<String, dynamic>? json) {
    otherDocument = json?['otherDocument'] ?? '';
    formID = json?['formID'];
    formLink = json?['formLink'];
    commentPettyCash = json?['commentPettyCash'] ?? '';
    pettyCashDocument = json?['pettyCashDocument'] ?? '';
    formName = json?['formName'] ?? '';
    formReference = json?['form_reference'];
    requiredToSign = List.generate(
      json?['requiredToSign'] == null ? 0 : json?['requiredToSign'].length,
      (index) => json?['requiredToSign']?[index],
    );
    sentTo = List.generate(
      json?['sentTo'] == null ? 0 : json?['sentTo'].length,
      (index) => json?['sentTo']?[index],
    );
    sentBy = json?['sentBy'];
    signedBy = json?['signedBy'] == null || json?['signedBy'].isEmpty
        ? []
        : (json?['signedBy']?[0]) is String
            ? []
            : List.generate(
                json?['signedBy'] == null ? 0 : json?['signedBy'].length,
                (index) => SignatureModel.fromJson(json?['signedBy']?[index]),
              );
    serviceType = json?['serviceType'] ?? '';
    comments = List.generate(
      json?['comments'] == null ? 0 : json?['comments'].length,
      (index) => CommentModel.fromJson(json?['comments'][index]),
    );
    isFullySigned = json?['isFullySigned'];
    sentDate = json?['sentDate'];
    signedDate = json?['signedDate'];
    uploadProcurment = json?['uploadProcurment'] ?? '';
    formTitle = json?['formTitle'];
    paymentType = json?['paymentType'] ?? '';
    commercialRegistration = json?['commercialRegistration'] ?? '';
    electronicInvoice = json?['electronicInvoice'] ?? '';
    advancePayment = json?['advancePayment'] ?? '';
    taxID = json?['taxID'] ?? '';
    bankDetails = json?['bankDetails'] ?? '';
    invoiceNumber = json?['invoiceNumber'] ?? '';

  }
}

class SignatureModel {
  final String email;
  final String signatureLink;
  final String name;

  SignatureModel({
    required this.email,
    required this.name,
    required this.signatureLink,
  });

  factory SignatureModel.fromJson(Map<String, dynamic>? json) => SignatureModel(
        email: json?['email'] ?? 'No Email',
        name: json?['name'] ?? json?['email'],
        signatureLink: json?['signature_link'] ?? "",
      );

  Map<String, dynamic> toMap() => {
        'email': email,
        'signature_link': signatureLink,
        'name': name,
      };
}
