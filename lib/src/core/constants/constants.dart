import 'package:signature_system/src/core/functions/app_functions.dart';

import '../models/user_model.dart';

abstract class Constants {
  static UserModel? userModel = UserModel(
    email: 'i.medhat@waseela-cf.com',
    department: 'department',
   isFirstLogin:  false,
    name:  'name',
    role: ' role ',
    userId: 'i.medhat@waseela-cf.com',
    mainSignature: ' mainSignature',
    systemRole: AppFunctions.getSystemRole('view_download_all'),
  );
  static final List<String> titleName = [
    'Other'
    'Problematic Asset Committee',
    'Procurement Committee',
    'Product / Pricing Committee',
    'Administrative Stuff',
    'Board Authentication Fees',
    'Board Expenses',
    'HR Activity',
    'MD Car Maintenance',
    'Hospitality Fees',
    'Call Center Invoice',
    'Marketing Expenses',
    'iScore Invoice',
    'Information Technology Expenses',

  ];
}
