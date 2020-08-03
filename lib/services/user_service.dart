import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';

///Matthias Maxelon
class UserService extends ChangeNotifier{

  final CollectionReference _ref = Firestore.instance.collection(CollectionNames.USER);
  final _timeout = Duration(seconds: 10);

  ///Checks in database if userName already exist in user collection
  Future<bool> validateUser(String userName) async{
   QuerySnapshot snapshot = await _ref
       .where("userName", isEqualTo: userName)
       .getDocuments();
   return _validate(snapshot);
  }

  bool _validate(QuerySnapshot snapshot){
    if(snapshot.documents.length == 0){
      return false;
    } else {
      return true;
    }
  }

  ///Checks in database if email already exist in user collection
  Future<bool> validateEmail(String email) async{

    QuerySnapshot snapshot = await _ref
        .where("email", isEqualTo: email)
        .getDocuments();
    return _validate(snapshot);
  }

  ///add User into user collection as document
  Future<void> insertUser(User user) async{
    await _ref.document().setData(user.toJson());
  }

  ///check if user is admin
  Future<bool> checkIfAdmin(String userID) async {
    bool isAdmin;
    await _ref.where("uid", isEqualTo: userID)
        .getDocuments().then((dataSnapshot) {
          var document = dataSnapshot.documents.first;
          isAdmin = document != null ? document.data['admin'] : false;
    });
      return isAdmin;
  }

  Future<User> getUser(String userID) async{
    User user;
    await _ref
        .where("uid", isEqualTo: userID)
        .getDocuments()
        .then((snapshot){
          var fetchedUser = User.fromJson(snapshot.documents[0].data, snapshot.documents[0].documentID);
          user = fetchedUser;
        })
        .timeout(_timeout, onTimeout: (){
          print("Developermessage ERROR: timeout on Service: [UserService] in: [getUser()]");
          throw Exception();
        })
        .catchError((error){
          print("Developermessage ERROR: " + error);
        });
    return user;
  }

  Future<List<User>> getUsers(User loggedUser) async {
    List<User> users = [];
    final snapshot = await _ref.getDocuments();
    for(var document in snapshot.documents){
      if(document.data["uid"] != loggedUser.uid)
        users.add(User.fromJson(document.data, document.documentID));
    }
    return users;
  }
}