import 'package:flutter/material.dart';

class Constants {
  static const String appName = 'Graderoom';
  static const String logoPath = 'assets/images/logo.png';
  static const String dbPath = 'offlineStore.db';
  static const String baseURL = 'http://192.168.1.31:5998';

  static final kHintTextStyle = TextStyle(
    fontFamily: 'Montserrat',
  );

  static final kLabelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
  );

  static final kBoxDecorationStyle = BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.circular(10.0),
  );
}
