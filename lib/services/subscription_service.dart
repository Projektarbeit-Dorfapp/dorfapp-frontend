
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';

///Matthias Maxelon
class SubscriptionService{

  ///Returns a [Future] bool true if user successfully subscribed or false if already subscribed.
  ///The subscription is saved as a sub collection of a document inside a top level collection
  ///-> [TopLevelCollection] -> [topLevelDocumentID] -> Saved in sub collection with name "Gepinnt".
  ///A subscription is saved as a Document with no values in "Gepinnt". The DocumentID is the [User.uid] from [User].
  //missing error catch
  Future<bool> subscribe({@required User currentUser, @required String topLevelDocumentID, @required String topLevelCollection,}) async{
    bool isInsert;
    var ref = _getRef(topLevelDocumentID, topLevelCollection);

    bool isSubscribed = await isUserSubscribed(
        topLevelCollection: topLevelCollection,
        currentUser: currentUser,
        topLevelDocumentID: topLevelDocumentID);
    if(isSubscribed){
      isInsert = false;
    } else {
      await ref.document(currentUser.uid).setData({}).then((_) {
        isInsert = true;
      });
    }
    return isInsert;
  }
  ///Check if user already subscribed to [topLevelDocumentID].
  //Missing Error catch
  Future<bool> isUserSubscribed({@required User currentUser, @required String topLevelDocumentID, @required String topLevelCollection}) async{
    var ref = _getRef(topLevelDocumentID, topLevelCollection);
    bool isSubscribed;
    var subscriptionDoc = await ref.document(currentUser.uid).get();
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
  deleteSubscription({@required User currentUser, @required String topLevelDocumentID, @required String topLevelCollection}) async {
    var ref = _getRef(topLevelDocumentID, topLevelCollection);
    ref.document(currentUser.uid).delete();
  }
  CollectionReference _getRef(documentID, collection){
    return Firestore.instance
        .collection(collection)
        .document(documentID)
        .collection(CollectionNames.PIN);
  }
}