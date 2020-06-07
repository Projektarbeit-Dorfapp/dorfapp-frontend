import 'package:flutter/material.dart';

///Matthias Maxelon
class RegistrationTextNavi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showRegistrationPage(context);
      },
      child: Text(
        "Neu hier?",
        style: TextStyle(color: Colors.blueGrey, fontSize: 17),
      ),
    );
  }
  _showRegistrationPage(BuildContext context){
    Navigator.pushNamed(context, '/registration')
        .then((value) {
      if(value == "success"){
        SnackBar snackBar = SnackBar(content: Text("Account angelegt"));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    });
  }
}
