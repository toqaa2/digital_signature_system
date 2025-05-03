import 'package:flutter/material.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:signature_system/src/core/style/colors.dart';
import '../../../login_screen/view/widgets/custom_text_field.dart';
import '../../manager/home_cubit.dart';
import 'dashed_text_field.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      child: Column(
        children: [
          // First Row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async{
                    widget.cubit.commercialRegistrationController.text=await
                    widget.cubit.uploadDocument(
                       formName: widget.cubit.selectedFormModel!.formName!,
                       userID:  Constants.userModel!.name!,
                    );
                  },
                  child: DashedTextField(
                    textStyle: widget.cubit.commercialRegistrationController.text.isEmpty
                        ? TextStyle(fontSize: 11, color: Colors.grey)
                        : TextStyle(fontSize: 11, color: Colors.green),
                    hintText: "Upload Commercial Registration",
                    controller: widget.cubit.commercialRegistrationController,
                    leadingIcon:
                    widget.cubit.state is UploadCommercialRegistrationLoading
                        ? CircularProgressIndicator(
                      color: AppColors.mainColor,
                    )
                        : widget.cubit.commercialRegistrationController.text.isNotEmpty
                        ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                        : Icon(
                      Icons.upload,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              5.isWidth,
              Expanded(
                child: GestureDetector(
                  onTap: ()async{
                    widget.cubit.advancePaymentController.text =await    widget.cubit.uploadDocument(
                       formName: widget.cubit.selectedFormModel!.formName!,
                       userID:  Constants.userModel!.name!,
                    );
                  },
                  child: DashedTextField(
                    hintText: "Upload Advance payment Certificate",
                    textStyle: widget.cubit.advancePaymentController.text.isEmpty
                        ? TextStyle(fontSize: 11, color: Colors.grey)
                        : TextStyle(fontSize: 11, color: Colors.green),
                    controller: widget.cubit.advancePaymentController,
                    leadingIcon:
                        widget.cubit.state is UploadAdvancePaymentLoading
                            ? CircularProgressIndicator(
                                color: AppColors.mainColor,
                              )
                            : widget.cubit.advancePaymentController.text.isNotEmpty
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.upload,
                                    color: Colors.grey,
                                  ),
                  ),
                ),
              ),
            ],
          ),
          10.isHeight,

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async{
                    widget.cubit.electronicInvoiceController.text=await       widget.cubit.uploadDocument(
                         formName: widget.cubit.selectedFormModel!.formName!,
                         userID:  Constants.userModel!.name!,
                    );
                  },
                  child: DashedTextField(
                    textStyle: widget.cubit.electronicInvoiceController.text.isEmpty
                        ? TextStyle(fontSize: 11, color: Colors.grey)
                        : TextStyle(fontSize: 11, color: Colors.green),
                    hintText: "Upload Electronic Invoice",
                    controller: widget.cubit.electronicInvoiceController,
                    leadingIcon:
                    widget.cubit.state is UploadElectronicInvoiceLoading
                        ? CircularProgressIndicator(
                      color: AppColors.mainColor,
                    )
                        : widget.cubit.electronicInvoiceController.text.isNotEmpty
                        ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                        : Icon(
                      Icons.upload,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              5.isWidth,
              Expanded(
                  child: TextFieldWidget(
                controller: widget.cubit.taxIDController,
                labelText: "Enter Tax ID",
              )),
            ],
          ),

          5.isHeight,
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  width: 420,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton<String>(
                    underline: SizedBox(),
                    value: widget.cubit.selectedItemTypeofService,
                    // Use the selectedItem state variable
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
                        widget.cubit.selectedItemTypeofService =
                            newValue; // Update the selected item
                      });
                    },
                  ),
                ),
              ),
              5.isWidth,
              Expanded(
                  child: TextFieldWidget(
                controller: widget.cubit.bankNameController,
                labelText: "Enter Bank Name",
              )),
            ],
          ),
          5.isHeight,

          Row(
            children: [
              Expanded(
                  child: TextFieldWidget(
                controller: widget.cubit.bankAccountNumberController,
                labelText: "Enter Bank Account Number",
              )),
              5.isWidth,
              Expanded(
                  child: TextFieldWidget(
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
