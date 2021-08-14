import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graderoom_app/database/assignmentModel.dart';
import 'package:graderoom_app/database/courseModel.dart';
import 'package:graderoom_app/database/dataModel.dart';
import 'package:graderoom_app/database/globals.dart';
import 'package:graderoom_app/overlays/toaster.dart';
import 'package:graderoom_app/theme/themeNotifier.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AssignmentsScreen extends StatefulWidget {
  @override
  _AssignmentsState createState() => _AssignmentsState();
}

class _AssignmentsState extends State<AssignmentsScreen> {
  late final _themeNotifier = Provider.of<ThemeNotifier>(context);
  late final Map<String, dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  late final Course course = arguments["Course"] as Course;
  late final Color color = arguments["Color"] as Color;
  late final int index = arguments["index"] as int;
  late final sortingData = Globals.settings!.sortingData;
  late final PreferredSizeWidget appBar = _themeNotifier.appBar(
    context: context,
    title: Text(
      course.className,
      style: TextStyle(
        color: _themeNotifier.iconColor,
      ),
    ),
  );

  late final IndexedScrollController _scrollController = IndexedScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 200.0),
              child: Scrollbar(
                radius: Radius.circular(2.0),
                child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  physics: ScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        margin: EdgeInsets.all(5.0),
                        semanticContainer: true,
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            course.overallPercent.toString() + "% (" + course.overallLetter.toString() + ")",
                            style: _themeNotifier.overallGradeInAssignmentsScreenTextStyle.copyWith(
                              color: color,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 200.0,
                        child: IndexedListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          reverse: !sortingData["dateSort"][this.index],
                          itemBuilder: (BuildContext context, int index) {
                            if (index < 0) index = course.grades.length + index;
                            Assignment assignment = course.grades[index];
                            return Card(
                              margin: EdgeInsets.all(5.0),
                              semanticContainer: true,
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15.0),
                                onLongPress: () => toastDebug("That worked"),
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(assignment.date),
                                            Text('[' + assignment.category + ']'),
                                            Container(
                                              child: Text(
                                                assignment.assignmentName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              _parsedAssignmentScore(
                                                assignment.pointsGotten,
                                                assignment.pointsPossible,
                                              ),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            _getDeltaText(index),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 5.0),
                  child: Card(
                    margin: EdgeInsets.only(
                      bottom: 5.0,
                    ),
                    semanticContainer: true,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                    child: Container(
                      height: 200.0,
                      padding: EdgeInsets.only(bottom: 5.0, left: 10.0, right: 20.0, top: 20.0),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: <LineChartBarData>[
                            LineChartBarData(
                              spots: _generateSpots(index),
                              isCurved: true,
                              preventCurveOverShooting: true,
                              curveSmoothness: 0.5,
                              colors: [color],
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                getDotPainter: (a, b, c, d) => FlDotCirclePainter(
                                  color: color,
                                  strokeColor: Colors.transparent,
                                  radius: 3.0,
                                ),
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchCallback: (LineTouchResponse response) async {
                              if (response.lineBarSpots == null) return;
                              await _scrollController.animateToIndex(
                                response.lineBarSpots![0].spotIndex,
                                duration: Duration(milliseconds: 250),
                              );
                              toastDebug("Scrolled to " + response.lineBarSpots![0].spotIndex.toString());
                            },
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Theme.of(context).backgroundColor.withOpacity(0.8),
                              fitInsideHorizontally: true,
                              tooltipRoundedRadius: 4.0,
                              showOnTopOfTheChartBoxArea: true,
                              fitInsideVertically: true,
                              getTooltipItems: (spots) {
                                Map<Color, String> deltaData = _getDeltaData(spots[0].spotIndex);
                                Color deltaColor = deltaData.keys.first;
                                String deltaString = deltaData.values.first;
                                if (deltaString != "") deltaString = "\n" + deltaString;
                                List<TextSpan> textSpans = [
                                  TextSpan(
                                    text: "\n" + Data.parsedData[this.index].assignmentScoresParsed[spots[0].spotIndex],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ];
                                textSpans.add(
                                  TextSpan(
                                    text: "\n" +
                                        Data.parsedData[this.index].rawData[spots[0].spotIndex].toStringAsFixed(2) +
                                        "%",
                                    style: TextStyle(),
                                  ),
                                );
                                textSpans.add(
                                  TextSpan(
                                    text: deltaString,
                                    style: TextStyle(
                                      color: deltaColor,
                                    ),
                                  ),
                                );
                                return [
                                  LineTooltipItem(
                                    Data.parsedData[this.index].assignmentNames[spots[0].spotIndex].toString(),
                                    TextStyle(),
                                    children: textSpans,
                                  ),
                                ];
                              },
                            ),
                            touchSpotThreshold: 5,
                          ),
                          gridData: FlGridData(
                            drawVerticalLine: true,
                            verticalInterval: 4 * 7 * 24 * 60 * 60 * 1000,
                            drawHorizontalLine: false,
                            getDrawingVerticalLine: (a) => FlLine(
                              strokeWidth: 0.5,
                              color: _themeNotifier.iconColor,
                            ),
                          ),
                          borderData: FlBorderData(
                            border: Border(
                              top: BorderSide.none,
                              right: BorderSide.none,
                              bottom: BorderSide(
                                color: _themeNotifier.iconColor,
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                              left: BorderSide(
                                color: _themeNotifier.iconColor,
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: SideTitles(
                                getTextStyles: (value) => _themeNotifier.labelTextStyle,
                                showTitles: true,
                                interval: 4 * 7 * 24 * 60 * 60 * 1000,
                                getTitles: (value) {
                                  return DateFormat("MMMM").format(DateTime.fromMillisecondsSinceEpoch(value.round()));
                                }),
                            leftTitles: SideTitles(
                              getTextStyles: (value) => _themeNotifier.labelTextStyle,
                              showTitles: true,
                              interval: 15.0,
                            ),
                          ),
                          maxY: 110,
                          minY: 70,
                        ),
                        swapAnimationDuration: Duration(milliseconds: 250),
                        swapAnimationCurve: Curves.easeIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _parsedAssignmentScore(dynamic pointsGotten, dynamic pointsPossible) {
    return (pointsGotten == false ? "--" : pointsGotten).toString() +
        "/" +
        (pointsPossible == false ? "--" : pointsPossible).toString();
  }

  List<FlSpot> _generateSpots(int index) {
    List<Map> _points = Data.chartData[index].mixedData;
    List<FlSpot> _spots = _points.map((p) {
      return FlSpot(
        p["x"].toDouble(),
        p["y"],
      );
    }).toList();
    return _spots;
  }

  Map<Color, String> _getDeltaData(int index) {
    List<double> rawData = Data.parsedData[this.index].rawData;
    if (index == 0) return {_themeNotifier.iconColor: ""};
    double delta = rawData[index] - rawData[index - 1];
    String deltaString = "";
    Color deltaColor = _themeNotifier.iconColor;
    if (delta > 0) {
      deltaColor = Colors.green;
      deltaString = "↑" + ((delta * 1000).round() / 1000).toStringAsFixed(2) + "%";
    } else if (delta < 0) {
      deltaColor = Colors.red;
      deltaString = "↓" + ((delta * 1000).round() / 1000).abs().toStringAsFixed(2) + "%";
    }
    return {deltaColor: deltaString};
  }

  Text _getDeltaText(int index) {
    Map<Color, String> deltaData = _getDeltaData(index);
    Color deltaColor = deltaData.keys.first;
    String deltaString = deltaData.values.first == "" ? "\n±0.00%" : deltaData.values.first;
    FontWeight fontWeight = deltaString.startsWith("\n±") ? FontWeight.normal : FontWeight.bold;

    return Text(
      deltaString,
      style: TextStyle(
        color: deltaColor,
        fontWeight: fontWeight,
      ),
    );
  }
}
