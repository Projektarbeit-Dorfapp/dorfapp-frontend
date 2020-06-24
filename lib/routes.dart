
import 'package:dorf_app/basic_theme.dart';
import 'package:dorf_app/screens/calendar/calendar.dart';
import 'package:dorf_app/screens/forum/addEntryPage/addEntryPage.dart';
import 'package:dorf_app/screens/forum/boardEntryPage/boardEntryPage.dart';
import 'package:dorf_app/screens/forum/forum.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/login/passwordResetPage/passwordResetPage.dart';
import 'package:dorf_app/screens/login/registrationPage/registrationPage.dart';
import 'package:dorf_app/screens/login/rootPage/rootPage.dart';
import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class Application {

  final routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => RootPage(),
    //'/news': (BuildContext context) => new News(),
    '/calendar': (BuildContext context) => new Calendar(),
    '/forum': (BuildContext context) => new Forum(),
    '/registration': (BuildContext context) => RegistrationPage(),
    '/passwordReset': (BuildContext context) => PasswordResetPage(),
    '/rootPage': (BuildContext context) => RootPage(),
    '/boardEntryPage': (BuildContext context) => BoardEntryPage(),
    '/addEntryPage' : (BuildContext context) => AddEntryPage(),
  };

  void main() {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Authentication(),),
        ChangeNotifierProvider(create: (context) => UserService(),),
        ChangeNotifierProvider(create: (context) => AccessHandler(),),
        ChangeNotifierProvider(create: (context) => BoardEntryService(),),
      ],
      child: MaterialApp(
        theme: basicTheme,
        routes: routes,
      ),
    ));
  }
}