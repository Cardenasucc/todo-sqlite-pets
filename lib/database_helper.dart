import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'veterinaria.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        species TEXT,
        isVaccinated INTEGER
      )
    ''');
  }

  Future<int> insertPet(Map<String, dynamic> pet) async {
    final db = await database;
    return await db.insert('pets', pet);
  }

  Future<List<Map<String, dynamic>>> getPets() async {
    final db = await database;
    return await db.query('pets');
  }

  Future<int> updatePet(Map<String, dynamic> pet) async {
    final db = await database;
    return await db.update(
      'pets',
      pet,
      where: 'id = ?',
      whereArgs: [pet['id']],
    );
  }

  Future<int> deletePet(int id) async {
    final db = await database;
    return await db.delete(
      'pets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
