import 'file:///C:/Users/R4pture/AndroidStudioProjects/dorfapp-frontend/lib/screens/profile/widgets/userSettings.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final double _safeAreaHeight;
  final double height;
  final double width;
  UserAvatar(this._safeAreaHeight, this.height, this.width);
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
          return Container(
            height: MediaQuery.of(context).size.height - _safeAreaHeight,
            //TODO: MediaQuery.of(context).padding.top isn't working... something is off with the context dont know why even the _safeAreaHeight doesnt work.
            child: UserSettings(

            ),
          );
        }
    );
  }
}
