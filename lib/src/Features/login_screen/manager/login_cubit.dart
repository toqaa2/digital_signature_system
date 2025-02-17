import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signature_system/src/Features/layout/view/layout_screen.dart';
import 'package:signature_system/src/core/models/user_model.dart';

import '../../../core/constants/constants.dart';

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
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((value) {
      uid = value.user!.uid;
      FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get()
          .then((value) async {
        Constants.userModel = UserModel.fromJson(value.data());
        isloading = false;
        emit(NotLoading());
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LayoutScreen(),
          ),
          (route) => false,
        );
      });
    }).catchError((onError) {
      Fluttertoast.showToast(msg: onError.message.toString());
    });
  }
}
