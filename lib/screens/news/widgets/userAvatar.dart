import 'package:dorf_app/screens/news/widgets/userSettings.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final _safeAreaHeight;
  UserAvatar(this._safeAreaHeight);
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
              image: AssetImage('assets/australian-shepherd-2208371_1920.jpg'),
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

              ),
            ),
          );
        }
    );
  }
}
