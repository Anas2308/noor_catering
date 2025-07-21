import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

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

  // Convert to Map for Database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
    };
  }

  // Create from Map from Database
  factory CustomerDB.fromMap(Map<String, dynamic> map) {
    return CustomerDB(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phone_number'],
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
        version: 1,
        onCreate: _createDatabase,
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

    } catch (e) {
      debugPrint('❌ Fehler beim Erstellen der Tabellen: $e');
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
      if (!hasCustomers) {
        debugPrint('⚠️ Customers Tabelle fehlt - erstelle sie...');
        await _createDatabase(db, 1);
      }

      // Zeige Anzahl der Einträge
      final customerCount = await db.rawQuery('SELECT COUNT(*) as count FROM customers');
      debugPrint('👥 Anzahl Kunden in DB: ${customerCount.first['count']}');

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