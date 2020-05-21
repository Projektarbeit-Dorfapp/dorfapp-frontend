import 'dart:async';

import 'package:dorf_app/screens/news/widgets/weatherDisplay.dart';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  Timer updateCycle;
  int hours;
  int minutes;
  final Color defaultColor = Colors.black;
  @override
  void initState() {
    super.initState();
    initializeState();
    updateState();
  }
  initializeState(){
    minutes = DateTime.now().minute;
    hours = DateTime.now().hour;
  }
  updateState() {
    final int waitTime = 1;
    updateCycle = Timer.periodic(Duration(seconds: waitTime), (Timer t) {
      setState(() {
        minutes = DateTime.now().minute;
        hours = DateTime.now().hour;
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    updateCycle.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blueGrey,
      child: Row(
        children: <Widget>[
          Text(
            transformClockNumber(hours) + ":",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Raleway",
              fontSize: 30,
              color: defaultColor,
            ),
          ),
          Text(
            transformClockNumber(minutes),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Raleway",
              fontSize: 30,
              color: defaultColor,
            ),
          ),

          WeatherDisplay(),
        ],
      ),
    );
  }

  String transformClockNumber(int clockNumber) {
    if (clockNumber >= 0 && clockNumber <= 9) {
      return "0" + clockNumber.toString();
    } else {
      return clockNumber.toString();
    }
  }
}
