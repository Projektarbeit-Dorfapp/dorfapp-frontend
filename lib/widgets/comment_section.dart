import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/models/topComment_model.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/provider/messageQuantity.dart';
import 'package:dorf_app/screens/general/empty_list_text.dart';
import 'package:dorf_app/screens/general/textNoteBar.dart';
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
  final SubscriptionType subscriptionType;
  final Color sortMenuColor;

  ///where is the commentsection implemented? [SubscriptionType.news] when in news or [SubscriptionType.entry] when in Forum

  CommentSection(this.commentList, this.document, this.collection, this.subscriptionType, {this.disableAddingComment, this.sortMenuColor});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final commentService = CommentService();
  TextEditingController _controller;
  String answerTo;
  FocusNode myFocusNode;
  List<TopComment> curCommentList;
  String sortMode = MenuButtons.SORT_DESCENDING;

  function(TopComment topComment) {
    setState(() {
      answerTo = topComment.comment.id;
      myFocusNode.requestFocus();
      _controller.text = topComment.comment.user.firstName.toString() + " " + topComment.comment.user.lastName.toString() + " ";
    });
  }

  void initState() {
    super.initState();
    curCommentList = widget.commentList;
    _controller = TextEditingController();
    myFocusNode = FocusNode();
  }

  void dispose() {
    _controller.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  Future<void> _addNewComment(String val, String answerTo) async {
    AccessHandler _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    var user = await _accessHandler.getUser();
    var date = Timestamp.now();
    Comment newComment = Comment(
        user: User(firstName: user.firstName, lastName: user.lastName, uid: user.uid),
        userID: user.uid,
        content: val,
        createdAt: date,
        modifiedAt: date,
        isDeleted: false);

    if (answerTo != null) {
      String documentID = await commentService.insertAnswerComment(widget.document, widget.collection, newComment, answerTo, widget.subscriptionType);
      newComment.id = documentID;
      _localCommentCountIncrement();
      setState(() {
        curCommentList.firstWhere((element) => element.comment.id == answerTo).answerList.add(newComment);
      });
    } else {
      String documentID = await commentService.insertNewComment(widget.document, widget.collection, newComment,
          Provider.of<AlertService>(context, listen: false), widget.subscriptionType);
      newComment.id = documentID;
      _localCommentCountIncrement();
      setState(() {
        TopComment newTopComment = TopComment(newComment, []);
        if (sortMode == MenuButtons.SORT_DESCENDING) {
          curCommentList.insert(0, newTopComment);
        } else {
          curCommentList.insert(curCommentList.length, newTopComment);
        }
      });
    }
    //widget.emitChange();
  }

  _localCommentCountIncrement(){
    if(widget.subscriptionType == SubscriptionType.entry)
      Provider.of<MessageQuantity>(context, listen: false).increment();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: widget.disableAddingComment != true
                    ? TextField(
                        focusNode: myFocusNode,
                        controller: _controller,
                        onChanged: (text) {
                          if (text.isEmpty) {
                            answerTo = null;
                          }
                        },
                        onSubmitted: (String submittedStr) async {
                          await _addNewComment(submittedStr, answerTo);
                          //Provider.of<UpdateCommentCard>(context, listen: false).update();
                          answerTo = null;
                          _controller.clear();
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20.0),
                          hintText: "Schreibe einen Kommentar...",
                        ),
                      )
                    : TextNoteBar(
                        text: "Der Kommentarbereich wurde geschlossen.",
                        backgroundColor: Colors.white24,
                      ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.tune, color: widget.sortMenuColor == null ? Theme.of(context).primaryColor : widget.sortMenuColor),
                onSelected: (value) {
                  FocusManager.instance.primaryFocus.unfocus();
                  var tempCommentList = curCommentList;
                  switch (value) {
                    case MenuButtons.SORT_ASCENDING:
                      {
                        tempCommentList.sort((a, b) => (a.comment.createdAt.compareTo(b.comment.createdAt)));
                        sortMode = MenuButtons.SORT_ASCENDING;
                      }
                      break;
                    case MenuButtons.SORT_DESCENDING:
                      {
                        tempCommentList.sort((a, b) => (b.comment.createdAt.compareTo(a.comment.createdAt)));
                        sortMode = MenuButtons.SORT_DESCENDING;
                      }
                      break;
                    default:
                      {
                        tempCommentList.sort((a, b) => (b.comment.createdAt.compareTo(a.comment.createdAt)));
                        sortMode = MenuButtons.SORT_DESCENDING;
                      }
                      break;
                  }
                  setState(() {
                    curCommentList = tempCommentList;
                  });
                },
                color: Colors.white,
                itemBuilder: (BuildContext context) {
                  return MenuButtons.CommentSorting.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              )
            ],
          ),
          Column(
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: curCommentList.length > 0
                      ? curCommentList
                          .map((comment) => CommentCard(
                              topComment: comment,
                              collection: widget.collection,
                              document: widget.document,
                              disableAddingComment: widget.disableAddingComment,
                              emitAnswerTo: function))
                          .toList()
                      : [
                          ShowTextIfListEmpty(
                            iconData: Icons.message,
                            text: "Noch keine Kommentare",
                          )
                        ]),
            ],
          )
        ],
      ),
    );
  }
}
