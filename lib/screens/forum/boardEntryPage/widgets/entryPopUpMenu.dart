import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntryPopUpMenu extends StatefulWidget {
  final BoardEntry entry;
  EntryPopUpMenu(this.entry);
  @override
  _EntryPopUpMenuState createState() => _EntryPopUpMenuState();
}

class _EntryPopUpMenuState extends State<EntryPopUpMenu> {
  bool _isSubscribed;
  User _loggedUser;
  SubscriptionService _subscriptionService;
  AccessHandler _accessHandler;
  bool _isDataLoaded = false;
  initState() {
    _subscriptionService = SubscriptionService();
    _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    _loadInitialData();
    super.initState();
  }

  _loadInitialData() {
    _accessHandler.getUser().then((user) {
      _loggedUser = user;
      _subscriptionService
          .isUserSubscribed(loggedUser: user, topLevelDocumentID: _getCorrectEntryReference(), topLevelCollection: CollectionNames.BOARD_ENTRY)
          .then((isSubscribed) {
        if (mounted) {
          setState(() {
            _isSubscribed = isSubscribed;
            _isDataLoaded = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isDataLoaded
        ? PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.grey,),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            onSelected: (value) => _choiceAction(value, context),
            color: Colors.white,
            itemBuilder: (BuildContext context) {
              return _createPopupMenuItems();
            },
          )
        : IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey,),
            onPressed: () {},
          );
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

  void _choiceAction(String choice, BuildContext context) {
    if (choice == MenuButtons.SUBSCRIBE) {
      _subscriptionEvent();
    } else if (choice == MenuButtons.CANCEL_SUBSCRIPTION) {
      _subscriptionEvent();
    }
  }

  _subscriptionEvent() {
    var service = SubscriptionService();
    setState(() {
      _isSubscribed = !_isSubscribed;
    });
    service
        .subscribe(
      shouldNotify: true,
      entry: widget.entry,
      loggedUser: _loggedUser,
      topLevelDocumentID: _getCorrectEntryReference(),
      topLevelCollection: CollectionNames.BOARD_ENTRY,
    )
        .then((isInserted) {
      if (!isInserted) {
        service.deleteSubscription(
            loggedUser: _loggedUser,
            topLevelDocumentID: _getCorrectEntryReference(),
            topLevelCollection: CollectionNames.BOARD_ENTRY);
      }
      showSubscriptionMessage(isInserted, false);
    }).catchError((onError) {
      showSubscriptionMessage(false, true);
    });
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
  String _getCorrectEntryReference(){
    return widget.entry.originalDocReference == "" ? widget.entry.documentID : widget.entry.originalDocReference;
  }
}
