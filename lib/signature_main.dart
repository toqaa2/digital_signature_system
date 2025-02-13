import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:image/image.dart' as img; // Import the image package
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        Uint8List fileBytes = result.files.single.bytes!; // Works for Web & Mobile
        final PdfDocument document = PdfDocument(inputBytes: fileBytes);
        int pageCount = document.pages.count;
        document.dispose(); // Free up memory

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
                width: 500,
                height: 700,
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
                    child: Image.network(
                        'data:image/png;base64,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',
                        width: 100), // Adjust size as needed
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
