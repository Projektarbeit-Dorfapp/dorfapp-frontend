import 'package:dorf_app/screens/calendar/calendar.dart';
import 'package:dorf_app/screens/forum/forum.dart';
import 'package:dorf_app/screens/home/home.dart';
import 'package:dorf_app/screens/news/news.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class Application {

  final routes = <String, WidgetBuilder> {
    '/': (BuildContext context) => new Home(),
    '/news': (BuildContext context) => new News(),
    '/calendar': (BuildContext context) => new Calendar(),
    '/forum': (BuildContext context) => new Forum(),
  };

  void main() {
    runApp(MaterialApp(
      routes: routes,
    ));
  }
}