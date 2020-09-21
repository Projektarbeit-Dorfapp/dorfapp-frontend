import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/profile/widgets/userSettings.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String imagePath;
  final double height;
  final double width;
  UserAvatar(this.imagePath, this.height, this.width);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only( right: 5, top: 10),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imagePath != "" ? NetworkImage(imagePath)
                : AssetImage("assets/avatar.png"),
            fit: BoxFit.fill,
          ),
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

}
