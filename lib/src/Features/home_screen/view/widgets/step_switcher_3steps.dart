import 'package:flutter/material.dart';
import 'package:signature_system/src/Features/home_screen/view/widgets/Send_request_emails.dart';

import '../../manager/home_cubit.dart';
import 'first_step.dart';

class StepSwitcher3Steps extends StatelessWidget {
  final HomeCubit cubit;

  const StepSwitcher3Steps({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    // Use if statements to determine which widget to show
    if (cubit.currentStep == 0) {
      return FirstStep(cubit: cubit); // Show FirstStep for step 0
    } else if (cubit.currentStep == 1) {
      return Center(
        child: Text("Step 2"),
      ); // Replace with actual SecondStep widget
    } else if (cubit.currentStep == 2) {
      return SendRequestEmails(); // Replace with actual ThirdStep widget
    } else {
      return Center(
        child: Text('Unknown Step'),
      ); // Handle unexpected step values
    }
  }
}