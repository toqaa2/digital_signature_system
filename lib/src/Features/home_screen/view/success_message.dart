import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/Features/home_screen/view/home_screen.dart';
import 'package:signature_system/src/Features/layout/view/layout_screen.dart';
import 'package:signature_system/src/core/style/colors.dart';

import '../../../core/shared_widgets/custom_button.dart';

class SuccessMessage extends StatelessWidget {
  const SuccessMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height:MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(150),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/Sucssess.svg',
            height: 120,
          ),
          Text("Request Sent Successfully",style: TextStyle(color: AppColors.mainColor,fontSize: 16,fontWeight: FontWeight.bold),),
          Text("Follow up it’s Status at Your Requests",style: TextStyle(color: Colors.grey,fontSize: 10)),
          ButtonWidget(
            onTap: (){
              // FormModel? formModel = await homeCubit.getForm();
              // if (formModel != null && context.mounted) {
              //   Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => RecivedRequestWidget(
              //       form: formModel,
              //       cubit: cubit,
              //     ),
              //   ));
              // }
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LayoutScreen(),));
            },
            minWidth: 350,
            height: 45,
            textStyle: TextStyle(fontSize: 14,color: Colors.white),
            text: "Home",
          ),
        ],
      ),
    );
  }
}
