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
  ScrollController _controller;
  User _loggedUser;
  int _itemLimit = 10;
  @override
  void initState() {
    _subscriptionService = SubscriptionService();
    _controller = ScrollController();
    Provider.of<AccessHandler>(context, listen: false).getUser().then((user) {
      if (mounted)
        setState(() {
          _loggedUser = user;
        });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, int index){
                      return BoardEntryDisplay(entry: snapshot.data[index], boardCategoryReference: snapshot.data[index].boardCategoryReference,);
                    });
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                  child: Text("Etwas lief schief"),
                );
              }
            },
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
