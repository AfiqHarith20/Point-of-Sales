import 'package:flutter/material.dart';
import 'package:pointofsales/constant.dart';

class CustomBackgroundPainter extends CustomPainter {
  final double width; // Width of the background
  final double height; // Height of the background

  CustomBackgroundPainter({
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Define your background colors here
    final color1 = Colors.blue; // Change this to your first color (blue)
    final color2 = kSign; // Change this to your second color (red)

    // Define the line's properties
    final lineColor = Colors.white; // Change this to the line color
    final lineWidth = 5.0; // Change this to the line width

    // Draw the background with color1 (blue) using the provided size
    paint.color = color1;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

    // Draw the diagonal line from top-left to bottom-right with lineColor and lineWidth
    paint.color = lineColor;
    paint.strokeWidth = lineWidth;
    final startPoint = Offset(0, 0);
    final endPoint = Offset(width, height);
    canvas.drawLine(startPoint, endPoint, paint);

    // Draw the remaining area with color2 (red) using the provided size
    paint.color = color2;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(width, height / 2)
      ..lineTo(0, height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
