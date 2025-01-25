import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/CourseModel.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'courses.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE courses (
            id INTEGER PRIMARY KEY,
            title TEXT,
            overview TEXT,
            subject TEXT,
            photo TEXT,
            createdAt TEXT
          )
        ''');
      },
    );
  }

  Future<List<CourseModel>> getCourses() async {
    final db = await database;
    final result = await db.query('courses');
    return result.map((data) => CourseModel.fromJson(data)).toList();
  }

  Future<int> insertCourse(CourseModel course) async {
    final db = await database;
    return await db.insert('courses', course.toJson());
  }

  Future<int> updateCourse(CourseModel course) async {
    final db = await database;
    return await db.update('courses', course.toJson(), where: 'id = ?', whereArgs: [course.id]);
  }

  Future<int> deleteCourse(int id) async {
    final db = await database;
    return await db.delete('courses', where: 'id = ?', whereArgs: [id]);
  }
}
