import 'package:dorf_app/models/topComment_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/news/widgets/userAvatar.dart';
import 'package:dorf_app/services/comment_service.dart';
import 'package:dorf_app/widgets/comment_answer.dart';
import 'package:dorf_app/widgets/delete_comment.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Meike Nedwidek
class CommentCard extends StatefulWidget {
  final Function emitAnswerTo;
  final TopComment topComment;
  final String document;
  final String collection;
  final bool disableAddingComment;
  String answerTo;

  CommentCard({this.topComment, this.collection, this.document, this.disableAddingComment, this.emitAnswerTo});

  @override
  CommentCardState createState() => CommentCardState();
}

class CommentCardState extends State<CommentCard> {
  int numberOfAnswersShown = 1;
  bool showButtonToShowAllAnswers = true;
  bool _showDelete = false;
  final CommentService _commentService = CommentService();
  AccessHandler _accessHandler;
  String _userID;

  @override
  void initState() {
    _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    _accessHandler.getUID().then((uid) {
      _userID = uid;
      setState(() {});
    });
    super.initState();
  }

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
                  child: UserAvatar(userID: widget.topComment.comment.userID, width: 50.0, height: 50.0),
                ),
                InkWell(
                    onLongPress: () {
                      setState(() {
                        if (!widget.topComment.comment.isDeleted && widget.topComment.comment.userID == _userID) _showDelete = true;
                      });
                    },
                    child: !_showDelete
                        ? Container(
                            margin: EdgeInsets.only(top: 10.0),
                            padding: EdgeInsets.all(15.0),
                            width: MediaQuery.of(context).size.width - 100,
                            decoration: BoxDecoration(color: Color(0xFFE6E6E6), borderRadius: BorderRadius.circular(10.0)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      widget.topComment.comment.user.firstName + " " + widget.topComment.comment.user.lastName,
                                      style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10.0),
                                      alignment: Alignment.topRight,
                                      child: RelativeDate(
                                          widget.topComment.comment.convertTimestamp(widget.topComment.comment.createdAt), Colors.black, 12.0),
                                    ),
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
                              ],
                            ),
                          )
                        : DeleteComment(_deleteComment, _cancelDeleteComment, 100.0)),
              ],
            ),
            _answerButton(widget.disableAddingComment, context),
            Column(
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: widget.topComment.answerList.length > 0
                        ? widget.topComment.answerList
                            .map((comment) => CommentAnswer(
                                comment: comment,
                                topCommentID: widget.topComment.comment.id,
                                document: widget.document,
                                collection: widget.collection))
                            .toList()
                            .sublist(0, numberOfAnswersShown)
                        : []),
                _getButtonToShowAllAnswers()
              ],
            )
          ],
        ));
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
                widget.emitAnswerTo(widget.topComment);
              },
              child: Text(
                "Antworten",
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  _getButtonToShowAllAnswers() {
    if (widget.topComment.answerList.length > 1) {
      return Container(
          padding: EdgeInsets.only(top: 2.0, left: 30.0),
          width: MediaQuery.of(context).size.width,
          child: showButtonToShowAllAnswers
              ? FlatButton(
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
                )
              : Container());
    } else {
      return Container();
    }
  }

  _showUserName() {
    if ((widget.topComment.comment.user.firstName.length + widget.topComment.comment.user.lastName.length) >= 20) {
      return Text(
        widget.topComment.comment.user.firstName + "\n" + widget.topComment.comment.user.lastName,
        style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
      );
    } else {
      return Text(
        widget.topComment.comment.user.firstName + " " + widget.topComment.comment.user.lastName,
        style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
      );
    }
  }

  void _deleteComment() {
    setState(() {
      widget.topComment.comment.content = "Dieser Kommentar wurde gelöscht.";
      widget.topComment.comment.isDeleted = true;
      _commentService.deleteComment(widget.document, widget.collection, widget.topComment.comment.id);
      _showDelete = false;
    });
  }

  void _cancelDeleteComment() {
    setState(() {
      _showDelete = false;
    });
  }
}
