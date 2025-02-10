import 'package:flutter/material.dart';
import 'package:signature_system/src/Features/home_screen/view/widgets/dropdownmenu.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:signature_system/src/core/style/colors.dart';
import 'package:signature_system/src/Features/home_screen/manager/home_cubit.dart'; // Import your cubit

class FirstStep extends StatelessWidget {
  final HomeCubit cubit;

  const FirstStep({super.key, required this.cubit}); // Constructor

  @override
  Widget build(BuildContext context) {
    String? selectedValue;
    return Column(
      children: [
        Text(
          'Send Signature Request Form',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.mainColor),
        ),
        20.isHeight,
        // Dropdown Menu for Form Type
        FormTypeSelector(
          hintText: "Select Form Type",
          titleText: "Please Choose The Type of Form *",
          onChanged: (String? newValue) {
            cubit.selectItem(newValue);
          },
          dropdownItems: cubit.dropdownItems,
          selectedItem: cubit.selectedItem,
        ),
        5.isHeight,
        // Dropdown Menu for Form Title
        FormTypeSelector(
          hintText: "Select Form Title",
          titleText: "Please Choose The Title of Form *",
          onChanged: (String? newValue) {

          },
          dropdownItems: [],
          selectedItem: cubit.selectedItem,
        ),
        if (cubit.selectedItem == 'Payment Request Memo')
          Column(
          children: [
            5.isHeight,
            FormTypeSelector(
              hintText: "Limit of Request",
              titleText: "Please Choose The Limit of your Request *",
              onChanged: (String? newValue) {

              },
              dropdownItems: [],
              selectedItem: cubit.selectedItem,
            ),
            5.isHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Please Choose The Type of Payment Request *",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // First Radio Button
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Invoice',
                            groupValue: selectedValue,
                            onChanged: (value) {
                              // setState(() {
                              //   _selectedValue = value;
                              // });
                            },
                            activeColor: Colors.blue, // Color when selected
                          ),
                          Text(
                            'Invoice',
                            style: TextStyle(
                              color: selectedValue == 'Invoice' ? Colors.blue : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20), // Space between the radio buttons
                      // Second Radio Button
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Petty Cash',
                            groupValue: selectedValue,
                            onChanged: (value) {
                              // setState(() {
                              //   _selectedValue = value;
                              // });
                            },
                            activeColor: Colors.blue, // Color when selected
                          ),
                          Text(
                            'Petty Cash',
                            style: TextStyle(
                              color: selectedValue == 'Petty Cash' ? Colors.blue : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
