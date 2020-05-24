import 'package:dorf_app/screens/news_edit/news_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class News extends StatelessWidget {
  final String title;

  News(this.title);

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
       children: <Widget>[
         Center(
           child: RaisedButton(
             child: Text(
               "Go to News edit"
             ),
             onPressed: () {
               Navigator.push(context, MaterialPageRoute<void>(
                 builder: (BuildContext context) {
                   return NewsEdit();
                 }
               ));
             },
           ),
         )
       ],
      ),
    );
  }
}