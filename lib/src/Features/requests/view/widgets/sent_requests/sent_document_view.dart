import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/Features/requests/manager/requests_cubit.dart';
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:signature_system/src/core/shared_widgets/custom_button.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SentDocumentView extends StatefulWidget {
  const SentDocumentView({
    super.key,
    required this.form,
    this.canDownload = false,
  });

  final FormModel form;
  final bool canDownload;

  @override
  State<SentDocumentView> createState() => _SentDocumentViewState();
}

class _SentDocumentViewState extends State<SentDocumentView> {
  List<Widget> signatures = [];

  @override
  void initState() {
    super.initState();
    // signatures=AppFunctions.viewSignatures(form, index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/background.png"), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              spacing: 20,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.form.formName!),
                        ...List.generate(widget.form.sentTo!.length, (index) {
                          bool isSigned = widget.form.signedBy!.any(
                            (element) =>
                                element.email == widget.form.sentTo![index],
                          );
                          return Row(
                            spacing: 5,
                            children: [
                              SvgPicture.asset(
                                isSigned
                                    ? 'assets/Signed status.svg'
                                    : 'assets/pendingstatus.svg',
                                width: 22,
                                height: 22,
                              ),
                              Text(widget.form.sentTo![index]),
                            ],
                          );
                        })
                      ],
                    ),
                    Column(
                      children: [
                        Text(intl.DateFormat('yyy-MM-dd hh:mm a').format(
                            DateTime.fromMicrosecondsSinceEpoch(
                                widget.form.sentDate!.microsecondsSinceEpoch ??
                                    0))),
                        if (widget.canDownload)
                          ButtonWidget(
                            minWidth: 40.w,
                            onTap: () {
                              AppFunctions.downloadPdf(
                                  widget.form.formLink ?? '');
                            },
                            text: 'Download',
                          ),
                      ],
                    )
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 1100,
                      height: 1410,
                      child: SfPdfViewer.network(
                        widget.form.formLink!,
                      ),
                    ),
                    Container(
                      width: 1100,
                      height: 1410,
                      color: Colors.transparent,
                    ),
                    // ... RequestsCubit.viewSignatures(form),

                    // ...form.signedBy?.map(
                    //       (e) => Positioned(
                    //     left: e.signatureX.toDouble(),
                    //     top: e.signatureY.toDouble(),
                    //     child: Image.network(
                    //       e.signatureLink,
                    //       fit: BoxFit.contain,
                    //       width: e.scale.toDouble(),
                    //       height: e.scale.toDouble() / 2,
                    //     ),
                    //   ),
                    // ) ??
                    //     []
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
