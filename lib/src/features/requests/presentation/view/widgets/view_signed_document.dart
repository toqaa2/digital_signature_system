import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:signature_system/src/core/shared_widgets/custom_button.dart';
import 'package:signature_system/src/features/requests/presentation/view/widgets/signatures_table_widget.dart';
import 'package:signature_system/src/features/requests/presentation/view/widgets/view_single_page_with_signature.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ViewSignedDocumentWidget extends StatefulWidget {
  const ViewSignedDocumentWidget({
    super.key,
    required this.formModel,
    this.canDownload = false,
  });

  final FormModel formModel;
  final bool canDownload;

  @override
  State<ViewSignedDocumentWidget> createState() => _ViewSignedDocumentWidgetState();
}

class _ViewSignedDocumentWidgetState extends State<ViewSignedDocumentWidget> {
  int pageCount = 0;

  Uint8List? documentBytes;

  List<GlobalKey<State<StatefulWidget>>> paintKeys = [];

  List<Widget> pdfPageSignatures = [];

  Future<void> loadPdfFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        documentBytes = response.bodyBytes;
        final PdfDocument document = PdfDocument(inputBytes: documentBytes!);
        pageCount = document.pages.count;
        document.dispose();
        paintKeys = List.generate(pageCount + 1, (index) => GlobalKey<State<StatefulWidget>>());
        pdfPageSignatures = List.generate(
          pageCount,
          (index) => ViewSinglePageWithSignature(
            paintKey: paintKeys[index],
            formModel: widget.formModel,
            documentBytes: documentBytes!,
            page: index,
          ),
        );
        setState(() {});
      } else {
        debugPrint('Failed to load PDF: ${response.statusCode}');
      }
    } catch (e) {
      showDialog(
        context: context.mounted ? context : context,
        builder: (context) => AlertDialog(
          content: Text('Please Try Again '),
        ),
      );
      debugPrint('Error in received widget view is : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadPdfFromUrl(widget.formModel.formLink ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (widget.canDownload)
            ButtonWidget(
              minWidth: 40.w,
              onTap: () {
                AppFunctions.saveWidgetsAsPdf(
                  paintKeys,
                  widget.formModel.formName ?? 'Document',
                );
              },
              text: 'Download',
            ),
          Expanded(
              child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ...pdfPageSignatures,
                  if (paintKeys.isNotEmpty)
                    RepaintBoundary(
                        key: paintKeys[paintKeys.length - 1],
                        child: SignaturesTableWidget(signatures: widget.formModel.signedBy))
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
