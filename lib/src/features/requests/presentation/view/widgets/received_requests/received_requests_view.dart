import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:signature_system/src/core/shared_widgets/custom_button.dart';
import 'package:signature_system/src/features/requests/presentation/view/widgets/received_requests/sign_the_document_widget.dart';
import 'package:signature_system/src/core/style/colors.dart';
import 'package:signature_system/src/features/login_screen/view/widgets/custom_text_field.dart';
import 'package:signature_system/src/features/requests/presentation/manager/requests_cubit.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

ScrollController scrollController=ScrollController();
class ReceivedFormsView extends StatefulWidget {
  const ReceivedFormsView({
    super.key,
    required this.formModel,
    required this.cubit,
  });

  final RequestsCubit cubit;
  final FormModel formModel;

  @override
  State<ReceivedFormsView> createState() => _ReceivedFormsViewState();
}

class _ReceivedFormsViewState extends State<ReceivedFormsView> {
  int pageCount = 0;
  Uint8List? documentBytes;
  List<Uint8List> documents = [];
  List<GlobalKey<State<StatefulWidget>>> paintKeys = [];
  List<Widget> pdfPageSignatures = [];
  bool isVisible = true;


  @override
  void initState() {
    _loadPdfFromUrl(widget.formModel.formLink ?? '');
    super.initState();
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withAlpha(150),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: [
                      IconButton(
                          onPressed: () {
                            _toggleVisibility();
                          },
                          icon: Icon(Icons.remove_circle_outline)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.formModel.formName ?? ''),
                              Text(
                                  "at ${intl.DateFormat('yyy-MM-dd hh:mm a').format(
                                DateTime.fromMicrosecondsSinceEpoch(widget
                                        .formModel
                                        .sentDate
                                        ?.microsecondsSinceEpoch ??
                                    0),
                              )}"),
                            ],
                          ),
                          Row(
                            spacing: 5,
                            children: [
                              if (widget.cubit
                                  .checkIfValidToSign(widget.formModel))
                                ButtonWidget(
                                    verticalMargin: 2,
                                    minWidth: 120,
                                    height: 35,
                                    textStyle: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    text: "Save Form",
                                    onTap: () async {
                                      if (paintKeys.isNotEmpty) {
                                        /// save to DB
                                        widget.cubit
                                            .signTheForm(
                                                widget.formModel, context)
                                            .then((onValue) {
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                        });
                                      }
                                    }),
                              ButtonWidget(
                                verticalMargin: 2,
                                buttonColor: Colors.white,
                                borderColor: AppColors.mainColor,
                                minWidth: 120,
                                height: 35,
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.mainColor,
                                ),
                                text: "Reverse",
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
                    ],
                  ),
                  if (widget.formModel.formName!
                          .contains("PaymentRequest") &&
                      isVisible)
                    Container(
                      color: Colors.blue.shade50,
                      margin: EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50),
                      padding: EdgeInsets.symmetric(
                          vertical: 20, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  if (widget.formModel.taxID!.isNotEmpty)
                                    Text(
                                        "TaxID:${widget.formModel.taxID!} "),
                                  if (widget
                                      .formModel.serviceType!.isNotEmpty)
                                    Text(
                                        "Service Type: ${widget.formModel.serviceType!}"),
                                  if (widget.formModel.bankName!.isNotEmpty)
                                    Text(
                                        "Bank Name: ${widget.formModel.bankName!}"),
                                ],
                              ),
                              Column(
                                spacing: 10,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (widget.formModel.bankAccountNumber!
                                      .isNotEmpty)
                                    Text(
                                        "Bank Account No.: ${widget.formModel.bankAccountNumber!}"),
                                  if (widget
                                      .formModel.invoiceNumber!.isNotEmpty)
                                    Text(
                                        "Invoice Number: ${widget.formModel.invoiceNumber!}"),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            spacing: 20,
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                      AppFunctions.downloadPdf(widget
                                          .formModel
                                          .commercialRegistration!);
                                    }),
                              if (widget
                                  .formModel.advancePayment!.isNotEmpty)
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
                              if (widget
                                  .formModel.electronicInvoice!.isNotEmpty)
                                ButtonWidget(
                                    verticalMargin: 2,
                                    minWidth: 230,
                                    buttonColor: Colors.green,
                                    height: 35,
                                    textStyle: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    text: "Download Electronic Invoice",
                                    onTap: () async {
                                      AppFunctions.downloadPdf(widget
                                          .formModel.electronicInvoice!);
                                    }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (widget.formModel.formName!
                      .contains("InternalCommittee") &&
                      isVisible&&widget.formModel.otherDocument!
                      .isNotEmpty)
                    Container(
                      color: Colors.blue.shade50,
                      margin: EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50),
                      padding: EdgeInsets.symmetric(
                          vertical: 20, horizontal: 25),
                      child: Column(
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
                    ),
                  SizedBox(height: 20),
                  Expanded(
                      child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: scrollController,
                      child: Column(
                        children: pdfPageSignatures,
                      ),
                    ),
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
        pageCount = document.pages.count;
        document.dispose();

        documents = List.generate(
            pageCount, (index) => Uint8List.fromList(documentBytes!.toList()));
        paintKeys = List.generate(
            pageCount, (index) => GlobalKey<State<StatefulWidget>>());
        pdfPageSignatures = List.generate(
          pageCount,
              (index) => SignTheDocumentWidget(
            key: ValueKey(index),
            formModel: widget.formModel,
            cubit: widget.cubit,
            document: documents[index],
            index: index,
            paintKey: paintKeys[index],
          ),
        );
        setState(() {});
      } else {
        debugPrint('Failed to load PDF: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in received widget view is : $e');
    }
  }
  void _toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

}




void _showDialog(BuildContext context) {
  final TextEditingController textFieldController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Reverse',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.mainColor),
        ),
        content: SizedBox(
          width: 400,
          height: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please Enter the Reason for the reverse to help the',
                textAlign: TextAlign.center,
              ),
              Text(
                'person who sent the request',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                controller: textFieldController,
                labelText: "Type here..",
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Reverse'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
