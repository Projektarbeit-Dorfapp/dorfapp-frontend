import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Meike Nedwidek
class LikeDetail extends StatelessWidget{

  final List<User> likeList;

  LikeDetail({this.likeList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6178a3),
      ),
      body: Container(
        color: Colors.white,
        constraints: BoxConstraints.expand(),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: likeList.map((user) => Text(
                      user.firstName + " " + user.lastName,
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      )
                  )).toList()
              )
            )
          ],
        ),
      ),
    );
  }
}