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
          return Scaffold(
            body: Column(
              children: [
                const Text('Change Your Password'),
                TextFormField(
                  controller: cubit.passwordController,
                  decoration: InputDecoration(hintText: 'Change Your Password'),
                ),
                MaterialButton(onPressed:()=>cubit.changePassword(context))
              ],
            ),
          );
        },
      ),
    );
  }
}
