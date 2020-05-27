import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/screens/news/widgets/comment_card.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//Meike Nedwidek
class CommentSection extends StatefulWidget {

  List<Comment> commentList;
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
          color: Color(0xFFE6E6E6),
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
          Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: commentList.map((comment) => CommentCard(comment: comment)).toList()
            ),
          ),
        ],
      ),
    );
  }

}





