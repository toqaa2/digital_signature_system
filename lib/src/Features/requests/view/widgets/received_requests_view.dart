import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:signature_system/src/core/style/colors.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/shared_widgets/custom_button.dart';
import '../../../login_screen/view/widgets/custom_text_field.dart';

class ReceivedFormsView extends StatefulWidget {
  const ReceivedFormsView(
      {super.key, required this.formName, required this.sentDate, required this.formLink});

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

  @override
  void initState() {
    loadPdfFromUrl(
        widget.formLink);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/BackGround.png"), fit: BoxFit.fill),
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
                          ButtonWidget(
                            verticalMargin: 2,
                            minWidth: 120,
                            height: 35,
                            textStyle:
                                TextStyle(fontSize: 12, color: Colors.white),
                            text: "Save Form",
                            onTap: () async {
                              if (paintKeys.isNotEmpty) {
                                Uint8List file =
                                    await AppFunctions.saveWidgetsAsPdf(
                                        paintKeys);

                                /// save to DB
                                final SupabaseClient _client =
                                    Supabase.instance.client;
                                final String _bucketName = 'prv1';
                                String path='${widget.formName}/${Constants.userModel?.userId}/${widget.formName}${widget.sentDate}';
                                await _client.storage
                                    .from(_bucketName)
                                    .uploadBinary(
                                        path,
                                        file);
                                final publicUrl = _client.storage.from(_bucketName).getPublicUrl(path);
                                print(publicUrl);
                              } else {
                                print('No pages to save.');
                              }
                            },
                          ),
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
              SizedBox(
                width: 800,
                height: 1100,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
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
              ),
              Container(
                width: 800,
                height: 1100,
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
                    child: Image.asset(
                      'assets/toqasignature.png',
                      width: 80,
                      height: 80,
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
              Textfield(
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
