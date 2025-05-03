import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewSinglePageWithSignature extends StatefulWidget {
  const ViewSinglePageWithSignature({
    super.key,
    required this.formModel,
    required this.documentBytes,
    required this.page,
    this.paintKey,
  });

  final FormModel formModel;
  final Uint8List documentBytes;
  final int page;
  final GlobalKey<State<StatefulWidget>>? paintKey;

  @override
  State<ViewSinglePageWithSignature> createState() =>
      _ViewSinglePageWithSignatureState();
}

class _ViewSinglePageWithSignatureState extends State<ViewSinglePageWithSignature> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.paintKey,
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            width: 1100,
            height: 1410,
            child: SfPdfViewer.memory(
              widget.documentBytes,
              initialPageNumber: widget.page + 1,
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
          ...AppFunctions.viewSignatures(widget.formModel, widget.page),
          Container(
            width: 1100,
            height: 1410,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
