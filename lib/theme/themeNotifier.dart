import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graderoom_app/database/db.dart';
import 'package:graderoom_app/database/preferenceEnums.dart';
import 'package:graderoom_app/theme/darkTheme.dart';
import 'package:graderoom_app/theme/lightTheme.dart';
import 'package:graderoom_app/toaster.dart';
import 'package:graderoom_app/extensions.dart';

class ThemeNotifier with ChangeNotifier  {

  String _theme;
  ThemeMode _themeMode;
  String _logoPath;
  Color _iconColor;
  TextStyle _labelTextStyle;
  BoxDecoration _textFieldBoxDecoration;
  InputDecoration _textFieldInputDecoration;
  BoxDecoration _brandBoxDecoration;

  ThemeNotifier(this._themeMode) {
    if (_themeMode == ThemeMode.light || _themeMode == ThemeMode.dark) {
      _theme = _themeMode.toString().substring(10).capitalize();
    } else {
      _theme = SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? "Dark" : "Light";
    }
    _updateInstanceData();
    print("Set theme to " + _theme);
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

  ThemeMode get themeMode => _themeMode;
  ThemeData get darkTheme => DarkTheme.themeData;
  ThemeData get lightTheme => LightTheme.themeData;
  String get logoPath => _logoPath;
  Color get iconColor => _iconColor;
  TextStyle get labelTextStyle => _labelTextStyle;
  BoxDecoration get textFieldBoxDecoration => _textFieldBoxDecoration;
  InputDecoration get textFieldInputDecoration => _textFieldInputDecoration;
  BoxDecoration get brandBoxDecoration => _brandBoxDecoration;

  void init() async {
    await DB.database;
    var localTheme = DB.getLocal("theme");
    if (localTheme == "Light" || localTheme == "Dark") {
      _theme = localTheme;
    } else {
      _theme = SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? "Dark" : "Light";
    }
    _updateInstanceData();
    toastDebug("Set theme to " + _theme);
  }

  void _updateInstanceData() {
    switch (_theme) {
      case 'Dark':
        _logoPath = DarkTheme.logoPath;
        _iconColor = DarkTheme.themeData.iconTheme.color;
        _labelTextStyle = DarkTheme.labelTextStyle;
        _textFieldBoxDecoration = DarkTheme.textFieldBoxDecoration;
        _textFieldInputDecoration = DarkTheme.textFieldInputDecoration;
        _brandBoxDecoration = DarkTheme.brandBoxDecoration;
        break;
      case 'Light':
        _logoPath = LightTheme.logoPath;
        _iconColor = LightTheme.themeData.iconTheme.color;
        _labelTextStyle = LightTheme.labelTextStyle;
        _textFieldBoxDecoration = LightTheme.textFieldBoxDecoration;
        _textFieldInputDecoration = LightTheme.textFieldInputDecoration;
        _brandBoxDecoration = LightTheme.brandBoxDecoration;
        break;
    }
    notifyListeners();
  }

  Future<void> setThemeModeFromTheme(Themes theme) async {
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
    return ThemeMode.system;
  }
}
