import 'package:flutter/material.dart';
import 'dart:math' as math;

class GoldenDivider extends StatelessWidget {
  const GoldenDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          // Linke Linie
          Expanded(
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Color(0xFFD4AF37),
                  ],
                ),
              ),
            ),
          ),

          // Mittelstück - Diamant
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFD4AF37), // Gold
                  Color(0xFFB8860B), // Dunkles Gold
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.diamond,
              size: 16,
              color: Color(0xFF2C1810),
            ),
          ),

          // Rechte Linie
          Expanded(
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFD4AF37),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Ornamentale Verzierung für zwischen den Buttons
class GoldenOrnament extends StatelessWidget {
  final double size;

  const GoldenOrnament({super.key, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD4AF37), // Gold
            Color(0xFFB8860B), // Dunkles Gold
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CustomPaint(
        painter: OrnamnetPainter(),
      ),
    );
  }
}

// Custom Painter für elegante Ornamente
class OrnamnetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF2C1810)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 4;

    // Zeichne ein elegantes Muster
    for (int i = 0; i < 8; i++) {
      final double angle = (i * 45) * (3.14159 / 180);
      final double x = centerX + radius * cos(angle);
      final double y = centerY + radius * sin(angle);

      canvas.drawLine(
        Offset(centerX, centerY),
        Offset(x, y),
        paint,
      );
    }

    // Zentraler Kreis
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Helper für mathematische Funktionen

double cos(double angle) => math.cos(angle);
double sin(double angle) => math.sin(angle);