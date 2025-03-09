import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature_system/src/core/helper/extension/distance.dart';
import 'package:signature_system/src/core/style/colors.dart';

class ButtonWidget extends StatelessWidget {
  final String? text;
  final Widget? widget;
  final double? minWidth;
  final VoidCallback onTap;
  final bool isHollow;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final double leftPadding;
  final double? height;
  final Color? buttonColor;
  final bool enabled;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color? borderColor;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final double? verticalMargin;

  const ButtonWidget({
    this.textColor,
    this.textStyle,
    this.borderColor,
    this.topLeftRadius = 8,
    this.topRightRadius = 8,
    this.bottomLeftRadius = 8,
    this.bottomRightRadius = 8,
    this.height,
    this.enabled = true,
    this.buttonColor,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.rightPadding = 0,
    this.leftPadding = 0,
    this.isHollow = false,
    required this.onTap,
    this.widget,
    this.minWidth,
    this.text,
    this.verticalMargin,

    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return Container(

      color: verticalMargin==0?Colors.transparent: Colors.white,
      padding: EdgeInsets.symmetric(vertical:verticalMargin?? 18.h),
      child: SizedBox(
        height: 40,
        child: MaterialButton(
          height: 12,
          padding: EdgeInsets.only(
            top: topPadding,
            bottom: bottomPadding,
            left: leftPadding,
            right: rightPadding,
          ),
          elevation: isHollow ? 0 : 2,
          color: isHollow ? Colors.white : buttonColor ?? AppColors.mainColor,
          minWidth: minWidth ?? double.infinity,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftRadius.r),
              topRight: Radius.circular(topRightRadius.r),
              bottomLeft: Radius.circular(bottomLeftRadius.r),
              bottomRight: Radius.circular(bottomRightRadius.r),
            ),
            borderSide:
            BorderSide(color: isHollow ? AppColors.mainColor : borderColor ?? Colors.transparent),
          ),
          disabledColor: Colors.grey.shade300,
          onPressed: enabled
              ? () {
            if (enabled) {
              onTap();
            }
          }
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget ?? const SizedBox(),
              if (widget != null && text != null)
                Row(
                  children: [
                    10.isWidth,
                  ],
                ),
              if (text != null)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 60),
                  child: Text(
                    text!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: textStyle ??
                        TextStyle(
                          fontSize: 12.sp,
                          color: isHollow
                              ? AppColors.mainColor
                              : enabled
                              ? textColor ?? Colors.white
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}