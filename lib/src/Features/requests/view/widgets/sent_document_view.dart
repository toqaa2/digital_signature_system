import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SentDocumentView extends StatelessWidget {
  const SentDocumentView(
      {super.key,
      required this.formLink,
      required this.sentDate,
      required this.requiredToSign,
      required this.formName});

  final String formLink;
  final String sentDate;
  final String formName;
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
                        Text(formName),
                        ...List.generate(requiredToSign.length,  (index)=> Row(
                          spacing: 4,
                          children: [
                            SvgPicture.asset('assets/Signed status.svg',width: 22,height: 22,),
                            Text(requiredToSign[index]),
                          ],
                        ))
                      ],
                    ),
                    Text(sentDate)
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 1,
                  child: SfPdfViewer.network(
                    formLink,
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
