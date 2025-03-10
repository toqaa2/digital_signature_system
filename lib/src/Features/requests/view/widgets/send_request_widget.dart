import 'package:flutter/material.dart';
import 'package:signature_system/src/Features/requests/manager/requests_cubit.dart';
import 'package:signature_system/src/Features/requests/view/widgets/sent_document_view.dart';
import 'package:signature_system/src/core/style/colors.dart';
import 'package:intl/intl.dart' as intl;
class SentRequestsWidget extends StatelessWidget {
   SentRequestsWidget({super.key, required this.cubit});
 final RequestsCubit cubit;
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: cubit.sentForms.length,
      itemBuilder: (context, index) {
        final SentForm = cubit.sentForms[index];
        return  ListTile(

          // textColor: Color(0xFFF6F6F6),
          title: Text(
            SentForm.formName.toString(),
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(
           intl.DateFormat('yyy/MM/dd hh:mm a').format(DateTime.fromMicrosecondsSinceEpoch(SentForm.sentDate?.microsecondsSinceEpoch??0)),
            // "at 01/23/2025  03:25 PM",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: Container(
            decoration: BoxDecoration(
                color: AppColors.mainColor.withAlpha(30),
                borderRadius: BorderRadius.circular(4)),
            height: 30,
            width: 100,
            child: Center(
              child: Text(
                "Pending",
                style: TextStyle(color: AppColors.mainColor, fontSize: 12),
              ),
            ),
          ),
          onTap: () {
            print(SentForm.sentTo);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SentDocumentView(
              formLink: SentForm.formLink!,
              formName: SentForm.formName!,
              requiredToSign:SentForm.sentTo!,
              sentDate: intl.DateFormat('yyy/MM/dd hh:mm a').format(DateTime.fromMicrosecondsSinceEpoch(SentForm.sentDate?.microsecondsSinceEpoch??0)),
            ),));
          },
        );
      },
    );
  }
}

