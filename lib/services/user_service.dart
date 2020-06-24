import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/screens/login/models/user_model.dart';
import 'package:flutter/cupertino.dart';

///Matthias Maxelon
class UserService extends ChangeNotifier{
  final CollectionReference _ref = Firestore.instance.collection("User");
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
          throw Exception();
        });
    return user;
  }
}