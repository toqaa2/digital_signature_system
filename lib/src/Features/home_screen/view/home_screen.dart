import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature_system/src/Features/home_screen/view/widgets/dropdownmenu.dart';
import 'package:signature_system/src/Features/home_screen/view/widgets/horizontal_steper.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:signature_system/src/core/shared_widgets/smallbutton.dart';
import 'package:signature_system/src/core/style/colors.dart';

import '../manager/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.height * 1.5,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //stepper
                      custom_horizontal_stepper(
                          stepNames: cubit.stepNames,
                          currentStep: cubit.currentStep),
                      const SizedBox(height: 20),
                      //center widget
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.height * 1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.mainColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //title text
                            Text(
                              'Send Signature Request Form',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mainColor),
                            ),
                            20.isHeight,
                            // Dropdown Menu
                            FormTypeSelector(
                              onChanged: (String? newValue) {
                                cubit.selectItem(newValue);
                              },
                              dropdownItems: cubit.dropdownItems,
                              selectedItem: cubit.selectedItem,
                            ),
                            15.isHeight,
                            //buttons
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 120.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButtonWithIcon(
                                    onPressed: cubit.currentStep > 0
                                        ? () {
                                            cubit.changeStepPrev();
                                          }
                                        : () {},
                                    // No-op function when there's no previous step
                                    backgroundColor: cubit.currentStep > 0
                                        ? Colors.white
                                        : Colors.grey.shade300,
                                    // Change color based on state
                                    label: 'Previous',
                                    border:
                                        cubit.currentStep > 0 ? true : false,
                                    icon: const Icon(
                                        Icons.keyboard_arrow_left_rounded),
                                    iconPosition: IconPosition.leading,
                                  ),
                                  2.isWidth,
                                  ElevatedButtonWithIcon(
                                    border: false,
                                    backgroundColor: AppColors.mainColor,
                                    onPressed: () {
                                      if (cubit.currentStep < 2) {
                                        cubit.changeStepNext();
                                      }
                                    },
                                    label: 'Next',
                                    textColor: Colors.white,
                                    icon: Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      color: Colors.white,
                                    ),
                                    iconPosition: IconPosition.trailing,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
