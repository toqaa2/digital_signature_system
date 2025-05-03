import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature_system/src/features/home_screen/view/home_screen.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import '../../profile/view/profile_screen.dart';
import '../../requests/presentation/view/requests_screen.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());

  static LayoutCubit get(context) => BlocProvider.of(context);

  checkUserEmailToChangeHomePage() {
    if (Constants.userModel?.email == "a.elghandakly@aur-consumerfinance.com" ||
        Constants.userModel?.email == "a.ibrahim@waseela-cf.com"|| Constants.userModel?.email ==
        "n.elzorkany@aur-consumerfinance.com") {
      changePage(1);
    }
  }

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
