import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/models/form_model.dart';

class SignaturesTableWidget extends StatelessWidget {
  const SignaturesTableWidget({super.key, required this.signatures});

  final List<SignatureModel>? signatures;

  @override
  Widget build(BuildContext context) {
    if (signatures != null) {
      return AspectRatio(
        aspectRatio: 5/7,
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(),
            verticalInside: BorderSide(),
            top: BorderSide(),
            bottom: BorderSide(),
            left: BorderSide(),
            right: BorderSide(),
          ),
          children: [
            TableRow(children: [
              TableCell(child: Text('Name')),
              TableCell(child: Text('Signature')),
            ]),
            ...signatures!.map(
              (e) => TableRow(children: [
                TableCell(child: Text(e.name)),
                TableCell(
                    child: Image.network(
                  e.signatureLink,
                  height: 100.h,
                  width: 50.w,
                ))
              ]),
            )
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
