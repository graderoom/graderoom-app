import 'dart:convert';

import 'package:graderoom_app/database/assignmentModel.dart';

List<Course> coursesFromJsonString(String str) {
  if (str == null) return [];
  return List<Course>.from(json.decode(str).map((x) => Course.fromJsonOrSql(x)));
}

String coursesToJsonString(List<Course> data) =>
    json.encode(List<Course>.from(data.map((x) => x.toSql())));

class Course {
  Course({
    this.className,
    this.teacherName,
    this.overallPercent,
    this.overallLetter,
    this.studentId,
    this.sectionId,
    this.psLocked,
    this.grades,
  });

  String className;
  String teacherName;
  dynamic overallPercent;
  dynamic overallLetter;
  String studentId;
  String sectionId;
  int psLocked;
  String grades;

  factory Course.fromJsonOrSql(Map<String, dynamic> _json) {
    if (([true, false]).contains(_json["ps_locked"])) {
      _json["ps_locked"] = _json["ps_locked"] ? 0 : 1;
    }
    if (!(_json["grades"] is String)) {
      _json["grades"] = json.encode(_json["grades"]);
    }
    return Course(
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
    "ps_locked": psLocked == 1 ? false : true,
    "grades": assignmentsFromJsonString(grades),
  };
}
