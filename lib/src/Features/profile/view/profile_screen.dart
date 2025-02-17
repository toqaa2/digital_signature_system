import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:signature_system/src/core/style/colors.dart';

import '../../../core/constants/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.45,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'profile.svg',
                          width: 65,
                          height: 65,
                        ),
                        2.isWidth,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Constants.userModel!.name.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              Constants.userModel!.email.toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(4)),
                      height: 30,
                      width: 180,
                      child: Center(
                        child: Text(
                          "Change info Request",
                          style: TextStyle(
                              color: AppColors.mainColor, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                5.isHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Constants.userModel!.department.toString(),
                      ),
                      Text(
                        Constants.userModel!.role.toString(),
                      ),
                      5.isHeight,
                      Text("Signature "),
                      Image.asset(
                        "assets/mysegniture.png",
                        height: 50,
                        width: 100,
                      ),
                      5.isHeight,
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(4)),
                        height: 30,
                        width: 180,
                        child: Center(
                          child: Text(
                            "Add Signature Request",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
