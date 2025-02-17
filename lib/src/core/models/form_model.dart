abstract class FormModel {
  String id;
  String formName;
  String link;
  List<String> sentTo;
  List<String> signedBy;
  bool isFullySigned;
  FormModel({});
  Map<String,dynamic> toJson();
}
