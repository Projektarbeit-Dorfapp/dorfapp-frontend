import 'package:flutter/cupertino.dart';

//Meike Nedwidek
class Address{

  String street;
  String houseNumber;
  String zipCode;
  String district;

  Address({this.street, this.houseNumber, this.zipCode, this.district});

  String getAddressFormat() {
    if(this.zipCode == '' && this.district == '' && this.street != '') {
      return '${this.street} ${this.houseNumber}';
    }

    if(this.street == '' && this.houseNumber == '' && this.zipCode != '') {
      return '${this.zipCode} ${this.district}';
    }

    return '${this.street} ${this.houseNumber}, ${this.zipCode} ${this.district}';
  }

}