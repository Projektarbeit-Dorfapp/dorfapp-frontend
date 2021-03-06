import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Meike Nedwidek
class TimeDetailView extends StatelessWidget {

  final DateTime start;
  final DateTime end;
  final double fontSize;

  TimeDetailView(this.start, this.end, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
            Icons.access_time,
            color: Colors.white,
            size: 22.0
        ),
        Container(
            margin: EdgeInsets.only(left: 10.0),
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              _getTime(),
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                  fontSize: this.fontSize,
                  color: Colors.white
              ),
            )
        )
      ],
    );
  }

  _getTime(){
    if (this.start == null && this.end == null) {
      return '-';
    }
    String formattedStartTime = DateFormat('HH:mm').format(start);
    String formattedEndTime = DateFormat('HH:mm').format(end);

    if (this.end == null || formattedStartTime == formattedEndTime) {
      return formattedStartTime;
    }
    String time = formattedStartTime + ' - ' + formattedEndTime;
    return time;
  }
}