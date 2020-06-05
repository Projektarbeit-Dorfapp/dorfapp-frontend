import 'package:flutter/material.dart';

///Matthias Maxelon
class RegistrationText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        _showRegistrationPage(context);
      },
      child: Container(
        width: 80,
        height: 20,
        child: Center(
            child: Text(
              "Neu hier?",
              style: TextStyle(
                fontSize: 18,
                  color: Colors.black,
              fontFamily: "Raleway"),
            ),
          ),
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
