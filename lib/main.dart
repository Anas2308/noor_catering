import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CateringApp());
}

class CateringApp extends StatelessWidget {
  const CateringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noor Catering',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF335B41), // Grün statt Rot
        scaffoldBackgroundColor: const Color(0xFF335B41), // Grün statt Rot
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD4AF37), // Gold bleibt
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black, // Weiß bleibt
          ),
        ),
      ),
      builder: (context, child) {
        // Für Web: Mobile-ähnliche Darstellung mit maximaler Breite
        if (kIsWeb) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: const BoxDecoration(
                color: Color(0xFF335B41), // Grün statt Rot
              ),
              child: child,
            ),
          );
        }
        // Für Mobile: Standard Darstellung
        return child!;
      },
      home: const HomeScreen(),
    );
  }
}