import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/Features/layout/manager/layout_cubit.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit(),
      child: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          LayoutCubit cubit = LayoutCubit.get(context);
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/BackGround.png"),
                    fit: BoxFit.fill)
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20),
                      child: SvgPicture.asset(
                        'assets/Logo.svg', height: 50,),
                    ),
                    Row(
                      children: [
                        TextButton(onPressed: () {
                          cubit.changePage(0);
                        }, child: Text("Home")),
                        TextButton(onPressed: () {
                          cubit.changePage(1);
                        }, child: Text("Requests")),
                        TextButton(onPressed: () {
                          cubit.changePage(2);
                        }, child: Text("Profile")),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(right: 20),
                        child: SvgPicture.asset(
                          'assets/logout.svg', height: 20,)),
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
