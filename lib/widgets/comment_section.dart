import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/comment_service.dart';
import 'package:dorf_app/widgets/comment_card.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

//Meike Nedwidek
class CommentSection extends StatefulWidget {
  final List<Comment> commentList;
  final String document;
  final String collection;

  CommentSection(this.commentList, this.document, this.collection);

  @override
  _CommentSectionState createState() =>
      _CommentSectionState(commentList, document, collection);
}

class _CommentSectionState extends State<CommentSection> {
  final commentService = CommentService();

  List<Comment> commentList;
  String document;
  String collection;
  TextEditingController _controller;

  _CommentSectionState(this.commentList, this.document, this.collection);

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addNewComment(String val) {
    AccessHandler _accessHandler =
        Provider.of<AccessHandler>(context, listen: false);
    var date = Timestamp.now();
    Comment newComment = Comment(
        user: User(
            firstName: _accessHandler.getFirstName(),
            lastName: _accessHandler.getLastName(),
            uid: _accessHandler.getUID()),
        content: val,
        createdAt: date,
        modifiedAt: date);

    commentService.insertNewComment(document, collection, newComment);

    setState(() {
      commentList.insert(0, newComment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Color(0xFF141e3e), width: 2.0))),
      child: Column(
        children: <Widget>[
          TextField(
            //keyboardType: TextInputType.multiline,
            //maxLines: null,
            controller: _controller,
            onSubmitted: (String submittedStr) {
              _addNewComment(submittedStr);
              _controller.clear();
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20.0),
              hintText: "Schreibe einen Kommentar...",
              /*suffixIcon: IconButton(
                icon: Icon(Icons.send),
                color: Color(0xFF141e3e),
                iconSize: 28.0,
                onPressed: () {
                },
              ) */
            ),
          ),
          Column(
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: commentList.length > 0
                      ? commentList
                          .map((comment) => CommentCard(comment: comment))
                          .toList()
                      : [_getTextIfCommentListEmpty()]),
            ],
          )
        ],
      ),
    );
  }

  Container _getTextIfCommentListEmpty() {
    return Container(
        margin: EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.message, color: Colors.grey, size: 80.0),
            Container(
                margin: EdgeInsets.only(left: 10.0),
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Noch keine Kommentare',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey),
                ))
          ],
        ));
  }
}
