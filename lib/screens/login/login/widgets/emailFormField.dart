import 'package:flutter/material.dart';

class EmailFormField extends StatefulWidget {
  @override
  _EmailFormFieldState createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            color: Colors.blueGrey,
          ),
          labelText: "E-Mail",
        ),
        validator: (String value){
          return null; //TODO: Validate if email is incorrect
        },
      ),
    );
  }
}
