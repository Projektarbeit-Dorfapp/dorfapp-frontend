import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/news/widgets/userAvatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Meike Nedwidek
class LikeDetail extends StatelessWidget{

  final List<User> likeList;
  final Color appbarColor;
  LikeDetail({this.likeList, this.appbarColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor != null ? appbarColor : Theme.of(context).primaryColor,
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
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                            child: UserAvatar(userID: user.uid, height: 50, width: 50,)),
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