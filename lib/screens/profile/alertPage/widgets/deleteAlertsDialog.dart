import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAlertsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Alle Benachrichtigungen löschen?"),
      actions: <Widget>[
        FlatButton(
          child: Text("Ja", style: TextStyle(color: Theme.of(context).buttonColor),),
          onPressed: (){
            _cancelAlertsEvent(context);
          },
        ),
        FlatButton(
          child: Text("Nein", style: TextStyle(color: Theme.of(context).buttonColor),),
          onPressed: (){
            _dismiss(context);
          },
        ),
      ],
    );
  }
  _cancelAlertsEvent(BuildContext context) async {
    String uid = await Provider.of<AccessHandler>(context, listen: false).getUID();
    Provider.of<AlertService>(context, listen: false).deleteAllAlerts(uid);
    Navigator.pop(context);
  }
  _dismiss(context){
    Navigator.pop(context);
  }
}
