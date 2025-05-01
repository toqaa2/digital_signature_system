import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/helper/enums/form_enum.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;

class AppFunctions {
  static List<Widget> viewSignatures(FormModel form, int index) {
    List<Widget> widgets = [];
    form.signedBy?.forEach((element) {
      for (SignatureModel e in element.signatureModelList) {
        if (e.page == index) {
          widgets.add(Positioned(
            left: e.signatureX.toDouble(),
            top: e.signatureY.toDouble(),
            child: Image.network(
              element.signatureLink,
              fit: BoxFit.contain,
              width: e.scale.toDouble(),
              height: e.scale.toDouble() / 2,
            ),
          ));
        }
      }
    });
    return widgets;
  }

  static SystemRoleEnum getSystemRole(String systemRole) {
    switch (systemRole) {
      case 'view_download_all':
        return SystemRoleEnum.canViewAndDownloadAllForms;
      default:
        return SystemRoleEnum.none;
    }
  }

  static sendEmailTo(
      {required String toEmail, required String fromEmail}) async {
    print(toEmail);
    print(fromEmail);
    var response = await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {
        'Content-Type': "application/json",
      },
      body: json.encode({
        'service_id': "service_onxkzts",
        'template_id': "template_sje8e6m",
        'user_id': "uKgn4fDs-ds-799qo",
        'template_params': {
          'to_email': toEmail,
          'from_name': Constants.userModel?.name,
          'from_email': fromEmail,
        },
      }),
    );
    print(response.body);
  }

  static img.Image imageDecode(Uint8List imageData) {
    return img.decodeImage(imageData)!;
  }

  static Future<Uint8List> saveWidgetsAsPdf(List<GlobalKey> globalKeys) async {
    if (globalKeys.isEmpty) {
      throw ArgumentError(
          'The number of global keys must match the number of image names.');
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
        RenderRepaintBoundary boundary = globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        // Get the original size of the widget
        double originalWidth = boundary.size.width;
        double originalHeight = boundary.size.height;
        print(originalWidth);
        print(originalHeight);

        ui.Image image = await boundary.toImage(
            pixelRatio: 3.0); // Increase pixel ratio for better quality
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();
        // Calculate the aspect ratio of the original image
        final double aspectRatio = originalWidth / originalHeight;

        // Define the page format and size. Match the image's aspect ratio for best results
        PdfPageFormat pageFormat =
            PdfPageFormat(originalWidth, originalHeight, marginAll: 0);
        // Add a page with the image
        pdf.addPage(
          pw.Page(
            pageFormat: pageFormat,
            build: (pw.Context context) {
              return pw.Center(
                  child: pw.Image(
                fit: pw.BoxFit.fill,
                pw.MemoryImage(pngBytes),
              ));
            },
          ),
        );
      }

      // Save the PDF to bytes
      Uint8List bytes = await pdf.save();
      // downloadPdf(bytes);
      return bytes;
      // Trigger a download of the PDF file
    } catch (e) {
      print('sign pdf error: $e');
      return [] as Uint8List;
    }
  }

  static downloadPdf(String link) {
    try {
      final url = link;
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'images.pdf'; // Set the PDF file name
      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Error saving widgets as PDF: $e');
    }
  }
}
