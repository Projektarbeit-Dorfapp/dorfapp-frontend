import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/screens/news/widgets/userAvatar.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Meike Nedwidek
class CommentAnswer extends StatelessWidget {
  final Comment comment;

  CommentAnswer({this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 60.0),
        child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: UserAvatar(userID: comment.userID, width: 30.0, height: 30.0),
            ),
            Container(
                margin: EdgeInsets.only(top: 10.0),
                padding: EdgeInsets.all(15.0),
                width: MediaQuery.of(context).size.width - 140.0,
                decoration: BoxDecoration(color: Color(0xFFE6E6E6), borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _showUserName(),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10.0),
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
                    ])),
          ],
        ),
      ],
    ));
  }

  _showUserName() {
    if((comment.user.firstName.length + comment.user.lastName.length) >= 11) {
      if(comment.user.lastName.length >= 11) {
        return Text(
          comment.user.firstName + "\n" + comment.user.lastName.substring(0, 10) + "-" + "\n" + comment.user.lastName.substring(10),
          style: TextStyle(
              fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)
        );
      }
      else {
        return Text(
          comment.user.firstName + "\n" + comment.user.lastName,
          style: TextStyle(
              fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        );
      }
    }
  }
}
