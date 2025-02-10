import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:signature_system/src/core/shared_widgets/smallbutton.dart';
import 'package:signature_system/src/core/style/colors.dart';
import '../manager/home_cubit.dart';
import 'widgets/custom_stepper.dart';
import 'widgets/step_switcher_3steps.dart';
import 'widgets/step_switcher_4steps.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.9,
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomStepper(
                        cubit: cubit,
                      ),
                      const SizedBox(height: 20),
                      // Center widget
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.mainColor),
                        ),
                        child: Column(
                          children: [
                            cubit.selectedItem == 'Payment Request Memo'
                                ? StepSwitcher4Steps(cubit: cubit)
                                : StepSwitcher3Steps(cubit: cubit),
                            15.isHeight,
                            // Buttons
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButtonWithIcon(
                                    onPressed: cubit.currentStep > 0
                                        ? () {
                                            cubit.changeStepPrev();
                                          }
                                        : () {},
                                    backgroundColor: cubit.currentStep > 0
                                        ? Colors.white
                                        : Colors.grey.shade300,
                                    label: 'Previous',
                                    border: cubit.currentStep > 0,
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
                                      } else if (cubit.selectedItem ==
                                              'Payment Request Memo' &&
                                          cubit.currentStep < 3) {
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
