import 'package:signature_system/src/core/functions/app_functions.dart';

import '../models/user_model.dart';

abstract class Constants {
  static String version ='1.0.4+1';
  static UserModel? userModel = UserModel(
    email: 'i.medhat@waseela-cf.com',
    department: 'department',
   isFirstLogin:  false,
    name:  'name',
    role: ' role ',
    userId: 'i.medhat@waseela-cf.com',
    mainSignature: 'https://firebasestorage.googleapis.com/v0/b/e-document-70241.firebasestorage.app/o/Signature%2Fi.medhat%40waseela-cf.com%2Fsignature.png?alt=media&token=42b2ca30-860a-44ae-a6b8-24965c4ac106',
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
