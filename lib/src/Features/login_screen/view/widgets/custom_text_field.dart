import 'package:flutter/material.dart';
import 'package:signature_system/src/core/style/colors.dart';


class Textfield extends StatelessWidget {
  final String labelText;
  final IconButton? trailingIcon;
  final bool? obscureText;
  final TextEditingController? controller;
final Function(String)? onSubmitted;
  const Textfield({
    super.key,
    required this.labelText,
    this.trailingIcon,  this.obscureText,  this.controller,this.onSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: TextField(
        textInputAction: TextInputAction.next,
        onSubmitted: onSubmitted,
        obscureText: obscureText??false,
        controller: controller,
        style: const TextStyle(fontSize: 10),
        decoration: InputDecoration(

          labelText: labelText,
          labelStyle: const TextStyle(fontSize: 10,color: Colors.grey),

          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainColor),
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),

          suffixIcon: trailingIcon,
        ),
      ),
    );
  }
}