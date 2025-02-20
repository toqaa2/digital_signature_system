import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:signature_system/src/core/style/colors.dart';

import '../../manager/home_cubit.dart';

class SendRequestEmails extends StatelessWidget {
  final HomeCubit cubit;

  const SendRequestEmails({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Padding(padding:
    EdgeInsets.symmetric(horizontal: 100,vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Send Signature Request",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color:AppColors.mainColor ),),
          2.isHeight,
          Text("By Sending this Request it Will Automatic Send to these Officials",style: TextStyle(fontSize: 10,color:Colors.grey ),),
          15.isHeight,
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final cubit = context.read<HomeCubit>();
              return Column(
                spacing: 5,
                children: cubit.requiredEmails.map((email) {
                  return Row(
                    children: [
                      SvgPicture.asset('emailicon.svg', width: 20, height: 20),
                      2.isWidth,
                      Text(email, style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
