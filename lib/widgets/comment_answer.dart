import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/news/widgets/userAvatar.dart';
import 'package:dorf_app/services/comment_service.dart';
import 'package:dorf_app/widgets/delete_comment.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Meike Nedwidek
class CommentAnswer extends StatefulWidget {
  final String topCommentID;
  final Comment comment;
  final String document;
  final String collection;

  CommentAnswer({this.comment, this.topCommentID, this.document, this.collection});

  @override
  _CommentAnswerState createState() => _CommentAnswerState();
}

class _CommentAnswerState extends State<CommentAnswer> {
  bool _showDelete = false;
  CommentService _commentService = CommentService();
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
        padding: EdgeInsets.only(left: 60.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: UserAvatar(userID: widget.comment.userID, width: 30.0, height: 30.0),
                ),
                InkWell(
                    onLongPress: () {
                      setState(() {
                        if (!widget.comment.isDeleted && widget.comment.userID == _userID) _showDelete = true;
                      });
                    },
                    child: !_showDelete
                        ? Container(
                            margin: EdgeInsets.only(top: 10.0),
                            padding: EdgeInsets.all(15.0),
                            width: MediaQuery.of(context).size.width - 140.0,
                            decoration: BoxDecoration(color: Color(0xFFE6E6E6), borderRadius: BorderRadius.circular(10.0)),
                            child:
                                Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                      child: Text(
                                        widget.comment.user.firstName + " " + widget.comment.user.lastName,
                                        style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    alignment: Alignment.topRight,
                                    child: RelativeDate(widget.comment.convertTimestamp(widget.comment.createdAt), Colors.black, 12.0),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    widget.comment.content,
                                    style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.normal, fontSize: 16),
                                  ),
                                ],
                              )
                            ]))
                        : DeleteComment(_deleteComment, _cancelDeleteComment, 140.0)),
              ],
            ),
          ],
        ));
  }

  void _deleteComment() {
    setState(() {
      widget.comment.content = "Dieser Kommentar wurde gelöscht.";
      widget.comment.isDeleted = true;
      _commentService.deleteAnswer(widget.document, widget.collection, widget.comment.id, widget.topCommentID);
      _showDelete = false;
    });
  }

  void _cancelDeleteComment() {
    setState(() {
      _showDelete = false;
    });
  }
}
