import 'package:flutter/material.dart';
import 'package:signature_system/src/Features/home_screen/manager/home_cubit.dart';

import 'horizontal_4steps.dart';
import 'horizontal_steper.dart';

class CustomStepper extends StatelessWidget {
  final HomeCubit cubit;

  const CustomStepper({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    if (cubit.selectedItem == 'Payment Request Memo') {
      return custom_horizontal_stepper_4Steps(
          stepNames: cubit.stepNames4, currentStep: cubit.currentStep);
    } else {
      return custom_horizontal_stepper(
          stepNames: cubit.stepNames, currentStep: cubit.currentStep);
    }
  }
}