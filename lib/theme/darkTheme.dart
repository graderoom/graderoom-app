import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graderoom_app/extensions.dart';

class DarkTheme {
  static const String logoPath = 'assets/images/dark/logo.png';

  static final ThemeData themeData = ThemeData(
      fontFamily: 'Montserrat',
      primarySwatch: Colors.grey,
      accentColor: HexColor.fromHex("#AAAAAA"),
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: HexColor.fromHex("#333333"),
      brightness: Brightness.dark,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      primaryColor: HexColor.fromHex("#EEEEEE"),
      primaryColorLight: Colors.grey[500],
      primaryColorDark: Colors.black,
      focusColor: HexColor.fromHex("#333333"),
      pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }));

  static final BoxDecoration textFieldBoxDecoration = BoxDecoration(
    color: themeData.primaryColorLight,
    borderRadius: BorderRadius.circular(10.0),
  );
}
