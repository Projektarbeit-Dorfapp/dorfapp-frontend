import 'package:flutter/material.dart';

final ThemeData basicTheme = new ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.lightBlue[800],
  accentColor: Colors.cyan[600],
  primarySwatch: Colors.blue,
  fontFamily: 'Georgia',
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
    headline2: TextStyle(fontSize: 30),
    bodyText1: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 10, fontFamily: 'Hind'),
  ),
);
