import 'package:dorf_app/screens/general/alertQuantityDisplay.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class MyAlerts extends StatefulWidget {
  @override
  _MyAlertsState createState() => _MyAlertsState();
}

class _MyAlertsState extends State<MyAlerts> {

  @override
  Widget build(BuildContext context) {
   final minPadding = MediaQuery.of(context).size.width * 0.1;
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, "/alertPage");
      },
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Icon(Icons.notifications, color: Theme.of(context).buttonColor,
            ),
          ),
          Text("Meine Benachrichtigungen",
            style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 16
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: minPadding * 1, right: minPadding),
            child: Consumer<AlertService>(
              builder: (context, alertService, _){
                return AlertQuantityDisplay(
                  height: 35,
                  width: 35,
                  color: Theme.of(context).buttonColor,
                  textColor: Colors.white,
                  borderRadius: 50,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
