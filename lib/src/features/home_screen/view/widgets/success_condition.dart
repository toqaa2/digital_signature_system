import 'package:flutter/material.dart';
import 'package:signature_system/src/features/home_screen/manager/home_cubit.dart';
import 'package:signature_system/src/features/home_screen/view/widgets/step_switcher_4steps.dart';
import 'package:signature_system/src/core/constants/constants.dart';

import '../../../../core/shared_widgets/small_button.dart';
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
    bool isUploaded = cubit.downloadURLOFUploadedDocument != '';
    bool showSingleSelector = (cubit.selectedItem != null &&
            cubit.selectedItem!.contains('PaymentRequest') &&
            cubit.currentStep == 4 &&
            cubit.formSent) ||
        (cubit.selectedItem != null &&
            !cubit.selectedItem!.contains('PaymentRequest') &&
            cubit.currentStep == 3 &&
            cubit.formSent);

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
                if (cubit.selectedItem == null ||
                    cubit.selectedItem!.contains('PaymentRequest') &&
                        cubit.currentStep != 4 ||
                    !cubit.selectedItem!.contains('PaymentRequest') &&
                        cubit.currentStep != 3)
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
                        const SizedBox(width: 4),
                        ElevatedButtonWithIcon(
                          border: false,
                          backgroundColor: cubit.selectedTitleName == null ||
                                  cubit.currentStep == 1 &&
                                      isUploaded == false ||
                                  cubit.currentStep == 0 &&
                                      cubit.selectedItem == null
                              ? Colors.grey
                              : AppColors.mainColor,
                          onPressed: cubit.selectedTitleName == null ||
                                  cubit.currentStep == 1 &&
                                      isUploaded == false ||
                                  cubit.currentStep == 0 &&
                                      cubit.selectedItem == null
                              ? () {}
                              : () {


                                  if (cubit.currentStep == 2 &&
                                      !cubit.selectedItem!
                                          .contains('PaymentRequest')) {
                                    cubit
                                        .sendForm(
                                      context: context,
                                            userId:
                                                Constants.userModel!.userId!,
                                            downloadLink: "",
                                            // formLink:  cubit.selectedFormModel!.formLink!,
                                            pathURL: "",
                                            formName: cubit
                                                .selectedFormModel!.formName!,
                                            sentBy: Constants.userModel!.email!,
                                            )
                                        .then(
                                          (value) => cubit.sendToRequiredEmails(
                                            sentBy: Constants.userModel!.email!,
                                            userID: Constants.userModel!.email!,
                                          ),
                                        );
                                  }
                                  if (cubit.selectedItem != null &&
                                      cubit.selectedItem!
                                          .contains('PaymentRequest') &&
                                      cubit.currentStep == 3) {
                                    cubit
                                        .sendPaymentForm(
                                      context: context,
                                            formLink: cubit
                                                .selectedFormModel!.formLink!,
                                            taxID: cubit.taxIDController.text,

                                            bankDetails:
                                                cubit.bankDetails.text,
                                            downloadLink: "",
                                            pathURL: "",
                                            invoiceNumber: cubit
                                                .invoiceNumberController.text,
                                            paymentType:
                                                cubit.selectedPaymentType!,
                                            serviceType: cubit
                                                    .selectedItemTypeofService ??
                                                "",
                                            userId:
                                                Constants.userModel!.userId!,
                                            formName: cubit
                                                .selectedFormModel!.formName!,
                                            sentBy: Constants.userModel!.email!,
                                             )
                                        .then(
                                          (value) => cubit.sendToRequiredEmails(
                                            sentBy: Constants.userModel!.email!,
                                            userID: Constants.userModel!.email!,
                                          ),
                                        );
                                  }

                                  if (cubit.currentStep < 3 ||
                                      (cubit.selectedItem != null &&
                                          cubit.selectedItem!
                                              .contains('PaymentRequest') &&
                                          cubit.currentStep < 4)) {
                                    cubit.changeStepNext();
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
