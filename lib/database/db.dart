import 'dart:io';

import 'package:graderoom_app/constants.dart';
import 'package:graderoom_app/database/courseModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  DB._();

  static final DB db = DB._();

  static Database _database;
  static List<Map<String, dynamic>> _cache = [];

  static List<Map<String, dynamic>> get all {
    return _cache;
  }

  static Future<Database> get database async {
    if (_database == null) {
      _database = await _openDB();
    } else {
      // If db exists but table doesn't
      var result = await _database.query("sqlite_master", where: "name = ?", whereArgs: ["Courses"]);
      if (result.length == 0) {
        await _initDB();
      } else {
        await _initCache();
      }
    }
    return _database;
  }

  int get length {
    if (_cache == null) {
      _cache = [];
    }
    return _cache.length;
  }

  static _openDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, Constants.dbPath);
    return await openDatabase(path, onOpen: (db) async {
      _database = db;
      await _initDB();
    });
  }

  static _initDB() async {
    await _database.execute("CREATE TABLE IF NOT EXISTS Courses ("
        "class_name TEXT,"
        "teacher_name TEXT,"
        "overall_percent,"
        "overall_letter,"
        "student_id TEXT,"
        "section_id TEXT,"
        "ps_locked INTEGER,"
        "grades TEXT" // Store as json string
        ")");
    await _initCache();
  }

  static _initCache() async {
    List<Map<String, dynamic>> courseList = await _database.rawQuery("SELECT * FROM Courses");
    _cache = [];
    for (Map<String, dynamic> course in courseList) {
      _cache.add(Course.fromJsonOrSql(course).toJson());
    }
  }

  static _clearDB() async {
    await _database.execute("DROP TABLE IF EXISTS Courses");
    _cache = [];
  }

  static _addCourse(Course newCourse) async {
    var res = await _database.insert("Courses", newCourse.toSql());
    _cache.add(newCourse.toJson());
    return res;
  }

  clearCourses() async {
    await _clearDB();
    await _initDB();
  }

  writeCourses(String courseString) async {
    await database;
    List<Course> courses = coursesFromJsonString(courseString);
    if (length > 0 && courses.length > 0) await clearCourses();
    for (Course course in courses) {
      await _addCourse(course);
    }
  }

  get(int index) {
    if (index != null && index < _cache.length) {
      return _cache[index];
    }
    return null;
  }
}
