import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature_system/src/Features/requests/manager/requests_cubit.dart';
import 'package:signature_system/src/Features/requests/view/widgets/sent_document_view.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/style/colors.dart';
import 'package:intl/intl.dart' as intl;

class SentRequestsWidget extends StatefulWidget {
  const SentRequestsWidget({super.key, required this.cubit});

  final RequestsCubit cubit;

  @override
  _SentRequestsWidgetState createState() => _SentRequestsWidgetState();
}

class _SentRequestsWidgetState extends State<SentRequestsWidget> with SingleTickerProviderStateMixin {
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
                    color: Colors.white.withAlpha(150), borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
      itemCount: cubit.sentForms.length,
      itemBuilder: (context, index) {
        final sentForm = cubit.sentForms[index];
        return ListTile(
          title: Text(
            sentForm.formName.toString(),
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            intl.DateFormat('yyy/MM/dd hh:mm a').format(
                DateTime.fromMicrosecondsSinceEpoch(sentForm.sentDate?.microsecondsSinceEpoch ?? 0)),
            // "at 01/23/2025  03:25 PM",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: Container(
            decoration: BoxDecoration(
                color: AppColors.mainColor.withAlpha(30), borderRadius: BorderRadius.circular(4)),
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
            print(sentForm.sentTo);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SentDocumentView(
                  form: sentForm,
                  requiredToSign: sentForm.sentTo!,
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
      itemCount: cubit.fullSignedList.length,
      itemBuilder: (context, index) {
        final fullSigned = cubit.fullSignedList[index];
        return ListTile(
          title: Text(
            fullSigned.formName.toString(),
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            intl.DateFormat('yyy/MM/dd hh:mm a').format(
                DateTime.fromMicrosecondsSinceEpoch(fullSigned.sentDate?.microsecondsSinceEpoch ?? 0)),
            // "at 01/23/2025  03:25 PM",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: Container(
            decoration: BoxDecoration(
                color: Colors.greenAccent.withAlpha(30), borderRadius: BorderRadius.circular(4)),
            height: 30,
            width: 100,
            child: Center(
              child: Text(
                "Signed",
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ),
          ),
          onTap: () {
            print(fullSigned.sentTo);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SentDocumentView(
                form: fullSigned,
                requiredToSign: fullSigned.sentTo!,
              ),
            ));
          },
        );
      },
    );
  }
}
