import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:signature_system/src/features/requests/presentation/view/widgets/view_signed_document.dart';

class SignedDocumentScreen extends StatelessWidget {
  const SignedDocumentScreen({
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
        body: Padding(
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
                        bool isSigned = form.signedBy!.any(
                          (element) => element.email == form.sentTo![index],
                        );
                        return Row(
                          spacing: 5,
                          children: [
                            SvgPicture.asset(
                              isSigned
                                  ? 'assets/Signed status.svg'
                                  : 'assets/pending_status.svg',
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
                              form.sentDate!.microsecondsSinceEpoch))),
                    ],
                  )
                ],
              ),
              ViewSignedDocumentWidget(
                formModel: form,
                canDownload: canDownload,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
