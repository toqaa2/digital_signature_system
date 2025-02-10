import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:html' as html;


class SignaturePage extends StatefulWidget {
  const SignaturePage({super.key});

  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  String? selectedDocument;
  List<String> documents = ['document1.doc', 'document2.doc']; // Add your asset document names
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Signature System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButton<String>(
              value: selectedDocument,
              hint: Text('Select Document'),
              items: documents.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedDocument = newValue;
                });
                downloadDocument(newValue!);
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: selectedDocument != null
                    ? GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      RenderBox renderBox = context.findRenderObject() as RenderBox;
                      points.add(renderBox.globalToLocal(details.globalPosition));
                    });
                  },
                  onPanEnd: (details) {
                    points.add(null);
                  },
                  child: CustomPaint(
                    painter: SignaturePainter(points),
                    size: Size.infinite,
                  ),
                )
                    : Text('Select a document to start signing.'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                saveSignature();
              },
              child: Text('Save Signature'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadDocument(String documentName) async {
    final ByteData data = await rootBundle.load('assets/$documentName');
    final uint8List = data.buffer.asUint8List();

    // Create a blob and download the file
    final blob = html.Blob([uint8List], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', documentName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void saveSignature() {
    // Implement signature saving logic here
    // For example, save the signature image to the file system
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}