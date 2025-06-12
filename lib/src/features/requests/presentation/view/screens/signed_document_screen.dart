import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:signature_system/src/features/requests/presentation/view/widgets/view_signed_document.dart';

import '../../../../../core/functions/app_functions.dart';
import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../../core/style/colors.dart';

class SignedDocumentScreen extends StatefulWidget {
  const SignedDocumentScreen({
    super.key,
    required this.formModel,
    this.canDownload = false,
    this.onRequestDone,
  });

  final FormModel formModel;
  final bool canDownload;
final VoidCallback? onRequestDone;
  @override
  State<SignedDocumentScreen> createState() => _SignedDocumentScreenState();
}

class _SignedDocumentScreenState extends State<SignedDocumentScreen> {
  bool hasDialogContent() {
    // Check for PaymentRequest content
    if (widget.formModel.formName!.contains("PaymentRequest")) {
      if (widget.formModel.commentPettyCash!.isNotEmpty ||
          widget.formModel.pettyCashDocument!.isNotEmpty ||
          widget.formModel.taxID!.isNotEmpty ||
          widget.formModel.serviceType!.isNotEmpty ||
          widget.formModel.bankDetails!.isNotEmpty ||
          widget.formModel.invoiceNumber!.isNotEmpty ||
          widget.formModel.commercialRegistration!.isNotEmpty ||
          widget.formModel.advancePayment!.isNotEmpty ||
          widget.formModel.electronicInvoice!.isNotEmpty||  widget.formModel.uploadProcurment!.isNotEmpty
      ) {
        return true;
      }
    }

    // Check for InternalCommittee content
    if (widget.formModel.formName!.contains("InternalCommittee") &&
        widget.formModel.otherDocument!.isNotEmpty) {
      return true;
    }

    // No content to show
    return false;
  }

  void _showDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              if (widget.formModel.formName!
                  .contains("PaymentRequest")
              )
                Row(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.formModel.commentPettyCash!.isNotEmpty||widget.formModel.pettyCashDocument!
                        .isNotEmpty)
                      Column(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Comment: ${widget.formModel.commentPettyCash!} "),

                          ButtonWidget(
                              verticalMargin: 2,
                              buttonColor: Colors.green,
                              minWidth: 230,
                              height: 35,
                              textStyle: TextStyle(
                                  fontSize: 12, color: Colors.white),
                              text:
                              "Download Document",
                              onTap: () async {
                                AppFunctions.downloadPdf(widget.formModel
                                    .pettyCashDocument!);
                              }),
                        ],
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        if (widget.formModel.serviceType!.isNotEmpty)
                          Text(
                              "Service Type: ${widget.formModel.serviceType!}"),
                        if (widget.formModel.invoiceNumber!.isNotEmpty)
                          Text(
                              "Invoice Number: ${widget.formModel.invoiceNumber!}"),

                      ],
                    ),
                    Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (widget.formModel.commercialRegistration!
                            .isNotEmpty)
                          ButtonWidget(
                              verticalMargin: 2,
                              buttonColor: Colors.green,
                              minWidth: 230,
                              height: 35,
                              textStyle: TextStyle(
                                  fontSize: 12, color: Colors.white),
                              text:
                              "Download Commercial Registration",
                              onTap: () async {
                                AppFunctions.downloadPdf(widget.formModel
                                    .commercialRegistration!);
                              }),
                        if (widget.formModel.taxID!.isNotEmpty)
                          ButtonWidget(
                              verticalMargin: 2,
                              buttonColor: Colors.green,
                              minWidth: 230,
                              height: 35,
                              textStyle: TextStyle(fontSize: 12, color: Colors.white),
                              text: "Download Tax ID",
                              onTap: () async {
                                AppFunctions.downloadPdf(widget.formModel.taxID!);
                              }),
                        if (widget.formModel.bankDetails!
                            .isNotEmpty)
                          ButtonWidget(
                              verticalMargin: 2,
                              buttonColor: Colors.green,
                              minWidth: 230,
                              height: 35,
                              textStyle: TextStyle(
                                  fontSize: 12, color: Colors.white),
                              text:
                              "Download Bank Details",
                              onTap: () async {
                                AppFunctions.downloadPdf(widget.formModel
                                    .bankDetails!);
                              }),
                        if (widget.formModel.uploadProcurment!.isNotEmpty)
                          ButtonWidget(
                              verticalMargin: 2,
                              minWidth: 230,
                              buttonColor: Colors.green,
                              height: 35,
                              textStyle: TextStyle(
                                  fontSize: 12, color: Colors.white),
                              text: "Download Procurement Committee",
                              onTap: () async {
                                AppFunctions.downloadPdf(
                                    widget.formModel.uploadProcurment!);
                              }),

                        if (widget.formModel.advancePayment!.isNotEmpty)
                          ButtonWidget(
                              verticalMargin: 2,
                              minWidth: 230,
                              buttonColor: Colors.green,
                              height: 35,
                              textStyle: TextStyle(
                                  fontSize: 12, color: Colors.white),
                              text: "Download Advance Payment",
                              onTap: () async {
                                AppFunctions.downloadPdf(
                                    widget.formModel.advancePayment!);
                              }),
                        if (widget.formModel.electronicInvoice!.isNotEmpty)
                          ButtonWidget(
                              verticalMargin: 2,
                              minWidth: 230,
                              buttonColor: Colors.green,
                              height: 35,
                              textStyle: TextStyle(
                                  fontSize: 12, color: Colors.white),
                              text: "Download Electronic Invoice",
                              onTap: () async {
                                AppFunctions.downloadPdf(widget.formModel.electronicInvoice!);
                              }),
                      ],
                    ),
                  ],
                ),
              if (widget.formModel.formName!
                  .contains("InternalCommittee") &&
                  widget.formModel.otherDocument!
                      .isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.formModel.otherDocument!
                        .isNotEmpty)
                      ButtonWidget(
                          verticalMargin: 2,
                          buttonColor: Colors.green,
                          minWidth: 230,
                          height: 35,
                          textStyle: TextStyle(
                              fontSize: 12, color: Colors.white),
                          text:
                          "Download Attached Document",
                          onTap: () async {
                            AppFunctions.downloadPdf(widget.formModel.otherDocument!);

                          }),
                  ],
                ),

            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/background.png"), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            spacing: 20,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.formModel.formName!),
                      ...List.generate(widget.formModel.sentTo!.length, (index) {
                        bool isSigned = widget.formModel.signedBy!.any(
                          (element) => element.email == widget.formModel.sentTo![index],
                        );
                        return Row(
                          spacing: 5,
                          children: [
                            SvgPicture.asset(
                              isSigned
                                  ? 'assets/Signed status.svg'
                                  : 'assets/pending_status.svg',
                              width: 22,
                              height: 22,
                            ),
                            Text(widget.formModel.sentTo![index]),
                          ],
                        );
                      })
                    ],
                  ),
                  Column(
                    spacing: 10,
                    children: [
                      Text(intl.DateFormat('yyy-MM-dd hh:mm a').format(
                          DateTime.fromMicrosecondsSinceEpoch(
                              widget.formModel.sentDate!.microsecondsSinceEpoch))),
                      if (hasDialogContent() )
                        ButtonWidget(
                          verticalMargin: 2,
                          buttonColor: Colors.white,
                          borderColor: AppColors.mainColor,
                          minWidth: 200,
                          height: 30,
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: AppColors.mainColor,
                          ),
                          text: "Show Attached Docs",
                          onTap: () {
                            setState(() {
                              _showDialog(context);
                            });
                          },
                        ),

                      if(widget.onRequestDone!=null)
                      ButtonWidget(
                        verticalMargin: 2,
                        buttonColor: Colors.green,
                        minWidth: 200,
                        height: 30,
                        textStyle: TextStyle(
                          fontSize: 12,
                          color:Colors.white,
                        ),
                        text: "Request Done",
                        onTap:  widget.onRequestDone!,
                      ),
                    ],
                  )
                ],
              ),
              ViewSignedDocumentWidget(
                formModel: widget.formModel,
                canDownload: widget.canDownload,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
