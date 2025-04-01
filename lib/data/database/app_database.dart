import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  late Database _db;

  Future<void> init() async {
    sqfliteFfiInit();
    final dbPath = join(Directory.current.path, 'app_database.sqlite');
    final databaseFactory = databaseFactoryFfi;

    _db = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE inventories (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              createdAt TEXT NOT NULL
            );
          ''');

          await db.execute('''
            CREATE TABLE products (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              quantity INTEGER DEFAULT 0,
              inventoryId INTEGER NOT NULL,
              barcode TEXT,
              price REAL NOT NULL,
              FOREIGN KEY (inventoryId) REFERENCES inventories(id) ON DELETE CASCADE
            );
          ''');
        },
      ),
    );
  }

  Future<int> insertInventory(Map<String, dynamic> inventory) async {
    return await _db.insert('inventories', inventory);
  }

  Future<List<Map<String, dynamic>>> getAllInventories() async {
    return await _db.query('inventories');
  }

  Future<int> deleteInventory(int id) async {
    return await _db.delete('inventories', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertProduct(Map<String, dynamic> product) async {
    return await _db.insert('products', product);
  }

  Future<List<Map<String, dynamic>>> getProductsByInventory(int inventoryId) async {
    return await _db.query(
      'products',
      where: 'inventoryId = ?',
      whereArgs: [inventoryId],
    );
  }

  Future<int> deleteProduct(int id) async {
    return await _db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
