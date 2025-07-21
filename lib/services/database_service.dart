import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'noor_catering.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Customers Table
    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone_number TEXT NOT NULL
      )
    ''');
  }

  // ========== CUSTOMERS ==========

  Future<List<CustomerDB>> getCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');

    return List.generate(maps.length, (i) {
      return CustomerDB.fromMap(maps[i]);
    });
  }

  Future<void> insertCustomer(CustomerDB customer) async {
    final db = await database;
    await db.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCustomer(CustomerDB customer) async {
    final db = await database;
    await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<void> deleteCustomer(String id) async {
    final db = await database;
    await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}