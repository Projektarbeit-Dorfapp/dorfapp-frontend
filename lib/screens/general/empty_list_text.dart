import 'package:flutter/material.dart';

class ShowTextIfListEmpty extends StatelessWidget {
  final IconData iconData;
  final String text;
  ShowTextIfListEmpty({this.iconData, this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData != null ? iconData : Icons.error, color: Colors.grey, size: 80.0),
            Container(
                margin: const EdgeInsets.only(left: 10.0),
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  text != null ? text : "Missing text",
                  style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey),
                ))
          ],
        ));
  }
}