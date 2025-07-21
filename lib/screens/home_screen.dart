import 'package:flutter/material.dart';
import 'ingredients/ingredients_main_screen.dart';  // GEÄNDERT: neue Datei
import 'recipes/recipes_screen.dart';
import 'customers/customers_main_screen.dart';       // GEÄNDERT: neue Datei
import 'orders/orders_screen.dart';
import '../widgets/golden_lines_painter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF335B41),
      body: Stack(
        children: [
          // WICHTIG: Goldene Linien ZUERST (im Hintergrund)
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: GoldenLinesPainter(),
          ),

          // Zentrale Raute (im Hintergrund)
          Center(
            child: Transform.rotate(
              angle: 0.785398,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  border: Border.all(color: const Color(0xFFD4AF37), width: 3),
                ),
                child: Transform.rotate(
                  angle: -0.785398,
                  child: Center(
                    child: Text(
                      'Noor\nCatering',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 26,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // BUTTONS KOMMEN ZULETZT (im Vordergrund - klickbar!)

          // Oberer linker Button - Zutaten
          Positioned(
            top: 0,
            left: 0,
            right: MediaQuery.of(context).size.width / 2,
            bottom: MediaQuery.of(context).size.height / 2,
            child: FullButton(
              title: 'Zutaten',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IngredientsMainScreen()),
                );
              },
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecipesScreen()),
                );
              },
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersScreen()),
                );
              },
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomersMainScreen()),
                );
              },
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: Colors.transparent, // Keine Farbe - zeigt Hintergrund + goldene Linien
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
      ),
    );
  }
}