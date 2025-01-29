import 'package:flutter/material.dart';
import 'package:signature_system/src/core/style/colors.dart';


class Textfield extends StatelessWidget {
  final String labelText;
  final Icon? trailingIcon;
  final bool? obscureText;
  final TextEditingController? controller;

  const Textfield({
    super.key,
    required this.labelText,
    this.trailingIcon,  this.obscureText,  this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextField(
        obscureText: false,
        controller: controller,
        style: const TextStyle(fontSize: 10),
        decoration: InputDecoration(

          labelText: labelText,
          labelStyle: const TextStyle(fontSize: 10),

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