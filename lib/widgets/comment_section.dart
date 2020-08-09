import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/screens/general/empty_list_text.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:dorf_app/services/comment_service.dart';
import 'package:dorf_app/services/subscription_service.dart';
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
  final SubscriptionType subscriptionType; ///where is the commentsection implemented? [SubscriptionType.news] when in news or [SubscriptionType.entry] when in Forum

  CommentSection(this.commentList, this.document, this.collection, this.subscriptionType);

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

  void _addNewComment(String val) async{
    AccessHandler _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    var user = await _accessHandler.getUser();
    var date = Timestamp.now();
    Comment newComment = Comment(
        user: User(
            firstName: user.firstName,
            lastName: user.lastName,
            uid: user.uid),
        content: val,
        createdAt: date,
        modifiedAt: date);

    commentService.insertNewComment(document, collection, newComment, Provider.of<AlertService>(context, listen: false), widget.subscriptionType);

    setState(() {
      commentList.insert(0, newComment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
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
                      : [ShowTextIfListEmpty(iconData: Icons.message, text: "Noch keine Kommentare",)]),
            ],
          )
        ],
      ),
    );
  }
}

///Matthias Maxelon
class CommentingOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 150);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        color: Colors.red,
      ),
    );
  }
}
