import 'package:animations/animations.dart';
import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:dorf_app/screens/calendar/calendar.dart';
import 'package:dorf_app/screens/chat/chatsPage/chatsPage.dart';
import 'package:dorf_app/screens/forum/forum.dart';
import 'package:dorf_app/screens/general/alertQuantityDisplay.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/news/news.dart';
import 'package:dorf_app/screens/profile/alertPage/alertPage.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final int _pageIndex;
  final double safeAreaHight;
  Home(this._pageIndex, {this.safeAreaHight});

  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    Calendar(),
    NewsOverview(),
    Forum(),
    Chats(),
    AlertPage(),
  ];
  @override
  void initState() {
    _children[1] = NewsOverview(safeAreaHight: widget.safeAreaHight,);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
        Widget child, Animation<double> animation, Animation<double> secondaryAnimation
        ){
          return FadeThroughTransition(
            animation: animation,
              secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _children[
          _currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black54,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Calendar')
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text('News'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('Forum')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chat'),
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 26,
              height: 26,
              child: Stack(
                children: [
                  Icon(
                      Icons.notifications),
                  Align(
                    alignment: Alignment.topRight,
                    child: Consumer<AlertService>(
                      builder: (context, alertS, _){
                        return AlertQuantityDisplay(
                          showIcon: false,
                          iconSize: 13,
                          iconColor: Colors.white,
                          width: 14,
                          height: 14,
                          color: Theme.of(context).buttonColor,
                          borderRadius: 50,
                          textColor: Colors.white,);
                      },
                    ),
                  ),
                ],

              ),
            ),
            title: Text("Alarme"),
          )
        ],
      ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}