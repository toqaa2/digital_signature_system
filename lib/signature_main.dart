import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// Import the image package


class SignatureHomePage extends StatefulWidget {
  const SignatureHomePage({super.key});

  @override
  _SignatureHomePageState createState() => _SignatureHomePageState();
}

class _SignatureHomePageState extends State<SignatureHomePage> {
  int pageCount = 0;
  Uint8List? documentBytes;
  List<Uint8List> documents = [];
  List<PdfViewerController> pdfControllers = [];
  List<double> signatureX = []; // Signature X position
  List<double> signatureY = []; // Signature Y position
  Uint8List? signature;
  List<GlobalKey<State<StatefulWidget>>> paintKeys = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          MaterialButton(
              onPressed: () async => await pickAndCountPdf().then((onValue) {
                pageCount = onValue.$1;
                documentBytes = onValue.$2;
                documents = List.generate(
                  pageCount,
                      (index) => Uint8List.fromList(documentBytes!.toList()),
                );
                signatureX = List.generate(
                  pageCount,
                      (index) => 100,
                );
                signatureY = List.generate(
                  pageCount,
                      (index) => 100,
                );
                paintKeys = List.generate(
                  pageCount,
                      (index) => GlobalKey<State<StatefulWidget>>(),
                );
                setState(() {});
              }),
              child: Text('Pick and Count PDF')),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            onPressed: () {
              AppFunctions.saveWidgetsAsPdf(paintKeys, List.generate(paintKeys.length, (index) => 'index',));
            },
            child: Text('Save Form as pdf'),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: documents.length,
                separatorBuilder: (context, index) => SizedBox(
                  width: 20,
                ),
                itemBuilder: (context, index) {
                  return PdfPageSignature(
                    document: documents[index],
                    index: index,
                    signatureX: signatureX[index],
                    signatureY: signatureY[index],
                    paintKey: paintKeys[index],
                  );
                },
              )),
        ],
      ),
    );
  }

  Future<(int, Uint8List)> pickAndCountPdf() async {
    try {
      // Pick a PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        Uint8List fileBytes = result.files.single.bytes!;
        final PdfDocument document = PdfDocument(inputBytes: fileBytes);
        int pageCount = document.pages.count;
        document.dispose();

        print('Total PDF pages: $pageCount');
        return (pageCount, fileBytes);
      }
    } catch (e) {
      print('Error: $e');
    }

    return (0, [] as Uint8List); // Return 0 if there's an error or no file selected
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

  @override
  void initState() {
    super.initState();
    signatureX = widget.signatureX;
    signatureY = widget.signatureY;
  }
  bool showSignature = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(onPressed: (){
          setState(() {
            showSignature = !showSignature;

          });
        },child: Text('Toggle Signature'),),
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
              if(showSignature)
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
                        width: 40,height: 40,), // Adjust size as needed
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
