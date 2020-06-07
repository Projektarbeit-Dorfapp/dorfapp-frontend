import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Meike Nedwidek
class DateDetailView extends StatelessWidget {

  final DateTime start;
  final DateTime end;

  DateDetailView(this.start, this.end);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 22.0
        ),
        Container(
            margin: EdgeInsets.only(left: 10.0),
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
            _getDate(),
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

  _getDate(){
    DateTime startTime = this.start.toLocal();
    DateTime endTime = this.end.toLocal();

    if (this.start == null && this.end == null) {
      return '-';
    }
    if (this.end == null) {
      String formattedDate = DateFormat('dd.MM.yyyy').format(startTime);
      return formattedDate;
    }
    String formattedStartDate = DateFormat('dd.MM.yyyy').format(startTime);
    String formattedEndDate = DateFormat('dd.MM.yyyy').format(endTime);

    String date = formattedStartDate + ' - ' + formattedEndDate;
    return date;
  }
}