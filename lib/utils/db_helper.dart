import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _databaseHelperInstance = DBHelper._internal();
  factory DBHelper() => _databaseHelperInstance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'workouts.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        print('Creating database');
        return db.execute(
          "CREATE TABLE workouts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, image TEXT, date TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertWorkout(Map<String, dynamic> workout) async {
    try {
      final db = await database;
      await db.insert(
        'workouts',
        workout,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting workout: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getWorkouts() async {
    final db = await database;
    return db.query('workouts');
  }

  Future<void> deleteWorkout(int id) async {
    try {
      final db = await database;
      await db.delete(
        'workouts',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Workout deleted with id: $id');
    } catch (e) {
      print('Error deleting workout: $e');
    }
  }
}
