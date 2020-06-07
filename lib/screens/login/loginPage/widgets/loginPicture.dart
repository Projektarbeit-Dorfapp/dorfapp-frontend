import 'package:flutter/material.dart';

class LoginPicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Image.network(
         "https://miro.medium.com/max/1000/1*ilC2Aqp5sZd1wi0CopD1Hw.png"),
    );
  }
}
