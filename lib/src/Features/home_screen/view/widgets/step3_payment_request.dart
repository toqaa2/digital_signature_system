import 'package:flutter/material.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import '../../../login_screen/view/widgets/custom_text_field.dart';
import '../../manager/home_cubit.dart';
import 'dashed_textfield.dart';

class Step3PaymentRequest extends StatefulWidget {
  const Step3PaymentRequest({super.key, required this.cubit});
  final HomeCubit cubit;

  @override
  State<Step3PaymentRequest> createState() => _Step3PaymentRequestState();
}

class _Step3PaymentRequestState extends State<Step3PaymentRequest> {


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
                  controller: widget.cubit.commercialRegistrationController,
                  leadingIcon: Icons.upload_rounded,
                ),
              ),
              5.isWidth,
              Expanded(
                child: DashedTextField(
                  hintText: "Upload Advance payment Certificate",
                  controller: widget.cubit.advancePaymentController,
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
                  controller: widget.cubit.electronicInvoiceController,
                  leadingIcon: Icons.upload_rounded,
                ),
              ),
              5.isWidth,
              Expanded(
                child: DashedTextField(
                  hintText: "Upload Tax ID",
                  controller: widget.cubit.taxIDController,
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
                    value: widget.cubit.selectedItemTypeofService, // Use the selectedItem state variable
                    hint: Text("Choose Service type"),
                    style: const TextStyle(fontSize: 11),
                    isExpanded: true,
                    items: widget.cubit.typeOfService.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.cubit.selectedItemTypeofService = newValue; // Update the selected item
                      });
                    },
                  ),
                ),
              ),
              5.isWidth,
              Expanded(
                  child: Textfield(
                    controller: widget.cubit.bankNameController,
                labelText: "Enter Bank Name",
              )),
            ],
          ),
          5.isHeight,

          Row(
            children: [
              Expanded(
                  child: Textfield(
                    controller: widget.cubit.bankAccountNumberController,
                labelText: "Enter Bank Account Number",
              )),
              5.isWidth,
              Expanded(
                  child: Textfield(
                    controller: widget.cubit.invoiceNumberController,
                labelText: "Enter Invoice Number",
              )),
            ],
          ),
        ],
      ),
    );
  }
}
