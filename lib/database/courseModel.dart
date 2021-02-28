import 'dart:convert';

import 'package:graderoom_app/database/assignmentModel.dart';

List<Courses> coursesFromJsonString(String str) {
  if (str == null) return [];
  return List<Courses>.from(json.decode(str).map((x) => Courses.fromJsonOrSql(x)));
}

String coursesToJsonString(List<Courses> data) => json.encode(List<Courses>.from(data.map((x) => x.toSql())));

class Courses {
  Courses({
    this.className,
    this.teacherName,
    this.overallPercent,
    this.overallLetter,
    this.studentId,
    this.sectionId,
    this.psLocked,
    this.grades,
  });

  static final Map<String, String> sqlColumns = {
    "class_name": "TEXT",
    "teacher_name": "TEXT",
    "overall_percent": "",
    "overall_letter": "",
    "student_id": "TEXT",
    "section_id": "TEXT",
    "ps_locked": "TEXT",
    "grades": "TEXT",
  };

  static String get sqlModel => sqlColumns.entries.map((e) => e.key + " " + e.value).join(", ");

  String className;
  String teacherName;
  dynamic overallPercent;
  dynamic overallLetter;
  String studentId;
  String sectionId;
  int psLocked;
  String grades;

  factory Courses.fromJsonOrSql(Map<String, dynamic> _json) {
    if (([true, false]).contains(_json["ps_locked"])) {
      _json["ps_locked"] = _json["ps_locked"] ? 1 : 0;
    }
    if (!(_json["grades"] is String)) {
      _json["grades"] = json.encode(_json["grades"]);
    }
    return Courses(
      className: _json["class_name"],
      teacherName: _json["teacher_name"],
      overallPercent: _json["overall_percent"],
      overallLetter: _json["overall_letter"],
      studentId: _json["student_id"],
      sectionId: _json["section_id"],
      psLocked: _json["ps_locked"],
      grades: _json["grades"],
    );
  }

  Map<String, dynamic> toSql() => {
        "class_name": className,
        "teacher_name": teacherName,
        "overall_percent": overallPercent,
        "overall_letter": overallLetter,
        "student_id": studentId,
        "section_id": sectionId,
        "ps_locked": psLocked,
        "grades": grades,
      };

  Map<String, dynamic> toJson() => {
        "class_name": className,
        "teacher_name": teacherName,
        "overall_percent": overallPercent,
        "overall_letter": overallLetter,
        "student_id": studentId,
        "section_id": sectionId,
        "ps_locked": psLocked == 1,
        "grades": assignmentsFromJsonString(grades),
      };
}
