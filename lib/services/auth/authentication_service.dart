import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

///Matthias Maxelon
enum AuthStatus{WAITING, NOT_LOGGED_IN, LOGGED_IN}

abstract class Auth {
  ///User login
  Future<String> userSignIn(String email, String password);
  ///creates user account in firebase
  Future<String> userSignUp(String email, String password);
  ///Get currently logged in user information
  Future<FirebaseUser> getCurrentUser();
  ///send password reset to users email
  Future<void> sendPasswordResetEmail(String email);

  Future<void> sendEmailVerification();
  ///force user to sign out
  Future<void> userSignOut();

  Future<bool> isEmailVerified();
}
class Authentication extends ChangeNotifier implements Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Future<String> userSignIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> userSignUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> userSignOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}