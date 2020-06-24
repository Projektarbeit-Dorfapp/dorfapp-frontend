import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Meike Nedwidek
class DateComment extends StatelessWidget {

  final DateTime datetime;
  final Color color;

  const DateComment(this.datetime, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      _getDateDifference(),
      style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 12.0,
          color: this.color
      ),
    );
  }

  _getDateDifference(){
    DateTime curDatetime = DateTime.now();

    if (this.datetime == null) {
      return '';
    }

    Duration dateDiff = this.datetime.difference(curDatetime) *-1;

    if (dateDiff.inSeconds <= 59) {
      return 'Gerade eben';
    }
    if (dateDiff.inMinutes <= 59) {
      return 'Vor ' + dateDiff.inMinutes.toString() + ' Min.';
    }
    if (dateDiff.inHours <= 23) {
      return 'Vor ' + dateDiff.inHours.toString() + ' Std.';
    }
    if (dateDiff.inDays == 1) {
      return 'Vor ' + dateDiff.inDays.toString() + ' Tag';
    }
    return 'Vor ' + dateDiff.inDays.toString() + ' Tagen';
  }
}