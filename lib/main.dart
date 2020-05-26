import 'package:dorf_app/basic_theme.dart';
import 'package:flutter/material.dart';
import 'package:dorf_app/screens/home/home.dart';

void main() => runApp(MyApp());

// Hannes Hauenstein

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dorf App',
      theme: basicTheme,
      home: Home(),
    );
  }
}

