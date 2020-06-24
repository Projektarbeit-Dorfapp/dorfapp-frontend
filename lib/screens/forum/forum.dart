import 'package:dorf_app/screens/forum/boardCategoryPage/boardCategoryPage.dart';
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
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            children: <Widget>[
              SafeArea(
                child: TabBar(
                  tabs: <Widget>[
                    Tab(icon: Icon(Icons.chat)),
                    Tab(icon: Icon(Icons.notifications)),
                    Tab(icon: Icon(Icons.group)),
                    Tab(
                      icon: Icon(Icons.star),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            BoardCategoryPage(),
            Icon(Icons.notifications),
            Icon(Icons.group),
            Icon(Icons.star),
          ],
        ),
      ),
    );
  }
}
