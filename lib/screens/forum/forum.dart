import 'package:flutter/cupertino.dart';

class Forum extends StatelessWidget {
  final String title;

  Forum(this.title);

  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(this.title),
      ),
    );
  }
}