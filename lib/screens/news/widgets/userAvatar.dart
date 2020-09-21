import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/profile/widgets/userSettings.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final double _safeAreaHeight;
  final User _currentUser;
  final double height;
  final double width;
  UserAvatar(this._safeAreaHeight, this._currentUser, this.height, this.width);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only( right: 5, top: 10),
      child: GestureDetector(
        onTap: (){
          _showDrawer(context);
        },
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _currentUser.imagePath != "" ? NetworkImage(_currentUser.imagePath)
                  : AssetImage("assets/avatar.png"),
              fit: BoxFit.fill,
            ),
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
  _showDrawer(BuildContext context){
    showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        builder: (context){
          return Container(
            height: MediaQuery.of(context).size.height - _safeAreaHeight,
            child: UserSettings(

            ),
          );
        }
    );
  }
}
