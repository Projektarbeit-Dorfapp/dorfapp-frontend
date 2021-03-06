import 'package:flutter/material.dart';

//Hannes Hauenstein

final ThemeData basicTheme = new ThemeData(
  //brightness: Brightness.dark,
  primaryColor: Color(0xff6178a3),
  buttonColor: Color(0xff548c58),
  textSelectionColor: Color(0xff548c58),
  cardColor: Color(0xff141e3e),
  accentColor: Color(0xff548c58),
  backgroundColor: Colors.white,
  //primarySwatch: Colors.blue,
  ///Fontfamaly müsste man auf Raleway umbauen, ich lasse es erstmal so wie es ist
  ///Thema fürs nächste meeting
  fontFamily: 'Raleway',
  textTheme: TextTheme(
    headline1: TextStyle(fontFamily: 'Raleway', fontSize: 60, fontWeight: FontWeight.bold),
    headline2: TextStyle(fontFamily: 'Raleway', fontSize: 30),
    bodyText1: TextStyle(fontFamily: 'Raleway', fontSize: 20, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontFamily: 'Raleway', fontSize: 10),
    button: TextStyle(fontFamily: 'Raleway', fontSize: 14)
  ),
);


