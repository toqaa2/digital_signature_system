import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReceivedFormsView extends StatefulWidget {
  const ReceivedFormsView({super.key});

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
  List<Widget>pdfPageSignatures=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          MaterialButton(
            onPressed: () async {
              String pdfUrl = 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'; // Replace with your PDF URL
              await loadPdfFromUrl(pdfUrl);
            },
            child: Text('Load PDF from URL'),
          ),
          SizedBox(height: 10),
          MaterialButton(
            onPressed: () {
              if (paintKeys.isNotEmpty) {
                AppFunctions.saveWidgetsAsPdf(
                  paintKeys,
                  List.generate(paintKeys.length, (index) => 'index'),
                );
              } else {
                print('No pages to save.');
              }
            },
            child: Text('Save Form as PDF'),
          ),
          SizedBox(height: 10),
          Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: pdfPageSignatures,),
              )),
        ],
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

        documents = List.generate(pageCount, (index) => Uint8List.fromList(documentBytes!.toList()));
        signatureX = List.generate(pageCount, (index) => 100);
        signatureY = List.generate(pageCount, (index) => 100);
        paintKeys = List.generate(pageCount, (index) => GlobalKey<State<StatefulWidget>>());
        pdfPageSignatures = List.generate(
          pageCount,
              (index) => PdfPageSignature(
            key: ValueKey(index), // Use ValueKey for each widget
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
      children: [
        MaterialButton(
          onPressed: () {
            setState(() {
              showSignature = !showSignature;
            });
          },
          child: Text('Toggle Signature'),
        ),
        RepaintBoundary(
          key: widget.paintKey,
          child: Stack(
            children: [
              SizedBox(
                width: 400,
                height: 550,
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
                      width: 40,
                      height: 40,
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
