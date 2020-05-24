import 'package:flutter/material.dart';

class RegistrationTextNavi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/registration')
        .then((value) {
          if(value == "sucess"){
            SnackBar snackBar = SnackBar(content: Text("Account angelegt"));
            Scaffold.of(context).showSnackBar(snackBar);
          }
        });
      },
      child: Text(
        "Neu hier?",
        style: TextStyle(color: Colors.blueGrey, fontSize: 17),
      ),
    );
  }
}
