import 'package:dorf_app/screens/forum/boardCategoryPage/boardCategoryPage.dart';
import 'package:dorf_app/screens/forum/municipalPage/municipalPage.dart';
import 'package:dorf_app/screens/forum/pinsPage/pinsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xfff0f0f0),
        appBar: AppBar(
          backgroundColor: Color(0xfff0f0f0),
          elevation: 0,
          flexibleSpace: TabBar(
            indicatorColor: Theme.of(context).buttonColor,
            labelColor: Theme.of(context).buttonColor,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.chat,),text: "Themen", iconMargin: EdgeInsets.only(bottom: 1),),
              Tab(icon: Icon(Icons.group,),text: "Gemeinde", iconMargin: EdgeInsets.only(bottom: 1),),
              Tab(icon: Icon(Icons.star,),text: "Gepinnt", iconMargin: EdgeInsets.only(bottom: 1),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            BoardCategoryPage(),
            MunicipalPage(),
            PinsPage(),
          ],
        ),
      ),
    );
  }
}
