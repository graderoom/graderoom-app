import 'dart:convert';

import 'package:graderoom_app/database/courseModel.dart';

class General {
  General({
    this.termsAndSemesters,
    this.term,
    this.semester,
    this.gradeData,
    this.weightData,
    this.addedAssignments,
    this.editedAssignments,
    this.gradeHistory,
    this.relevantClassData,
  });

  static final List<String> keys = [
    "termsAndSemesters",
    "term",
    "semester",
    "gradeData",
    "weightData",
    "addedAssignments",
    "editedAssignments",
    "relevantClassData",
  ];

  List<dynamic> termsAndSemesters;
  String term;
  String semester;
  List<Courses> gradeData;
  Map<String, dynamic> weightData;
  Map<String, dynamic> addedAssignments;
  Map<String, dynamic> editedAssignments;
  Map<String, dynamic> gradeHistory;
  Map<String, dynamic> relevantClassData;

  factory General.fromMapOrResponse(Map<String, dynamic> _json) {
    if (_json["termsAndSemesters"] is String) {
      _json["termsAndSemesters"] = json.decode(_json["termsAndSemesters"]);
    }
    if (_json["gradeData"] is String) {
      _json["gradeData"] = coursesFromJsonString(_json["gradeData"]);
    }
    if (_json["weightData"] is String) {
      _json["weightData"] = json.decode(_json["weightData"]);
    }
    if (_json["addedAssignments"] is String) {
      _json["addedAssignments"] = json.decode(_json["addedAssignments"]);
    }
    if (_json["editedAssignments"] is String) {
      _json["editedAssignments"] = json.decode(_json["editedAssignments"]);
    }
    if (_json["gradeHistory"] is String) {
      _json["gradeHistory"] = json.decode(_json["gradeHistory"]);
    }
    if (_json["relevantClassData"] is String) {
      _json["relevantClassData"] = json.decode(_json["relevantClassData"]);
    }
    return General(
      termsAndSemesters: _json["termsAndSemesters"] as List<dynamic>,
      term: _json["term"] as String,
      semester: _json["semester"] as String,
      gradeData: _json["gradeData"] as List<Courses>,
      weightData: _json["weightData"] as Map<String, dynamic>,
      addedAssignments: _json["addedAssignments"] as Map<String, dynamic>,
      editedAssignments: _json["editedAssignments"] as Map<String, dynamic>,
      gradeHistory: _json["gradeHistory"] as Map<String, dynamic>,
      relevantClassData: _json["relevantClassData"] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toMap() => {
    "termsAndSemesters": termsAndSemesters,
    "term": term,
    "semester": semester,
    "gradeData": gradeData,
    "weightData": weightData,
    "addedAssignments": addedAssignments,
    "editedAssignments": editedAssignments,
    "gradeHistory": gradeHistory,
    "relevantClassData": relevantClassData,
  };
}
