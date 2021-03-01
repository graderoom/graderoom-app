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
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DB {
  DB._();

  static final DB db = DB._();

  static Database _database;
  static StoreRef _store;
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
      await _openDB();
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

  static Future<void> _openDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, Constants.dbPath);
    _database = await databaseFactoryIo.openDatabase(path);
    _store = StoreRef<String, dynamic>.main();
    await localCache;
    await courseCache;
    await settingsCache;
    print("Opened new database");
  }

  static Future<void> _initCourses() async {
    List<Map<String, dynamic>> courses = await _store.record("Courses").get(_database);
    if (courses == null) {
      await _store.record("Courses").put(_database, []);
      toastDebug("Created Courses DB");
    } else {
      toastDebug("Courses DB already exists!");
    }
  }

  static Future<void> _fixCourses() async {
    List<String> keys = Courses.keys;
    List courses = await _store.record('Courses').get(_database);
    for (var i = 0; i < courses.length; i++) {
      var course = courses[i];
      var currentKeys = course.keys.toList();
      for (var j = 0; j < currentKeys.length; j++) {
        if (keys.contains(currentKeys[j])) continue;
        course.remove(currentKeys[j]);
        print("Deleted " + currentKeys[j] + " from course " + j.toString());
      }
      for (var j = 0; j < keys.length; j++) {
        if (currentKeys.contains(keys[j])) continue;
        course[keys[j]] = null;
        print("Added " + keys[j] + " to course " + j.toString());
      }
    }
    await _store.record("Courses").put(_database, courses);
  }

  static Future<void> _initSettings() async {
    Map<String, dynamic> settings = await _store.record("Settings").get(_database);
    if (settings == null) {
      await _store.record("Settings").put(_database, {});
      toastDebug("Created Settings DB");
    } else {
      toastDebug("Settings DB already exists!");
    }
  }

  static Future<void> _fixSettings() async {
    List<String> keys = Settings.keys;
    Map<String, dynamic> _settings = await _store.record('Settings').get(_database);
    Map<String, dynamic> settings = {..._settings};
    List<String> currentKeys = settings.keys.toList();
    for (int j = 0; j < currentKeys.length; j++) {
      if (keys.contains(currentKeys[j])) continue;
      settings.remove(currentKeys[j]);
      print("Deleted setting: " + currentKeys[j]);
    }
    for (int j = 0; j < keys.length; j++) {
      if (currentKeys.contains(keys[j])) continue;
      settings[keys[j]] = null;
      print("Added setting: " + keys[j]);
    }
    await _store.record("Settings").put(_database, settings);
  }

  static Future<void> _initLocal() async {
    Map<String, dynamic> local = await _store.record("Local").get(_database);
    if (local == null) {
      await _store.record("Local").put(_database, {});
      toastDebug("Created Local DB");
    } else {
      toastDebug("Local DB already exists!");
    }
  }

  static Future<void> _fixLocal() async {
    List<String> keys = Local.keys;
    Map<String, dynamic> _local = await _store.record('Local').get(_database);
    Map<String, dynamic> local = {..._local};
    List<String> currentKeys = local.keys.toList();
    for (int j = 0; j < currentKeys.length; j++) {
      if (keys.contains(currentKeys[j])) continue;
      local.remove(currentKeys[j]);
      print("Deleted local: " + currentKeys[j]);
    }
    for (int j = 0; j < keys.length; j++) {
      if (currentKeys.contains(keys[j])) continue;
      local[keys[j]] = null;
      print("Added local: " + keys[j]);
    }
    await _store.record("Local").put(_database, local);
  }

  static Future<void> initCourseCache() async {
    if (await _store.record("Courses").exists(_database)) {
      _fixCourses();
    } else {
      _initCourses();
    }
    List courseList = await _store.record("Courses").get(_database);
    courseList ??= [];
    _courseCache = [];
    for (Map<String, dynamic> course in courseList) {
      _courseCache.add(Courses.fromMapOrResponse(course).toMap());
    }

    print("Initialized Course Cache");
  }

  static Future<void> _initSettingsCache() async {
    if (await _store.record("Settings").exists(_database)) {
      _fixSettings();
    } else {
      _initSettings();
    }
    Map<String, dynamic> _settings = await _store.record("Settings").get(_database);
    Map<String, dynamic> settings = {..._settings};
    _settingsCache = Settings.fromMapOrResponse(settings).toMap();

    print("Initialized Settings Cache");

    if (!(["Dark", "Light", "System"]).contains(_localCache["theme"])) {
      var appearance = _settingsCache["appearance"] ?? {};
      var rawTheme = appearance["theme"];
      if (!(["dark", "light", "system"]).contains(rawTheme)) {
        rawTheme = "dark";
      }
      await DB.setLocal("theme", rawTheme.toString().capitalize());
    }
  }

  static Future<void> _initLocalCache() async {
    if (await _store.record("Local").exists(_database)) {
      _fixLocal();
    } else {
      _initLocal();
    }
    Map<String, dynamic> local = await _store.record("Local").get(_database);
    _localCache = Local.fromMap(local).toMap();

    print("Initialized Local Cache");

    if (DB.getLocal("showDebugToasts") == null) {
      await DB.setLocal("showDebugToasts", false);
    }
    if (DB.getLocal("theme") == null) {
      await DB.setLocal("theme", "Dark");
    }
  }

  static Future<void> _clearCourses() async {
    await _store.record("Courses").put(_database, []);
    _courseCache = [];
    toastDebug("Cleared Course DB");
  }

  static Future<void> _clearSettings() async {
    await _store.record("Settings").put(_database, {});
    _settingsCache = {};
    toastDebug("Cleared Settings DB");
  }

  static Future<void> _clearLocal() async {
    await _store.record("Local").put(_database, {});
    _localCache = {};
    toastDebug("Cleared Local DB");
  }

  static Future<void> _addCourse(Courses newCourse) async {
    List<dynamic> _courses = await _store.record("Courses").get(_database);
    List<dynamic> courses = [..._courses];
    courses.add(newCourse.toMap());
    await _store.record("Courses").put(_database, courses);
    _courseCache.add(newCourse.toMap());
    toastDebug("Added course " + _courseCache.length.toString());
  }

  static Future<void> writeSettings(Settings settings) async {
    await database;
    await _clearSettings();
    await _store.record("Settings").put(_database, settings.toMap());
    _settingsCache = settings.toMap();
    toastDebug("Saved Settings");
  }

  static Future<void> writeCourses(List<Courses> courses) async {
    await database;
    if (numCourses > 0 && courses.length > 0) {
      await _clearCourses();
    }
    for (Courses course in courses) {
      await _addCourse(course);
    }
    toastDebug("Synced courses");
  }

  static Future<void> writeCoursesFromString(String courseString) async {
    await database;
    List<Courses> courses = coursesFromJsonString(courseString);
    if (numCourses > 0 && courses.length > 0) {
      await _clearCourses();
    }
    for (Courses course in courses) {
      await _addCourse(course);
    }
    toastDebug("Synced courses");
  }

  static Future<void> writeLocal(Local local) async {
    await database;
    await _store.record("Local").put(_database, local.toMap());
    _localCache = local.toMap();
    print("Saved Local");
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

  static dynamic getSetting(String key) {
    if (_settingsCache.containsKey(key)) {
      return _settingsCache[key];
    }
    return null;
  }

  static Map<String, dynamic> getCourse(int index) {
    if (_courseCache == null) return null;
    if (index != null && index < _courseCache.length) {
      return _courseCache[index];
    }
    return null;
  }

  static Future<void> setLocal(String key, dynamic value) async {
    await database;
    _localCache[key] = value;
    if (key == "showDebugToasts" && value == true) {
      toastDebug("Here is an example of a debug toast");
    }
    var _local = Local.fromMap(_localCache);
    await writeLocal(_local);
    print("Saved local setting: " + key + " | " + value.toString());
  }

  static dynamic getLocal(String key) {
    if (_localCache == null) return null;
    if (_localCache.containsKey(key)) {
      return _localCache[key];
    }
    return null;
  }
}
