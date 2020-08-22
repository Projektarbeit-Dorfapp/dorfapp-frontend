import 'package:flutter/material.dart';

class TextNoteBar extends StatelessWidget {
  final String text;
  final double height;
  final Color backgroundColor;
  final double leftPadding;
  TextNoteBar({this.height, this.backgroundColor, @required this.text, this.leftPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: backgroundColor != null ? backgroundColor : const Color(0xffE0E0E0),
      height: height != null ? height : 60,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: leftPadding != null ? leftPadding : 10, right: 10, bottom: 10, top: 10 ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
}
