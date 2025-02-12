import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:image/image.dart' as img; // Import the image package



class SignaturePage2 extends StatefulWidget {
  const SignaturePage2({super.key});

  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage2> {
  Uint8List? documentData;
  String signatureAssetPath = 'assets/signature.png'; // Change this to your signature path
  double signatureX = 100; // Signature X position
  double signatureY = 100; // Signature Y position
  Uint8List? signature;
@override
  void initState()  {
// TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      signature =(  await signatureBytes());});

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: uploadDocument,
              child: Text('Upload Document'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: documentData != null
                    ? Stack(
                  children: [
                    SfPdfViewer.memory( documentData!),
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
                        child: Image.memory(signature!, width: 100), // Adjust size as needed
                      ),
                    ),
                  ],
                )
                    : Text('Upload a document to start signing.'),
              ),
            ),
            ElevatedButton(
              onPressed: saveCombinedDocument,
              child: Text('Save Document with Signature'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final file = result.files.single;
      documentData = file.bytes;
      setState(() {});
    }
  }
Future<Uint8List> signatureBytes()async{
  final signatureImage = await rootBundle.load(signatureAssetPath);
  final signatureBytes = signatureImage.buffer.asUint8List();
  return signatureBytes;
}
  void saveCombinedDocument() async {
    // final signatureImage = await rootBundle.load(signatureAssetPath);

    try{
      final signatureImage = await rootBundle.load(signatureAssetPath);
      final signatureBytes = signatureImage.buffer.asUint8List();
      final originalImage = img.decodePng(signatureBytes); // Assuming PDF is PNG for first page preview

      print('image bytes $signatureBytes');
      // Create a PDF document
      final pdf = pw.Document();

      // Add the original PDF page
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                // Draw the original PDF page preview
                pw.Text('Helloe'),
                pw.Text('Helloe'),

                pw.Positioned(
                  left: signatureX,
                  top: signatureY,
                  child:pw.Image(pw.MemoryImage(img.encodePng(originalImage!)), width:60),
                ),
              ],
            );
          },
        ),
      );

      // Save the PDF document
      final output = await pdf.save();
      final blob = html.Blob([output], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'signed_document.pdf')
        ..click();
      html.Url.revokeObjectUrl(url);
    }catch(e){
      print('error is :${e.toString()}');
    }
  }
}

// class PDFViewer extends StatelessWidget {
//   final Uint8List data;
//
//   PDFViewer({required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     // Create a temporary file to display the PDF
//     final pdfFile = html.Blob([data], 'application/pdf');
//     final url = html.Url.createObjectUrlFromBlob(pdfFile);
//
//     return Container(
//       child: HtmlElementView(
//         viewType: 'pdf-viewer',
//         onPlatformViewCreated: (int viewId) {
//           // Use this to interact with the web component
//         },
//       ),
//     );
//   }
// }