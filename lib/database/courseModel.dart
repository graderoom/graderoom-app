import 'dart:convert';

import 'assignmentModel.dart';

List<Course> coursesFromJsonString(String? str) {
  if (str == null) return [];
  return List<Course>.from(json.decode(str).map((x) => Course.fromMapOrResponse(x)));
}

class Course {
  Course({
    required this.className,
    required this.teacherName,
    required this.overallPercent,
    required this.overallLetter,
    required this.studentId,
    required this.sectionId,
    required this.psLocked,
    required this.grades,
  });

  static final List<String> keys = [
    "class_name",
    "teacher_name",
    "overall_percent",
    "overall_letter",
    "student_id",
    "section_id",
    "ps_locked",
    "grades",
  ];

  String className;
  String teacherName;
  dynamic overallPercent;
  dynamic overallLetter;
  String studentId;
  String sectionId;
  bool psLocked;
  List<Assignment> grades;

  factory Course.fromMapOrResponse(Map<String, dynamic> _json) {
    if (_json["grades"] is String) {
      _json["grades"] = assignmentsFromJsonString(_json["grades"]);
    } else if (!(_json["grades"] is List<Assignment>)) {
      _json["grades"] = assignmentsFromJsonString(json.encode(_json["grades"]));
    }
    return Course(
      className: _json["class_name"] as String,
      teacherName: _json["teacher_name"] as String,
      overallPercent: _json["overall_percent"] as dynamic,
      overallLetter: _json["overall_letter"] as dynamic,
      studentId: _json["student_id"] as String,
      sectionId: _json["section_id"] as String,
      psLocked: _json["ps_locked"] as bool,
      grades: _json["grades"] as List<Assignment>,
    );
  }

  Map<String, dynamic> toMap() => {
        "class_name": className,
        "teacher_name": teacherName,
        "overall_percent": overallPercent,
        "overall_letter": overallLetter,
        "student_id": studentId,
        "section_id": sectionId,
        "ps_locked": psLocked,
        "grades": grades.map((x) => x.toMap()).toList(),
      };
}
