import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/models/topComment_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/provider/messageQuantity.dart';
import 'package:dorf_app/screens/general/custom_border.dart';
import 'package:dorf_app/screens/general/textNoteBar.dart';
import 'package:dorf_app/screens/general/sortBar.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/news/news_detail.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:dorf_app/services/comment_service.dart';
import 'package:dorf_app/services/like_service.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:dorf_app/widgets/comment_section.dart';
import 'package:dorf_app/widgets/like_section.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon

class BoardMessagePage extends StatefulWidget {
  final String entryDocumentID;
  final String boardCategoryHeadline;
  final int boardCategoryColor;
  BoardMessagePage({@required this.entryDocumentID, this.boardCategoryColor, this.boardCategoryHeadline});

  @override
  _BoardMessagePageState createState() => _BoardMessagePageState();
}

class _BoardMessagePageState extends State<BoardMessagePage> {
  BoardEntryService _entryService;
  SubscriptionService _subscriptionService;
  LikeService _likeService;
  CommentService _commentService;
  BoardEntry _entry;
  List<User> _likeList;
  List<TopComment> _commentList;
  int _categoryColor;
  AccessHandler _accessHandler;
  User _loggedUser;
  bool _isSubscribed;
  bool _isClosed;

  @override
  void initState() {
    _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    _entryService = BoardEntryService();
    _likeService = LikeService();
    _commentService = CommentService();
    _loadInitialData();
    super.initState();
  }

  _loadInitialData() {
    _subscriptionService = SubscriptionService();
    _accessHandler.getUser().then((user) {
      _loggedUser = user;
      _subscriptionService
          .isUserSubscribed(
              loggedUser: _loggedUser,
              topLevelDocumentID: widget.entryDocumentID,
              subscriptionType: SubscriptionType.entry)
          .then((isSubscribed) {
        if (mounted) {
          setState(() {
            _isSubscribed = isSubscribed;
          });
        }
      });
      _entryService.getEntry(widget.entryDocumentID).then((entry) {
        if (mounted) {
          setState(() {
            _entry = entry;
            _categoryColor = _entry.categoryColor;
            if (entry != null) _isClosed = _entry.isClosed;
          });
        }
      });
      _likeService.getUsersThatLiked(widget.entryDocumentID, CollectionNames.BOARD_ENTRY).then((likes) {
        if (mounted) {
          setState(() {
            _likeList = likes;
          });
        }
      });
      _commentService.getComments(widget.entryDocumentID, CollectionNames.BOARD_ENTRY).then((comments) {
        if (mounted) {
          setState(() {
            _commentList = comments;
          });
        }
      });
    });
  }

  bool _isCreator() {
    return _loggedUser.uid == _entry.createdBy || _loggedUser.admin == true;
  }

  List _createPopupMenuItems() {
    if (_isSubscribed) {
      return MenuButtons.CancelSubPopUpMenu.map((String choice) {
        return PopupMenuItem<String>(
          value: choice,
          child: Text(choice),
        );
      }).toList();
    } else {
      return MenuButtons.SubPopUpMenu.map((String choice) {
        return PopupMenuItem<String>(
          value: choice,
          child: Text(choice),
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isSubscribed != null && _entry != null && _likeList != null && _commentList != null
        ? Scaffold(
            appBar: AppBar(
              title: Text(_entry.boardCategoryTitle),
              centerTitle: true,
              backgroundColor: widget.boardCategoryColor != null ? Color(widget.boardCategoryColor) : Color(_categoryColor),
              actions: <Widget>[
                _isClosed != true && _isCreator()
                    ? IconButton(
                        icon: Icon(Icons.lock),
                        onPressed: () {
                          _showCloseThreadDialog();
                        },
                      )
                    : Container(),
                PopupMenuButton<String>(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  onSelected: (value) => _choiceAction(value, context),
                  color: Colors.white,
                  itemBuilder: (BuildContext context) {
                    return _createPopupMenuItems();
                  },
                )
              ],
            ),
            body: Container(
              child: ListView(
                children: <Widget>[
                  ImageTitleDisplay(
                    title: _entry.title,
                    imagePath: null,
                  ),
                  DescriptionDisplay(
                    description: _entry.description,
                  ),
                  LikeSection(
                    _likeList,
                    _entry.documentID,
                    CollectionNames.BOARD_ENTRY,
                    _loggedUser.uid,
                    likedColor: Color(_categoryColor),
                    notLikedColor: Colors.grey,
                    likeDetailAppbarColor: Color(_categoryColor),
                  ),
                  CustomBorder(
                    color: Color(_categoryColor),
                  ),
                  SortBar(
                    barHeight: 50,
                    elevation: 4,
                    commentQuantity: _entry.commentCount,
                    iconColor: Color(_categoryColor),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  _isClosed == true
                      ? TextNoteBar(
                          text: "Der Ersteller hat den Kommentarbereich geschlossen. Kommentieren ist nicht möglich",
                          leftPadding: 20,
                        )
                      : Container(),
                  CommentSection(_commentList, _entry.documentID, CollectionNames.BOARD_ENTRY, SubscriptionType.entry,
                      disableAddingComment: _isClosed != true ? false : true),
                ],
              ),
            ))
        : Center(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: widget.boardCategoryColor != null ? Color(widget.boardCategoryColor) : Theme.of(context).primaryColor,
                centerTitle: true,
                title: Text(widget.boardCategoryHeadline),
              ),
              body: Center(child: CircularProgressIndicator()),
            ),
          );
  }

  _showCloseThreadDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CloseThreadDialog();
        }).then((dialogCommunication) {
      if (dialogCommunication == "close")
        setState(() {
          _closeThread();
        });
    });
  }

  _closeThread() {
    _isClosed = true;
    _entryService.closeBoardEntry(_entry);
  }

  void _choiceAction(String choice, BuildContext context) {
    if (choice == MenuButtons.SUBSCRIBE) {
      _subscriptionEvent();
    } else if (choice == MenuButtons.CANCEL_SUBSCRIPTION) {
      _subscriptionEvent();
    }
  }

  showSubscriptionMessage(isInserted, isError) {
    Flushbar(
      messageText: Center(
        child: Text(
          isError == true
              ? "Etwas ist schief gelaufen. Überprüfe deine Internetverbindung"
              : isInserted ? "Gepinnt" : "Nicht mehr gepinnt",
          style: TextStyle(fontSize: 15, fontFamily: "Raleway", color: Colors.white),
        ),
      ),
      duration: Duration(seconds: 1),
    )..show(context);
  }

  _subscriptionEvent() {
    var service = SubscriptionService();
    setState(() {
      _isSubscribed = !_isSubscribed;
    });
    service
        .subscribe(
      loggedUser: _loggedUser,
      topLevelDocumentID: widget.entryDocumentID,
      subscriptionType: SubscriptionType.entry,
    )
        .then((isInserted) {
      if (!isInserted) {
        service.deleteSubscription(
            loggedUser: _loggedUser,
            topLevelDocumentID: widget.entryDocumentID,
            subscriptionType: SubscriptionType.entry);
      }
      showSubscriptionMessage(isInserted, false);
    }).catchError((onError) {
      showSubscriptionMessage(false, true);
    });
  }
}

class CloseThreadDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Möchtest du dein Thema schließen? Kommentieren ist dann nicht mehr möglich"),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Ja",
            style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 17),
          ),
          onPressed: () {
            Navigator.pop(context, "close");
          },
        ),
        FlatButton(
          child: Text(
            "Nein",
            style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 17),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
