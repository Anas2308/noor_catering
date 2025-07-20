import 'package:flutter/material.dart';
import 'dart:math' as math;

class GoldenLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double diamondRadius = 99;

    // Horizontale Linien mit Ornamenten
    _drawOrnamentalHorizontalLine(canvas, paint, 0, centerX - diamondRadius, centerY);
    _drawOrnamentalHorizontalLine(canvas, paint, centerX + diamondRadius, size.width, centerY);

    // Vertikale Linien mit Ornamenten
    _drawOrnamentalVerticalLine(canvas, paint, centerX, 0, centerY - diamondRadius);
    _drawOrnamentalVerticalLine(canvas, paint, centerX, centerY + diamondRadius, size.height);
  }

  void _drawOrnamentalHorizontalLine(Canvas canvas, Paint paint, double startX, double endX, double y) {
    final double lineLength = endX - startX;
    final double ornamentWidth = 60;
    final double lineWidth = (lineLength - ornamentWidth) / 2;

    if (lineWidth > 0) {
      // Linke Linie
      canvas.drawLine(Offset(startX, y), Offset(startX + lineWidth, y), paint);

      // Rechte Linie
      canvas.drawLine(Offset(endX - lineWidth, y), Offset(endX, y), paint);

      // Ornament in der Mitte
      final double ornamentCenterX = startX + lineLength / 2;
      _drawHorizontalOrnament(canvas, paint, ornamentCenterX, y);
    }
  }

  void _drawOrnamentalVerticalLine(Canvas canvas, Paint paint, double x, double startY, double endY) {
    final double lineLength = endY - startY;
    final double ornamentHeight = 60;
    final double lineHeight = (lineLength - ornamentHeight) / 2;

    if (lineHeight > 0) {
      // Obere Linie
      canvas.drawLine(Offset(x, startY), Offset(x, startY + lineHeight), paint);

      // Untere Linie
      canvas.drawLine(Offset(x, endY - lineHeight), Offset(x, endY), paint);

      // Ornament in der Mitte
      final double ornamentCenterY = startY + lineLength / 2;
      _drawVerticalOrnament(canvas, paint, x, ornamentCenterY);
    }
  }

  void _drawHorizontalOrnament(Canvas canvas, Paint paint, double centerX, double centerY) {
    // Zentrale Raute
    final double size = 8;
    final Path diamond = Path()
      ..moveTo(centerX, centerY - size)
      ..lineTo(centerX + size, centerY)
      ..lineTo(centerX, centerY + size)
      ..lineTo(centerX - size, centerY)
      ..close();
    canvas.drawPath(diamond, paint);

    // Seitliche Schnörkel
    for (int side = -1; side <= 1; side += 2) {
      final double baseX = centerX + side * 15;

      // Geschwungene Linien
      final Path curve = Path()
        ..moveTo(baseX, centerY)
        ..quadraticBezierTo(baseX + side * 8, centerY - 6, baseX + side * 12, centerY)
        ..quadraticBezierTo(baseX + side * 8, centerY + 6, baseX, centerY);
      canvas.drawPath(curve, paint);

      // Kleine Spiralen
      for (double angle = 0; angle < 2 * math.pi; angle += math.pi / 3) {
        final double spiralX = baseX + side * 20 + math.cos(angle) * 4;
        final double spiralY = centerY + math.sin(angle) * 3;
        canvas.drawCircle(Offset(spiralX, spiralY), 1, paint);
      }
    }
  }

  void _drawVerticalOrnament(Canvas canvas, Paint paint, double centerX, double centerY) {
    // Zentrale Raute
    final double size = 8;
    final Path diamond = Path()
      ..moveTo(centerX, centerY - size)
      ..lineTo(centerX + size, centerY)
      ..lineTo(centerX, centerY + size)
      ..lineTo(centerX - size, centerY)
      ..close();
    canvas.drawPath(diamond, paint);

    // Seitliche Schnörkel (vertikal gespiegelt)
    for (int side = -1; side <= 1; side += 2) {
      final double baseY = centerY + side * 15;

      // Geschwungene Linien
      final Path curve = Path()
        ..moveTo(centerX, baseY)
        ..quadraticBezierTo(centerX - 6, baseY + side * 8, centerX, baseY + side * 12)
        ..quadraticBezierTo(centerX + 6, baseY + side * 8, centerX, baseY);
      canvas.drawPath(curve, paint);

      // Kleine Spiralen
      for (double angle = 0; angle < 2 * math.pi; angle += math.pi / 3) {
        final double spiralX = centerX + math.cos(angle) * 3;
        final double spiralY = baseY + side * 20 + math.sin(angle) * 4;
        canvas.drawCircle(Offset(spiralX, spiralY), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}