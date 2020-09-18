import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/forum/boardEntryPage/widgets/boardEntryDisplay.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class PinsPage extends StatefulWidget {
  @override
  _PinsPageState createState() => _PinsPageState();
}

class _PinsPageState extends State<PinsPage> with TickerProviderStateMixin{
  AnimationController _animationController;
  SubscriptionService _subscriptionService;
  ScrollController _scrollController;
  User _loggedUser;
  int _itemLimit = 10;
  int _snapshotItemCount;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );
    _subscriptionService = SubscriptionService();
    _scrollController = ScrollController();
    Provider.of<AccessHandler>(context, listen: false).getUser().then((user) {
      if (mounted)
        setState(() {
          _loggedUser = user;
        });
    });
    _scrollController.addListener(_increaseListSize);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loggedUser != null
        ? StreamBuilder(
            stream: _subscriptionService.getPinnedDocumentsAsStream(_loggedUser, _itemLimit, SubscriptionType.entry),
            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasData) {
               final boardEntries = _parseToEntries(snapshot);
                return ListView.builder(
                  key: UniqueKey(),
                  controller: _scrollController,
                    itemCount: boardEntries.length,
                    itemBuilder: (context, int index){
                      _snapshotItemCount = boardEntries.length;
                      _animationController.forward();
                      return FadeScaleTransition(
                        animation: _animationController,
                        child: BoardEntryDisplay(
                            entry: boardEntries[index]),
                      );
                    });
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                  child: Text("Etwas ist schief gelaufen"),
                );
              }
            },
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
  _increaseListSize(){
    if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
      if(_snapshotItemCount > _itemLimit){
        setState(() {
          _itemLimit = _itemLimit + 10;
        });
      }
    }
  }
 List<BoardEntry> _parseToEntries(AsyncSnapshot<List<DocumentSnapshot>> snapshot){
    List<BoardEntry> list = [];
    for(DocumentSnapshot doc in snapshot.data){
      try{
        list.add(BoardEntry.fromJson(doc.data, doc.documentID));
      }catch(e){
        print(e);
      }

    }
    return list;
  }
}
