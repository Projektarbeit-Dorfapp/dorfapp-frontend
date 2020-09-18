import 'package:flutter/material.dart';

class UserAvatarDisplay extends StatelessWidget {
  final double height;
  final double width;
  UserAvatarDisplay(this.height, this.width);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: CircleAvatar(
        backgroundImage: AssetImage("assets/avatar.png"),
        backgroundColor: Colors.white,

      )
    );
  }
}
