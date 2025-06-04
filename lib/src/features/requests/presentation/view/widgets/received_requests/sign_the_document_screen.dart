import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:signature_system/src/core/shared_widgets/custom_button.dart';
import 'package:signature_system/src/core/style/colors.dart';
import 'package:signature_system/src/features/requests/presentation/manager/requests_cubit.dart';
import 'package:signature_system/src/features/requests/presentation/view/widgets/signatures_table_widget.dart';
import 'package:signature_system/src/features/requests/presentation/view/widgets/view_single_page_with_signature.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../../login_screen/view/widgets/custom_text_field.dart';


class SignTheDocumentScreen extends StatefulWidget {
  const SignTheDocumentScreen({
    super.key,
    required this.formModel,
    required this.cubit,
  });

  final RequestsCubit cubit;
  final FormModel formModel;

  @override
  State<SignTheDocumentScreen> createState() => _SignTheDocumentScreenState();
}

class _SignTheDocumentScreenState extends State<SignTheDocumentScreen> {
  Uint8List? documentBytes;
  List<GlobalKey<State<StatefulWidget>>> paintKeys = [];
  List<Widget> pdfPageSignatures = [];

  @override
  void initState() {
    widget.cubit.getComments(widget.formModel);
    _loadPdfFromUrl(widget.formModel.formLink ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withAlpha(150),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.formModel.formName ?? ''),
                          Text("at ${intl.DateFormat('yyy-MM-dd hh:mm a').format(
                            DateTime.fromMicrosecondsSinceEpoch(
                                widget.formModel.sentDate?.microsecondsSinceEpoch ?? 0),
                          )}"),
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
                            text: "Add Comment",
                            onTap: () {
                              setState(() {
                                _showDialog2(context);
                              });
                            },
                          ),
                        ],
                      ),
                      Column(
                        spacing: 5,
                        children: [
                          if (widget.cubit.checkIfValidToSign(widget.formModel))
                            ButtonWidget(
                                verticalMargin: 2,
                                minWidth: 200,
                                height: 30,
                                textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                text: "Approve form",
                                onTap: () async {
                                  if (paintKeys.isNotEmpty) {
                                    /// save to DB
                                    widget.cubit
                                        .signTheForm(widget.formModel, context)
                                        .then((onValue) {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
                                }),
                          if (hasDialogContent())
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
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
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
                          }),
                          10.isHeight,
                          ...pdfPageSignatures,
                          SignaturesTableWidget(signatures: widget.formModel.signedBy,),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadPdfFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        documentBytes = response.bodyBytes;
        final PdfDocument document = PdfDocument(inputBytes: documentBytes!);
        paintKeys =
            List.generate(document.pages.count, (index) => GlobalKey<State<StatefulWidget>>());
        pdfPageSignatures = List.generate(
          document.pages.count,
          (index) => ViewSinglePageWithSignature(
            key: ValueKey(index),
            formModel: widget.formModel,
            documentBytes: documentBytes!,
            page: index,
            paintKey: paintKeys[index],
          ),
        );
        setState(() {});
        // document.dispose();
      } else {
        debugPrint('Failed to load PDF: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in received widget view is : $e');
    }
  }

  bool hasDialogContent() {
    final formModel = widget.formModel;

    // Check for PaymentRequest content
    if (formModel.formName!.contains("PaymentRequest")) {
      if (formModel.commentPettyCash!.isNotEmpty ||
          formModel.pettyCashDocument!.isNotEmpty ||
          formModel.taxID!.isNotEmpty ||
          formModel.serviceType!.isNotEmpty ||
          formModel.bankDetails!.isNotEmpty ||

          formModel.invoiceNumber!.isNotEmpty ||
          formModel.commercialRegistration!.isNotEmpty ||
          formModel.advancePayment!.isNotEmpty ||
          formModel.electronicInvoice!.isNotEmpty ||
          formModel.uploadProcurment!.isNotEmpty) {
        return true;
      }
    }

    // Check for InternalCommittee content
    if (formModel.formName!.contains("InternalCommittee") && formModel.otherDocument!.isNotEmpty) {
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
              SizedBox(
                height: 20,
              ),
              if (widget.formModel.formName!.contains("PaymentRequest"))
                Row(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.formModel.commentPettyCash!.isNotEmpty ||
                        widget.formModel.pettyCashDocument!.isNotEmpty)
                      Column(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Comment: ${widget.formModel.commentPettyCash!} "),
                          ButtonWidget(
                              verticalMargin: 2,
                              buttonColor: Colors.green,
                              minWidth: 230,
                              height: 35,
                              textStyle: TextStyle(fontSize: 12, color: Colors.white),
                              text: "Download Document",
                              onTap: () async {
                                AppFunctions.downloadPdf(widget.formModel.pettyCashDocument!);
                              }),
                        ],
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        if (widget.formModel.serviceType!.isNotEmpty)
                          Text("Service Type: ${widget.formModel.serviceType!}"),

                        if (widget.formModel.invoiceNumber!.isNotEmpty)
                          Text("Invoice Number: ${widget.formModel.invoiceNumber!}"),
                      ],
                    ),
                    Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                        if (widget.formModel.commercialRegistration!.isNotEmpty)
                          ButtonWidget(
                              verticalMargin: 2,
                              buttonColor: Colors.green,
                              minWidth: 230,
                              height: 35,
                              textStyle: TextStyle(fontSize: 12, color: Colors.white),
                              text: "Download Commercial Registration",
                              onTap: () async {
                                AppFunctions.downloadPdf(widget.formModel.commercialRegistration!);
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
                        if (widget.formModel.advancePayment!.isNotEmpty)
                          ButtonWidget(
                              verticalMargin: 2,
                              minWidth: 230,
                              buttonColor: Colors.green,
                              height: 35,
                              textStyle: TextStyle(fontSize: 12, color: Colors.white),
                              text: "Download Advance Payment",
                              onTap: () async {
                                AppFunctions.downloadPdf(widget.formModel.advancePayment!);
                              }),
                        if (widget.formModel.uploadProcurment!.isNotEmpty)
                          ButtonWidget(
                              verticalMargin: 2,
                              minWidth: 230,
                              buttonColor: Colors.green,
                              height: 35,
                              textStyle: TextStyle(fontSize: 12, color: Colors.white),
                              text: "Download Procurement Committee",
                              onTap: () async {
                                AppFunctions.downloadPdf(widget.formModel.uploadProcurment!);
                              }),
                        if (widget.formModel.electronicInvoice!.isNotEmpty)
                          ButtonWidget(
                              verticalMargin: 2,
                              minWidth: 230,
                              buttonColor: Colors.green,
                              height: 35,
                              textStyle: TextStyle(fontSize: 12, color: Colors.white),
                              text: "Download Electronic Invoice",
                              onTap: () async {
                                AppFunctions.downloadPdf(widget.formModel.electronicInvoice!);
                              }),
                      ],
                    ),
                  ],
                ),
              if (widget.formModel.formName!.contains("InternalCommittee") &&
                  widget.formModel.otherDocument!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.formModel.otherDocument!.isNotEmpty)
                      ButtonWidget(
                          verticalMargin: 2,
                          buttonColor: Colors.green,
                          minWidth: 230,
                          height: 35,
                          textStyle: TextStyle(fontSize: 12, color: Colors.white),
                          text: "Download Attached Document",
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

  void _showDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Comments",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.mainColor, fontSize: 18),
              ),
              Text("If there are any comments on the submitted form, you can write them here.",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
              TextFieldWidget(
                controller: widget.cubit.commentsController,
                labelText: "Add Comment..",
              ),
              SizedBox(
                height: 200,
                width: 600,
                child: ListView.builder(
                  itemCount: widget.cubit.comments.length,
                  itemBuilder: (context, index) {
                    final comment = widget.cubit.comments[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(comment.userID ?? "Unknown User"),
                        subtitle: Text(comment.comment ?? ""),
                      ),
                    );
                  },
                ),
              )
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
              onPressed: () async {
                if (widget.cubit.commentsController.text.isNotEmpty) {
                  await widget.cubit.addComment(widget.formModel);
                  if (context.mounted) Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(msg: 'Please add a comment');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
