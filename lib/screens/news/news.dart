import 'package:flutter/cupertino.dart';

class News extends StatelessWidget {
  final String title;

  News(this.title);

  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(this.title),
      ),
    );
  }
}