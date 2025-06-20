import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signature_system/src/features/layout/view/layout_screen.dart';
import 'package:signature_system/src/features/login_screen/view/change_password_screen.dart';
import 'package:signature_system/src/core/models/user_model.dart';
import '../../../core/constants/constants.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = true;

  Future<void> login({
    required BuildContext context,
  }) async {
    String uid;
    isLoading = true;
    emit(Loading());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim())

        .then((value) async {
      uid = emailController.text.trim();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get()
          .then((value) {
        updatePassword();

        Constants.userModel = UserModel.fromJson(value.data());
        isLoading = false;
        emit(NotLoading());
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Constants.userModel!.isFirstLogin ?? true
                  ? ChangePasswordScreen()
                  : const LayoutScreen(),
            ),
                (route) => false,

          );
        }
      });
    }).catchError((onError) {
      Fluttertoast.showToast(msg: onError.message.toString());
    });
    emit(NotLoading());
  }

  bool isPasswordVisible = true;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(ChangeVisibility());
  }

  Future changePassword(BuildContext context) async {
    emit(ChangePasswordLoading());
    try {
      if (passwordController.text.trim().isEmpty) {
        Fluttertoast.showToast(msg: 'Please enter your new password');
        emit(NotLoading());
        return;
      }
      await FirebaseAuth.instance.currentUser!
          .updatePassword(passwordController.text.trim())
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(Constants.userModel?.email)
            .set(
          {
            'isFirstLogin': false,
            'password': passwordController.text.trim(),
          },
          SetOptions(merge: true),
        );
        Fluttertoast.showToast(msg: 'Password updated successfully');
        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LayoutScreen(),
              ));
        }
        passwordController.text = '';
      }).catchError((onError) {
        emit(Error(onError.toString()));
        Fluttertoast.showToast(msg: 'Failed to update password');
      });
    } catch (e) {
      emit(Error(e.toString()));
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> resetPassword(String email) async {

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  void onResetPasswordPressed(String email) {
    if (emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Write your email First');
    } else {
      resetPassword(email);
    }
  }

  Future<void> updatePassword() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(emailController.text)
        .update({"password": passwordController.text});
  }
}
