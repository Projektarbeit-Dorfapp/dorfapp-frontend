import 'package:dorf_app/models/address_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Meike Nedwidek
class AddressDetailView extends StatelessWidget {

  Address address;

  AddressDetailView(this.address);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Icon(
              Icons.location_on,
              color: Colors.white,
              size: 22.0
          ),
          Flexible(
            child: Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  _getAddressFormat(),
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Colors.white
                  ),
                )
            ),
          )
        ],
    );
  }

  String _getAddressFormat() {

    if(address == null){
      return '-';
    }
    if(address.zipCode == null && address.district == null && address.street != null) {
      return '${address.street} ${address.houseNumber}';
    }
    if(address.street == null && address.houseNumber == null && address.zipCode != null) {
      return '${address.zipCode} ${address.district}';
    }
    return '${address.street} ${address.houseNumber}, ${address.zipCode} ${address.district}';
  }


}