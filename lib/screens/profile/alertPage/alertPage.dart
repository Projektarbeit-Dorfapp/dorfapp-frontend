import 'package:dorf_app/screens/profile/alertPage/widgets/alertBuilder.dart';
import 'package:dorf_app/screens/profile/alertPage/widgets/deleteAlertsDialog.dart';
import 'package:flutter/material.dart';

///Matthias Maxelon
class AlertPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meine Benachrichtigungen"),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.delete, color: Colors.white,),
            onPressed: (){
              _showDeleteAllMessageDialog(context);
            },
          ),
        ],
      ),
      body: AlertBuilder(),
    );
  }
  _showDeleteAllMessageDialog(BuildContext context){
    showDialog(context: context,
    builder: (BuildContext context){
      return DeleteAlertsDialog();
    });
  }
}
