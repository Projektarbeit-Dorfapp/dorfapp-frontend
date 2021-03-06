import 'package:flutter/material.dart';

///Matthias Maxelon
class LoginInputDecoration {
  final IconData icon;
  final Color color;
  final String labelText;
  final double contentPadding;
  LoginInputDecoration({this.icon, this.color, this.labelText, this.contentPadding});

  InputDecoration decorate(BuildContext context) {
    return InputDecoration(

        contentPadding: contentPadding != null ? EdgeInsets.only(right: contentPadding) : null,

        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black38),
        ),

        /*
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 2, color: Colors.red)),
*
         */
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 2, color: Colors.red)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor),
        ),
        labelText: labelText != null ? labelText : null,
        prefixIcon: icon != null && color != null
            ? Padding(
          padding: EdgeInsets.only(left: 10),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(icon, color: Theme.of(context).buttonColor,),
                    Container(
                        height: 40,
                        child: VerticalDivider(
                          thickness: 2,
                        )),
                  ],
                ),
            )
            : null);
  }
}
