import 'package:dorf_app/screens/login/models/user_model.dart';
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
        title: Text('"Gefällt mir"'),
      ),
      body: Container(
        color: Colors.white,
        constraints: BoxConstraints.expand(),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: likeList.map((user) => Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 10.0, bottom: 15.0, top: 15.0),
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(user.imagePath != null && user.imagePath != "" ? user.imagePath : "assets/avatar.png")
                                )
                            )
                        ),
                        Text(
                            user.firstName + " " + user.lastName,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0
                            )
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFE6E6E6),
                            width: 2.0
                          )
                        )
                      ),
                    )
                  ],
                )).toList()
              )
            )
          ],
        ),
      ),
    );
  }
}