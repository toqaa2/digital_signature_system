import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature_system/src/Features/home_screen/view/widgets/success_condtion.dart';
import '../manager/home_cubit.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchForms(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          bool showSingleSelector = (cubit.selectedItem == 'Payment Request Memo' && cubit.currentStep < 4) ||
              (cubit.selectedItem != 'Payment Request Memo' && cubit.currentStep < 3);
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConditionalStepWidget(
                        cubit: cubit,
                      )

                      // Column(
                      //   children: [
                      //     CustomStepper(
                      //       cubit: cubit,
                      //     ),
                      //     const SizedBox(height: 20),
                      //     // Center widget
                      //
                      //     Container(
                      //       padding: const EdgeInsets.symmetric(vertical: 30.0),
                      //       decoration: BoxDecoration(
                      //           color: Colors.white.withAlpha(150),
                      //           borderRadius: BorderRadius.circular(12),
                      //         border: Border.all(color: Colors.grey.shade300),
                      //       ),
                      //       child: Column(
                      //         children: [
                      //           cubit.selectedItem == 'Payment Request Memo'
                      //               ? StepSwitcher4Steps(cubit: cubit)
                      //               : StepSwitcher3Steps(cubit: cubit),
                      //           15.isHeight,
                      //           // Buttons
                      //           Padding(
                      //             padding: EdgeInsets.symmetric(horizontal: 20.w),
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.end,
                      //               children: [
                      //                 ElevatedButtonWithIcon(
                      //                   onPressed: cubit.currentStep > 0
                      //                       ? () {
                      //                           cubit.changeStepPrev();
                      //                         }
                      //                       : () {},
                      //                   backgroundColor: cubit.currentStep > 0
                      //                       ? Colors.white
                      //                       : Colors.grey.shade300,
                      //                   label: 'Previous',
                      //                   border: cubit.currentStep > 0,
                      //                   icon: const Icon(
                      //                       Icons.keyboard_arrow_left_rounded),
                      //                   iconPosition: IconPosition.leading,
                      //                 ),
                      //                 2.isWidth,
                      //                 ElevatedButtonWithIcon(
                      //                   border: false,
                      //                   backgroundColor: AppColors.mainColor,
                      //                   onPressed: () {
                      //                     if (cubit.currentStep < 2) {
                      //                       cubit.changeStepNext();
                      //                     } else if (cubit.selectedItem ==
                      //                             'Payment Request Memo' &&
                      //                         cubit.currentStep < 4) {
                      //                       cubit.changeStepNext();
                      //                     }
                      //                   },
                      //                   label: 'Next',
                      //                   textColor: Colors.white,
                      //                   icon: Icon(
                      //                     Icons.keyboard_arrow_right_rounded,
                      //                     color: Colors.white,
                      //                   ),
                      //                   iconPosition: IconPosition.trailing,
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
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
