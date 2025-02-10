import 'package:flutter/material.dart';
import 'package:signature_system/src/core/style/colors.dart';

Widget recivedRequestsWidget() {
  return ListView(
    padding: EdgeInsets.all(16.0),
    children: List.generate(2, (index) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(

          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
            color: Color(0xFFF6F6F6),
          ),
          child: ListTile(
            // textColor: Color(0xFFF6F6F6),
            title: Text(
              "Payment Request Memo",
              style: TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              "Email@Waseela-cf.com",
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "01/23/2025  03:25 PM",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              // Handle tap
            },
          ),
        ),
      );
    }),
  );
}