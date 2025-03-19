import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';

import 'package:universal_html/html.dart' as html;
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;

class AppFunctions {
  static img.Image imageDecode(Uint8List imageData) {
    return img.decodeImage(imageData)!;
  }

  static Future<Uint8List> saveWidgetsAsPdf(List<GlobalKey> globalKeys) async {
    if (globalKeys.isEmpty) {
      throw ArgumentError('The number of global keys must match the number of image names.');
    }

    try {
      final pdf = pw.Document();

      for (int i = 0; i < globalKeys.length; i++) {
        final globalKey = globalKeys[i];

        // Check if the global key's context is valid
        if (globalKey.currentContext == null) {
          print('Error: Global key context is null for index $i');
          continue; // Skip this key if the context is invalid
        }

        // Capture the widget as an image
        RenderRepaintBoundary boundary =
            globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        // Get the original size of the widget
        double originalWidth = boundary.size.width;
        double originalHeight = boundary.size.height;
        print(originalWidth);
        print(originalHeight);

        ui.Image image =
            await boundary.toImage(pixelRatio: 3.0); // Increase pixel ratio for better quality
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();
        // Calculate the aspect ratio of the original image
        final double aspectRatio = originalWidth / originalHeight;

        // Define the page format and size. Match the image's aspect ratio for best results
        PdfPageFormat pageFormat = PdfPageFormat(originalWidth, originalHeight, marginAll: 0);
        // Add a page with the image
        pdf.addPage(
          pw.Page(
            pageFormat: pageFormat,
            build: (pw.Context context) {
              return

                pw.Center(
                  child: pw.Image(
                    fit: pw.BoxFit.fill,
                    pw.MemoryImage(pngBytes),
                  )
                )
              ;
            },
          ),
        );
      }

      // Save the PDF to bytes
      Uint8List bytes = await pdf.save();
      downloadPdf(bytes);
      return bytes;
      // Trigger a download of the PDF file
    } catch (e) {
      print('sign pdf error: $e');
      return [] as Uint8List;
    }
  }

  static downloadPdf(Uint8List bytes) {
    try {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'images.pdf'; // Set the PDF file name
      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
      return bytes;
    } catch (e) {
      print('Error saving widgets as PDF: $e');
      return [] as Uint8List;
    }
  }
}
// static Future<void> saveWidgetsAsPdf(List<GlobalKey> globalKeys, List<String> imageNames) async {
//   if (globalKeys.length != imageNames.length) {
//     throw ArgumentError('The number of global keys must match the number of image names.');
//   }
//
//   try {
//     // Create a new PDF document
//     // final PdfDocument document = PdfDocument();
//     final pdf = pw.Document();
//
//     for (int i = 0; i < globalKeys.length; i++) {
//       final globalKey = globalKeys[i];
//
//       RenderRepaintBoundary boundary =
//           globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       ui.Image image = await boundary.toImage(pixelRatio: 3.0); // Increase pixelRatio
//       ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       Uint8List pngBytes = byteData!.buffer.asUint8List();
//
//       // Decode the image
//       // final img.Image pdfImage = imageDecode(pngBytes);
//
//       // Add a page with the image
//       pdf.addPage(
//         pw.Page(
//           build: (pw.Context context) {
//             return pw.Center(
//               child: pw.Image(
//                 pw.MemoryImage(pngBytes),
//                 // width: 200,
//                 // height: 200,
//               ),
//             );
//           },
//         ),
//       );
//
//       // Add a new page to the PDF
//       // final PdfPage page = document.pages.add();
//
//       // Draw the image on the page
//       // final PdfGraphics graphics = page.graphics;
//       // final PdfBitmap pdfImage = PdfBitmap(pngBytes);
//       // graphics.drawImage(pdfImage, const Rect.fromLTWH(0, 0, 500, 700)); // Adjust size as needed
//     }
//
//     // Save the PDF to bytes
//     List<int> bytes = await pdf.save();
//     // pdf.dispose();
//
//     // Trigger a download of the PDF file
//     final blob = html.Blob([bytes]);
//     final url = html.Url.createObjectUrlFromBlob(blob);
//     final anchor = html.document.createElement('a') as html.AnchorElement
//       ..href = url
//       ..style.display = 'none'
//       ..download = 'images.pdf'; // Set the PDF file name
//     html.document.body!.children.add(anchor);
//     anchor.click();
//     html.document.body!.children.remove(anchor);
//     html.Url.revokeObjectUrl(url);
//   } catch (e) {
//     print('Error saving widgets as PDF: $e');
//   }
// }
