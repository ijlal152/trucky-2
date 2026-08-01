import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Central SQLite database access point.
///
/// This is the single owner of the database connection and schema. DAOs /
/// local data sources use [database] to run queries.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    final existing = _database;
    if (existing != null) return existing;
    final opened = await _open();
    _database = opened;
    return opened;
  }

  Future<Database> _open() async {
    final databasesPath = await getDatabasesPath();
    return openDatabase(
      p.join(databasesPath, 'trucky.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
