import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/models/user_model.dart';

class LikeService {
  
  void insertLike(User user, String documentID, String collection) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection("likes").document(user.uid).setData({
        "firstName": user.firstName,
        "lastName": user.lastName
    });
  }

  void deleteLike(User user, String documentID, String collection) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection("likes").document(user.uid).delete();
  }
}
