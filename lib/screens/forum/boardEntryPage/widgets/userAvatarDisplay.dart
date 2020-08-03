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
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Icon(Icons.person, color: Colors.black38,),
      ),
    );
  }
}
