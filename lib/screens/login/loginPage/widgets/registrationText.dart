import 'package:flushbar/flushbar.dart';
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
        Flushbar(
          message: "Dein neuer Account ist angelegt",
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          icon: Icon(Icons.error_outline, color: Color(0xFF548c58)),
          duration: Duration(seconds: 5),
          flushbarPosition: FlushbarPosition.TOP,
        )..show(context);
      }
    });
  }
}
