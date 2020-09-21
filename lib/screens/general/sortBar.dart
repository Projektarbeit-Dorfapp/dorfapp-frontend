import 'package:flutter/material.dart';

///Matthias Maxelon
class CommentsDisplayBar extends StatelessWidget {
  final Color barColor;
  final double barHeight;
  final double elevation;
  final int commentQuantity;
  final iconColor;
  CommentsDisplayBar({this.barColor, this.barHeight, this.elevation, this.commentQuantity, this.iconColor});

  final double _paddingDistance = 20;
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: barHeight != null ? barHeight : 50,
      child: Row(
        children: <Widget>[
          commentQuantity != null ? Padding(
            padding: EdgeInsets.only(left: _paddingDistance),
            child: Text(
                commentQuantity.toString() + " Kommentare",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}
