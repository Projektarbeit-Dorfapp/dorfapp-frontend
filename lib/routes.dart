import 'package:dorf_app/basic_theme.dart';
import 'package:dorf_app/screens/calendar/calendar.dart';
import 'package:dorf_app/screens/forum/addEntryPage/addEntryPage.dart';
import 'package:dorf_app/screens/forum/boardEntryPage/boardEntryPage.dart';
import 'package:dorf_app/screens/forum/forum.dart';
import 'package:dorf_app/screens/general/ProfilePage.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/login/passwordResetPage/passwordResetPage.dart';
import 'package:dorf_app/screens/login/registrationPage/registrationPage.dart';
import 'package:dorf_app/screens/login/rootPage/rootPage.dart';
import 'package:dorf_app/screens/profile/alertPage/alertPage.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';


class Application {

  final String SPLASH_SCREEN_PATH = 'assets/dorf_intro.flr';
//  'assets/dorf_intro.flr'
//  'assets/2019-11-01_SPECT8_Splash_Animation_2_sec.flr'

  final routes = <String, WidgetBuilder>{
//    '/': (BuildContext context) => RootPage(),
    //'/news': (BuildContext context) => new News(),
    '/calendar': (BuildContext context) => new Calendar(),
    '/forum': (BuildContext context) => new Forum(),
    '/registration': (BuildContext context) => RegistrationPage(),
    '/passwordReset': (BuildContext context) => PasswordResetPage(),
    '/rootPage': (BuildContext context) => RootPage(),
    '/boardEntryPage': (BuildContext context) => BoardEntryPage(),
    '/addEntryPage' : (BuildContext context) => AddEntryPage(),
    '/profile' : (BuildContext context) => Profile(),
    '/profile_edit' : (BuildContext context) => ProfileEdit(),
    '/alertPage' : (BuildContext context) => AlertPage(),
  };

  void main() {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Authentication(),),
        ChangeNotifierProvider(create: (context) => UserService(),),
        ChangeNotifierProvider(create: (context) => AccessHandler(),),
        ChangeNotifierProvider(create: (context) => AlertService(),),
      ],
      child: MaterialApp(
        theme: basicTheme,
        routes: routes,
        home: SplashScreen.navigate(
          name: SPLASH_SCREEN_PATH,
          until: () => Future.delayed(Duration(seconds: 1)),
          startAnimation: 'Animation',
          backgroundColor: Colors.white,
          next: (context) => RootPage(),

        ),
      ),
    ));
  }
}