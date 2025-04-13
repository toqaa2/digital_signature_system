import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/models/form_model.dart';

import 'package:signature_system/src/core/style/colors.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../login_screen/view/widgets/custom_text_field.dart';
import '../../../manager/requests_cubit.dart';

class ReceivedFormsView extends StatefulWidget {
  const ReceivedFormsView({
    super.key,
    required this.formModel,
    required this.formName,
    required this.sentDate,
    required this.formLink,
    required this.cubit,
  });

  final RequestsCubit cubit;
final FormModel formModel;
  final String formName;
  final String sentDate;
  final String formLink;

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
    loadPdfFromUrl(widget.formLink);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // if (widget.cubit.state is LoadingSave)
        // Center(
        //   child: CircularProgressIndicator(),
        // ),
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
                          IconButton(onPressed: (){
                            toggleVisibility();
                          }, icon: Icon(Icons.remove_circle_outline)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.formName),
                                  Text("at ${widget.sentDate}"),
                                ],
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  if(widget.cubit.checkIfValidToSign(widget.formModel))
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
                                                .signTheForm(paintKeys, widget.formModel,context).then((onValue){
                                                  if(context.mounted)Navigator.pop(context);
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

                      if (widget.formModel.formName!.contains("PaymentRequest")&& isVisible)
                        Container(
                          color: Colors.blue.shade50,
                          margin: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
                          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    spacing: 10,
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if ( widget.formModel.taxID!.isNotEmpty) Text("TaxID:${ widget.formModel.taxID!} "),
                                      if ( widget.formModel.serviceType!.isNotEmpty) Text("Service Type:${widget.formModel.serviceType!}"),
                                      if ( widget.formModel.bankName!.isNotEmpty)  Text("Bank Name: ${widget.formModel.bankName!}"),
                                    ],
                                  ),
                                  Column(
                                    spacing: 10,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    children: [
                                      if ( widget.formModel.bankAccountNumber!.isNotEmpty)  Text("Bank Account No.: ${widget.formModel.bankAccountNumber!}"),
                                      if ( widget.formModel.invoiceNumber!.isNotEmpty) Text("Invoice Number: ${widget.formModel.invoiceNumber!}"),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                spacing: 20,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  if ( widget.formModel.commercialRegistration!.isNotEmpty)  ButtonWidget(
                                      verticalMargin: 2,
                                      buttonColor: Colors.green,
                                      minWidth: 230,
                                      height: 35,
                                      textStyle: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      text: "Download Commercial Reqistration",
                                      onTap: () async {

                                      }),
                                  if ( widget.formModel.advancePayment!.isNotEmpty) ButtonWidget(
                                      verticalMargin: 2,
                                      minWidth: 230,
                                      buttonColor: Colors.green,

                                      height: 35,
                                      textStyle: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      text: "Download Advance Payment",
                                      onTap: () async {

                                      }),
                                  if ( widget.formModel.electronicInvoice!.isNotEmpty) ButtonWidget(
                                      verticalMargin: 2,
                                      minWidth: 230,
                                      buttonColor: Colors.green,

                                      height: 35,
                                      textStyle: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      text: "Download Electronic Invoice",
                                      onTap: () async {

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
      print(url);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('response bodybytes');
        print(response.bodyBytes);
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
            document: documents[index],
            index: index,
            signatureX: signatureX[index],
            signatureY: signatureY[index],
            paintKey: paintKeys[index],
          ),
        );
        setState(() {});
      } else {
        print('Failed to load PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class PdfPageSignature extends StatefulWidget {
  const PdfPageSignature({
    super.key,
    required this.document,
    required this.index,
    required this.signatureX,
    required this.signatureY,
    required this.paintKey,
  });

  final GlobalKey<State<StatefulWidget>> paintKey;
  final Uint8List document;
  final int index;
  final double signatureX;
  final double signatureY;

  @override
  State<PdfPageSignature> createState() => _PdfPageSignatureState();
}

class _PdfPageSignatureState extends State<PdfPageSignature> {
  late double signatureX;
  late double signatureY;
  bool showSignature = false;

  @override
  void initState() {
    super.initState();
    signatureX = widget.signatureX;
    signatureY = widget.signatureY;
  }

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
            setState(() {
              showSignature = !showSignature;
            });
          },
        ),
        RepaintBoundary(
          key: widget.paintKey,
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                width: 1100,
                height: 1410,
                child: SfPdfViewer.memory(
                  widget.document,
                  initialPageNumber: widget.index + 1,
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
              Container(
                width: 1100,
                height: 1410,
                color: Colors.transparent,
              ),
              if (showSignature)
                Positioned(
                  left: signatureX,
                  top: signatureY,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        signatureX += details.delta.dx;
                        signatureY += details.delta.dy;
                      });
                    },
                    child: Image.network(
                      Constants.userModel?.mainSignature??'',
                      width: 200,
                      height: 200,
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

void _showDialog(BuildContext context) {
  final TextEditingController _textFieldController = TextEditingController();

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
        content: Container(
          width: 400, // Set the desired width
          height: 150, // Set the desired height
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
                controller: _textFieldController,
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
              // Handle the send action
              String inputText = _textFieldController.text;
              print(
                  'Input: $inputText'); // You can replace this with your logic
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
