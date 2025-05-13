import 'package:flutter/material.dart';
import 'package:signature_system/src/core/style/colors.dart';

class DashedTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onTap;

  const DashedTextField({
    super.key,
    required this.hintText,
    required this.onTap,
    required this.controller,
  });

  @override
  State<DashedTextField> createState() => _DashedTextFieldState();
}

class _DashedTextFieldState extends State<DashedTextField> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  @override
  void didUpdateWidget(covariant DashedTextField oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('updated');
    setState(() {
      controller = widget.controller;
    });
  }
@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    print('here2 controller ${controller.toString()}');
    if (controller.text.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
    }
    return CustomPaint(
      painter: DashedBorderPainter(),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          widget.onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              isLoading
                  ? CircularProgressIndicator(
                      color: AppColors.mainColor,
                    )
                  : controller.text.isNotEmpty
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.upload,
                          color: Colors.grey,
                        ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  enabled: false,
                  controller: controller,
                  style: controller.text.isEmpty
                      ? TextStyle(fontSize: 11, color: Colors.grey)
                      : TextStyle(fontSize: 11, color: Colors.green),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: controller.text.isEmpty
                        ? TextStyle(fontSize: 11, color: Colors.grey)
                        : TextStyle(fontSize: 11, color: Colors.green),

                    border: InputBorder.none, // Remove default border
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
      canvas.drawLine(
          Offset(i, size.height), Offset(i + 5, size.height), paint);
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
