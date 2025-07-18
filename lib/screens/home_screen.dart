import 'package:flutter/material.dart';
import '../widgets/big_button.dart';
import 'ingredients/ingredients_screen.dart';
import 'recipes/recipes_screen.dart';
import 'customers/customers_screen.dart';
import 'orders/orders_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Noor Catering',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Willkommenstext
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.restaurant,
                    size: 50,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Willkommen bei Noor Catering',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Verwalten Sie Ihr Catering-Business',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Die 4 Hauptfunktionen in 2x2 Grid
            Expanded(
              child: Column(
                children: [
                  // Erste Reihe
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: BigButton(
                            icon: Icons.shopping_cart,
                            title: 'Zutaten',
                            subtitle: 'Preisvergleich',
                            color: const Color(0xFF2196F3),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const IngredientsScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: BigButton(
                            icon: Icons.book,
                            title: 'Rezepte',
                            subtitle: 'Kalkulation',
                            color: const Color(0xFFFF9800),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RecipesScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Zweite Reihe
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: BigButton(
                            icon: Icons.calendar_today,
                            title: 'Bestellungen',
                            subtitle: 'Kalender',
                            color: const Color(0xFF4CAF50),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OrdersScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: BigButton(
                            icon: Icons.people,
                            title: 'Kunden',
                            subtitle: 'Kontakte',
                            color: const Color(0xFF9C27B0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CustomersScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Footer mit Version
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Version 1.0 • Made with ❤️ for Mama',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}