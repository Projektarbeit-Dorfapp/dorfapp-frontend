import 'dart:async';

import 'package:flutter/material.dart';

class DateTimeDisplay extends StatefulWidget {
  @override
  _DateTimeDisplayState createState() => _DateTimeDisplayState();
}

class _DateTimeDisplayState extends State<DateTimeDisplay> {
  String currentDate;
  int currentWeekDay;
  Timer updateCycle;

  @override
  void initState() {
    super.initState();
    _initializeDate();
    _updateState();

  }
  @override
  void dispose() {
    super.dispose();
    updateCycle.cancel();
  }
  _updateState() {
    final int waitTime = 30;
    if(!mounted){
      return;
    }
    updateCycle = Timer.periodic(Duration(minutes: waitTime), (Timer t) {
      setState(() {
      });
    });
  }
  _initializeDate() {
    currentDate = DateTime.now().day.toString() +
        "." +
        DateTime.now().month.toString() +
        "." +
        DateTime.now().year.toString();
    currentWeekDay = DateTime.now().weekday;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          weekDay(),
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Raleway",
          ),
        ),
        Text(
          currentDate,
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Raleway"
          ),
        ),
      ],
    );
  }
  String weekDay() {
    switch (currentWeekDay) {
      case 1:
        return "Montag ";
      case 2:
        return "Dienstag ";
      case 3:
        return "Mittwoch ";
      case 4:
        return "Donnerstag ";
      case 5:
        return "Freitag ";
      case 6:
        return "Samstag ";
      case 7:
        return "Sonntag ";
      default:
        return "";
    }
  }
}
