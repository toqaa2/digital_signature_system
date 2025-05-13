import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature_system/src/features/requests/presentation/manager/requests_cubit.dart';
import 'package:signature_system/src/features/requests/presentation/view/screens/signed_document_screen.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/shared_widgets/searchable_dropdown.dart';
import 'package:signature_system/src/core/style/colors.dart';
import 'package:intl/intl.dart';

class SentRequestsScreen extends StatefulWidget {
  const SentRequestsScreen({super.key, required this.cubit});

  final RequestsCubit cubit;

  @override
  State<SentRequestsScreen> createState() => _SentRequestsScreenState();
}

class _SentRequestsScreenState extends State<SentRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    widget.cubit.getSentForms(Constants.userModel?.userId ?? '');

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: widget.cubit.state is LoadingSentForms
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withAlpha(150),
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SearchableDropdown(
                      onReset: (){
                        widget.cubit.getSentForms(Constants.userModel?.userId??'');
                      },
                      onDateChanged: (p0) {
                        if (_tabController.index == 0) {
                          widget.cubit.dateQueryPending(p0);
                        } else {
                          widget.cubit.dateQueryFullySigned(p0);
                         }
                      },
                      onSelected: (p0) {
                        if (_tabController.index == 0) {
                          widget.cubit.searchPendingRequests(p0);
                        } else {
                          widget.cubit.searchFullySignedRequests(p0);
                        }
                      },
                    ),
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: [
                        Tab(text: 'Pending Requests'),
                        Tab(text: 'Signed Requests'),
                      ],
                      labelColor: AppColors.mainColor,
                      indicatorColor: AppColors.mainColor,
                      indicatorWeight: 4.0,
                      unselectedLabelColor: Colors.grey.shade400,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SentListView(
                            cubit: widget.cubit,
                          ),
                          FullSignedListView(
                            cubit: widget.cubit,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class SentListView extends StatelessWidget {
  const SentListView({super.key, required this.cubit});

  final RequestsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cubit.sentFormsView.length,
      itemBuilder: (context, index) {
        final sentForm = cubit.sentFormsView[index];
        return ListTile(
          title: Text(
            sentForm.formTitle.toString(),
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            sentForm.formName.toString(),
            style: TextStyle(fontSize: 12),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                width: 170,
                child: Row(
                  spacing: 5,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.mainColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(4)),
                      height: 30,
                      width: 80,
                      child: Center(
                        child: Text(
                          "Pending",
                          style: TextStyle(color: AppColors.mainColor, fontSize: 12),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        cubit.deleteSentDocument(
                          userId: Constants.userModel!.userId,
                            formID: sentForm.formID!,
                            emailsToRemoveFrom: sentForm.sentTo!);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(4)),
                        height: 30,
                        width: 80,
                        child: Center(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                DateFormat('yyy/MM/dd hh:mm a').format(
                    DateTime.fromMicrosecondsSinceEpoch(
                        sentForm.sentDate?.microsecondsSinceEpoch ?? 0)),
                // "at 01/23/2025  03:25 PM",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SignedDocumentScreen(
                  formModel: sentForm,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class FullSignedListView extends StatelessWidget {
  const FullSignedListView({super.key, required this.cubit});

  final RequestsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cubit.fullySignedView.length,
      itemBuilder: (context, index) {
        final fullSigned = cubit.fullySignedView[index];
        return ListTile(
          title: Text(
            fullSigned.formTitle.toString(),
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            fullSigned.formName.toString(),
            style: TextStyle(fontSize: 12),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.greenAccent.withAlpha(30),
                    borderRadius: BorderRadius.circular(4)),
                height: 30,
                width: 100,
                child: Center(
                  child: Text(
                    "Signed",
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                DateFormat('yyy/MM/dd hh:mm a').format(
                    DateTime.fromMicrosecondsSinceEpoch(
                        fullSigned.sentDate?.microsecondsSinceEpoch ?? 0)),
                // "at 01/23/2025  03:25 PM",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SignedDocumentScreen(
                formModel: fullSigned,
              ),
            ));
          },
        );
      },
    );
  }
}
