
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension Distance on num {
  Widget get isHeight => SizedBox(height: h);

  Widget get isWidth => SizedBox(width: w);
}
