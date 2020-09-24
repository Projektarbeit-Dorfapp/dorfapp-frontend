import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/user_model.dart';

///Kilian Berthold & Meike Nedwidek
class LikeService {
  
  void insertLike(User user, String documentID, String collection) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection(CollectionNames.LIKES).document(user.uid).setData({
        "firstName": user.firstName,
        "lastName": user.lastName
    });
    _collectionReference.document(documentID).updateData({"likeCount" : FieldValue.increment(1)});
  }

  void deleteLike(User user, String documentID, String collection) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection(CollectionNames.LIKES).document(user.uid).delete();
    _collectionReference.document(documentID).updateData({"likeCount" : FieldValue.increment(-1)});
  }

  Future<List<User>> getUsersThatLiked(String documentID, String collection) async {
    List<User> userList = [];
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    QuerySnapshot snapshot = await _collectionReference.document(documentID).collection(CollectionNames.LIKES).getDocuments();
    for(var doc in snapshot.documents){
      userList.add(new User(
          uid: doc.documentID,
          firstName: doc.data['firstName'],
          lastName: doc.data['lastName']));
    }
    return userList;
  }

  Future<int> getLikeQuantity(String documentID, String collection) async{
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    QuerySnapshot snapshot = await _collectionReference.document(documentID).collection(CollectionNames.LIKES).getDocuments();
    return snapshot.documents.length;
  }
}
