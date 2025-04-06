import 'package:flutter/material.dart';
import 'package:signature_system/src/Features/requests/view/widgets/received_requests_view.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/style/colors.dart';
import 'package:http/http.dart' as http;

import '../../manager/requests_cubit.dart';
import 'package:intl/intl.dart' as intl;

class RecivedRequestWidget extends StatefulWidget {
  RecivedRequestWidget({super.key, required this.cubit});

  final RequestsCubit cubit;

  @override
  State<RecivedRequestWidget> createState() => _RecivedRequestWidgetState();
}

class _RecivedRequestWidgetState extends State<RecivedRequestWidget> {
  @override
  void initState() {
    super.initState();

    widget.cubit.getReceivedForms(Constants.userModel?.userId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return widget.cubit.state is LoadingReceivedForms
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: widget.cubit.receivedForms.length,
            itemBuilder: (context, index) {
              final receivedForm = widget.cubit.receivedForms[index];
              return ListTile(
                title: Text(
                  receivedForm.formTitle.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.bold),
                ),

                subtitle: Text(
                  receivedForm.formName.toString(),
                  // "Payment Request Memo",
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Column(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sent By: ${receivedForm.sentBy.toString()}",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "at: ${intl.DateFormat('yyy-MM-dd hh:mm a').format(DateTime.fromMicrosecondsSinceEpoch(receivedForm.sentDate?.microsecondsSinceEpoch ?? 0))}",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => ReceivedFormsView(
                        cubit: widget.cubit,
                        formModel: receivedForm,
                        formLink: receivedForm.formLink!,
                        formName: receivedForm.formName.toString(),
                        sentDate: intl.DateFormat('yyy-MM-dd hh:mm a').format(
                          DateTime.fromMicrosecondsSinceEpoch(
                              receivedForm.sentDate?.microsecondsSinceEpoch ??
                                  0),
                        )),
                  ))
                      .then((onValue) {
                    widget.cubit
                        .getReceivedForms(Constants.userModel?.userId ?? '');
                  });
                },
              );
            },
          );
  }
}
