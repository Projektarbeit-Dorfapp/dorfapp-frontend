import 'package:flutter/material.dart';

final ThemeData basicTheme = new ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.lightBlue[800],
  accentColor: Colors.cyan[600],
  primarySwatch: Colors.blue,
  fontFamily: 'Georgia',
  textTheme: TextTheme(
    headline: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
    body1: TextStyle(fontSize: 40, fontStyle: FontStyle.italic),
    body2: TextStyle(fontSize: 60, fontFamily: 'Hind'),
  ),
);
