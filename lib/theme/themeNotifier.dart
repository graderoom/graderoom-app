import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graderoom_app/database/db.dart';
import 'package:graderoom_app/database/preferenceEnums.dart';
import 'package:graderoom_app/extensions.dart';
import 'package:graderoom_app/overlays/toaster.dart';
import 'package:graderoom_app/theme/darkTheme.dart';
import 'package:graderoom_app/theme/lightTheme.dart';

class ThemeNotifier with ChangeNotifier {
  late String _theme;
  late ThemeMode _themeMode;
  late String _logoPath;
  late Color _iconColor;
  late TextStyle _labelTextStyle;
  late BoxDecoration _textFieldBoxDecoration;
  late BoxDecoration _brandBoxDecoration;
  late TextStyle _overallGradeInAssignmentsScreenTextStyle;

  ThemeNotifier(this._themeMode) {
    if (_themeMode == ThemeMode.light || _themeMode == ThemeMode.dark) {
      _theme = _themeMode.toString().substring(10).capitalize();
    } else {
      _theme = SchedulerBinding.instance?.window.platformBrightness == Brightness.dark ? "Dark" : "Light";
    }
    _updateInstanceData();
    toastDebug("Set theme to " + _theme);
  }

  factory ThemeNotifier.fromString(String theme) {
    _themeModeFromString(String _theme) {
      switch (_theme) {
        case "Dark":
          return ThemeMode.dark;
        case "Light":
          return ThemeMode.light;
        default:
          return ThemeMode.system;
      }
    }

    return ThemeNotifier(_themeModeFromString(theme));
  }

  PreferredSizeWidget appBar({
    required BuildContext context,
    required Widget title,
    List<Widget>? actions,
    Widget? leading,
  }) =>
      PreferredSize(
        child: Container(
          child: ClipRect(
            clipBehavior: Clip.hardEdge,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.0,
                sigmaY: 5.0,
              ),
              child: Container(
                child: AppBar(
                  leading: leading,
                  title: title,
                  iconTheme: IconThemeData(
                    color: iconColor,
                  ),
                  actions: actions,
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          56,
        ),
      );

  ThemeMode get themeMode => _themeMode;

  ThemeData get darkTheme => DarkTheme.themeData;

  ThemeData get lightTheme => LightTheme.themeData;

  String get logoPath => _logoPath;

  Color get iconColor => _iconColor;

  TextStyle get labelTextStyle => _labelTextStyle;

  BoxDecoration get textFieldBoxDecoration => _textFieldBoxDecoration;

  BoxDecoration get brandBoxDecoration => _brandBoxDecoration;

  TextStyle get overallGradeInAssignmentsScreenTextStyle => _overallGradeInAssignmentsScreenTextStyle;

  void init() async {
    await DB.database;
    String localTheme = DB.getLocal("theme");
    if (localTheme == "Light" || localTheme == "Dark") {
      _theme = localTheme;
    } else {
      _theme = SchedulerBinding.instance?.window.platformBrightness == Brightness.dark ? "Dark" : "Light";
    }
    _updateInstanceData();
    toastDebug("Set theme to " + _theme);
  }

  void _updateInstanceData() {
    switch (_theme) {
      case 'Dark':
        _logoPath = DarkTheme.logoPath;
        _iconColor = DarkTheme.themeData.iconTheme.color!;
        _textFieldBoxDecoration = DarkTheme.textFieldBoxDecoration;
        break;
      case 'Light':
        _logoPath = LightTheme.logoPath;
        _iconColor = LightTheme.themeData.iconTheme.color!;
        _textFieldBoxDecoration = LightTheme.textFieldBoxDecoration;
        break;
    }
    _labelTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );
    _brandBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
    );
    _overallGradeInAssignmentsScreenTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 50.0,
    );
    notifyListeners();
  }

  Future<void> setThemeModeFromTheme(Themes? theme) async {
    if (theme == null) return;
    _themeMode = _themeModeFromTheme(theme);
    await DB.setLocal("theme", themeStrings[theme]);
    init();
  }

  ThemeMode _themeModeFromTheme(Themes theme) {
    switch (theme) {
      case Themes.DARK:
        return ThemeMode.dark;
      case Themes.LIGHT:
        return ThemeMode.light;
      case Themes.SYSTEM:
        return ThemeMode.system;
    }
  }
}
