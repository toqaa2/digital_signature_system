import 'package:signature_system/src/core/models/form_model.dart';

class NewFormModel {
  bool? isRead;
  FormModel? formModel;

  NewFormModel({
    required this.isRead,
    required this.formModel,
  });

  Map<String, dynamic> toMap() => {
    'isRead': isRead,
    'formModel': formModel,
  };

  NewFormModel.fromJson(Map<String, dynamic>? json) {
    isRead = json!['isRead'];
    formModel = json['formModel'];
  }
}
