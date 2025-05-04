import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:signature_system/src/core/style/colors.dart';

import '../../../../core/shared_widgets/custom_button.dart';
import '../../manager/home_cubit.dart';

class SendRequestEmails extends StatefulWidget {
  final HomeCubit cubit;

  const SendRequestEmails({super.key, required this.cubit});

  @override
  State<SendRequestEmails> createState() => _SendRequestEmailsState();
}

class _SendRequestEmailsState extends State<SendRequestEmails> {
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
          2.isHeight,
          Text("Select your Manager",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color:AppColors.mainColor ),),
          10.isHeight,
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
              return widget.cubit.userEmails.where((email) =>
                  email.toLowerCase().contains(textEditingValue.text.toLowerCase()));
            },
            onSelected: (String email) {
              setState(() {
                widget.cubit.selectedEmail = email;
              });
            },
            fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Search and select email',
                  hintStyle: TextStyle(fontSize: 12),
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          10.isHeight,
          ButtonWidget(
              verticalMargin: 2,
              minWidth: 120,
              height: 35,
              textStyle: TextStyle(
                  fontSize: 12, color: Colors.white),
              text: "Add Email",
              onTap: widget.cubit.selectedEmail == null
                  ? (){}
                  : () => widget.cubit.addToRequiredToSign(email: widget.cubit.selectedEmail!,context:  context),
          ),
          // ElevatedButton(
          //   onPressed: widget.cubit.selectedEmail == null
          //       ? null
          //       : () => widget.cubit.addToRequiredToSign(widget.cubit.selectedEmail!,context),
          //   child: Text('Add to Required To Sign'),
          // ),
          15.isHeight,
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final cubit = context.read<HomeCubit>();
              return SizedBox(
                height: 100.h,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                    if(cubit.requiredEmails.isNotEmpty)  Text('It will be sent to :'),

                      ...cubit.requiredEmails.reversed.toList().map((email) {
                      return Row(
                        children: [
                          SvgPicture.asset('email_icon.svg', width: 20, height: 20),
                          2.isWidth,
                          Text(email, style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Spacer(),
                          IconButton(onPressed: (){
                            cubit.removeEmail(email: email, context: context);
                          }, icon: Icon(Icons.delete,color: Colors.redAccent,))
                        ],
                      );
                    }),

                      if(cubit.requiredEmails.isNotEmpty)                      Text("Then :"),

                      ...cubit.selectedFormModel!.requiredToSign!.map((email) {
                        return Row(
                          children: [
                            SvgPicture.asset('email_icon.svg', width: 20, height: 20),
                            2.isWidth,
                            Text(email, style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Spacer(),
                            IconButton(onPressed: (){
                              cubit.removeEmail(email: email, context: context);
                            }, icon: Icon(Icons.delete,color: Colors.redAccent,))
                          ],
                        );
                      }),

                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
