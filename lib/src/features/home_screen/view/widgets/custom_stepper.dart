import 'package:flutter/material.dart';
import 'package:signature_system/src/features/home_screen/manager/home_cubit.dart';

import 'horizontal_4steps.dart';
import 'horizontal_stepper.dart';

class CustomStepper extends StatelessWidget {
  final HomeCubit cubit;

  const CustomStepper({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    if ( cubit.selectedItem!=null&& cubit.selectedItem!.contains('PaymentRequest')) {
      return CustomHorizontalStepper4Steps(
          stepNames: cubit.stepNames4, currentStep: cubit.currentStep);
    } else {
      return CustomHorizontalStepper(
          stepNames: cubit.stepNames, currentStep: cubit.currentStep);
    }
  }
}