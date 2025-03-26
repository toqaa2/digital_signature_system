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

    widget.cubit.getReceivedForms(Constants.userModel?.userId??'');
  }
  @override
  Widget build(BuildContext context) {
    return widget.cubit.state is LoadingReceivedForms
        ? const Center(child: CircularProgressIndicator())
        :ListView.builder(
      itemCount: widget.cubit.receivedForms.length,
      itemBuilder: (context, index) {
        final receivedForm = widget.cubit.receivedForms[index];
        return  ListTile(
          // textColor: Color(0xFFF6F6F6),
          title: Text(
              receivedForm.formName.toString(),
            // "Payment Request Memo",
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            receivedForm.sentBy.toString(),
            // "Email@Waseela-cf.com",
            style: TextStyle(
                fontSize: 12,
                color: AppColors.mainColor,
                fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            intl.DateFormat('yyy-MM-dd hh:mm a').format(DateTime.fromMicrosecondsSinceEpoch(receivedForm.sentDate?.microsecondsSinceEpoch??0)),

            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReceivedFormsView(
              cubit: widget.cubit,
              formModel: receivedForm,
              formLink: receivedForm.formLink!,
              formName:  receivedForm.formName.toString(),
              sentDate: intl.DateFormat('yyy-MM-dd hh:mm a').format(DateTime.fromMicrosecondsSinceEpoch(receivedForm.sentDate?.microsecondsSinceEpoch??0),)
            ) ,)).then((onValue){
              widget.cubit.getReceivedForms(Constants.userModel?.userId??'');

            });
          },
        ) ;
      },
    );


  }
}

