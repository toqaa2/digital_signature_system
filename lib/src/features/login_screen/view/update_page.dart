import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/style/colors.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
             Text('You are Not Up to Date',style: TextStyle(
              color: AppColors.mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 25
            ),),
            const Text('Please Keep Refreshing...',style: TextStyle(
                fontSize: 18

            ),),

          ],
        ),
      ),
    );
  }
}
