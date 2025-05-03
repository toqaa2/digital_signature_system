import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/features/layout/manager/layout_cubit.dart';
import 'package:signature_system/src/features/login_screen/view/login_screen.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/style/colors.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit()..checkUserEmailToChangeHomePage(),
      child: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          LayoutCubit cubit = LayoutCubit.get(context);
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    fit: BoxFit.fill)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LayoutScreen(),
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: SvgPicture.asset(
                          'assets/Logo.svg',
                          height: 50,
                        ),
                      ),
                    ),
                  Row(
                            children:(Constants.userModel?.email ==
                                "a.elghandakly@aur-consumerfinance.com" ||
                                Constants.userModel?.email ==
                                    "a.ibrahim@waseela-cf.com"||  Constants.userModel?.email ==
                                "n.elzorkany@aur-consumerfinance.com")
                                ? [
                              TextButton(
                                  onPressed: () {
                                    cubit.changePage(1);
                                  },
                                  child: Text(
                                    "Requests",
                                    style: TextStyle(
                                      fontWeight: cubit.isSelected[1]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: cubit.isSelected[1]
                                          ? AppColors.mainColor
                                          : Colors.grey.shade700,
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    cubit.changePage(0);
                                  },
                                  child: Text(
                                    "Send Form",
                                    style: TextStyle(
                                      fontWeight: cubit.isSelected[0]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: cubit.isSelected[0]
                                          ? AppColors.mainColor
                                          :Colors.grey.shade700,
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    cubit.changePage(2);
                                  },
                                  child: Text(
                                    "Profile",
                                    style: TextStyle(
                                      fontWeight: cubit.isSelected[2]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: cubit.isSelected[2]
                                          ? AppColors.mainColor
                                          : Colors.grey.shade700,
                                    ),
                                  )),
                            ]: [
                              TextButton(
                                  onPressed: () {
                                    cubit.changePage(0);
                                  },
                                  child: Text(
                                    "Home",
                                    style: TextStyle(
                                      fontWeight: cubit.isSelected[0]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: cubit.isSelected[0]
                                          ? AppColors.mainColor
                                          : Colors.blueGrey,
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    cubit.changePage(1);
                                  },
                                  child: Text(
                                    "Requests",
                                    style: TextStyle(
                                      fontWeight: cubit.isSelected[1]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: cubit.isSelected[1]
                                          ? AppColors.mainColor
                                          : Colors.blueGrey,
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    cubit.changePage(2);
                                  },
                                  child: Text(
                                    "Profile",
                                    style: TextStyle(
                                      fontWeight: cubit.isSelected[2]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: cubit.isSelected[2]
                                          ? AppColors.mainColor
                                          : Colors.blueGrey,
                                    ),
                                  )),
                            ],
                          ),

                    // Row(
                    //   children: [
                    //     TextButton(
                    //         onPressed: () {
                    //           cubit.changePage(0);
                    //         },
                    //         child: Text("Home",style: TextStyle(fontWeight: cubit.isSelected[0] ?FontWeight.bold: FontWeight.normal ,color: cubit.isSelected[0] ? AppColors.mainColor : Colors.blueGrey,))),
                    //     TextButton(
                    //         onPressed: () {
                    //           cubit.changePage(1);
                    //         },
                    //         child: Text("Requests",style: TextStyle(fontWeight: cubit.isSelected[1] ?FontWeight.bold: FontWeight.normal ,color: cubit.isSelected[1] ? AppColors.mainColor : Colors.blueGrey,))),
                    //     TextButton(
                    //         onPressed: () {
                    //           cubit.changePage(2);
                    //         },
                    //         child: Text("Profile",style: TextStyle(fontWeight: cubit.isSelected[2] ?FontWeight.bold: FontWeight.normal ,color: cubit.isSelected[2] ? AppColors.mainColor : Colors.blueGrey,))),
                    //   ],
                    // ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                      },
                      child: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: SvgPicture.asset(
                            'assets/logout.svg',
                            height: 20,
                          )),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(child: cubit.pages[cubit.page]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
