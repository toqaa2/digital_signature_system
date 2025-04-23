import 'package:cloud_firestore/cloud_firestore.dart';

class FormModel {
  String? formID;
  String? formLink;
  String? formName;
  List<String>? requiredToSign;
  List<String>? sentTo;
  String? sentBy;
  List<String>? signedBy;
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
  String? bankName;
  String? invoiceNumber;
  String? bankAccountNumber;
  DocumentReference<Map<String,dynamic>>? formReference;

  FormModel({
    required this.formID,
    required this.formLink,
    required this.formName,
    required this.requiredToSign,
    this.sentTo,
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
    this.bankName,
    this.invoiceNumber,
    this.bankAccountNumber,
  });

  Map<String, dynamic> toMap() => {
    'form_reference':formReference,
    if(formID!=null)'formID': formID,
    if(formLink!=null)'formLink': formLink,
    if(formName!=null)'formName': formName,
     'requiredToSign': List.generate(requiredToSign?.length??0,  (index) => requiredToSign?[index],),
     'sentTo': List.generate(sentTo?.length??0,  (index) => sentTo?[index],),
    if(sentBy!=null)'sentBy': sentBy,
     'signedBy': List.generate(signedBy?.length??0,  (index) => signedBy?[index],),
     'serviceType':  List.generate(serviceType?.length??0,  (index) => serviceType?[index],),
    if(isFullySigned!=null)'isFullySigned': isFullySigned,
    if(sentDate!=null)'sentDate': sentDate,
    if(pathURL!=null)'pathURL': pathURL,
     if(signedDate!=null)'signedDate': signedDate,
    if(formTitle!=null)'formTitle': formTitle,
    if(paymentType!=null)'paymentType': paymentType,
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
    formReference = json?['form_reference'];
    requiredToSign = List.generate(json?['requiredToSign']==null?0:json?['requiredToSign'].length,  (index) => json?['requiredToSign']?[index],);
    sentTo =List.generate(json?['sentTo']==null?0:json?['sentTo'].length,  (index) => json?['sentTo']?[index],) ;
    sentBy = json?['sentBy'];
    signedBy =List.generate(json?['signedBy']==null?0:json?['signedBy'].length,  (index) => json?['signedBy']?[index],)  ;
    serviceType = json?['serviceType']  ;
    isFullySigned = json?['isFullySigned'];
    sentDate = json?['sentDate'];
    signedDate = json?['signedDate'];
    formTitle = json?['formTitle'];
    paymentType = json?['paymentType'];
    commercialRegistration = json?['commercialRegistration'];
    electronicInvoice = json?['electronicInvoice'];
    advancePayment = json?['advancePayment'];
    taxID = json?['taxID'];
    bankName = json?['bankName'];
    invoiceNumber = json?['invoiceNumber'];
    bankAccountNumber = json?['bankAccountNumber'];
  }
}