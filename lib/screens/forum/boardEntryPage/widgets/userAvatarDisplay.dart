import 'package:flutter/material.dart';

class UserAvatarDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
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
