import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:dorf_app/screens/calendar/calendar.dart';
import 'package:dorf_app/screens/forum/forum.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/news/news.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final int _pageIndex;
  Home(this._pageIndex);

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
  ];
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xFF6178a3),
        actions: <Widget>[
          PopupMenuButton<String> (
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
              onSelected: (value) => _choiceAction(value, context),
              color: Colors.white,
              itemBuilder: (BuildContext context) {
                return MenuButtons.HomePopUpMenu.map((String choice) {
                  return PopupMenuItem<String> (
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
        ],
        title: Text('Dorf App'),
        centerTitle: true,
      ),


      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
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
              icon: Icon(Icons.person),
              title: Text('Forum')
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

  void _choiceAction(String choice, BuildContext context) {
    if(choice == MenuButtons.LOGOUT){
      final accessHandler =
      Provider.of<AccessHandler>(context, listen: false);
      accessHandler.logout();
    }
  }
}