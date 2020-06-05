import 'package:dorf_app/screens/calendar/calendar.dart';
import 'package:dorf_app/screens/forum/forum.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/login/passwordResetPage/passwordResetPage.dart';
import 'package:dorf_app/screens/login/registrationPage/registrationPage.dart';
import 'package:dorf_app/screens/login/rootPage/rootPage.dart';
import 'package:dorf_app/services/auth/authentification.dart';
import 'package:dorf_app/services/auth/userService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class Application {

  final routes = <String, WidgetBuilder> {
    '/': (BuildContext context) => RootPage(),
    //'/news': (BuildContext context) => new News(),
    '/calendar': (BuildContext context) => new Calendar(),
    '/forum': (BuildContext context) => new Forum(),
    '/registration' : (BuildContext context) => RegistrationPage(),
    '/passwordReset' : (BuildContext context) => PasswordResetPage(),
    '/rootPage' : (BuildContext context) => RootPage(),
  };

  void main() {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Authentication(),),
        ChangeNotifierProvider(create: (context) => UserService(),),
        ChangeNotifierProvider(create: (context) => AccessHandler(),),
      ],
      child: MaterialApp(
        routes: routes,
      ),
    ));
  }

}