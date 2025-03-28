import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature_system/src/Features/login_screen/manager/login_cubit.dart';

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
                body: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Change Your Password'),
                    TextFormField(
                      controller: cubit.passwordController,
                      decoration: InputDecoration(hintText: 'Change Your Password'),
                    ),
                    state is ChangePasswordLoading
                        ? const Center(child: CircularProgressIndicator())
                        : MaterialButton(
                            child: const Text('Change Password'),
                            onPressed: () => cubit.changePassword(
                              context,
                            ),
                          ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
