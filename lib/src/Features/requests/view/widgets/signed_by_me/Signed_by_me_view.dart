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
                            Text(form.signedBy![index]),
                          ],
                        ))
                      ],
                    ),
                    Text(
                    "${intl.DateFormat('yyy-MM-dd hh:mm a').format(DateTime.fromMicrosecondsSinceEpoch(form.sentDate?.microsecondsSinceEpoch??0))}"
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
