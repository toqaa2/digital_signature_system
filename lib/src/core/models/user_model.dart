import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:signature_system/src/core/helper/enums/form_enum.dart';

class UserModel {
  String? userId;
  String? department;
  bool? isFirstLogin;
  String? name;
  String? role;
  SystemRoleEnum? systemRole;
  String? email;
  String? mainSignature;

  UserModel({
    required this.userId,
    required this.systemRole,
    required this.department,
    required this.isFirstLogin,
    required this.name,
    required this.role,
    required this.email,
    required this.mainSignature,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'system_role': systemRole,
        'isFirstLogin': isFirstLogin,
        'department': department,
        'name': name,
        'role': role,
        'email': email,
        'mainSignature': mainSignature,
      };

  UserModel.fromJson(Map<String, dynamic>? json) {
    userId = json!['userId'];
    systemRole = AppFunctions.getSystemRole(json['system_role'].toString());
    department = json['department'];
    isFirstLogin = json['isFirstLogin']??true;
    name = json['name'];
    role = json['role'];
    email = json['email'];
    mainSignature = json['mainSignature'];
  }
}
