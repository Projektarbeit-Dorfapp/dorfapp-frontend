import 'package:flutter/cupertino.dart';

///Matthias Maxelon
class User extends ChangeNotifier {
  String documentID;
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
  String firstName;
  String townDistrict;
  String plz;
  String street;
  String email;
  String imagePath;

  User(
      {this.uid,
      this.userName,
      this.admin,
      this.verificationState,
      this.age,
      this.userAvatarReference,
      this.municipalReference,
      this.sex,
      this.houseNumber,
      this.lastName,
      this.firstName,
      this.townDistrict,
      this.plz,
      this.street,
      this.email,
      this.imagePath,
      this.documentID});

  User.fromJson(Map snapshot, String id){
    this.documentID = id;
    admin = snapshot["admin"] ?? false;
    verificationState = snapshot["verificationState"] ?? false;
    userName = snapshot["userName"] ?? "";
    age = snapshot["age"] ?? 0;
    userAvatarReference = snapshot["userAvatarReference"] ?? "";
    municipalReference = snapshot["municipalReference"] ?? "";
    sex = snapshot["sex"] ?? "";
    houseNumber = snapshot["houseNumber"] ?? "";
    lastName = snapshot["lastName"] ?? "";
    firstName = snapshot["firstName"] ?? "";
    townDistrict = snapshot["townDistrict"] ?? "";
    plz = snapshot["plz"] ?? "";
    street = snapshot["street"] ?? "";
    email = snapshot["email"] ?? "";
    uid = snapshot["uid"] ?? "";
    imagePath = snapshot["imagePath"] ?? "";
  }

  Map<String, dynamic> toJson() {
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
      "firstName" : firstName,
      "townDistrict" : townDistrict,
      "plz" : plz,
      "street" : street,
      "email" : email,
      "uid" : uid,
      "imagePath" : imagePath,
      "id" : documentID,
    };
  }
}
