import 'package:dorf_app/screens/news/widgets/userSettings.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final _safeAreaHeight;
  final _currentUser;
  UserAvatar(this._safeAreaHeight, this._currentUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only( right: 5, top: 10),
      child: GestureDetector(
        onTap: (){
          _showDrawer(context);
        },
        child: Container(
          height: 50,
          width: 50,
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
          return SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height - _safeAreaHeight, //TODO: Need to subtract system bar for perfect height
              child: UserSettings(
                _currentUser
              ),
            ),
          );
        }
    );
  }
}
