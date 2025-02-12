import 'package:flutter/material.dart';

import '../../manager/home_cubit.dart';
import '../step2_screen.dart';
import '../success_message.dart';
import 'Send_request_emails.dart';
import 'first_step.dart';
import 'step3_payment_request.dart';

class StepSwitcher4Steps extends StatelessWidget {
  final HomeCubit cubit;

  const StepSwitcher4Steps({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    if (cubit.currentStep == 0) {
      return FirstStep(cubit: cubit); // Show FirstStep for step 0
    } else if (cubit.currentStep == 1) {
      return Step2Screen(); // Replace with actual SecondStep widget
    } else if (cubit.currentStep == 2) {
      return Step3PaymentRequest(); // Replace with actual ThirdStep widget
    } else if (cubit.currentStep == 3) {
      return SendRequestEmails();
    }else if (cubit.currentStep == 4) {
      return SuccessMessage();
    }
    else {
      return Center(
        child: Text('Unknown Step'),
      ); // Handle unexpected step values
    }
  }
}