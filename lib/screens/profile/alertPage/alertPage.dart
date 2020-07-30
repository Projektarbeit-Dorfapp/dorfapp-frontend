import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/profile/alertPage/widgets/alertBuilder.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class AlertPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meine Benachrichtigungen"),
        actions: <Widget>[
          PopupMenuButton<String>(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            onSelected: (value) => _choiceAction(value, context),
            color: Colors.white,
            itemBuilder: (BuildContext context) {
              return MenuButtons.AlertPagePopUpMenu.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: AlertBuilder(),
    );
  }

  _choiceAction(String choice, BuildContext context) {
    if (choice == MenuButtons.DELETE_ALERTS) {
      _cancelAlertsEvent(context);
    }
  }

  _cancelAlertsEvent(BuildContext context) async {
    String uid = await Provider.of<AccessHandler>(context, listen: false).getUID();
    Provider.of<AlertService>(context, listen: false).deleteAllAlerts(uid);
  }
}
