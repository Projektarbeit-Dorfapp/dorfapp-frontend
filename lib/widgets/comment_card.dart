import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/models/topComment_model.dart';
import 'package:dorf_app/services/comment_service.dart';
import 'package:dorf_app/widgets/comment_answer.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Meike Nedwidek
class CommentCard extends StatefulWidget  {
  ///TO DO:
  ///hochscrollen zu kommentareingabe, @ hinzufügen, wenn @ gelöscht nicht mehr antwort schreiben,
  ///neue Antwort direkt anzeigen, Button zum alle Kommentare anzeigen direkt alle Antworten anzeigen
  final Function emitAnswerTo;
  final TopComment topComment;
  final bool disableAddingComment;
  String answerTo;

  CommentCard({this.topComment, this.disableAddingComment, this.emitAnswerTo});

  @override
  _CommentCardState createState() =>
      _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {

  int numberOfAnswersShown = 1;
  bool showButtonToShowAllAnswers = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.topComment.answerList.length > 0 ? EdgeInsets.only(bottom: 20.0) : EdgeInsets.zero,
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
                          image: AssetImage(widget.topComment.comment.user.imagePath != null ? widget.topComment.comment.user.imagePath : "assets/avatar.png")))),
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
                              widget.topComment.comment.user.firstName + " " + widget.topComment.comment.user.lastName,
                              style: TextStyle(
                                  fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topRight,
                                child: RelativeDate(widget.topComment.comment.convertTimestamp(widget.topComment.comment.createdAt), Colors.black, 12.0),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              widget.topComment.comment.content,
                              style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.normal, fontSize: 16),
                            ),
                          ],
                        )
                      ]
                  )
              ),
            ],
          ),
          _answerButton(widget.disableAddingComment, context),
          Column(
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: widget.topComment.answerList.length > 0
                      ? widget.topComment.answerList
                      .map((comment) => CommentAnswer(comment: comment))
                      .toList().sublist(0, numberOfAnswersShown)
                      : []),
              _getButtonToShowAllAnswers()
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
                widget.emitAnswerTo(widget.topComment.comment.id);
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

  _getButtonToShowAllAnswers() {

    if (widget.topComment.answerList.length > 1) {
      return Container(
          padding: EdgeInsets.only(top: 2.0, left: 30.0),
          width: MediaQuery.of(context).size.width,
          child: showButtonToShowAllAnswers? FlatButton(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              setState(() {
                numberOfAnswersShown = widget.topComment.answerList.length;
                showButtonToShowAllAnswers = false;
              });
            },
            child: Text(
              "Alle " + widget.topComment.answerList.length.toString() + " Antworten anzeigen",
              style: Theme.of(context).textTheme.button,
            ),
          ) : Container());
    }
    else {
      return Container();
    }
  }
}
