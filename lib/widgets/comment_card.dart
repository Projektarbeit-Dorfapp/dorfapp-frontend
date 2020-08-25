import 'package:dorf_app/models/topComment_model.dart';
import 'package:dorf_app/services/comment_service.dart';
import 'package:dorf_app/widgets/comment_answer.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Meike Nedwidek
class CommentCard extends StatelessWidget  {
  ///TO DO: CHANGE TO STATEFUL
  ///richtig sortieren, hochscrollen zu kommentareingabe, @ hinzufügen, wenn @ gelöscht nicht mehr antwort schreiben,
  ///über zwei kommentaren "alle kommentare anzeigen" machen
  final Function emitAnswerTo;
  final TopComment topComment;
  final bool disableAddingComment;
  String answerTo;
  CommentService _commentService;

  CommentCard({this.topComment, this.disableAddingComment, this.emitAnswerTo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: topComment.answerList.length > 0 ? EdgeInsets.only(bottom: 20.0) : EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 10.0),
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(topComment.comment.user.imagePath != null ? topComment.comment.user.imagePath : "assets/avatar.png")))),
              Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.all(15.0),
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(color: Color(0xFFE6E6E6), borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              topComment.comment.user.firstName + " " + topComment.comment.user.lastName,
                              style: TextStyle(
                                  fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topRight,
                                child: RelativeDate(topComment.comment.convertTimestamp(topComment.comment.createdAt), Colors.black, 12.0),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              topComment.comment.content,
                              style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.normal, fontSize: 16),
                            ),
                          ],
                        )
                      ]
                  )
              ),
            ],
          ),
          _answerButton(disableAddingComment, context),
          Column(
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: topComment.answerList.length > 0
                      ? topComment.answerList
                      .map((comment) => CommentAnswer(comment: comment))
                      .toList()
                      : []),
            ],
          )
        ],
      ),
    );
  }

  _answerButton(bool disableAddingComment, BuildContext context) {
    if (disableAddingComment == false) {
      return Container(
        padding: EdgeInsets.only(top: 2.0, left: 50.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlatButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                emitAnswerTo(topComment.comment.id);
              },
              child: Text(
                "Antworten",
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        ),
      );
    }
    else {
      return Container();
    }
  }
}
