
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/alert_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:flutter/cupertino.dart';

///Matthias Maxelon
enum NotificationType{news, entry}
class SubscriptionService{

  ///Returns a [Future] bool true if user successfully subscribed or false if already subscribed.
  ///The Subscription-Document is saved here:
  ///
  ///-> [TopLevelCollection] -> [topLevelDocumentID] -> Saved as document in sub collection under [topLevelDocumentID] with name [CollectionNames.PIN].
  ///
  ///
  ///This document contains no values. The DocumentID is the [User.uid] from [User].
  ///Additionally you can add a [News] or [BoardEntry] to notify the creator that somebody subscribed to his own content.
  //missing error catch
  Future<bool> subscribe({@required User loggedUser, @required String topLevelDocumentID, @required String topLevelCollection, News news, BoardEntry entry}) async{
    if(news != null && entry != null){
      throw Exception("The Method subscribe() in [SubscriptionService] should not get a [News]-Object and [BoardEntry]-Object at the same time");
    }
    bool isInsert;
    var ref = _getRef(topLevelDocumentID, topLevelCollection);
    bool isSubscribed = await isUserSubscribed(
        topLevelCollection: topLevelCollection,
        loggedUser: loggedUser,
        topLevelDocumentID: topLevelDocumentID);
    if(isSubscribed){
      isInsert = false;
    } else {
      await ref.document(loggedUser.uid).setData({}).then((_) {
        isInsert = true;
        if(news != null){
          _notifyCreator(news.createdBy, news.description, loggedUser, NotificationType.news);
        } else if(entry != null)
          _notifyCreator(entry.userReference, entry.title, loggedUser, NotificationType.entry);
      });
    }
    return isInsert;
  }

  ///Notify Creator of Content that somebody subscribed to his content (creatorID must be the User that created content!)
  _notifyCreator(String creatorID, String headline, User loggedUser, NotificationType type){
    if(creatorID == loggedUser.uid){
      return;
    }
    final _alertService = AlertService();
    List<String> list = [];
    list.add(creatorID);
    final alert = Alert(
      additionalMessage: _createAdditionalMessage(headline, loggedUser, type),
      alertType: AlertType.pin_notification,
      fromUserName: loggedUser.userName,
      fromLastName: loggedUser.lastName,
      fromFirstName: loggedUser.firstName,
      creationDate: Timestamp.fromDate(DateTime.now()),
      headline: headline,
    );
    _alertService.insertAlerts(list, alert);
  }

  String _createAdditionalMessage(String headline, User loggedUser, NotificationType type){
    String text = "";
    String title = headline;
    if(title == null || title == "")
      title = "[MISSING HEADLINE]";

    if(type == NotificationType.entry){
      text = "${loggedUser.userName} folgt jetzt dein Thema: " + title;
    } else
      text = "${loggedUser.userName} folgt jetzt deiner Veranstaltung: " + title;
    return text;
  }

  ///Check if user already subscribed to [topLevelDocumentID].
  //Missing Error catch
  Future<bool> isUserSubscribed({@required User loggedUser, @required String topLevelDocumentID, @required String topLevelCollection}) async{
    var ref = _getRef(topLevelDocumentID, topLevelCollection);
    bool isSubscribed;
    var subscriptionDoc = await ref.document(loggedUser.uid).get();
    if(subscriptionDoc.data == null){
      isSubscribed = false;
    } else {
      isSubscribed = true;
    }
    return isSubscribed;
  }

  ///Returns a list of [User.uid] that subscribed to [topLevelDocumentID].
  Future<List<String>> getSubscriptions({@required String topLevelDocumentID, @required String topLevelCollection}) async {
    var ref = _getRef(topLevelDocumentID, topLevelCollection);
    List<String> list = [];
    QuerySnapshot snapshot = await ref.getDocuments();
    for(DocumentSnapshot doc in snapshot.documents){
      list.add(doc.documentID);
    }
    return list;
  }

  ///Deletes a specific subscription from [topLevelDocumentID]
  deleteSubscription({@required User loggedUser, @required String topLevelDocumentID, @required String topLevelCollection}) async {
    var ref = _getRef(topLevelDocumentID, topLevelCollection);
    ref.document(loggedUser.uid).delete();
  }

  CollectionReference _getRef(documentID, collection){
    return Firestore.instance
        .collection(collection)
        .document(documentID)
        .collection(CollectionNames.PIN);
  }
}