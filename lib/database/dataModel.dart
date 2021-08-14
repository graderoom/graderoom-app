import 'package:graderoom_app/database/assignmentModel.dart';
import 'package:graderoom_app/database/courseModel.dart';
import 'package:graderoom_app/database/globals.dart';

class Data {
  Data(this._courses, this._weights) {
    _chartData = [];
    _parsedData = [];
    _categorySortedData = [];
    for (var i = 0; i < _courses.length; i++) {
      List categories = (_weights[_courses[i].className]["weights"] as Map).keys.toList();
      List<Assignment> grades = _courses[i].grades;
      String className = _courses[i].className;
      List<dynamic> overallGradeSteps = [];
      List<double> excludedGradeSteps = [];
      List<double> categoryGradeSteps = [];
      Map<String, Map> categoryGrades = {}; // If category is default
      Map<String, Map> totalPossiblesAndGottens = {}; //by category
      double totalWeightValue =
          0; // divide by the total weight amount - so even if the final is not entered the grade is still of of 100
      Map weightData = Globals.general!.weightData;
      // VERY JANK CHANGE LATER
      bool doesntHaveWeights =
          !(Globals.general!.weightData.containsKey(className)) || (weightData[className]["hasWeights"] == "false");
      for (var assignment in grades) {
        var category = assignment.category;
        if (doesntHaveWeights) {
          category = "default";
          if (categoryGrades[assignment.category] == null) {
            categoryGrades[assignment.category] = {
              "totalPossible": 0,
              "totalGotten": 0,
            };
          }
        }
        if (!totalPossiblesAndGottens.containsKey(category) &&
            !assignment.exclude &&
            assignment.pointsPossible != false &&
            assignment.pointsGotten != false) {
          double weightVal = 100;
          if (!doesntHaveWeights) {
            weightVal = weightData[className]["weights"][category].toDouble();
          }
          totalPossiblesAndGottens[category] = {
            "totalPossible": 0,
            "totalGotten": 0,
            "weight": weightVal,
          };
          totalWeightValue += weightVal;
        }
        if (!assignment.exclude) {
          if (assignment.pointsPossible != false && assignment.pointsGotten != false) {
            totalPossiblesAndGottens[category]!["totalPossible"] += assignment.pointsPossible;
            totalPossiblesAndGottens[category]!["totalGotten"] += assignment.pointsGotten;
            if (doesntHaveWeights) {
              categoryGrades[assignment.category]!["totalPossible"] += assignment.pointsPossible;
              categoryGrades[assignment.category]!["totalGotten"] += assignment.pointsGotten;
            }
            double overallPercent = 0;
            for (Map value in totalPossiblesAndGottens.values) {
              if (value["totalGotten"] == false || value["totalPossible"] == false) {
                totalWeightValue -= value["weight"];
                value["weight"] = 0;
                continue;
              }
              overallPercent += value["weight"] *
                  (value["totalPossible"] != 0
                      ? (value["totalGotten"] / value["totalPossible"] * 100 * 100).round() / 100
                      : 100);
            }
            double total = (overallPercent / totalWeightValue * 100).round() / 100;
            overallGradeSteps.add(total);
          } else {
            overallGradeSteps.add(overallGradeSteps.lastWhere((x) => x != false, orElse: () => 100.0));
          }
        } else {
          overallGradeSteps.add(false);
          excludedGradeSteps.add(overallGradeSteps.lastWhere((x) => x != false, orElse: () => 100.0));
        }
        if (doesntHaveWeights) {
          if (categoryGrades.containsKey(assignment.category)) {
            categoryGradeSteps.add((categoryGrades[assignment.category]!["totalPossible"] != 0
                ? (categoryGrades[assignment.category]!["totalGotten"] /
                            categoryGrades[assignment.category]!["totalPossible"] *
                            100 *
                            100)
                        .round() /
                    100
                : 100));
          } else {
            categoryGradeSteps.add(100);
          }
        } else {
          if (totalPossiblesAndGottens.containsKey(category)) {
            categoryGradeSteps.add((totalPossiblesAndGottens[category]!["totalPossible"] != 0
                ? (totalPossiblesAndGottens[category]!["totalGotten"] /
                            totalPossiblesAndGottens[category]!["totalPossible"] *
                            100 *
                            100)
                        .round() /
                    100
                : 100));
          } else {
            categoryGradeSteps.add(100);
          }
        }
      }
      List<String> assignmentNames = grades.where((x) => !x.exclude).map((x) => x.assignmentName).toList();
      List<DateTime> assignmentDates = grades.where((x) => !x.exclude).map((x) {
        List<String> parts = x.date.split("/");
        String parsableDate = parts[2] + parts.getRange(0, 2).join();
        return DateTime.parse(parsableDate);
      }).toList();
      List<Assignment> _assignmentTimestamps = grades.where((x) => !x.exclude).toList();
      List<int> assignmentTimestamps = grades.where((x) => !x.exclude).toList().asMap().entries.map((entry) {
        List<String> parts = entry.value.date.split("/");
        String parsableDate = parts[2] + parts.getRange(0, 2).join();
        return (DateTime.parse(parsableDate).millisecondsSinceEpoch +
                ((24 *
                            60 *
                            60 *
                            1000 /
                            _assignmentTimestamps.where((assignment) => entry.value.date == assignment.date).length +
                        1) *
                    _assignmentTimestamps
                        .asMap()
                        .entries
                        .where((_entry) => _entry.key < entry.key && entry.value.date == _entry.value.date)
                        .length))
            .round();
      }).toList();
      List<dynamic> assignmentPercents = grades.where((x) => !x.exclude).map((x) => x.gradePercent).toList();
      List<String> assignmentScoresParsed =
          grades.where((x) => !x.exclude).map((x) => _parsedAssignmentScore(x.pointsGotten, x.pointsPossible)).toList();
      List<String> assignmentCategories = grades.where((x) => !x.exclude).map((x) => x.category).toList();
      List<Map> mixedData = overallGradeSteps
          .where((x) => x != false)
          .toList()
          .asMap()
          .entries
          .map((entry) => {"x": assignmentTimestamps[entry.key], "y": entry.value})
          .toList();
      _chartData.add(
        ChartData(
          assignmentNames,
          assignmentDates,
          assignmentTimestamps,
          assignmentPercents,
          assignmentScoresParsed,
          assignmentCategories,
          mixedData,
        ),
      );
      assignmentNames = grades.map((x) => x.assignmentName).toList();
      assignmentDates = grades.map((x) {
        List<String> parts = x.date.split("/");
        String parsableDate = parts[2] + parts.getRange(0, 2).join();
        return DateTime.parse(parsableDate);
      }).toList();
      assignmentPercents = grades.map((x) => x.gradePercent).toList();
      assignmentScoresParsed = grades.map((x) => _parsedAssignmentScore(x.pointsGotten, x.pointsPossible)).toList();
      assignmentCategories = grades.map((x) => x.category).toList();
      List<bool> assignmentExcludes = grades.map((x) => x.exclude).toList();
      List<int> assignmentPSAIDs = grades.map((x) => x.psaid).toList();
      List<double> rawData = overallGradeSteps
          .asMap()
          .entries
          .map((entry) => entry.value == false
              ? (entry.key >= 0 ? excludedGradeSteps.removeAt(0) : 100) as double
              : entry.value as double)
          .toList();
      _parsedData.add(
        ParsedData(
          assignmentNames,
          assignmentDates,
          assignmentPercents,
          assignmentScoresParsed,
          assignmentCategories,
          assignmentExcludes,
          assignmentPSAIDs,
          rawData,
        ),
      );

      // This took forever...I am so proud of it - Joel 06/03/20 10:25PM
      List<int> sortHelper =
          List.filled(assignmentCategories.length, null).asMap().entries.map((entry) => entry.key).toList();
      sortHelper
          .sort((a, b) => categories.indexOf(assignmentCategories[a]) - categories.indexOf(assignmentCategories[b]));

      _categorySortedData.add(
        CategorySortedData(
          assignmentNames
              .asMap()
              .entries
              .map((entry) => _parsedData[i].assignmentNames[sortHelper[entry.key]])
              .toList(),
          assignmentDates
              .asMap()
              .entries
              .map((entry) => _parsedData[i].assignmentDates[sortHelper[entry.key]])
              .toList(),
          assignmentPercents
              .asMap()
              .entries
              .map((entry) => _parsedData[i].assignmentPercents[sortHelper[entry.key]])
              .toList(),
          assignmentScoresParsed
              .asMap()
              .entries
              .map((entry) => _parsedData[i].assignmentScoresParsed[sortHelper[entry.key]])
              .toList(),
          assignmentCategories
              .asMap()
              .entries
              .map((entry) => _parsedData[i].assignmentCategories[sortHelper[entry.key]])
              .toList(),
          assignmentExcludes
              .asMap()
              .entries
              .map((entry) => _parsedData[i].assignmentExcludes[sortHelper[entry.key]])
              .toList(),
          assignmentPSAIDs
              .asMap()
              .entries
              .map((entry) => _parsedData[i].assignmentPSAIDs[sortHelper[entry.key]])
              .toList(),
          categoryGradeSteps.asMap().entries.map((entry) => _parsedData[i].rawData[sortHelper[entry.key]]).toList(),
          sortHelper,
        ),
      );
    }
  }

  List<Course> _courses;
  Map _weights;

  static List<ChartData> _chartData = [];
  static List<ParsedData> _parsedData = [];
  static List<CategorySortedData> _categorySortedData = [];

  static List<ChartData> get chartData => _chartData;

  static List<ParsedData> get parsedData => _parsedData;

  static List<CategorySortedData> get categorySortedData => _categorySortedData;

  String _parsedAssignmentScore(dynamic pointsGotten, dynamic pointsPossible) {
    return (pointsGotten == false ? "--" : pointsGotten).toString() +
        "/" +
        (pointsPossible == false ? "--" : pointsPossible).toString();
  }
}

class ChartData {
  ChartData(
    this._assignmentNames,
    this._assignmentDates,
    this._assignmentTimestamps,
    this._assignmentPercents,
    this._assignmentScoresParsed,
    this._assignmentCategories,
    this._mixedData,
  );

  List<String> _assignmentNames;
  List<DateTime> _assignmentDates;
  List<int> _assignmentTimestamps;
  List<dynamic> _assignmentPercents;
  List<String> _assignmentScoresParsed;
  List<String> _assignmentCategories;
  List<Map> _mixedData;

  List<String> get assignmentNames => _assignmentNames;

  List<DateTime> get assignmentDates => _assignmentDates;

  List<int> get assignmentTimestamps => _assignmentTimestamps;

  List<dynamic> get assignmentPercents => _assignmentPercents;

  List<String> get assignmentScoresParsed => _assignmentScoresParsed;

  List<String> get assignmentCategories => _assignmentCategories;

  List<Map> get mixedData => _mixedData;
}

class ParsedData {
  ParsedData(
    this._assignmentNames,
    this._assignmentDates,
    this._assignmentPercents,
    this._assignmentScoresParsed,
    this._assignmentCategories,
    this._assignmentExcludes,
    this._assignmentPSAIDs,
    this._rawData,
  );

  List<String> _assignmentNames;
  List<DateTime> _assignmentDates;
  List<dynamic> _assignmentPercents;
  List<String> _assignmentScoresParsed;
  List<String> _assignmentCategories;
  List<bool> _assignmentExcludes;
  List<int> _assignmentPSAIDs;
  List<double> _rawData;

  List<String> get assignmentNames => _assignmentNames;

  List<DateTime> get assignmentDates => _assignmentDates;

  List<dynamic> get assignmentPercents => _assignmentPercents;

  List<String> get assignmentScoresParsed => _assignmentScoresParsed;

  List<String> get assignmentCategories => _assignmentCategories;

  List<bool> get assignmentExcludes => _assignmentExcludes;

  List<int> get assignmentPSAIDs => _assignmentPSAIDs;

  List<double> get rawData => _rawData;
}

class CategorySortedData {
  CategorySortedData(
    this._assignmentNames,
    this._assignmentDates,
    this._assignmentPercents,
    this._assignmentScoresParsed,
    this._assignmentCategories,
    this._assignmentExcludes,
    this._assignmentPSAIDs,
    this._rawData,
    this._originalIndices,
  );

  List<String> _assignmentNames;
  List<DateTime> _assignmentDates;
  List<dynamic> _assignmentPercents;
  List<String> _assignmentScoresParsed;
  List<String> _assignmentCategories;
  List<bool> _assignmentExcludes;
  List<int> _assignmentPSAIDs;
  List<double> _rawData;
  List<int> _originalIndices;

  List<String> get assignmentNames => _assignmentNames;

  List<DateTime> get assignmentDates => _assignmentDates;

  List<dynamic> get assignmentPercents => _assignmentPercents;

  List<String> get assignmentScoresParsed => _assignmentScoresParsed;

  List<String> get assignmentCategories => _assignmentCategories;

  List<bool> get assignmentExcludes => _assignmentExcludes;

  List<int> get assignmentPSAIDs => _assignmentPSAIDs;

  List<double> get rawData => _rawData;

  List<int> get originalIndices => _originalIndices;
}
