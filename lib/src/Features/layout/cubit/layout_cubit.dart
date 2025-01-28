import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:signature_system/src/Features/login_screen/login_screen.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());
  static LayoutCubit get(context) => BlocProvider.of(context);
  List<Widget> pages = [
    LoginScreen(),
    const LoginScreen(),
    const LoginScreen(),

  ];
  List<bool> isSelected = [
    true,
    false,
    false,

  ];
  int page = 0;

  void changePage(index) {
    if (index != page) {
      page = index;
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = false;
      }
      isSelected[index] = true;
      emit(ChangePage());
    }
  }
}


