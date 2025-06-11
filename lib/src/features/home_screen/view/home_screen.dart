import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:signature_system/src/core/models/form_model.dart';
import 'package:signature_system/src/features/home_screen/view/widgets/success_condition.dart';
import '../../../core/constants/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/style/colors.dart';
import '../../requests/presentation/view/screens/signed_document_screen.dart';
import '../manager/home_cubit.dart';
import 'package:intl/intl.dart' as intl;



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchForms()..fetchUserEmails()..getAllForms()..getAllPaymentForms(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          final isAdmin = (Constants.userModel?.email == "t.hesham@waseela-cf.com"|| Constants.userModel?.email == "n.othman@waseela-cf.com");
          final isFinance = Constants.userModel?.department == "Finance";

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
                      : isFinance?
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.black,
                          indicatorColor: Colors.blue,
                          tabs: const [

                            Tab(text: "Fully Signed Payment Requests"),
                            Tab(text: "Send Request"),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: TabBarView(
                            children: [

                              cubit.isLoadingForms == true?
                              Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.mainColor,
                                ),
                              ):
                              Expanded(
                                child: ListView.builder(
                                  itemCount: cubit.allPaymentFormsView.length,
                                  itemBuilder: (context, index) {
                                    final receivedForm = cubit.allPaymentFormsView[index];
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
                                            formModel: receivedForm,
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
                              ConditionalStepWidget(cubit: cubit),
                              // YourOtherWidget(), // Replace with your actual widget
                            ],
                          ),
                        ),
                      ],
                    ),
                  ):
                  Column(
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
                Text("${item.formTitle}",style: TextStyle(color: AppColors.mainColor),),
                Text("Sent by: ${item.sentBy}",),
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