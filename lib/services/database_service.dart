import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/list_model.dart';
import '../models/location_model.dart';


class DatabaseService {
  // Singleton Implementation
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();
  // End of Singleton Implementation

  static Database? _database;

  // Database Initialization
  Future<Database> get database async {
    if (_database != null) return _database!; // Return existing instance if available

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'location_database.db');

    return await openDatabase(
      path,
      onCreate: _createDb,
      version: 1, // Start with version 1
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE lists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');
    await db.execute('''
      CREATE TABLE locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        listId INTEGER,
        name TEXT,
        latitude REAL,
        longitude REAL,
        FOREIGN KEY(listId) REFERENCES lists(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE photos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        locationId INTEGER,
        path TEXT,
        FOREIGN KEY(locationId) REFERENCES locations(id) ON DELETE CASCADE
      )
    ''');
  }

  // Lists CRUD Operations
  Future<void> insertList(ListModel list) async {
    final db = await database;
    await db.insert('lists', list.toMap());
  }

  Future<List<ListModel>> getLists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('lists');
    return List.generate(maps.length, (i) => ListModel.fromMap(maps[i]));
  }

  Future<int> getListIdByName(String name) async {
    final db = await database;
    final result = await db.query(
      'lists',
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty ? result.first['id'] as int : 0;
  }

  Future<void> updateList(ListModel list) async {
    final db = await database;
    await db.update(
      'lists',
      list.toMap(),
      where: 'id = ?',
      whereArgs: [list.id],
    );
  }

  Future<void> deleteList(int id) async {
    final db = await database;
    await db.delete(
      'lists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Locations CRUD Operations
  Future<void> insertLocation(LocationModel location) async {
    final db = await database;
    await db.insert('locations', location.toMap());
  }

  Future<List<LocationModel>> getLocationsByListId(int listId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'locations',
      where: 'listId = ?',
      whereArgs: [listId],
    );
    return List.generate(maps.length, (i) => LocationModel.fromMap(maps[i]));
  }

  Future<void> updateLocation(LocationModel location) async {
    final db = await database;
    await db.update(
      'locations',
      location.toMap(),
      where: 'id = ?',
      whereArgs: [location.id],
    );
  }

  Future<void> deleteLocation(int id) async {
    final db = await database;
    await db.delete(
      'locations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Photos CRUD Operations
  Future<void> insertPhoto(int locationId, String path) async {
    final db = await database;
    await db.insert('photos', {'locationId': locationId, 'path': path});
  }

  Future<List<String>> getPhotoPathsForLocation(int locationId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'photos',
      where: 'locationId = ?',
      whereArgs: [locationId],
    );
    return List.generate(maps.length, (i) => maps[i]['path'] as String);
  }

// ... (Other photo operations like update and delete)
}
