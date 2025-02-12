import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Step2Screen extends StatelessWidget {
  const Step2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 15),
    child: Column(
      spacing: 25,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Please Download the Chosen form and fill it*",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Container(
              height: 50,
              width: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300)
              ),
              child: ListTile(
                leading:  SvgPicture.asset(
                  'assets/xxx-word.svg',
                  height: 30,
                ),
                title: Text("Payment Request Memo ",style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                trailing:  SvgPicture.asset(
                  'assets/downloadsvg.svg',
                  height: 30,
                ),
              ),
            ),
          ],
        ),
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Please Upload your form after fill it as a PDF File*",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Container(
              height: 50,
              width: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300)
              ),
              child: ListTile(
                leading:  SvgPicture.asset(
                  'assets/pdf.svg',
                  height: 30,
                ),
                title: Text("Payment Request Memo ",style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                trailing:  SvgPicture.asset(
                  'assets/UploadSvg.svg',
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    );
  }
}
