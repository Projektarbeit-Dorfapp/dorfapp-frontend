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

class _PinsPageState extends State<PinsPage> {
  SubscriptionService _subscriptionService;
  ScrollController _scrollController;
  User _loggedUser;
  int _itemLimit = 10;
  int _snapshotItemCount;
  @override
  void initState() {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loggedUser != null
        ? StreamBuilder<List<BoardEntry>>(
            stream: _subscriptionService.getPinnedEntries(_loggedUser, _itemLimit),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  key: UniqueKey(),
                  controller: _scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, int index){
                      _snapshotItemCount = snapshot.data.length;
                      return BoardEntryDisplay(entry: snapshot.data[index], boardCategoryReference: snapshot.data[index].boardCategoryReference);
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
}
