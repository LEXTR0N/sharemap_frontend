// database_repository.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/list_model.dart';
import '../models/location_model.dart';

class DatabaseRepository {
  static const _databaseName = "sharemap.db";
  static const _databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE lists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        photos TEXT, 
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        listId INTEGER NOT NULL,
        FOREIGN KEY(listId) REFERENCES lists(id) ON DELETE CASCADE
      )
    ''');
  }

  // List Operations
  Future<int> insertList(ListModel list) async {
    final db = await database;
    return await db.insert('lists', list.toMap());
  }

  Future<List<ListModel>> getLists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('lists');
    return List.generate(maps.length, (i) => ListModel.fromMap(maps[i]));
  }

  Future<int> updateList(ListModel list) async {
    final db = await database;
    return await db.update('lists', list.toMap(),
        where: 'id = ?', whereArgs: [list.id]);
  }

  Future<int> deleteList(int id) async {
    final db = await database;
    return await db.delete('lists', where: 'id = ?', whereArgs: [id]);
  }

  // Location Operations
  Future<int> insertLocation(LocationModel location) async {
    final db = await database;
    return await db.insert('locations', location.toMap());
  }

  Future<List<LocationModel>> getLocationsForList(int listId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'locations',
      where: 'listId = ?',
      whereArgs: [listId],
    );
    return List.generate(maps.length, (i) => LocationModel.fromMap(maps[i]));
  }

  Future<int> updateLocation(LocationModel location) async {
    final db = await database;
    return await db.update('locations', location.toMap(),
        where: 'id = ?', whereArgs: [location.id]);
  }

  Future<int> deleteLocation(int id) async {
    final db = await database;
    return await db.delete('locations', where: 'id = ?', whereArgs: [id]);
  }
}
