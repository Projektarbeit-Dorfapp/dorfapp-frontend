import 'package:flutter/cupertino.dart';

class Calendar extends StatelessWidget {
  final String title;

  Calendar(this.title);

  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(this.title),
      ),
    );
  }
}