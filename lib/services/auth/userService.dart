import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/screens/login/models/user_model.dart';
import 'package:flutter/cupertino.dart';

///Matthias Maxelon
class UserService extends ChangeNotifier{
  final CollectionReference _ref = Firestore.instance.collection("User");
  ///Checks in database if userName already exist in user collection
  Future<bool> validateUser(String userName) async{
   QuerySnapshot snapshot = await _ref
       .where("userName", isEqualTo: userName)
       .getDocuments();
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
    if(snapshot.documents.length == 0){
      return false;
    } else {
      return true;
    }
  }
  ///add User into user collection as document
  Future<void> insertUser(User user) async{
    await _ref.document().setData(user.toJson());
  }
}