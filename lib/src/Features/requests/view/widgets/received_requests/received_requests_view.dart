import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:intl/intl.dart' as intl;

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../core/functions/app_functions.dart';
import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../login_screen/view/widgets/custom_text_field.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/style/colors.dart';
import '../../../manager/requests_cubit.dart';

class ReceivedFormsView extends StatefulWidget {
  const ReceivedFormsView({
    super.key,
    required this.formModel,
    required this.cubit,
  });

  final RequestsCubit cubit;
  final FormModel formModel;

  @override
  _ReceivedFormsViewState createState() => _ReceivedFormsViewState();
}

class _ReceivedFormsViewState extends State<ReceivedFormsView> {
  int pageCount = 0;
  Uint8List? documentBytes;
  List<Uint8List> documents = [];
  List<double> signatureX = [];
  List<double> signatureY = [];
  List<GlobalKey<State<StatefulWidget>>> paintKeys = [];
  List<Widget> pdfPageSignatures = [];
  bool isVisible = true;

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void initState() {
    loadPdfFromUrl(widget.formModel.formLink ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                                toggleVisibility();
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
                      SizedBox(height: 20),
                      Expanded(
                          child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
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
        )
      ],
    );
  }

  Future<void> loadPdfFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        documentBytes = response.bodyBytes;
        final PdfDocument document = PdfDocument(inputBytes: documentBytes!);
        pageCount = document.pages.count;
        document.dispose();

        documents = List.generate(
            pageCount, (index) => Uint8List.fromList(documentBytes!.toList()));
        signatureX = List.generate(pageCount, (index) => 100);
        signatureY = List.generate(pageCount, (index) => 100);
        paintKeys = List.generate(
            pageCount, (index) => GlobalKey<State<StatefulWidget>>());
        pdfPageSignatures = List.generate(
          pageCount,
          (index) => PdfPageSignature(
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
      }
    } catch (e) {
      debugPrint('Error in received widget view is : $e');
    }
  }
}

class PdfPageSignature extends StatefulWidget {
  const PdfPageSignature({
    super.key,
    required this.document,
    required this.index,
    required this.paintKey,
    required this.formModel,
    required this.cubit,
  });

  final FormModel formModel;

  final GlobalKey<State<StatefulWidget>> paintKey;
  final Uint8List document;
  final int index;
  final RequestsCubit cubit;

  @override
  State<PdfPageSignature> createState() => _PdfPageSignatureState();
}

class _PdfPageSignatureState extends State<PdfPageSignature> {
  bool showSignature = false;
  final SignatureModel signatureModel = SignatureModel(
    page: 0,
    scale: 100,
    signatureY: 100,
    signatureX: 100,
  );
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    signatureModel.page = widget.index;
    widgets = AppFunctions.viewSignatures(widget.formModel, widget.index);
  }

  bool rescale = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ButtonWidget(
          isHollow: true,
          borderColor: AppColors.mainColor,
          buttonColor: Colors.white,
          verticalMargin: 2,
          minWidth: 200,
          height: 35,
          textStyle: TextStyle(
              fontSize: 10,
              color: !showSignature ? AppColors.mainColor : Colors.redAccent),
          text: !showSignature
              ? "Add Signature to this Page"
              : "Remove Signature from this Page",
          onTap: () {
            signatureModel.page = widget.index;
            setState(() {
              showSignature = !showSignature;
            });
          },
        ),
        RepaintBoundary(
          key: widget.paintKey,
          child: Stack(
            children: <Widget>[
              PdfWithSignaturesWidget(
                formModel: widget.formModel,
                documentBytes: widget.document,
                page: widget.index,
              ),
              if (showSignature)
                Positioned(
                  left: signatureModel.signatureX.toDouble(),
                  top: signatureModel.signatureY.toDouble(),
                  child: GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        rescale = !rescale;
                      });
                    },
                    onPanEnd: (details) {

                      widget.cubit.signatureSet.add(signatureModel);
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        signatureModel.signatureX += details.delta.dx;
                        signatureModel.signatureY += details.delta.dy;
                      });
                    },
                    child: Column(
                      children: [
                        if (rescale)
                          Slider(
                            value: signatureModel.scale.toDouble(),
                            min: 1,
                            max: 400,
                            onChangeEnd: (value) {
                              widget.cubit.signatureSet.add(signatureModel);
                              setState(() {
                                rescale = false;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                signatureModel.scale = value;
                              });
                            },
                          ),
                        Image.network(
                          width: signatureModel.scale.toDouble(),
                          height: signatureModel.scale.toDouble() / 2,
                          Constants.userModel?.mainSignature ?? '',
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class PdfWithSignaturesWidget extends StatelessWidget {
  const PdfWithSignaturesWidget({
    super.key,
    required this.formModel,
    required this.page,
    required this.documentBytes,
  });

  final FormModel formModel;
  final int page;
  final Uint8List documentBytes;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          width: 1100,
          height: 1410,
          child: SfPdfViewer.memory(
            documentBytes,
            initialPageNumber: page + 1,
            scrollDirection: PdfScrollDirection.horizontal,
            canShowHyperlinkDialog: false,
            canShowPageLoadingIndicator: true,
            canShowPaginationDialog: false,
            canShowPasswordDialog: false,
            canShowScrollHead: false,
            canShowScrollStatus: false,
            canShowSignaturePadDialog: false,
            canShowTextSelectionMenu: false,
            enableDocumentLinkAnnotation: false,
            enableDoubleTapZooming: false,
            enableHyperlinkNavigation: false,
            enableTextSelection: false,
            interactionMode: PdfInteractionMode.pan,
          ),
        ),
        ...AppFunctions.viewSignatures(formModel, page),
        Container(
          width: 1100,
          height: 1410,
          color: Colors.transparent,
        ),
      ],
    );
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
