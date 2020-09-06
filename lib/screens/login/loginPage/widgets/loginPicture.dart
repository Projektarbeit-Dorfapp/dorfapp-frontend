import 'package:flutter/material.dart';

class LoginPicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Image.asset('assets/icon_resized.png')
    );
  }
}
