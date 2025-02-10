import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:signature_system/src/Features/login_screen/view/widgets/custom_text_field.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:signature_system/src/core/shared_widgets/custom_button.dart';
import 'package:signature_system/src/core/style/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/BackGround.png"),
              fit: BoxFit.fill)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: EdgeInsets.only(left: 20),
            child: SvgPicture.asset(
              'assets/Logo.svg',
              height: 50,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height*0.5,
            width: MediaQuery.of(context).size.height*0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.mainColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/Signup-logo.svg',
                        ),
                        5.isWidth,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  " to your Account ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              "Sign your Form Now, With Waseela’s Digital Signature System",
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    20.isHeight,
                    Textfield(

                      labelText: "Enter Your Email Address",
                    ),
                    10.isHeight,
                    Textfield(
                      labelText: "Enter Your Password",
                      trailingIcon: Icon(
                        Icons.visibility_off_sharp,
                        color: Colors.grey,
                        size: 18,
                      ),
                    ),
                    5.isHeight,
                    ButtonWidget(
                      onTap: (){},

                      minWidth: 400,
                      textStyle: TextStyle(fontSize: 14,color: Colors.white),
                      text: "Login",
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
