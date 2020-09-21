import 'package:flutter/material.dart';
///Matthias Maxelon
class ShowUserProfileText extends StatelessWidget {
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final String firstName;
  final String lastName;
  final String userName;
  final String userReference;
  ShowUserProfileText({this.color, this.fontSize, this.fontWeight, @required this.userName, @required this.userReference, @required this.firstName, @required this.lastName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //_showUserProfile(context); Does not work because how the profilePage is built (currently only works with the logged user)
      },
      child: Row(
        children: <Widget>[
          Text(
            firstName + " ",
            style: TextStyle(
              color: color != null ? color : Colors.black,
              fontSize: fontSize != null ? fontSize : 16,
              fontWeight: fontWeight != null ? fontWeight : FontWeight.normal,
            ),

          ),
          Text(
            lastName,
            style: TextStyle(
              color: color != null ? color : Colors.black,
              fontSize: fontSize != null ? fontSize : 16,
              fontWeight: fontWeight != null ? fontWeight : FontWeight.normal,
            ),

          ),
        ],
      ),
    );
  }
  _showUserProfile(BuildContext context){
    Navigator.pushNamed(context, "/profilePage", arguments: userReference);
  }
}
