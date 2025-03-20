import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature_system/src/Features/requests/view/widgets/signed_by_me_widget.dart';
import 'package:signature_system/src/core/constants/constants.dart';
import 'package:signature_system/src/core/style/colors.dart';

import '../manager/requests_cubit.dart';
import 'widgets/recived_request_widget.dart';
import 'widgets/send_request_widget.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => RequestsCubit()..getSentForms(Constants.userModel!.userId!)..getReceivedForms(Constants.userModel!.userId!),
  child: BlocConsumer<RequestsCubit, RequestsState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    RequestsCubit cubit = RequestsCubit.get(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100.0),
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
                    Tab(text: 'Sent Requests'),
                    Tab(text: 'Received Requests'),
                    Tab(text: 'Signed By Me'),
                    Tab(text: 'Reversed'),
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
                      SentRequestsWidget(cubit: cubit,),
                      RecivedRequestWidget(cubit: cubit,),
                      SignedByMeWidget(cubit: cubit,),
                      Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  },
),
);
  }
}
