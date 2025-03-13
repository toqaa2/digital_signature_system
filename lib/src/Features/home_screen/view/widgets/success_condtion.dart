import 'package:flutter/material.dart';
import 'package:signature_system/src/Features/home_screen/manager/home_cubit.dart';
import 'package:signature_system/src/Features/home_screen/view/widgets/step_switcher_4steps.dart';
import 'package:signature_system/src/core/constants/constants.dart';

import '../../../../core/shared_widgets/smallbutton.dart';
import '../../../../core/style/colors.dart';
import '../success_message.dart';
import 'custom_stepper.dart';
import 'step_switcher_3steps.dart';

class ConditionalStepWidget extends StatelessWidget {
  final HomeCubit cubit;

  const ConditionalStepWidget({
    super.key,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    bool showSingleSelector = (cubit.selectedItem != null &&
        cubit.selectedItem!.contains('PaymentRequest') &&
        cubit.currentStep == 4) ||
        (cubit.selectedItem != null &&
            !cubit.selectedItem!.contains('PaymentRequest') &&
            cubit.currentStep == 3);

    if (showSingleSelector) {
      return SuccessMessage();
    } else {
      return Column(
        children: [
          CustomStepper(cubit: cubit),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(150),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                cubit.selectedItem != null &&
                    cubit.selectedItem!.contains('PaymentRequest')
                    ? StepSwitcher4Steps(cubit: cubit)
                    : StepSwitcher3Steps(cubit: cubit),
                const SizedBox(height: 15), // Adjusted for height
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        icon: const Icon(Icons.keyboard_arrow_left_rounded),
                        iconPosition: IconPosition.leading,
                      ),
                      const SizedBox(width: 4), // Adjusted for width
                      ElevatedButtonWithIcon(
                        border: false,
                        backgroundColor: AppColors.mainColor,
                        onPressed: () {
                          if (cubit.currentStep < 3 ||
                              (cubit.selectedItem != null && cubit.selectedItem!
                                  .contains('PaymentRequest') && cubit
                                  .currentStep < 4)) {
                            cubit.changeStepNext();
                          }

                          if (cubit.currentStep == 2 && !cubit.selectedItem!
                              .contains('PaymentRequest') ) {

                            cubit.sendForm(userId: Constants.userModel!.userId!,

                                downloadLink: "بجرب",
                                // formLink:  cubit.selectedFormModel!.formLink!,
                                pathURL: "بجرب",
                                formName:  cubit.selectedFormModel!.formName!,
                                sentBy: Constants.userModel!.email!,
                                selectedEmails:  cubit.selectedFormModel!.requiredToSign!).then((value)
                            =>cubit.sendToRequiredEmails(sentBy:Constants.userModel!.email!,userID: Constants.userModel!.email!, ) ,);

                          }
                          if(cubit.selectedItem != null && cubit.selectedItem!
                              .contains('PaymentRequest') && cubit
                              .currentStep == 4){
                            cubit.sendPaymentForm(
                              formLink: cubit.selectedFormModel!.formLink!,
                              taxID: cubit.taxIDController.text??"",
                                advancePayment: cubit.advancePaymentController.text??"",
                                bankAccountNumber: cubit.bankAccountNumberController.text??"",
                                bankName: cubit.bankNameController.text??"",
                                downloadLink: "",
                                pathURL: "",
                                commercialRegistration: cubit.commercialRegistrationController.text??"",
                                electronicInvoice: cubit.electronicInvoiceController.text??"",
                                invoiceNumber: cubit.invoiceNumberController.text??"",
                                limitOfRequest: cubit.selectedListLimit!,
                                paymentType: cubit.selectedPaymentType!,
                                serviceType: cubit.serviceTypeController.text??"",
                                userId: Constants.userModel!.userId!,
                                formName:  cubit.selectedFormModel!.formName!,
                                sentBy: Constants.userModel!.email!,
                                selectedEmails:  cubit.selectedFormModel!.requiredToSign!).then((value)
                            =>cubit.sendToRequiredEmails(sentBy:Constants.userModel!.email!,userID: Constants.userModel!.email!, ) ,);
                          }
                        },
                        label: 'Next',
                        textColor: Colors.white,
                        icon: const Icon(
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
      );
    }
  }
}

// Usage example in your main widget or screen
/*
ConditionalStepWidget(
  cubit: cubit,
);
*/