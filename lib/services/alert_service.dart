import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/alert_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

///Matthias Maxelon
///
/// All [Consumer] that listens to this class will build when the client receives or deletes alerts. The AlertService can be accessed with
/// Provider.of<AlertService>(context, listen: true/false) or with the [Consumer]-Widget. The Provider is currently implemented as a global Provider and can
/// be safely accessed from every Widget in the Widget-Tree
class AlertService extends ChangeNotifier {
  List<Alert> _alerts = [];
  Stream<List<Alert>> _alertStream;
  StreamSubscription _subscription;
  String _loggedUserID;

  List<Alert> getAlerts() {
    return _alerts;
  }

  ///Opens stream. Is initiated in RootPage. Never call this function outside of RootPage
  initStream(UserService userService, AccessHandler accessHandler) async {
    FirebaseUser firebaseUser = await Authentication().getCurrentUser();
    User u = await UserService().getUser(firebaseUser.uid);
    _loggedUserID = u.uid;
    _alertStream = _getAlertRef(u.documentID).orderBy("creationDate", descending: true).snapshots().map((snapshot) {
      List<Alert> list = [];
      for (var document in snapshot.documents) {
        var alert = Alert.fromJson(document.data, document.documentID);
        list.add(alert);
      }
      _alerts = list;
      return list;
    }).handleError((onError) {
      print(onError); //???
      print("okoko");
    });
    _listenStream();
  }

  ///Listen to [_alertStream] and notifies [Consumer] each time there is a change in alert count.
  _listenStream() {
    _subscription = _alertStream.listen((event) {
      _alerts = event.toList();
      notifyListeners();
      print("Number of Alerts: " + _alerts.length.toString());
    });
  }

  ///Cancels subscription to stream. Is called in RootPage. Never call this function outside of RootPage
  //Not sure if needed?
  disposeSubscription() async {
    if (_subscription != null) await _subscription.cancel();
    _subscription = null;
  }

  ///The [subscriber]-list can be generated by the [SubscriptionService.getSubscriptions] and holds all [User.uid]
  ///that subscribed to a specific content. Note: The currently logged user cannot create Alerts for his own Account.
  //Much better if function is handled by firestore cloud function because client has to do the work for sending alerts to EACH user that has subscribed
  //-> I dont think it is worth to change it for this project because time limitations. This should be mentioned in the documentation
  insertAlerts(List<String> subscriber, Alert alert) async {
    for (var userID in subscriber) {
      if (_loggedUserID != userID) {///user that created the alert and is in subscriber list knows what happened. No alert creation for that user
        await Firestore.instance.collection(CollectionNames.USER).where("uid", isEqualTo: userID).getDocuments().then((snapshot) {
          _getAlertRef(snapshot.documents[0].documentID).add(alert.toJson());
        }).catchError((onError) {
          print(onError);
        });
      }
    }
  }

  ///Deletes a specific [Alert]-Document of the currently logged in user. TODO: Currently not working
  deleteAlert(String userID, Alert alert) async{
    await Firestore.instance.collection(CollectionNames.USER).where("uid", isEqualTo: userID).getDocuments().then((snapshot){
      _getAlertRef(snapshot.documents[0].documentID).document(alert.documentID).delete();
    }).catchError((onError){
      print(onError);
    });
  }

  ///Calling this function will delete every [Alert]-Document that a user might hold
  //Much better if function is handled by firestore cloud function
  deleteAllAlerts(String userID) async{
    await Firestore.instance.collection(CollectionNames.USER).where("uid", isEqualTo: userID).getDocuments().then((snapshot) async{
      final ref = _getAlertRef(snapshot.documents[0].documentID);
      final documents =  await ref.getDocuments();
      for(DocumentSnapshot doc in documents.documents){
        ref.document(doc.documentID).delete();
      }
    }).catchError((onError){
      print(onError);
    });
  }

  CollectionReference _getAlertRef(String userDocID) {
    return Firestore.instance.collection(CollectionNames.USER).document(userDocID).collection(CollectionNames.ALERTS);
  }

  ///Updates alert document field "isRead" to true
  markAsRead(String userID, Alert alert) async{
    await Firestore.instance.collection(CollectionNames.USER).where("uid", isEqualTo: userID).getDocuments().then((snapshot) {
      final ref = _getAlertRef(snapshot.documents[0].documentID);
      ref.document(alert.documentID).updateData({"isRead" : true});
    }).catchError((onError){
      print(onError);
    });
  }
}
