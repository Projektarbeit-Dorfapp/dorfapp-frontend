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
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(50),
        image: DecorationImage(
         fit: BoxFit.fill,
         image: AssetImage("assets/avatar.png"),
        ),
      ),
    );
  }
}