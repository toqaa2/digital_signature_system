import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:signature_system/src/Features/login_screen/manager/login_cubit.dart';
import 'package:signature_system/src/Features/login_screen/view/widgets/custom_text_field.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:signature_system/src/core/shared_widgets/custom_button.dart';
import 'package:signature_system/src/core/style/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final LoginCubit cubit = LoginCubit.get(context);
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.png"), fit: BoxFit.fill),
            ),
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
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: SingleChildScrollView(
                      child: AutofillGroup(
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Sign your Form Now, With Waseela’s Digital Signature System",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            20.isHeight,
                            TextFieldWidget(
                              autoFillHints: [AutofillHints.newUsername, AutofillHints.username],

                              keyboardType: TextInputType.emailAddress,
                              onSubmitted: (p0) {},
                              controller: cubit.emailController,
                              labelText: "Enter Your Email Address",
                            ),
                            10.isHeight,
                            TextFieldWidget(
                              autoFillHints: [AutofillHints.password],

                              keyboardType: TextInputType.visiblePassword,
                              obscureText: cubit.isPasswordVisible ,
                              onSubmitted: (p0) {
                                cubit.login(context: context);
                              },
                              controller: cubit.passwordController,
                              labelText: "Enter Your Password",
                              trailingIcon: IconButton(
                                onPressed: () {
                                  cubit.togglePasswordVisibility();
                                },
                                icon: Icon(
                                  cubit.isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off_sharp,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                              ),
                            ),
                            5.isHeight,
                            state is Loading
                                ? Column(
                                    children: [
                                      20.isHeight,
                                      Center(
                                          child: CircularProgressIndicator(
                                        color: AppColors.mainColor,
                                      )),
                                    ],
                                  )
                                : ButtonWidget(
                                    onTap: () {
                                      cubit.login(context: context);
                                      // Navigator.of(context).pushAndRemoveUntil(
                                      //   MaterialPageRoute(
                                      //     builder: (context) => const LayoutScreen(),
                                      //   ),
                                      //       (route) => false,
                                      // );
                                    },
                                    minWidth: 500,
                                    textStyle: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                    text: "Login",
                                  ),
                          ],
                        ),
                      ),
                    ),
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
