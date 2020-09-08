import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/models/topComment_model.dart';
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
  final List<TopComment> commentList;
  final String document;
  final String collection;
  final bool disableAddingComment;
  final SubscriptionType subscriptionType; ///where is the commentsection implemented? [SubscriptionType.news] when in news or [SubscriptionType.entry] when in Forum

  CommentSection(this.commentList, this.document, this.collection, this.subscriptionType, {this.disableAddingComment});

  @override
  _CommentSectionState createState() =>
      _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {

  final commentService = CommentService();
  TextEditingController _controller;
  String answerTo;
  FocusNode myFocusNode;

  function(TopComment topComment) {
    setState(() {
      answerTo = topComment.comment.id;
      myFocusNode.requestFocus();
      _controller.text = topComment.comment.firstName + " " + topComment.comment.lastName + " ";
    });
  }

  _CommentSectionState();

  void initState() {
    super.initState();
    _controller = TextEditingController();
    myFocusNode = FocusNode();
  }

  void dispose() {
    _controller.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  void _addNewComment(String val, String answerTo) async{
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

    if (answerTo != null) {
      commentService.insertAnswerComment(widget.document, widget.collection, newComment, answerTo);
    }
    else {
      commentService.insertNewComment(
          widget.document, widget.collection, newComment, Provider.of<AlertService>(context, listen: false), widget.subscriptionType);

      setState(() {
        TopComment newTopComment = TopComment(newComment, []);
        widget.commentList.insert(0, newTopComment);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: <Widget>[
            widget.disableAddingComment != true ? TextField(
              focusNode: myFocusNode,
              controller: _controller,
              onChanged: (text) {
                if(text.isEmpty) {
                  answerTo = null;
                }
              },
              onSubmitted: (String submittedStr) {
                _addNewComment(submittedStr, answerTo);
                answerTo = null;
                _controller.clear();
              },
              decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20.0),
              hintText: "Schreibe einen Kommentar...",
            ),
            ) : Container(),
            Column(
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: widget.commentList.length > 0
                        ? widget.commentList
                        .map((comment) => CommentCard(topComment: comment, collection: widget.collection, document: widget.document, disableAddingComment: widget.disableAddingComment, emitAnswerTo: function))
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
