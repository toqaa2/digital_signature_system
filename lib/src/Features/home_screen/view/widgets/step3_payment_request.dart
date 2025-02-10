import 'package:flutter/material.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import '../../../login_screen/view/widgets/custom_text_field.dart';
import 'dashed_textfield.dart';

class Step3PaymentRequest extends StatelessWidget {
  const Step3PaymentRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 15),
      child: Column(
        children: [
          // First Row
          Row(
            children: [
              Expanded(
                child: DashedTextField(
                  hintText: "Upload Commercial Registration",
                  controller: TextEditingController(),
                  leadingIcon: Icons.upload_rounded,
                ),
              ),
              5.isWidth,
              Expanded(
                child: DashedTextField(
                  hintText: "Upload Advance payment Certificate",
                  controller: TextEditingController(),
                  leadingIcon: Icons.upload_rounded,
                ),
              ),
            ],
          ),
          10.isHeight,

          Row(
            children: [
              Expanded(
                child: DashedTextField(
                  hintText: "Upload Electronic Invoice",
                  controller: TextEditingController(),
                  leadingIcon: Icons.upload_rounded,
                ),
              ),
              5.isWidth,
              Expanded(
                child: DashedTextField(
                  hintText: "Upload Tax ID",
                  controller: TextEditingController(),
                  leadingIcon: Icons.upload_rounded,
                ),
              ),
            ],
          ),

          5.isHeight,
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 0, horizontal: 12),
                  width: 420,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton<String>(
                    underline: SizedBox(),
                    value: "selectedItem",
                    hint: Text("Choose Service type"),
                    style: const TextStyle(fontSize: 11),
                    isExpanded: true,
                    items: [],
                    onChanged: (onChanged) {},
                  ),
                ),
              ),
              5.isWidth,
              Expanded(
                  child: Textfield(
                labelText: "Enter Bank Name",
              )),
            ],
          ),
          5.isHeight,

          Row(
            children: [
              Expanded(
                  child: Textfield(
                labelText: "Enter Bank Account Number",
              )),
              5.isWidth,
              Expanded(
                  child: Textfield(
                labelText: "Enter Invoice Number",
              )),
            ],
          ),
        ],
      ),
    );
  }
}
