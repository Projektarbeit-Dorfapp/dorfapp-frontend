import 'package:dorf_app/models/comment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget{

  final Comment comment;

  CommentCard({this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(15.0),
      width: MediaQuery.of(context).size.width * 1.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget>[
              Column(
                children: <Widget>[
                  Text(
                    comment.authorName,
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    comment.creationDate,
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.normal,
                        fontSize: 12
                    ) ,
                  )
                ],
              )
            ]
          ),
          Container(
              child: Text(
                comment.content,
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.normal,
                    fontSize: 16
                ),
              )
          )
        ]
      )
    );
  }
}