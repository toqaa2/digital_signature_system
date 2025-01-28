import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:signature_system/src/core/style/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: 300,
          width: 600,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.mainColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/Signup-logo.svg',),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Sign In",style: TextStyle(color: AppColors.mainColor,fontWeight: FontWeight.bold),),
                            Text(" to your Account ",style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Text("Sign your Form Now, With Waseela’s Digital Signature System",style: TextStyle(fontSize: 10),),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Textfield(
                ),
                SizedBox(height: 10,),
                Textfield(
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Textfield extends StatelessWidget {
  const Textfield({
    super.key,
  });

  @override
  Widget build(BuildContext context,) {

    return SizedBox(
        width: 400,
        // height: 45,
        child: TextField(

          style: const TextStyle(fontSize: 10),
          decoration: InputDecoration(
              labelText: "Enter Your Email Address",
              labelStyle: const TextStyle(fontSize: 10),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: AppColors.mainColor),
                borderRadius: BorderRadius.circular(4),

              ),
              enabledBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),

              ) ,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),

              )
          ),
        )
    );
  }
}
