import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/features/login_screen/manager/login_cubit.dart';
import 'package:signature_system/src/features/login_screen/view/widgets/custom_text_field.dart';

import '../../../core/shared_widgets/custom_button.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = LoginCubit.get(context);
          return BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/Logo.svg',
                        height: 100,
                      ),
                      const Text('Change Your Password'),
                      TextFieldWidget(
                        controller: cubit.passwordController,
                        labelText: "Change Your Password",
                      ),
                      state is ChangePasswordLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ButtonWidget(
                              onTap: () {
                                cubit.changePassword(
                                  context,
                                );
                              },
                              minWidth: 500,
                              textStyle:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              text: "Change Password",
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
