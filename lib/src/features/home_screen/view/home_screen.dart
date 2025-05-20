import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:signature_system/src/features/home_screen/view/widgets/success_condition.dart';
import '../../../core/constants/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/style/colors.dart';
import '../manager/home_cubit.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchForms()..fetchUserEmails()..getAllForms(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          final isAdmin = Constants.userModel?.email == "t.hesham@waseela-cf.com";

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.9,
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: isAdmin
                      ? DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.black,
                          indicatorColor: Colors.blue,
                          tabs: const [

                            Tab(text: "Dashboard"),
                            Tab(text: "Send Request"),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: TabBarView(
                            children: [
                              cubit.isLoadingDashboard == true?
                              Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.mainColor,
                                ),
                              ):

                              EmailGridWidget(emailDataList: cubit.allFormsView,),
                              ConditionalStepWidget(cubit: cubit),
                              // YourOtherWidget(), // Replace with your actual widget
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConditionalStepWidget(cubit: cubit),
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
class EmailGridWidget extends StatelessWidget {
  final List<FormModel> emailDataList;

  const EmailGridWidget({super.key, required this.emailDataList});

  @override
  Widget build(BuildContext context) {
    return
      MasonryGridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: emailDataList.length,
        itemBuilder: (context, index) {
          final item = emailDataList[index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
              item.isFullySigned==true?

                  Colors.green.withAlpha(30)
                  :
              Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Sent by: ${item.sentBy}",style: TextStyle(color: AppColors.mainColor),),
                Text("Sent Date: ${DateFormat('yyy/MM/dd hh:mm a').format(
                    DateTime.fromMicrosecondsSinceEpoch(
                        item.sentDate?.microsecondsSinceEpoch ?? 0))}"),
                const Divider(),

                Text("Required to Sign", style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.mainColor)),
                if (item.sentTo != null && item.sentTo!.isNotEmpty)
                  ...item.sentTo!.map((e) => Text(e)).toList(),
                const Divider(),
                 Text("Signed By", style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.mainColor)),
                if (item.signedBy != null && item.signedBy!.isNotEmpty)
                  ...item.signedBy!.map((e) => Text(e.email)).toList(),
              ],
            ),
          );
        },
      );
  }
}