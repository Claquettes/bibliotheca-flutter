import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'app_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categorie (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        libelle TEXT NOT NULL,
        last_updated TEXT DEFAULT CURRENT_TIMESTAMP,
        is_synced INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE auteur (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenoms TEXT NOT NULL,
        email TEXT,
        last_updated TEXT DEFAULT CURRENT_TIMESTAMP,
        is_synced INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE livre (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        libelle TEXT NOT NULL,
        description TEXT,
        auteur_id INTEGER NOT NULL,
        categorie_id INTEGER NOT NULL,
        last_updated TEXT DEFAULT CURRENT_TIMESTAMP,
        is_synced INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> insertCategorie(Map<String, dynamic> categorie) async {
    final db = await database;
    await db.insert('categorie', categorie, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return db.query('categorie');
  }

  Future<void> insertAuteur(Map<String, dynamic> auteur) async {
    final db = await database;
    await db.insert('auteur', auteur, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAuteurs() async {
    final db = await database;
    return db.query('auteur');
  }

  Future<void> insertLivre(Map<String, dynamic> livre) async {
    final db = await database;
    await db.insert('livre', livre, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getLivres() async {
    final db = await database;
    return db.query('livre');
  }
}
