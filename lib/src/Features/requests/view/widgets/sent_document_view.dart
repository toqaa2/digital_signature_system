import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:intl/intl.dart' as intl;

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SentDocumentView extends StatelessWidget {
  const SentDocumentView(
      {super.key,
      required this.form,
      required this.requiredToSign,
     });

  final FormModel form;

  final List requiredToSign;

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/BackGround.png"), fit: BoxFit.fill),
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
                        ...List.generate(form.sentTo!.length,  (index){
                          bool isSigned = form.signedBy!.contains(form.sentTo![index]);
                          return Row(
                                      spacing: 5,
                                      children: [
                                        SvgPicture.asset(
                                          isSigned ? 'assets/Signed status.svg' : 'assets/pendingstatus.svg',
                                          width: 22,
                                          height: 22,
                                        ),
                                        Text(form.sentTo![index]),
                                      ],
                                    );
                        })
                      ],
                    ),

                    Text(intl.DateFormat('yyy-MM-dd hh:mm a').format(DateTime.fromMicrosecondsSinceEpoch(form.sentDate!.microsecondsSinceEpoch??0)))
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

