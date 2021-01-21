import 'dart:io';

import 'package:graderoom_app/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'courseModel.dart';

class DB {
  DB._();

  static final DB db = DB._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, Constants.dbPath);
    return await openDatabase(path, onOpen: (db) async {
      await db.execute("CREATE TABLE IF NOT EXISTS Courses ("
          "class_name TEXT,"
          "teacher_name TEXT,"
          "overall_percent,"
          "overall_letter,"
          "student_id TEXT,"
          "section_id TEXT,"
          "ps_locked INTEGER,"
          "grades TEXT" // Store as json string
          ")");
    });
  }

  clearCourses() async {
    final db = await database;
    db.execute("DROP TABLE IF EXISTS Courses");
    _database = await initDB();
  }

  writeCourses(String courseString) async {
    List<Course> courses = coursesFromJsonString(courseString);
    if (courses.length > 0) await clearCourses();
    for (Course course in courses) {
      print(await _addCourse(course));
    }
  }

  _addCourse(Course newCourse) async {
    final db = await database;
    var res = await db.insert("Courses", newCourse.toJson());
    return res;
  }

  getCourse({int index, String className}) async {
    if (index != null) {
      final db = await database;
      var res = await db.query("Courses", limit: 1, offset: index);
      return res.isNotEmpty ? Course.fromJson(res.first) : Null;
    }
  }
}
