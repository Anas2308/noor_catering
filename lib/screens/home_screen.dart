import 'package:flutter/material.dart';
import 'ingredients/ingredients_screen.dart';
import 'recipes/recipes_screen.dart';
import 'orders/orders_screen.dart';
import '../widgets/golden_lines_painter.dart';

// Customer Model - direkt hier definiert
class Customer {
  final String id;
  String name;
  String phoneNumber;

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });
}

// Vollständiger CustomersScreen - direkt hier definiert
class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final List<Customer> _customers = [
    Customer(id: '1', name: 'Familie Schmidt', phoneNumber: '+49 123 456789'),
    Customer(id: '2', name: 'Ahmed Hassan', phoneNumber: '+49 987 654321'),
    Customer(id: '3', name: 'Sarah Miller', phoneNumber: '+49 555 123456'),
  ];

  void _addCustomer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Neuer Kunde'),
        content: const Text('Kunde-hinzufügen Funktion kommt hier hin!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Kunden'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
      body: _customers.isEmpty ? _buildEmptyState() : _buildCustomersList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomer,
        backgroundColor: const Color(0xFF9C27B0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 100, color: Color(0xFF9C27B0)),
          SizedBox(height: 20),
          Text('Keine Kunden', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildCustomersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _customers.length,
      itemBuilder: (context, index) {
        final customer = _customers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF9C27B0),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(customer.phoneNumber),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${customer.name} angeklickt')),
              );
            },
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: const Color(0xFF800020), // EINE Farbe!
=======
      backgroundColor: const Color(0xFF335B41), // Hauptfarbe
>>>>>>> 06458e6 (Navigation zu Kunden-Screen)
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IngredientsScreen()),
              ),
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecipesScreen()),
              ),
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()),
              ),
            ),
          ),

          // Unterer rechter Button - Kunden (FUNKTIONAL!)
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: MediaQuery.of(context).size.width / 2,
            right: 0,
            bottom: 0,
            child: FullButton(
              title: 'Kunden',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomersScreen()),
              ),
            ),
          ),

          // Zentrale Raute
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

          // Goldene Linien
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: GoldenLinesPainter(),
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
        color: const Color(0xFF335B41), // GLEICHE Farbe wie Hintergrund
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