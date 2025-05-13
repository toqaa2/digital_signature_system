import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/shared_widgets/searchable_dropdown.dart';
import 'package:signature_system/src/core/style/colors.dart';

import 'package:intl/intl.dart';
import 'package:signature_system/src/features/requests/presentation/manager/requests_cubit.dart';
import 'package:signature_system/src/features/requests/presentation/view/screens/signed_document_screen.dart';

class SignedByMeScreen extends StatefulWidget {
  const SignedByMeScreen({super.key, required this.cubit});


  final RequestsCubit cubit;

  @override
  State<SignedByMeScreen> createState() => _SignedByMeScreenState();
}

class _SignedByMeScreenState extends State<SignedByMeScreen> {
  @override
  void initState() {
    super.initState();
    widget.cubit.getReceivedForms(Constants.userModel?.userId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return widget.cubit.state is LoadingReceivedForms
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              SearchableDropdown(
                onReset: () {
                  widget.cubit
                      .getReceivedForms(Constants.userModel?.userId ?? '');
                },
                onDateChanged: (p0) {
                  widget.cubit.dateQuerySignedByMe(p0);
                },
                onSelected: (p0) {
                  widget.cubit.searchSignedByMe(p0);
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cubit.signedByMeView.length,
                  itemBuilder: (context, index) {
                    final signedByMe = widget.cubit.signedByMeView[index];
                    return ListTile(
                      leading: signedByMe.isFullySigned??false
                          ? SvgPicture.asset(
                              'Signed.svg',
                              width: 40,
                              height: 35,
                            )
                          : SvgPicture.asset(
                              'pending.svg',
                              width: 40,
                              height: 35,
                            ),
                      // textColor: Color(0xFFF6F6F6),
                      title: Text(
                        signedByMe.formName.toString(),
                        // "Payment Request Memo",
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        signedByMe.sentBy.toString(),
                        // "Email@Waseela-cf.com",
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        DateFormat('yyy-MM-dd hh:mm a').format(
                            DateTime.fromMicrosecondsSinceEpoch(
                                signedByMe.sentDate?.microsecondsSinceEpoch ??
                                    0)),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignedDocumentScreen(
                            formModel: signedByMe,
                          ),
                        ));
                      },
                    );
                  },
                ),
              ),
            ],
          );
  }
}
