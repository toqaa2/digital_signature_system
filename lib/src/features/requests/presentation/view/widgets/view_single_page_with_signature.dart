import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:signature_system/src/features/requests/presentation/view/widgets/signatures_table_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewSinglePageWithSignature extends StatefulWidget {
  const ViewSinglePageWithSignature({
    super.key,
    required this.formModel,
    required this.documentBytes,
    required this.page,
    required this.showTable,
    this.signatures,
  });

  final FormModel formModel;
  final Uint8List documentBytes;
  final int page;
  final bool showTable;
  final List<SignatureModel>? signatures;

  @override
  State<ViewSinglePageWithSignature> createState() => _ViewSinglePageWithSignatureState();
}

class _ViewSinglePageWithSignatureState extends State<ViewSinglePageWithSignature> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 5 / 7,
              child: SfPdfViewer.memory(
                widget.documentBytes,
                initialPageNumber: widget.page + 1,
                scrollDirection: PdfScrollDirection.vertical,
                pageLayoutMode: PdfPageLayoutMode.single,
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
            AspectRatio(
              aspectRatio: 5 / 7,
              child: Container(
                color: Colors.transparent,
              ),
            )
          ],
        ),
        if (widget.showTable) SignaturesTableWidget(signatures: widget.signatures)
      ],
    );
  }
}
