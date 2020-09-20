import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Philipp Hellwich

class SubscriptionSection extends StatefulWidget {

  final List<User> bookmarks;
  final String document;
  final String userID;
  

  SubscriptionSection(this.document, this.bookmarks, this.userID);

  @override
  _SubscriptionSectionState createState() => _SubscriptionSectionState(document, bookmarks, userID);
}

class _SubscriptionSectionState extends State<SubscriptionSection> {
  final subscriptionService = SubscriptionService();
  AccessHandler _accessHandler;
  List<User> bookmarks;
  String document;
  String _userID;
  User user; 
  bool isSubscribed;

  _SubscriptionSectionState(this.document, this.bookmarks, this._userID);

  // ignore: missing_return
  Future<bool> _subscribe() async {
    User user = await _accessHandler.getUser();    
    setState(() {
      if (bookmarks.any((element) => element.uid == _userID)) {
        isSubscribed = false;
        subscriptionService.deleteSubscription(loggedUser: user, topLevelDocumentID: document, subscriptionType: SubscriptionType.news);
        bookmarks.remove(bookmarks.firstWhere((element) => element.uid == _userID));
      } else {
        isSubscribed = true;
        subscriptionService.subscribe(loggedUser: user, topLevelDocumentID: document, subscriptionType: SubscriptionType.news);
        bookmarks.add(user);
      }
    });
    return isSubscribed;
  }

  @override
  void initState() {
    _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (bookmarks == null) {
      bookmarks = List<User>();
    }
    isSubscribed = bookmarks?.any((element) => element.uid == _userID);
    return IconButton(
      icon: Icon( isSubscribed ? Icons.bookmark : Icons.bookmark_border ),
      onPressed: () async {
        await _subscribe();
      },
    );
  }
}