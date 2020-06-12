import 'package:flutter/cupertino.dart';

///Matthias Maxelon
class User extends ChangeNotifier {
  String id;
  String uid;
  bool admin;
  bool verificationState;
  String userName;
  int age;
  String userAvatarReference;
  String municipalReference;
  String sex;
  String houseNumber;
  String lastName;
  String foreName;
  String townDistrict;
  String plz;
  String street;
  String email;
  User(
      {@required this.userName,
        @required this.uid,
      this.admin,
      this.verificationState,
      this.age,
      this.userAvatarReference,
      this.municipalReference,
      this.sex,
      this.houseNumber,
      this.lastName,
      this.foreName,
      this.townDistrict,
      this.plz,
      this.street,
      this.email});

  User.fromJson(Map snapshot, String id){
    this.id = id;
    admin = snapshot["admin"] ?? false;
    verificationState = snapshot["verificationState"] ?? false;
    userName = snapshot["userName"] ?? "";
    age = snapshot[age] ?? 0;
    userAvatarReference = snapshot["userAvatarReference"] ?? "";
    municipalReference = snapshot["municipalReference"] ?? "";
    sex = snapshot["sex"] ?? "";
    houseNumber = snapshot["houseNumber"] ?? "";
    lastName = snapshot["lastName"] ?? "";
    foreName = snapshot["foreName"] ?? "";
    townDistrict = snapshot["townDistrict"] ?? "";
    plz = snapshot["plz"] ?? "";
    street = snapshot["street"] ?? "";
    email = snapshot["email"] ?? "";
    uid = snapshot["uid"] ?? "";
  }
  Map<String, dynamic> toJson(){
    return {
      "admin" : admin,
      "verificationState" : verificationState,
      "userName" : userName,
      "age" : age,
      "userAvatarReference" : userAvatarReference,
      "municipalReference" : municipalReference,
      "sex" : sex,
      "houseNumber" : houseNumber,
      "lastName" : lastName,
      "foreName" : foreName,
      "townDistrict" : townDistrict,
      "plz" : plz,
      "street" : street,
      "email" : email,
      "uid" : uid,
    };
  }
}
