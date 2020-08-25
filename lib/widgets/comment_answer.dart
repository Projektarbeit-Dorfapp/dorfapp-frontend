import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Meike Nedwidek
class CommentAnswer extends StatelessWidget {
  final Comment comment;

  CommentAnswer({this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 10.0),
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(comment.user.imagePath != null ? comment.user.imagePath : "assets/avatar.png")))),
            Container(
                margin: EdgeInsets.only(top: 10.0),
                padding: EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0, left: 25.0),
                width: MediaQuery.of(context).size.width - 160,
                decoration: BoxDecoration(color: Color(0xFFE6E6E6), borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            comment.user.firstName + " " + comment.user.lastName,
                            style: TextStyle(
                                fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topRight,
                              child: RelativeDate(comment.convertTimestamp(comment.createdAt), Colors.black, 12.0),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            comment.content,
                            style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        ],
                      )
                    ]
                )
            ),
          ],
        ),
      ],
    );
  }
}
