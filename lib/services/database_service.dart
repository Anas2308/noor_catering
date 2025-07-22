import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

// Simple Customer Model for Database
class CustomerDB {
  final String id;
  final String name;
  final String phoneNumber;

  CustomerDB({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
    };
  }

  factory CustomerDB.fromMap(Map<String, dynamic> map) {
    return CustomerDB(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phone_number'],
    );
  }
}

// Ingredient Model for Database
class IngredientDB {
  final String id;
  final String name;
  final String unit;
  final Map<String, double> prices;
  final String? imagePath;
  final String category;
  final String notes;
  final String? otherStoreName;
  final double? otherStorePrice;
  final String lastUpdated;

  IngredientDB({
    required this.id,
    required this.name,
    required this.unit,
    required this.prices,
    this.imagePath,
    required this.category,
    required this.notes,
    this.otherStoreName,
    this.otherStorePrice,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'prices': jsonEncode(prices), // JSON String für Map
      'image_path': imagePath,
      'category': category,
      'notes': notes,
      'other_store_name': otherStoreName,
      'other_store_price': otherStorePrice,
      'last_updated': lastUpdated,
    };
  }

  factory IngredientDB.fromMap(Map<String, dynamic> map) {
    return IngredientDB(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      prices: Map<String, double>.from(jsonDecode(map['prices'] ?? '{}')),
      imagePath: map['image_path'],
      category: map['category'],
      notes: map['notes'] ?? '',
      otherStoreName: map['other_store_name'],
      otherStorePrice: map['other_store_price']?.toDouble(),
      lastUpdated: map['last_updated'],
    );
  }
}

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) {
      debugPrint('🔄 Database bereits initialisiert');
      return _database!;
    }

    debugPrint('🏗️ Initialisiere neue Database...');
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      // Database Pfad bestimmen
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'noor_catering.db');

      debugPrint('📁 Database Pfad: $path');

      // Database öffnen/erstellen
      final database = await openDatabase(
        path,
        version: 2, // VERSION ERHÖHT für neue Tabelle!
        onCreate: _createDatabase,
        onUpgrade: _upgradeDatabase,
        onOpen: (db) {
          debugPrint('📂 Database geöffnet: $path');
        },
      );

      // Prüfen ob Tabellen existieren
      await _verifyTables(database);

      return database;
    } catch (e) {
      debugPrint('❌ Fehler beim Initialisieren der Database: $e');
      rethrow;
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    try {
      debugPrint('🏗️ Erstelle Database Tabellen...');

      // Customers Table
      await db.execute('''
        CREATE TABLE customers (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          phone_number TEXT NOT NULL
        )
      ''');
      debugPrint('✅ Customers Tabelle erstellt');

      // Ingredients Table
      await db.execute('''
        CREATE TABLE ingredients (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          unit TEXT NOT NULL,
          prices TEXT NOT NULL,
          image_path TEXT,
          category TEXT NOT NULL,
          notes TEXT,
          other_store_name TEXT,
          other_store_price REAL,
          last_updated TEXT NOT NULL
        )
      ''');
      debugPrint('✅ Ingredients Tabelle erstellt');

    } catch (e) {
      debugPrint('❌ Fehler beim Erstellen der Tabellen: $e');
      rethrow;
    }
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    try {
      debugPrint('🔄 Upgrade Database von Version $oldVersion zu $newVersion');

      if (oldVersion < 2) {
        // Ingredients Table für bestehende Databases hinzufügen
        await db.execute('''
          CREATE TABLE ingredients (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            unit TEXT NOT NULL,
            prices TEXT NOT NULL,
            image_path TEXT,
            category TEXT NOT NULL,
            notes TEXT,
            other_store_name TEXT,
            other_store_price REAL,
            last_updated TEXT NOT NULL
          )
        ''');
        debugPrint('✅ Ingredients Tabelle hinzugefügt (Upgrade)');
      }
    } catch (e) {
      debugPrint('❌ Fehler beim Database-Upgrade: $e');
      rethrow;
    }
  }

  // Prüfe ob alle Tabellen existieren
  Future<void> _verifyTables(Database db) async {
    try {
      final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table'"
      );

      debugPrint('📋 Vorhandene Tabellen: ${tables.map((t) => t['name']).toList()}');

      // Prüfe ob customers Tabelle existiert
      final hasCustomers = tables.any((table) => table['name'] == 'customers');
      final hasIngredients = tables.any((table) => table['name'] == 'ingredients');

      if (!hasCustomers || !hasIngredients) {
        debugPrint('⚠️ Fehlende Tabellen - erstelle alle neu...');
        await _createDatabase(db, 2);
      }

      // Zeige Anzahl der Einträge
      final customerCount = await db.rawQuery('SELECT COUNT(*) as count FROM customers');
      final ingredientCount = await db.rawQuery('SELECT COUNT(*) as count FROM ingredients');

      debugPrint('👥 Anzahl Kunden in DB: ${customerCount.first['count']}');
      debugPrint('🥕 Anzahl Zutaten in DB: ${ingredientCount.first['count']}');

    } catch (e) {
      debugPrint('❌ Fehler beim Verifizieren der Tabellen: $e');
    }
  }

  // ========== CUSTOMERS ==========

  Future<List<CustomerDB>> getCustomers() async {
    try {
      debugPrint('📖 Lade Kunden aus Database...');

      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('customers');

      debugPrint('📊 ${maps.length} Kunden aus DB geladen');

      if (maps.isNotEmpty) {
        debugPrint('👤 Erste Kunde: ${maps.first}');
      }

      return List.generate(maps.length, (i) {
        return CustomerDB.fromMap(maps[i]);
      });
    } catch (e) {
      debugPrint('❌ Fehler beim Laden der Kunden: $e');
      return [];
    }
  }

  Future<void> insertCustomer(CustomerDB customer) async {
    try {
      debugPrint('💾 Speichere Kunde: ${customer.name}');

      final db = await database;
      await db.insert(
        'customers',
        customer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      debugPrint('✅ Kunde "${customer.name}" gespeichert (ID: ${customer.id})');

      // Verification: Prüfe ob Kunde wirklich in DB ist
      final savedCustomers = await db.query(
          'customers',
          where: 'id = ?',
          whereArgs: [customer.id]
      );

      if (savedCustomers.isNotEmpty) {
        debugPrint('✅ Verification: Kunde ist in DB gespeichert');
      } else {
        debugPrint('❌ Verification: Kunde NICHT in DB gefunden!');
      }

    } catch (e) {
      debugPrint('❌ Fehler beim Speichern des Kunden: $e');
      rethrow;
    }
  }

  Future<void> updateCustomer(CustomerDB customer) async {
    try {
      debugPrint('🔄 Aktualisiere Kunde: ${customer.name}');

      final db = await database;
      final updatedRows = await db.update(
        'customers',
        customer.toMap(),
        where: 'id = ?',
        whereArgs: [customer.id],
      );

      if (updatedRows > 0) {
        debugPrint('✅ Kunde "${customer.name}" aktualisiert');
      } else {
        debugPrint('⚠️ Kunde mit ID ${customer.id} nicht gefunden');
      }

    } catch (e) {
      debugPrint('❌ Fehler beim Aktualisieren des Kunden: $e');
      rethrow;
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      debugPrint('🗑️ Lösche Kunde mit ID: $id');

      final db = await database;
      final deletedRows = await db.delete(
        'customers',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (deletedRows > 0) {
        debugPrint('✅ Kunde gelöscht');
      } else {
        debugPrint('⚠️ Kunde mit ID $id nicht gefunden');
      }

    } catch (e) {
      debugPrint('❌ Fehler beim Löschen des Kunden: $e');
      rethrow;
    }
  }

  // ========== INGREDIENTS ==========

  Future<List<IngredientDB>> getIngredients() async {
    try {
      debugPrint('📖 Lade Zutaten aus Database...');

      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('ingredients');

      debugPrint('📊 ${maps.length} Zutaten aus DB geladen');

      if (maps.isNotEmpty) {
        debugPrint('🥕 Erste Zutat: ${maps.first['name']}');
      }

      return List.generate(maps.length, (i) {
        return IngredientDB.fromMap(maps[i]);
      });
    } catch (e) {
      debugPrint('❌ Fehler beim Laden der Zutaten: $e');
      return [];
    }
  }

  Future<List<IngredientDB>> getIngredientsByCategory(String category) async {
    try {
      debugPrint('📖 Lade Zutaten für Kategorie: $category');

      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'ingredients',
        where: 'category = ?',
        whereArgs: [category],
      );

      debugPrint('📊 ${maps.length} Zutaten für $category geladen');

      return List.generate(maps.length, (i) {
        return IngredientDB.fromMap(maps[i]);
      });
    } catch (e) {
      debugPrint('❌ Fehler beim Laden der Zutaten für $category: $e');
      return [];
    }
  }

  Future<void> insertIngredient(IngredientDB ingredient) async {
    try {
      debugPrint('💾 Speichere Zutat: ${ingredient.name}');

      final db = await database;
      await db.insert(
        'ingredients',
        ingredient.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      debugPrint('✅ Zutat "${ingredient.name}" gespeichert (ID: ${ingredient.id})');

      // Verification
      final savedIngredients = await db.query(
          'ingredients',
          where: 'id = ?',
          whereArgs: [ingredient.id]
      );

      if (savedIngredients.isNotEmpty) {
        debugPrint('✅ Verification: Zutat ist in DB gespeichert');
      } else {
        debugPrint('❌ Verification: Zutat NICHT in DB gefunden!');
      }

    } catch (e) {
      debugPrint('❌ Fehler beim Speichern der Zutat: $e');
      rethrow;
    }
  }

  Future<void> updateIngredient(IngredientDB ingredient) async {
    try {
      debugPrint('🔄 Aktualisiere Zutat: ${ingredient.name}');

      final db = await database;
      final updatedRows = await db.update(
        'ingredients',
        ingredient.toMap(),
        where: 'id = ?',
        whereArgs: [ingredient.id],
      );

      if (updatedRows > 0) {
        debugPrint('✅ Zutat "${ingredient.name}" aktualisiert');
      } else {
        debugPrint('⚠️ Zutat mit ID ${ingredient.id} nicht gefunden');
      }

    } catch (e) {
      debugPrint('❌ Fehler beim Aktualisieren der Zutat: $e');
      rethrow;
    }
  }

  Future<void> deleteIngredient(String id) async {
    try {
      debugPrint('🗑️ Lösche Zutat mit ID: $id');

      final db = await database;
      final deletedRows = await db.delete(
        'ingredients',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (deletedRows > 0) {
        debugPrint('✅ Zutat gelöscht');
      } else {
        debugPrint('⚠️ Zutat mit ID $id nicht gefunden');
      }

    } catch (e) {
      debugPrint('❌ Fehler beim Löschen der Zutat: $e');
      rethrow;
    }
  }

  // Debug-Funktionen
  Future<void> printAllCustomers() async {
    try {
      final db = await database;
      final customers = await db.query('customers');
      debugPrint('📋 Alle Kunden in DB:');
      for (final customer in customers) {
        debugPrint('  👤 ${customer['name']} (${customer['phone_number']})');
      }
    } catch (e) {
      debugPrint('❌ Fehler beim Anzeigen der Kunden: $e');
    }
  }

  Future<void> printAllIngredients() async {
    try {
      final db = await database;
      final ingredients = await db.query('ingredients');
      debugPrint('📋 Alle Zutaten in DB:');
      for (final ingredient in ingredients) {
        debugPrint('  🥕 ${ingredient['name']} (${ingredient['category']})');
      }
    } catch (e) {
      debugPrint('❌ Fehler beim Anzeigen der Zutaten: $e');
    }
  }

  Future<String> getDatabasePath() async {
    try {
      final databasesPath = await getDatabasesPath();
      return join(databasesPath, 'noor_catering.db');
    } catch (e) {
      debugPrint('❌ Fehler beim Ermitteln des Database-Pfads: $e');
      return 'Unbekannt';
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      debugPrint('🔒 Database geschlossen');
    }
  }
}