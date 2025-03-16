import 'package:flutter/material.dart';
import 'package:signature_system/src/core/style/colors.dart';

enum IconPosition { leading, trailing }

class ElevatedButtonWithIcon extends StatelessWidget {
  final String label;
  final Icon? icon;
  final VoidCallback onPressed;
  final IconPosition iconPosition;
  final bool border;
  final Color backgroundColor;
  final Color textColor;

  const ElevatedButtonWithIcon({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.iconPosition = IconPosition.leading,
    this.border = true,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(


      style: ElevatedButton.styleFrom(


        foregroundColor: textColor, backgroundColor: backgroundColor,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(8),

          side: border
              ?  BorderSide(color: AppColors.mainColor)
              : BorderSide.none,
        ),
      ),
      onPressed: onPressed,


      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPosition == IconPosition.leading && icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Text(label),
          if (iconPosition == IconPosition.trailing && icon != null) ...[
            const SizedBox(width: 8),
            icon!,
          ],
        ],
      ),
    );
  }
}