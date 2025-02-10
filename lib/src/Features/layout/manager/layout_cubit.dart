import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature_system/src/Features/home_screen/view/home_screen.dart';
import '../../profile/view/profile_screen.dart';
import '../../requests/view/requests_screen.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());

  static LayoutCubit get(context) => BlocProvider.of(context);
  List<Widget> pages = [
    HomeScreen(),
    RequestsScreen(),
    ProfileScreen(),
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
