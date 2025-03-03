import 'package:cloud_firestore/cloud_firestore.dart';

class FormModel {
  String? formID;
  String? formLink;
  String? formName;
  List<String>? requiredToSign;
  List<String>? sentTo;
  String? sentBy;
  List<String>? signedBy;
  List<String>? serviceType;
  bool? isFullySigned;
  Timestamp? sentDate;
  Timestamp? signedDate;
  String? formTitle;
  String? paymentType;
  String? limitOfRequest;
  String? commercialRegistration;
  String? electronicInvoice;
  String? advancePayment;
  String? taxID;
  String? bankName;
  String? invoiceNumber;
  String? bankAccountNumber;

  FormModel({
    required this.formID,
    required this.formLink,
    required this.formName,
    required this.requiredToSign,
    this.sentTo,
    this.sentBy,
    this.signedBy,
    this.serviceType,
    this.isFullySigned,
    this.sentDate,
    this.signedDate,
    this.formTitle,
    this.paymentType,
    this.limitOfRequest,
    this.commercialRegistration,
    this.electronicInvoice,
    this.advancePayment,
    this.taxID,
    this.bankName,
    this.invoiceNumber,
    this.bankAccountNumber,
  });

  Map<String, dynamic> toMap() => {
    if(formID!=null)'formID': formID,
    if(formLink!=null)'formLink': formLink,
    if(formName!=null)'formName': formName,
    if(requiredToSign!=null)'requiredToSign': List.generate(requiredToSign?.length??0,  (index) => requiredToSign?[index],),
    if(sentTo!=null)'sentTo': List.generate(sentTo?.length??0,  (index) => sentTo?[index],),
    if(sentBy!=null)'sentBy': sentBy,
    if(signedBy!=null)'signedBy': List.generate(signedBy?.length??0,  (index) => signedBy?[index],),
    if(serviceType!=null)'serviceType':  List.generate(serviceType?.length??0,  (index) => serviceType?[index],),
    if(isFullySigned!=null)'isFullySigned': isFullySigned,
    if(sentDate!=null)'sentDate': sentDate,
    if(signedDate!=null)'signedDate': signedDate,
    if(formTitle!=null)'formTitle': formTitle,
    if(paymentType!=null)'paymentType': paymentType,
    if(limitOfRequest!=null)'limitOfRequest': limitOfRequest,
    if(commercialRegistration!=null)'commercialRegistration': commercialRegistration,
    if(electronicInvoice!=null)'electronicInvoice': electronicInvoice,
    if(advancePayment!=null)'advancePayment': advancePayment,
    if(taxID!=null)'taxID': taxID,
    if(bankName!=null)'bankName': bankName,
    if(invoiceNumber!=null)'invoiceNumber': invoiceNumber,
    if(bankAccountNumber!=null)'bankAccountNumber': bankAccountNumber,
  };

  FormModel.fromJson(Map<String, dynamic>? json) {
    print('req');
    print(json?['requiredToSign']);
    formID = json?['formID'];
    formLink = json?['formLink'];
    formName = json?['formName'];
   if(json?['requiredToSign']!=null) requiredToSign = List.generate(json?['requiredToSign'].length??0,  (index) => json?['requiredToSign']?[index],);
    if(json?['sentTo']!=null) sentTo =List.generate(json?['sentTo'].length??0,  (index) => json?['sentTo']?[index],) ;
    sentBy = json?['sentBy'];
    if(json?['signedBy']!=null)    signedBy =List.generate(json?['signedBy'].length??0,  (index) => json?['signedBy']?[index],)  ;
    if(json?['serviceType']!=null)    serviceType = List.generate(json?['serviceType'].length??0,  (index) => json?['serviceType']?[index],)  ;
    isFullySigned = json?['isFullySigned'];
    sentDate = json?['sentDate'];
    signedDate = json?['signedDate'];
    formTitle = json?['formTitle'];
    paymentType = json?['paymentType'];
    limitOfRequest = json?['limitOfRequest'];
    commercialRegistration = json?['commercialRegistration'];
    electronicInvoice = json?['electronicInvoice'];
    advancePayment = json?['advancePayment'];
    taxID = json?['taxID'];
    bankName = json?['bankName'];
    invoiceNumber = json?['invoiceNumber'];
    bankAccountNumber = json?['bankAccountNumber'];
  }
}