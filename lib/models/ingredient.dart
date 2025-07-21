import 'package:flutter/material.dart';

// Ingredient Model
class Ingredient {
  final String id;
  String name;
  String unit;
  Map<String, double> prices; // Store: Price
  String? imagePath;
  IngredientCategory category;
  String notes;
  String? otherStoreName;
  double? otherStorePrice;
  DateTime lastUpdated;

  Ingredient({
    required this.id,
    required this.name,
    required this.unit,
    required this.prices,
    this.imagePath,
    required this.category,
    this.notes = '',
    this.otherStoreName,
    this.otherStorePrice,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  double get cheapestPrice {
    final allPrices = <double>[...prices.values];
    if (otherStorePrice != null) allPrices.add(otherStorePrice!);
    if (allPrices.isEmpty) return 0.0;
    return allPrices.reduce((a, b) => a < b ? a : b);
  }

  String get cheapestStore {
    if (prices.isEmpty && otherStorePrice == null) return '';

    final minPrice = cheapestPrice;

    // Check regular stores
    for (final entry in prices.entries) {
      if (entry.value == minPrice) return entry.key;
    }

    // Check other store
    if (otherStorePrice == minPrice && otherStoreName != null) {
      return otherStoreName!;
    }

    return '';
  }

  // Convert to Database Model
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'prices': prices,
      'image_path': imagePath,
      'category': category.name,
      'notes': notes,
      'other_store_name': otherStoreName,
      'other_store_price': otherStorePrice,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  // Create from Database
  factory Ingredient.fromDatabase(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      prices: Map<String, double>.from(map['prices'] ?? {}),
      imagePath: map['image_path'],
      category: IngredientCategory.values.firstWhere(
            (c) => c.name == map['category'],
        orElse: () => IngredientCategory.others,
      ),
      notes: map['notes'] ?? '',
      otherStoreName: map['other_store_name'],
      otherStorePrice: map['other_store_price']?.toDouble(),
      lastUpdated: DateTime.parse(map['last_updated']),
    );
  }
}

// Category Model
enum IngredientCategory {
  vegetables('Gemüse', Icons.eco, Color(0xFF4CAF50)),
  meat('Fleisch', Icons.set_meal, Color(0xFFE91E63)),
  spices('Gewürze', Icons.grain, Color(0xFFFF9800)),
  dairy('Milchprodukte', Icons.local_drink, Color(0xFF2196F3)),
  grains('Getreide & Hülsenfrüchte', Icons.grass, Color(0xFF795548)),
  oils('Öle & Fette', Icons.opacity, Color(0xFFFFC107)),
  others('Sonstiges', Icons.more_horiz, Color(0xFF9C27B0));

  const IngredientCategory(this.displayName, this.icon, this.color);

  final String displayName;
  final IconData icon;
  final Color color;
}