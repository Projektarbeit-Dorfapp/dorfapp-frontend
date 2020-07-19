import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/provider/boardMessageHandler.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/widgets/boardMessageTextField.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/widgets/messageStream.dart';
import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class BoardMessagePage extends StatefulWidget {
  final BoardCategory category;
  final BoardEntry entry;
  BoardMessagePage({@required this.category, @required this.entry});

  @override
  _BoardMessagePageState createState() => _BoardMessagePageState();
}

class _BoardMessagePageState extends State<BoardMessagePage> {
  BoardEntryService _entryService;
  SubscriptionService _subscriptionService;
  Authentication _auth;
  UserService _userService;
  User _currentUser;
  bool _isDataLoaded = false;
  //bool _isSubscribed;
  bool _isClosed;
  @override
  void initState() {
    _isClosed = widget.entry.isClosed;
   // _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    _auth = Provider.of<Authentication>(context, listen: false);
    _userService = Provider.of<UserService>(context, listen: false);
    _entryService = BoardEntryService();
    _loadInitialData();
    //TODO: TEMPORARY FIX UNTIL ACCESSHANDLER IS FIXED


    /* //Change this back once the accesshandler is fixed
    _accessHandler.getUser().then((user) {
      setState(() {
        _currentUser = user;
        _isInitialized = true;
      });
    });
     */
    super.initState();
  }
  _loadInitialData(){
    _subscriptionService = SubscriptionService();
    _auth.getCurrentUser().then((firebaseUser) {
      _userService.getUser(firebaseUser.uid).then((fullUser) {
        _currentUser = fullUser;
        _subscriptionService.isUserSubscribed(
            currentUser: _currentUser,
            topLevelDocumentID: widget.entry.documentID,
            topLevelCollection: CollectionNames.BOARD_ENTRY).then((isSubscribed){
          setState(() {
            //_isSubscribed = isSubscribed;
            _isDataLoaded = true;
          });
        });
      });
    });
  }
  bool _isCreator() {
    return _currentUser.uid == widget.entry.userReference ||
        _currentUser.admin == true;
  }
  List _createPopupMenuItems(){
    if(_isCreator()){
        return MenuButtons.BoardMessagePageCreatorAndAdmin.map(
                (String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
    } else {
        return MenuButtons.BoardMessagePageNotCreator.map(
                (String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
      }
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BoardMessageHandler(widget.entry, widget.category),
      child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              PopupMenuButton<String>(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                onSelected: (value) => _choiceAction(value, context),
                color: Colors.white,
                itemBuilder: (BuildContext context) {
                  return _isDataLoaded ? _createPopupMenuItems() : [];
                },
              )
            ],
          ),
          body: Container(
            color: const Color(0xfff0f0f0),
            child: Stack(
              children: <Widget>[
                MessageStream(
                  category: widget.category,
                  entry: widget.entry,
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
    );
  }


  void _choiceAction(String choice, BuildContext context) {
    if (choice == MenuButtons.SUBSCRIBE) {
      _subscriptionEvent();
    } else if (choice == MenuButtons.CLOSE_THREAD) {
      setState(() {
        _isClosed = true;
        _entryService.closeBoardEntry(widget.entry);
      });
    }
  }
  showSubscriptionMessage(isInserted, isError){
    Flushbar(
      messageText: Center(
        child: Text(isError == true ? "Etwas ist schief gelaufen. Überprüfe deine Internetverbindung" : isInserted ? "Gepinnt" : "Nicht mehr gepinnt",style: TextStyle(
          fontSize: 15,
          fontFamily: "Raleway",
          color: Colors.white
        ),),
      ),
      duration: Duration(seconds: 1),
    )..show(context);
  }
  _subscriptionEvent(){
    var service = SubscriptionService();
    service.subscribe(
        currentUser: _currentUser,
        topLevelDocumentID: widget.entry.documentID,
        topLevelCollection: CollectionNames.BOARD_ENTRY,).then((isInserted){
        if(!isInserted) {
          service.deleteSubscription(
              currentUser: _currentUser,
              topLevelDocumentID: widget.entry.documentID,
              topLevelCollection: CollectionNames.BOARD_ENTRY);
        }
        showSubscriptionMessage(isInserted, false);
    }).catchError((onError){
      showSubscriptionMessage(false, true);
    });
  }
}
