import 'package:flutter/material.dart';

class RespectfulNote extends StatelessWidget {
  final double height;
  final Color backgroundColor;
  RespectfulNote({this.height, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: backgroundColor != null ? backgroundColor : const Color(0xffE0E0E0),
      height: height != null ? height : 60,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: const Text(
            "Bitte achte auf einen respektvollen Umgang beim Schreiben von Kommentaren",
            style: TextStyle(
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
}
