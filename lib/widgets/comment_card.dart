import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/widgets/date_comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Meike Nedwidek
class CommentCard extends StatelessWidget{

  final Comment comment;

  CommentCard({this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(right: 10.0),
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(comment.user.imagePath != null ? comment.user.imagePath : "assets/avatar.png")
                )
            )
        ),
        Container(
            margin: EdgeInsets.only(top: 10.0),
            padding: EdgeInsets.all(15.0),
            width: MediaQuery.of(context).size.width - 100,
            decoration: BoxDecoration(
                color: Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        comment.user.firstName + " " + comment.user.lastName,
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topRight,
                          child: DateComment(comment.creationDate, Colors.black),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        comment.content,
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.normal,
                            fontSize: 16
                        ),
                      ),
                    ],
                  )
                ]
            )
        )
      ],
    );
  }
}