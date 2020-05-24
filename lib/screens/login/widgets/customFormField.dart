import 'package:flutter/material.dart';

enum FormFieldType {
  registrationEmail,
  username,
  foreName,
  lastName,
  age,
  town,
  registrationPassword,
  registrationConfirmedPassword,
  loginPassword,
  loginEmail,
}

class CustomFormField extends StatefulWidget {
  final IconData icon;
  final String labelText;
  final String validation;
  final FormFieldType type;
  final bool obscureText;
  CustomFormField({
    @required this.icon,
    @required this.labelText,
    @required this.validation,
    @required this.type,
    this.obscureText,
  });
  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  TextEditingController _controller;
  bool _obscureText = false;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if(widget.obscureText != null){
      _obscureText = widget.obscureText;
    }
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
        controller: _controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: Colors.blueGrey,
          ),
          labelText: widget.labelText,
        ),

      ),
    );
  }

}
