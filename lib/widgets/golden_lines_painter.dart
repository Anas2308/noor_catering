import 'package:flutter/material.dart';

class GoldenLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double diamondSize = 260;
    final double diamondRadius = diamondSize * 0.707 / 2;

    // Vertikale Linien
    canvas.drawLine(
        Offset(centerX, 0),
        Offset(centerX, centerY - diamondRadius - 5),
        paint
    );

    canvas.drawLine(
        Offset(centerX, centerY + diamondRadius + 5),
        Offset(centerX, size.height),
        paint
    );

    // Horizontale Linien
    canvas.drawLine(
        Offset(0, centerY),
        Offset(centerX - diamondRadius - 5, centerY),
        paint
    );

    canvas.drawLine(
        Offset(centerX + diamondRadius + 5, centerY),
        Offset(size.width, centerY),
        paint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}