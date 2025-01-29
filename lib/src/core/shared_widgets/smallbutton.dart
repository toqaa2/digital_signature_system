import 'package:flutter/material.dart';
import 'package:signature_system/src/core/style/colors.dart';

// Enum for Icon Position
enum IconPosition { leading, trailing }

// Custom Elevated Button Widget
class ElevatedButtonWithIcon extends StatelessWidget {
  final String label;
  final Icon? icon; // Optional leading icon
  final VoidCallback onPressed;
  final IconPosition iconPosition;
  final bool border; // Option for border
  final Color backgroundColor; // Background color
  final Color textColor; // Text color

  const ElevatedButtonWithIcon({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.iconPosition = IconPosition.leading, // Default icon position
    this.border = true, // Default to having a border
    this.backgroundColor = Colors.white, // Default background color
    this.textColor = Colors.black, // Default text color
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      style: ElevatedButton.styleFrom(

        foregroundColor: textColor, backgroundColor: backgroundColor, // Custom text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Border radius
          side: border
              ?  BorderSide(color: AppColors.mainColor) // Border color
              : BorderSide.none, // No border if false
        ),
      ),
      onPressed: onPressed,

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPosition == IconPosition.leading && icon != null) ...[
            icon!,
            const SizedBox(width: 8), // Space between icon and label
          ],
          Text(label),
          if (iconPosition == IconPosition.trailing && icon != null) ...[
            const SizedBox(width: 8), // Space between label and icon
            icon!,
          ],
        ],
      ),
    );
  }
}