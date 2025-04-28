import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../core/models/form_model.dart';
import 'package:intl/intl.dart' as intl;


class SignedByMeView extends StatelessWidget {
  const SignedByMeView(
      {super.key,
        required this.form,
        });

  final FormModel form;


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
                        Text("Form Is Signed By"),
                        ...List.generate(form.signedBy!.length,  (index)=> Row(
                          spacing: 4,
                          children: [
                            SvgPicture.asset('assets/Signed status.svg',width: 22,height: 22,),
                            Text(form.signedBy![index].email),
                          ],
                        ))
                      ],
                    ),
                    Text(
                    intl.DateFormat('yyy-MM-dd hh:mm a').format(DateTime.fromMicrosecondsSinceEpoch(form.sentDate?.microsecondsSinceEpoch??0))
                        )
                  ],
                ),
                SizedBox(
                  width: 1100,
                  height: 1410,
                  child: Stack(
                    children: [
                      SfPdfViewer.network(
                        form.formLink!,
                      ),
                      ...form.signedBy?.map((e) =>  Positioned(
                        left: e.signatureX.toDouble(),
                        top: e.signatureY.toDouble(),
                        child: Image.network(
                          e.signatureLink,
                          fit: BoxFit.contain,
                          width: e.scale.toDouble(),
                          height: e.scale.toDouble() / 2,
                        ),
                      ),)??[]
                    ],
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
