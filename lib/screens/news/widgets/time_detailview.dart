import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Meike Nedwidek
class TimeDetailView extends StatelessWidget {

  final DateTime start;
  final DateTime end;

  TimeDetailView(this.start, this.end);

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
                  fontSize: 20,
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
    if (this.end == null) {
      String formattedTime = DateFormat('HH:mm').format(start);
      return formattedTime;
    }
    String formattedStartTime = DateFormat('HH:mm').format(start);
    String formattedEndTime = DateFormat('HH:mm').format(end);

    String time = formattedStartTime + ' - ' + formattedEndTime;
    return time;
  }
}