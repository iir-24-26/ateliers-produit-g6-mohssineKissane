import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static bool _initialized = false;

  DatabaseHelper._init();

  static Future<void> _initializeFactory() async {
    if (_initialized) return;
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
    _initialized = true;
  }

  Future<Database> get database async {
    await _initializeFactory();
    if (_database != null) return _database!;
    _database = await _initDB('produits.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE produits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        libelle TEXT NOT NULL,
        description TEXT NOT NULL,
        prix REAL NOT NULL,
        photo TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertProduit(Map<String, dynamic> produit) async {
    final db = await database;
    return await db.insert('produits', produit);
  }

  Future<List<Map<String, dynamic>>> getAllProduits() async {
    final db = await database;
    return await db.query('produits');
  }

  Future<int> updateProduit(Map<String, dynamic> produit) async {
    final db = await database;
    return await db.update(
      'produits',
      produit,
      where: 'id = ?',
      whereArgs: [produit['id']],
    );
  }

  Future<int> deleteProduit(int id) async {
    final db = await database;
    return await db.delete(
      'produits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
