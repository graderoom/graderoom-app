import 'dart:convert';

List<Assignment> assignmentsFromJsonString(String? str) {
  if (str == null) return [];
  return List<Assignment>.from(json.decode(str).map((x) => Assignment.fromMap(x)));
}

class Assignment {
  Assignment({
    required this.date,
    required this.category,
    required this.assignmentName,
    required this.exclude,
    required this.pointsPossible,
    required this.pointsGotten,
    required this.gradePercent,
    required this.psaid,
  });

  String date;
  String category;
  String assignmentName;
  bool exclude;
  dynamic pointsPossible;
  dynamic pointsGotten;
  dynamic gradePercent;
  int psaid;

  factory Assignment.fromMap(Map<String, dynamic> json) => Assignment(
        date: json["date"],
        category: json["category"],
        assignmentName: json["assignment_name"],
        exclude: json["exclude"],
        pointsPossible: json["points_possible"],
        pointsGotten: json["points_gotten"],
        gradePercent: json["grade_percent"],
        psaid: json["psaid"],
      );

  Map<String, dynamic> toMap() => {
        "date": date,
        "category": category,
        "assignment_name": assignmentName,
        "exclude": exclude,
        "points_possible": pointsPossible,
        "points_gotten": pointsGotten,
        "grade_percent": gradePercent,
        "psaid": psaid,
      };
}
