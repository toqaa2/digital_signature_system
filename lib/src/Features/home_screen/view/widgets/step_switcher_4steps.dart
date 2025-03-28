import 'package:flutter/material.dart';

import '../../../../core/style/colors.dart';
import '../../manager/home_cubit.dart';
import '../step2_screen.dart';
import '../success_message.dart';
import 'send_request_emails.dart';
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
      return Step2Screen(cubit: cubit,); // Replace with actual SecondStep widget
    } else if (cubit.currentStep == 2) {
      return Step3PaymentRequest(cubit: cubit,); // Replace with actual ThirdStep widget
    } else if (cubit.currentStep == 3) {
      return SendRequestEmails(cubit: cubit,);
    }else if (cubit.currentStep == 4&&cubit.formSent) {
      return SuccessMessage();
    }
    else {
      return Center(
        child:CircularProgressIndicator(
          color: AppColors.mainColor,
        ),
      ); // Handle unexpected step values
    }
  }
}