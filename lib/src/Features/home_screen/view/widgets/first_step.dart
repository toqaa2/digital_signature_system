import 'package:flutter/material.dart';
import 'package:signature_system/src/Features/home_screen/view/widgets/dropdownmenu.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:signature_system/src/core/style/colors.dart';
import 'package:signature_system/src/Features/home_screen/manager/home_cubit.dart';

import 'drop_downmenu_payment_request.dart';

class FirstStep extends StatelessWidget {
  final HomeCubit cubit;

  const FirstStep({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Send Signature Request Form',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.mainColor),
        ),
        20.isHeight,

       cubit.selectedItem!=null&& cubit.selectedItem!.contains('PaymentRequest')
            ? Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  5.isHeight,
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FormTypeSelectorPayment(
                        hintText: "Select Form",
                        titleText: "Please Choose A Form *",
                        onChanged: (String? newValue) {
                          cubit.selectForm(newValue);
                        },
                        dropdownItems: cubit.forms.map((form) => form.formID!).toList(), // Populate dropdown with form IDs
                        selectedItem: cubit.selectedItem,
                      ),
                      FormTypeSelectorPayment(
                        hintText: "Payment Type",
                        titleText:
                            "Please Choose The Type of Payment Request *",
                        onChanged: (String? newValue) {
                          cubit.selectPaymentType(newValue);
                        },
                        dropdownItems: cubit.paymentType,
                        selectedItem: cubit.selectedPaymentType,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      FormTypeSelectorPayment(
                        hintText: "Select Limit of Request",
                        titleText: "Please Choose The Limit of your Request *",
                        onChanged: (String? newValue) {
                          cubit.selectListLimit(newValue);
                        },
                        dropdownItems: cubit.limitList,
                        selectedItem: cubit.selectedListLimit,
                      ),
                      FormTypeSelectorPayment(
                        hintText: "Title of Request",
                        titleText: "Please Choose The Title of your Request *",
                        onChanged: (String? newValue) {},
                        dropdownItems: [],
                        selectedItem: cubit.selectedItem,
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  FormTypeSelector(
                    withTitle: true,
                    hintText: "Select Form",
                    titleText: "Please Choose A Form *",
                    onChanged: (String? newValue) {
                      cubit.selectForm(newValue); // Select the form
                    },
                    dropdownItems: cubit.forms.map((form) => form.formID!).toList(), // Populate dropdown with form IDs
                    selectedItem: cubit.selectedItem,
                  ),
                  5.isHeight,
                  // Dropdown Menu for Form Title
                  FormTypeSelector(
                    withTitle: true,
                    hintText: "Select Form Title",
                    titleText: "Please Choose The Title of Form *",
                    onChanged: ( newValue) {},
                    dropdownItems: [],
                    selectedItem: cubit.selectedItem,
                  ),
                ],
              )
      ],
    );
  }
}

// if (cubit.selectedItem == 'Payment Request Memo')
//   Column(
//   children: [
//     5.isHeight,
//     Row(
//       spacing: 10,
//       children: [
//         FormTypeSelectorPayment(
//           hintText: "Select Form Type",
//           titleText: "Please Choose The Type of Form *",
//           onChanged: (String? newValue) {
//             cubit.selectItem(newValue);
//           },
//           dropdownItems: cubit.dropdownItems,
//           selectedItem: cubit.selectedItem,
//
//         ),
//         FormTypeSelectorPayment(
//           hintText: "Limit of Request",
//           titleText: "Please Choose The Limit of your Request *",
//           onChanged: (String? newValue) {
//
//           },
//           dropdownItems: [],
//           selectedItem: cubit.selectedItem,
//         ),
//       ],
//     ),
//     Row(
//       spacing: 10,
//       children: [
//         FormTypeSelectorPayment(
//           hintText: "Select Form Type",
//           titleText: "Please Choose The Type of Form *",
//           onChanged: (String? newValue) {
//             cubit.selectItem(newValue);
//           },
//           dropdownItems: cubit.dropdownItems,
//           selectedItem: cubit.selectedItem,
//
//         ),
//         FormTypeSelectorPayment(
//           hintText: "Limit of Request",
//           titleText: "Please Choose The Limit of your Request *",
//           onChanged: (String? newValue) {
//
//           },
//           dropdownItems: [],
//           selectedItem: cubit.selectedItem,
//         ),
//       ],
//     ),
//
//   ],
// ),
