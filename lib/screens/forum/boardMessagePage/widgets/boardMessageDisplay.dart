import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:dorf_app/services/boardMessage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardMessageDisplay extends StatefulWidget {
  final BoardMessageWithUser messageWithUser;
  BoardMessageDisplay(this.messageWithUser);
  @override
  _BoardMessageDisplayState createState() => _BoardMessageDisplayState();
}

class _BoardMessageDisplayState extends State<BoardMessageDisplay> {
  FirebaseUser _currentUser;
  @override
  void initState() {
    Provider.of<Authentication>(context, listen: false)
        .getCurrentUser()
        .then((user) {
      setState(() {
        _currentUser = user;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser != null) {
      return Container(
        height: 100,
        child: Card(
              color: _getColor(),
              child: Text(
                widget.messageWithUser.message.message,
                style: TextStyle(
                    fontFamily: "Raleway",
                color: _getTextColor()),
              ),
            ),
      );
    } else {
      return Container();
    }
  }
  Color _getColor(){
    if(_currentUser.uid == widget.messageWithUser.user.uid){
      return Colors.lightGreen;
    } else {
      return Color(0xfff2f2f2);
    }
  }
  Color _getTextColor(){
    if(_currentUser.uid == widget.messageWithUser.user.uid){
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

}
