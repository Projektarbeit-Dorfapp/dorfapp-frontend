import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/widgets/comment_card.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//Meike Nedwidek
class CommentSection extends StatefulWidget {

  final List<Comment> commentList;

  CommentSection(this.commentList);

  @override
  _CommentSectionState createState() => _CommentSectionState(commentList);

}

class _CommentSectionState extends State<CommentSection> {

  List<Comment> commentList;
  TextEditingController _controller;
  _CommentSectionState(this.commentList);

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addComment(String val) {
    Comment newComment = Comment(
        id: 1,
        user: User(firstName: "Peter", lastName: "Müller", userName: "test123", email: "test"),
        content: val,
        creationDate: DateTime.now());

    setState(() {
      commentList.insert(0, newComment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Color(0xFF141e3e),
                  width: 2.0
              )
          )
      ),
      child: Column(
        children: <Widget>[
          TextField(
            //keyboardType: TextInputType.multiline,
            //maxLines: null,
            controller: _controller,
            onSubmitted: (String submittedStr) {
              _addComment(submittedStr);
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
                  children: commentList.length > 0 ? commentList.map((comment) => CommentCard(comment: comment)).toList() : [
                    _getTextIfCommentListEmpty()
                  ]
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _getTextIfCommentListEmpty(){
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
              Icons.message,
              color: Colors.grey,
              size: 80.0
          ),
          Container(
              margin: EdgeInsets.only(left: 10.0),
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Noch keine Kommentare',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey
                ),
              )
          )
        ],
      )
    );
  }

}





