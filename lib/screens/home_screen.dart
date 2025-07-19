import 'package:flutter/material.dart';
import 'ingredients/ingredients_screen.dart';
import 'recipes/recipes_screen.dart';
import 'customers/customers_screen.dart';
import 'orders/orders_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF800020),
      body: Stack(
        children: [
          // Oberer linker Button - Zutaten
          Positioned(
            top: 0,
            left: 0,
            right: MediaQuery.of(context).size.width / 2,
            bottom: MediaQuery.of(context).size.height / 2,
            child: FullButton(
              title: 'Zutaten',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IngredientsScreen())),
            ),
          ),

          // Oberer rechter Button - Rezepte
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 2,
            right: 0,
            bottom: MediaQuery.of(context).size.height / 2,
            child: FullButton(
              title: 'Rezepte',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RecipesScreen())),
            ),
          ),

          // Unterer linker Button - Bestellungen
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: 0,
            right: MediaQuery.of(context).size.width / 2,
            bottom: 0,
            child: FullButton(
              title: 'Bestellungen',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersScreen())),
            ),
          ),

          // Unterer rechter Button - Kunden
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: MediaQuery.of(context).size.width / 2,
            right: 0,
            bottom: 0,
            child: FullButton(
              title: 'Kunden',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomersScreen())),
            ),
          ),

          // Goldene Linien
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: GoldenLinesPainter(),
          ),

          // Zentrale Raute
          Center(
            child: Transform.rotate(
              angle: 0.785398, // 45 Grad in Radiant
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF800020),
                  border: Border.all(color: const Color(0xFFD4AF37), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Transform.rotate(
                  angle: -0.785398, // Text wieder gerade drehen
                  child: Center(
                    child: Text(
                      'Noor\nCatering',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 18,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FullButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: const Color(0xFF800020),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 24,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class GoldenLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double diamondSize = 140;
    final double diamondRadius = diamondSize * 0.707 / 2; // 45° gedrehtes Quadrat

    // Rauten-Eckpunkte berechnen
    final Offset topCorner = Offset(centerX, centerY - diamondRadius);
    final Offset rightCorner = Offset(centerX + diamondRadius, centerY);
    final Offset bottomCorner = Offset(centerX, centerY + diamondRadius);
    final Offset leftCorner = Offset(centerX - diamondRadius, centerY);

    // Bildschirm-Ecken
    final Offset topLeft = const Offset(0, 0);
    final Offset topRight = Offset(size.width, 0);
    final Offset bottomLeft = Offset(0, size.height);
    final Offset bottomRight = Offset(size.width, size.height);

    // Linien von Rauten-Ecken zu Bildschirm-Ecken
    canvas.drawLine(topCorner, topLeft, paint);
    canvas.drawLine(topCorner, topRight, paint);
    canvas.drawLine(leftCorner, topLeft, paint);
    canvas.drawLine(leftCorner, bottomLeft, paint);
    canvas.drawLine(rightCorner, topRight, paint);
    canvas.drawLine(rightCorner, bottomRight, paint);
    canvas.drawLine(bottomCorner, bottomLeft, paint);
    canvas.drawLine(bottomCorner, bottomRight, paint);

    // Trennlinien zwischen den Buttons
    canvas.drawLine(Offset(centerX, 0), Offset(centerX, size.height), paint);
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}