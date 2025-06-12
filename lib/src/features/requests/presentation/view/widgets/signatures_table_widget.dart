import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:signature_system/src/core/style/colors.dart';

class SignaturesTableWidget extends StatelessWidget {
  const SignaturesTableWidget({super.key, required this.signatures});

  final List<SignatureModel>? signatures;

  @override
  Widget build(BuildContext context) {
    if (signatures != null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical:  50.0),
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: SizedBox(
            width: 250.w,
            child: Table(
              border: TableBorder(
                borderRadius: BorderRadius.circular(8),
                horizontalInside: BorderSide(color: Colors.grey.shade300,),
                verticalInside: BorderSide(color: Colors.grey.shade300),
                top: BorderSide(color: Colors.grey.shade300),
                bottom: BorderSide(color: Colors.grey.shade300),
                left: BorderSide(color: Colors.grey.shade300),
                right: BorderSide(color: Colors.grey.shade300),
              ),
              children: [
                TableRow(children: [
                  TableCell(child: Center(child: Text('Name',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color: AppColors.mainColor)))),
                  TableCell(child: Center(child: Text('Signature',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color: AppColors.mainColor)))),
                ]),
                ...signatures!.map(
                  (e) => TableRow(children: [
                    TableCell(child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(child: Text(e.name,textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))),
                    )),
                    TableCell(
                        child: Image.network(
                      e.signatureLink,
                      height: 75.h,
                      width: 30.w,
                    ))
                  ]),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
