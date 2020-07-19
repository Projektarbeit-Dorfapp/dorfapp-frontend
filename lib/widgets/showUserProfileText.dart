import 'package:flutter/material.dart';
///Matthias Maxelon
class ShowUserProfileText extends StatelessWidget {
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final String userName;
  final String userReference;
  ShowUserProfileText({this.color, this.fontSize, this.fontWeight, @required this.userName, @required this.userReference});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _showUserProfile(context);
      },
      child: Text(
        userName,
        style: TextStyle(
          color: color != null ? color : Colors.black,
          fontSize: fontSize != null ? fontSize : 16,
          fontWeight: fontWeight != null ? fontWeight : FontWeight.normal,
        ),
      ),
    );
  }
  _showUserProfile(BuildContext context){
    Navigator.pushNamed(context, "/profilePage", arguments: userReference);
  }
}
