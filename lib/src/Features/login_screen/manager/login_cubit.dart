import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signature_system/src/Features/layout/view/layout_screen.dart';
import 'package:signature_system/src/Features/login_screen/view/change_password_screen.dart';
import 'package:signature_system/src/core/models/user_model.dart';
import '../../../core/constants/constants.dart';
import 'package:http/http.dart' as http;

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isloading = true;

  Future<void> login({
    required BuildContext context,
  }) async {
    String uid;
    isloading = true;
    emit(Loading());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text.trim(), password: passwordController.text.trim())
        .then((value) async {
      uid = emailController.text.trim();
      await FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
        Constants.userModel = UserModel.fromJson(value.data());
        isloading = false;
        emit(NotLoading());
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Constants.userModel!.isFirstLogin ?? true
                ? ChangePasswordScreen()
                : const LayoutScreen(),
          ),
          (route) => false,
        );
      });
    }).catchError((onError) {
      Fluttertoast.showToast(msg: onError.message.toString());
    });
    emit(NotLoading());
  }

  Future changePassword(BuildContext context) async {
    await FirebaseAuth.instance.currentUser!
        .updatePassword(passwordController.text.trim())
        .then((value) async {
      print('Password updated successfully');
      await FirebaseFirestore.instance.collection('users').doc(Constants.userModel?.email).set(
        {
          'isFirstLogin': false,
          'password': passwordController.text.trim(),
        },
        SetOptions(merge: true),
      );
      Fluttertoast.showToast(msg: 'Password updated successfully');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LayoutScreen(),
          ));
      passwordController.text = '';
    }).catchError((onError) {
      print('Failed to update password: ${onError}');

      Fluttertoast.showToast(msg: 'Failed to update password');
      Fluttertoast.showToast(msg: 'Failed to update password');
    });
  }
}
