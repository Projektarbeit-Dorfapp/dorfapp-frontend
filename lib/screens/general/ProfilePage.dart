import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userReference = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
        child: Text(userReference),
      ),
    );
  }
}
