class Assignment {
  Assignment({
    this.date,
    this.category,
    this.assignmentName,
    this.exclude,
    this.pointsPossible,
    this.pointsGotten,
    this.gradePercent,
    this.psaid,
  });

  String date;
  String category;
  String assignmentName;
  bool exclude;
  double pointsPossible;
  dynamic pointsGotten;
  dynamic gradePercent;
  int psaid;

  factory Assignment.fromMap(Map<String, dynamic> json) => Assignment(
        date: json["date"],
        category: json["category"],
        assignmentName: json["assignment_name"],
        exclude: json["exclude"],
        pointsPossible: json["points_possible"].toDouble(),
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
