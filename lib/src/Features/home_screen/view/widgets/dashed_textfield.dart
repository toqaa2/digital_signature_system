import 'package:flutter/material.dart';

class DashedTextField extends StatelessWidget {
  final String hintText;
  final IconData leadingIcon;
  final TextEditingController controller;

  const DashedTextField({
    super.key,
    required this.hintText,
    required this.leadingIcon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(leadingIcon, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(fontSize: 11,color: Colors.grey),
                  border: InputBorder.none, // Remove default border
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw dashed horizontal lines
    for (double i = 0; i < size.width; i += 10) {
      canvas.drawLine(Offset(i, 0), Offset(i + 5, 0), paint);
      canvas.drawLine(Offset(i, size.height), Offset(i + 5, size.height), paint);
    }

    // Draw dashed vertical lines
    for (double i = 0; i < size.height; i += 10) {
      canvas.drawLine(Offset(0, i), Offset(0, i + 5), paint);
      canvas.drawLine(Offset(size.width, i), Offset(size.width, i + 5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}