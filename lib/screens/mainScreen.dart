import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:graderoom_app/database/db.dart';
import 'package:graderoom_app/httpClient.dart';
import 'package:graderoom_app/screens/loginScreen.dart';
import 'package:graderoom_app/screens/settingsScreen.dart';
import 'package:graderoom_app/theme/themeNotifier.dart';
import 'package:graderoom_app/toaster.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Main();
  }
}

class Main extends StatefulWidget {
  @override
  MainState createState() {
    return MainState();
  }
}

class MainState extends State<Main> with WidgetsBindingObserver {
  ThemeNotifier _themeNotifier;

  Future<void> _setupGeneral() async {
    var generalResponse = await HTTPClient().getGeneral();
    var courses = generalResponse.gradeData;
    await DB.writeCourses(courses);
    setState(() {});
  }

  Future<void> _checkUpdateBackground() async {
    var settingsResponse = await HTTPClient().getSettings();
    await DB.writeSettings(settingsResponse);
    var grades;
    await for (Response r in HTTPClient().checkUpdateBackgroundStream()) {
      grades = r.data['grades'];
    }
    await DB.writeCoursesFromString(grades);
    setState(() {});
  }

  Future<void> _checkStatus() async {
    var response = await HTTPClient().getStatus();
    if (response == null || response.statusCode == 401) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      _checkUpdateBackground();
      _setupGeneral();
    }
  }

  @override
  void initState() {
    _setupGeneral();
    _checkUpdateBackground();
    DB.database;
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    _themeNotifier.init();
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    _themeNotifier = Provider.of<ThemeNotifier>(context);
    return WillPopScope(
      onWillPop: () async {
        return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to exit?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              color: _themeNotifier.iconColor,
              onPressed: () => toast("This button does nothing yet"),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              color: _themeNotifier.iconColor,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SettingsScreen(),
                ),
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _checkStatus,
          child: _buildOverviewGrid(),
        ),
      ),
    );
  }

  Widget _buildOverviewGrid() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: DB.numCourses == null ? 0 : DB.numCourses,
      itemBuilder: (BuildContext context, int index) => Container(
        child: _buildOverviewGridCard(index),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
    );
  }

  GestureDetector _buildOverviewGridCard(int index) {
    var course = DB.getCourse(index);
    var color = DB.getColor(index);
    if (color == null || course == null) {
      return GestureDetector();
    }
    var className = course["class_name"];
    var overallPercent = course["overall_percent"];
    var overallLetter = course["overall_letter"];
    return GestureDetector(
      onTap: () => toastDebug("Course $index tapped"),
      child: Card(
        margin: EdgeInsets.all(5.0),
        semanticContainer: true,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "$className",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "$overallLetter",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 80.0,
                  color: color,
                ),
              ),
              Text(
                "$overallPercent%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
