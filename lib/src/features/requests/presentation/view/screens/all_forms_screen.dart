import 'package:flutter/material.dart';
import 'package:signature_system/src/features/requests/presentation/manager/requests_cubit.dart';
import 'package:signature_system/src/features/requests/presentation/view/screens/signed_document_screen.dart';
import 'package:signature_system/src/core/shared_widgets/searchable_dropdown.dart';
import 'package:signature_system/src/core/style/colors.dart';
import 'package:intl/intl.dart' as intl;

class AllFormsScreen extends StatefulWidget {
  const AllFormsScreen({super.key, required this.cubit});

  final RequestsCubit cubit;

  @override
  State<AllFormsScreen> createState() => _AllFormsScreenState();
}

class _AllFormsScreenState extends State<AllFormsScreen> {
  @override
  void initState() {
    super.initState();
    widget.cubit.getFullySignedForms();
  }

  @override
  Widget build(BuildContext context) {
    return widget.cubit.state is GetAllFormsLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              SearchableDropdown(
                onReset: () {
                  widget.cubit.getFullySignedForms();
                },
                onDateChanged: (p0) {
                  widget.cubit.dateQueryAllForms(p0);
                },
                onSelected: (p0) {
                  widget.cubit.searchAllForms(p0);
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cubit.allFormsView.length,
                  itemBuilder: (context, index) {
                    final receivedForm = widget.cubit.allFormsView[index];
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
                          builder: (context) => SignedDocumentScreen(
                            form: receivedForm,
                            canDownload: true,
                          ),
                        ))
                            .then((onValue) {
                          // widget.cubit
                          //     .getReceivedForms(Constants.userModel?.userId ?? '');
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          );
  }
}
