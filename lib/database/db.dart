import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graderoom_app/constants.dart';
import 'package:graderoom_app/database/courseModel.dart';
import 'package:graderoom_app/database/localModel.dart';
import 'package:graderoom_app/database/settingsModel.dart';
import 'package:graderoom_app/extensions.dart';
import 'package:graderoom_app/toaster.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  DB._();

  static final DB db = DB._();

  static Database _database;
  static List<Map<String, dynamic>> _courseCache;
  static Map<String, dynamic> _settingsCache;
  static Map<String, dynamic> _localCache;

  static Future<List<Map<String, dynamic>>> get courseCache async {
    if (_courseCache == null) {
      await initCourseCache();
    }
    return _courseCache;
  }

  static Future<Map<String, dynamic>> get settingsCache async {
    if (_settingsCache == null) {
      await _initSettingsCache();
    }
    return _settingsCache;
  }

  static Future<Map<String, dynamic>> get localCache async {
    if (_localCache == null) {
      await _initLocalCache();
    }
    return _localCache;
  }

  static Future<Database> get database async {
    if (_database == null) {
      _database = await _openDB();
    } else {
      await localCache;
      await courseCache;
      await settingsCache;
    }
    return _database;
  }

  static int get numCourses {
    if (_courseCache == null) return null;
    return _courseCache.length;
  }

  static _openDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, Constants.dbPath);
    return await openDatabase(path, onOpen: (db) async {
      _database = db;
      await localCache;
      await courseCache;
      await settingsCache;
    });
  }

  static _initCourses() async {
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
    toastDebug("Created Course DB");
  }

  static _fixCourses() async {
    Map<String, String> columnsAndTypes = Courses.sqlColumns;
    List<String> columns =
        List<String>.from((await _database.rawQuery("PRAGMA table_info(Courses)")).map((c) => c["name"].toString()));
    columnsAndTypes.forEach((column, type) async {
      if (!columns.contains(column)) {
        await _database.rawQuery("ALTER TABLE Courses ADD COLUMN " + column + " " + type);
      }
    });
  }

  static _initSettings() async {
    await _database.execute("CREATE TABLE IF NOT EXISTS Settings (" + Settings.sqlModel + ")");
    toastDebug("Created Settings DB");
  }

  static _fixSettings() async {
    Map<String, String> columnsAndTypes = Settings.sqlColumns;
    List<String> columns =
        List<String>.from((await _database.rawQuery("PRAGMA table_info(Settings)")).map((c) => c["name"].toString()));
    columnsAndTypes.forEach((column, type) async {
      if (!columns.contains(column)) {
        await _database.rawQuery("ALTER TABLE Settings ADD COLUMN " + column + " " + type);
      }
    });
  }

  static _initLocal() async {
    await _database.execute("CREATE TABLE IF NOT EXISTS Local ("
        "theme TEXT"
        "showDebugToasts INTEGER"
        ")");
    toastDebug("Created Local DB");
  }

  static _fixLocal() async {
    Map<String, String> columnsAndTypes = Local.sqlColumns;
    List<String> columns =
        List<String>.from((await _database.rawQuery("PRAGMA table_info(Local)")).map((c) => c["name"].toString()));
    columnsAndTypes.forEach((column, type) async {
      if (!columns.contains(column)) {
        await _database.rawQuery("ALTER TABLE Local ADD COLUMN " + column + " " + type);
      }
    });
  }

  static initCourseCache() async {
    List<Map<String, dynamic>> courseList;
    var db = _database;
    if ((await db.query("sqlite_master", where: "name = ?", whereArgs: ["Courses"])).length == 0) {
      await _initCourses();
      db = await database;
    }
    _fixCourses();
    courseList = await db.rawQuery("SELECT * FROM Courses");
    _courseCache = [];
    for (Map<String, dynamic> course in courseList) {
      _courseCache.add(Courses.fromJsonOrSql(course).toJson());
    }
    print("Initialized Course Cache");
  }

  static _initSettingsCache() async {
    List<Map<String, dynamic>> _settings;
    var db = _database;
    if ((await db.query("sqlite_master", where: "name = ?", whereArgs: ["Settings"])).length == 0) {
      await _initSettings();
      db = await database;
    }
    await _fixSettings();
    _settings = await db.rawQuery("SELECT * FROM Settings ORDER BY ROWID ASC LIMIT 1");

    if (_settings.length > 0) {
      Map<String, dynamic> settings = _settings[0];
      _settingsCache = Settings.fromJsonOrSql({...settings}).toJson();
      var appearance = _settingsCache["appearance"];
      var rawTheme = appearance["theme"];
      if (!(["dark", "light", "system"]).contains(rawTheme)) {
        rawTheme = "dark";
      }
      if (!(["Dark", "Light", "System"]).contains(_localCache["theme"])) {
        await DB.setLocal("theme", rawTheme.toString().capitalize());
      }
    } else {
      _settingsCache = Map<String, dynamic>();
    }
    print("Initialized Settings Cache");
  }

  static _initLocalCache() async {
    List<Map<String, dynamic>> _local;
    var db = _database;
    if ((await db.query("sqlite_master", where: "name = ?", whereArgs: ["Local"])).length == 0) {
      await _initLocal();
      db = await database;
    }
    await _fixLocal();
    _local = await db.rawQuery("SELECT * FROM Local ORDER BY ROWID ASC LIMIT 1");
    if (_local.length > 0) {
      Map<String, dynamic> local = _local[0];
      _localCache = Local.fromJsonOrSql({...local}).toJson();
    } else {
      _localCache = Map<String, dynamic>();
    }
    if (DB.getLocal("showDebugToasts") == null) {
      await DB.setLocal("showDebugToasts", false);
    }
    if (DB.getLocal("theme") == null) {
      await DB.setLocal("theme", "Dark");
    }
    print("Initialized Local Cache");
  }

  static _clearDB() async {
    await _database.execute("DROP TABLE IF EXISTS Courses");
    _courseCache = [];
    toastDebug("Cleared Course DB");
  }

  static _clearSettings() async {
    await _database.execute("DROP TABLE IF EXISTS Settings");
    _settingsCache = null;
    toastDebug("Cleared Settings DB");
  }

  static _clearLocal() async {
    await _database.execute("DROP TABLE IF EXISTS Local");
    _localCache = null;
    toastDebug("Cleared Local DB");
  }

  static _addCourse(Courses newCourse) async {
    var res = await _database.insert("Courses", newCourse.toSql());
    _courseCache.add(newCourse.toJson());
    toastDebug("Added course " + _courseCache.length.toString());
    return res;
  }

  static clearCourses() async {
    await _clearDB();
    await initCourseCache();
  }

  static writeSettings(Settings settings) async {
    await database;
    await _clearSettings();
    await _initSettingsCache();
    await _database.insert("Settings", settings.toSql());
    _settingsCache = settings.toJson();
    toastDebug("Saved Settings");
    return _localCache;
  }

  static writeCourses(String courseString) async {
    await database;
    List<Courses> courses = coursesFromJsonString(courseString);
    if (numCourses > 0 && courses.length > 0) {
      await clearCourses();
    }
    for (Courses course in courses) {
      await _addCourse(course);
    }
  }

  static Color getColor(int index) {
    if (_settingsCache == null) return null;
    if (_settingsCache.containsKey("appearance")) {
      var appearance = _settingsCache["appearance"];
      if (appearance == null) return null;
      var classColors = appearance["classColors"];
      if (classColors == null) return null;
      if (index != null && index < classColors.length) {
        return HexColor.fromHex(classColors[index]);
      }
    }
    return null;
  }

  static getSetting(String key) {
    if (_settingsCache.containsKey(key)) {
      return _settingsCache[key];
    }
    return null;
  }

  static getCourse(int index) {
    if (_courseCache == null) return null;
    if (index != null && index < _courseCache.length) {
      return _courseCache[index];
    }
    return null;
  }

  static writeLocal(Local local) async {
    await database;
    await _database.insert("Local", local.toSql());
    _localCache = local.toJson();
    print("Saved Local");
  }

  static setLocal(String key, dynamic value) async {
    await database;
    _localCache[key] = value;
    if (key == "showDebugToasts" && value == true) {
      toastDebug("Here is an example of a debug toast");
    }
    var _local = Local.fromJsonOrSql(_localCache);
    await writeLocal(_local);
    print("Saved local setting: " + key + " | " + value.toString());
  }

  static getLocal(String key) {
    if (_localCache == null) return null;
    if (_localCache.containsKey(key)) {
      return _localCache[key];
    }
    return null;
  }
}
