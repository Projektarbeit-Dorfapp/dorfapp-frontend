import 'package:flutter/material.dart';

class CustomBorder extends StatelessWidget {
  final Color color;
  CustomBorder({this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: color == null ? Color(0xFF141e3e): color, width: 2.0))));
  }
}
