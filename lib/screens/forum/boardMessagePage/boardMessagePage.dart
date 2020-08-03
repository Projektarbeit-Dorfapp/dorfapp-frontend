import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/provider/boardMessageHandler.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/widgets/boardMessageTextField.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/widgets/messageStream.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/boardCategory_service.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class BoardMessagePage extends StatefulWidget {
  final String categoryDocumentID;
  final String entryDocumentID;
  BoardMessagePage({@required this.categoryDocumentID, @required this.entryDocumentID,});

  @override
  _BoardMessagePageState createState() => _BoardMessagePageState();
}

class _BoardMessagePageState extends State<BoardMessagePage> {
  BoardEntryService _entryService;
  SubscriptionService _subscriptionService;
  BoardCategory _category;
  BoardEntry _entry;
  int _categoryColor;
  BoardCategoryService _categoryService;
  AccessHandler _accessHandler;
  User _loggedUser;
  bool _isDataLoaded = false;
  bool _isSubscribed;
  bool _isClosed;

  @override
  void initState() {
    _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    _entryService = BoardEntryService();
    _categoryService = BoardCategoryService();
    _loadInitialData();
    super.initState();
  }

  _loadInitialData() {
    _subscriptionService = SubscriptionService();
    _accessHandler.getUser().then((user) {
      _loggedUser = user;
      _subscriptionService
          .isUserSubscribed(loggedUser: _loggedUser, topLevelDocumentID: widget.entryDocumentID, topLevelCollection: CollectionNames.BOARD_ENTRY)
          .then((isSubscribed) {
        if (mounted) {
          setState(() {
            _isSubscribed = isSubscribed;
            _isDataLoaded = true;
          });
        }
      });
      _categoryService.getCategory(widget.categoryDocumentID).then((category) {
        if (mounted) {
          setState(() {
            _category = category;
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
    });
  }

  bool _isCreator() {
    return _loggedUser.uid == _entry.userReference || _loggedUser.admin == true;
  }

  List _createPopupMenuItems() {
    if (_isCreator()) {
      if (_isSubscribed) {
        return MenuButtons.BoardMessagePageCreatorAndAdminCancelSub.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      } else {
        return MenuButtons.BoardMessagePageCreatorAndAdmin.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      }
    } else {
      if (_isSubscribed) {
        return MenuButtons.CancelSubPopUpMenu.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      } else {
        return MenuButtons.BoardMessagePageNotCreator.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isDataLoaded && _entry != null && _category != null
        ? ChangeNotifierProvider(
            create: (context) => BoardMessageHandler(_entry, _category),
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(_categoryColor),
                  actions: <Widget>[
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
                  color: const Color(0xfff0f0f0),
                  child: Stack(
                    children: <Widget>[
                      MessageStream(
                        category: _category,
                        entry: _entry,
                      ),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: !_isClosed
                              ? BoardMessageTextField()
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      "Thema geschlossen",
                                      style: TextStyle(
                                        fontFamily: "Raleway",
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )),
                    ],
                  ),
                )),
          )
        : Center(
            child: Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
              body: Center(child: CircularProgressIndicator()),
            ),
          );
  }

  void _choiceAction(String choice, BuildContext context) {
    if (choice == MenuButtons.SUBSCRIBE) {
      _subscriptionEvent();
    } else if (choice == MenuButtons.CANCEL_SUBSCRIPTION) {
      _subscriptionEvent();
    } else if (choice == MenuButtons.CLOSE_THREAD) {
      setState(() {
        _isClosed = true;
        _entryService.closeBoardEntry(_entry);
      });
    }
  }

  showSubscriptionMessage(isInserted, isError) {
    Flushbar(
      messageText: Center(
        child: Text(
          isError == true ? "Etwas ist schief gelaufen. Überprüfe deine Internetverbindung" : isInserted ? "Gepinnt" : "Nicht mehr gepinnt",
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
      shouldNotify: true,
      entry: _entry,
      loggedUser: _loggedUser,
      topLevelDocumentID: widget.entryDocumentID,
      topLevelCollection: CollectionNames.BOARD_ENTRY,
    )
        .then((isInserted) {
      if (!isInserted) {
        service.deleteSubscription(loggedUser: _loggedUser, topLevelDocumentID: widget.entryDocumentID, topLevelCollection: CollectionNames.BOARD_ENTRY);
      }
      showSubscriptionMessage(isInserted, false);
    }).catchError((onError) {
      showSubscriptionMessage(false, true);
    });
  }
}
