import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/core/functions/app_functions.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:signature_system/src/core/shared_widgets/custom_button.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SentDocumentView extends StatelessWidget {
  const SentDocumentView({
    super.key,
    required this.form,
    this.canDownload = false,
  });

  final FormModel form;
  final bool canDownload;

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
                        Text(form.formName!),
                        ...List.generate(form.sentTo!.length, (index) {
                          bool isSigned =
                              form.signedBy!.contains(form.sentTo![index]);
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
                              Text(form.sentTo![index]),
                            ],
                          );
                        })
                      ],
                    ),
                    Column(
                      children: [
                        Text(intl.DateFormat('yyy-MM-dd hh:mm a').format(
                            DateTime.fromMicrosecondsSinceEpoch(
                                form.sentDate!.microsecondsSinceEpoch ?? 0))),
                        if (canDownload)
                          ButtonWidget(
                            minWidth: 40.w,
                            onTap: () {
                              AppFunctions.downloadPdf(form.formLink ?? '');
                            },
                            text: 'Download',
                          ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 1,
                  child: SfPdfViewer.network(
                    form.formLink!,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
