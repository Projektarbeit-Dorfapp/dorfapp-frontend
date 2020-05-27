import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/screens/news/widgets/dateComment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


//Meike Nedwidek
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
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 5.0, right: 10.0),
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
              Text(
                comment.user.firstName + " " + comment.user.lastName,
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
              DateComment(comment.creationDate)
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
                )
              ],
          )
        ]
      )
    );
  }
}