import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class ChangeUserAccount extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
       Provider.of<AccessHandler>(context, listen: false).logout();
       Navigator.pop(context);
      },
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Icon(
              Icons.account_box,
              color: Theme.of(context).buttonColor,
            ),
          ),
          Text(
            "Mein Account wechseln",
            style: TextStyle(fontFamily: "Raleway", fontSize: 16),
          ),
        ],
      ),
    );
  }
}
