import 'package:flutter/material.dart';
import 'package:signature_system/src/Features/home_screen/view/widgets/send_request_emails.dart';

import '../../manager/home_cubit.dart';
import '../step2_screen.dart';
import '../success_message.dart';
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
      return Step2Screen();
    } else if (cubit.currentStep == 2) {
      return SendRequestEmails(cubit: cubit,); // Replace with actual ThirdStep widget
    }else if (cubit.currentStep == 3) {
      return SuccessMessage();
    }
    else {
      return Center(
        child: Text('Unknown Step'),
      ); // Handle unexpected step values
    }
  }
}