import 'package:flutter/material.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
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
    print('here1');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      child: widget.cubit.selectedPaymentType == 'Petty Cash'
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DashedTextField(
                          onTap: () async {
                            widget.cubit.pettyCashDocument.text =
                                await widget.cubit.uploadDocument(
                              formName:
                                  widget.cubit.selectedFormModel!.formName!,
                              userID: Constants.userModel!.name!,
                            );
                            widget.cubit.emit(UploadSuccess());
                          },
                          hintText: "Upload Document or Image",
                          controller: widget.cubit.pettyCashDocument,
                        ),
                      ),
                    ],
                  ),
                  20.isHeight,
                  Row(
                    children: [
                      Expanded(
                          child: TextFieldWidget(
                        controller: widget.cubit.commentPettyCash,
                        labelText: "Add Comment..",
                      )),
                    ],
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // First Row
                Row(
                  children: [
                    Expanded(
                      child: DashedTextField(
                        onTap: () async {
                          widget.cubit.commercialRegistrationController.text =
                              await widget.cubit.uploadDocument(
                            formName: widget.cubit.selectedFormModel!.formName!,
                            userID: Constants.userModel!.name!,
                          );
                          widget.cubit.emit(UploadSuccess());
                        },
                        hintText: "Upload Commercial Registration",
                        controller:
                            widget.cubit.commercialRegistrationController,
                      ),
                    ),
                    5.isWidth,
                    Expanded(
                      child: DashedTextField(
                        onTap: () async {
                          widget.cubit.advancePaymentController.text =
                              await widget.cubit.uploadDocument(
                            formName: widget.cubit.selectedFormModel!.formName!,
                            userID: Constants.userModel!.name!,
                          );
                          widget.cubit.emit(UploadSuccess());
                        },
                        hintText: "Upload Advance payment Certificate",
                        controller: widget.cubit.advancePaymentController,
                      ),
                    ),
                  ],
                ),
                10.isHeight,

                Row(
                  children: [
                    Expanded(
                      child: DashedTextField(
                        onTap: () async {
                          widget.cubit.electronicInvoiceController.text =
                              await widget.cubit.uploadDocument(
                            formName: widget.cubit.selectedFormModel!.formName!,
                            userID: Constants.userModel!.name!,
                          );
                          widget.cubit.emit(UploadSuccess());
                        },
                        hintText: "Upload Electronic Invoice",
                        controller: widget.cubit.electronicInvoiceController,
                      ),
                    ),
                    5.isWidth,
                    Expanded(
                      child: DashedTextField(
                        onTap: () async {
                          widget.cubit.taxIDController.text =
                              await widget.cubit.uploadDocument(
                            formName: widget.cubit.selectedFormModel!.formName!,
                            userID: Constants.userModel!.name!,
                          );
                          widget.cubit.emit(UploadSuccess());
                        },
                        hintText: "Upload Tax ID",
                        controller: widget.cubit.taxIDController,
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
                      child: DashedTextField(
                        onTap: () async {
                          widget.cubit.bankDetails.text =
                              await widget.cubit.uploadDocument(
                            formName: widget.cubit.selectedFormModel!.formName!,
                            userID: Constants.userModel!.name!,
                          );
                          widget.cubit.emit(UploadSuccess());
                        },
                        hintText: "Upload Bank Details",
                        controller: widget.cubit.bankDetails,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
