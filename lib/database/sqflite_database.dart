import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/moment.dart';

class DatabaseHelper {
  late Database _database;
  late bool _isDatabaseInitialized; // New flag to track initialization

  DatabaseHelper() : _isDatabaseInitialized = false; // Initialize the flag

  Future<Database> get database async {
    if (!_isDatabaseInitialized) {
      await _initDatabase();
      _isDatabaseInitialized =
          true; // Set the flag to true after initialization
    }
    return _database;
  }

  Future<void> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE moments (
        id TEXT PRIMARY KEY,
        type TEXT,
        title TEXT,
        latestUpdate TEXT,
        description TEXT,
        dateList TEXT
      )
    ''');
  }

  Future<int> insertMoment(Moment moment) async {
    Database db = await database;
    return await db.insert(
      'moments',
      moment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Moment>> getAllMoments() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('moments');
    return List.generate(maps.length, (i) {
      return Moment.fromMap(maps[i]);
    });
  }

  Future<void> deleteMoment(String momentId) async {
    Database db = await database;
    await db.delete('moments', where: 'id = ?', whereArgs: [momentId]);
  }

  Future<void> updateMoment(Moment moment) async {
    Database db = await database;
    await db.update(
      'moments',
      moment.toMap(),
      where: 'id = ?',
      whereArgs: [moment.id],
    );
  }
}
