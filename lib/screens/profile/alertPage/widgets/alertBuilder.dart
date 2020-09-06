import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/profile/alertPage/widgets/alertDisplay.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class AlertBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AlertService>(
      builder: (context, alertService, _) {
        return ListView.builder(
            itemCount: alertService.getAlerts().length,
            itemBuilder: (context, int index) {
              _checkReadState(index, alertService, context);
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async{
                  User u = await Provider.of<AccessHandler>(context, listen: false).getUser();
                  alertService.deleteAlert(u.uid, alertService.getAlerts()[index]);
                },
                background: Container(
                  color: Colors.redAccent,
                  child: Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.delete, color: Colors.white, size: 30,),
                    ),
                  ),),
                child: AlertDisplay(
                  builderIndex: index,
                  alertService: alertService,
                ),
              );
            });
      },
    );
  }

  _checkReadState(int index, AlertService alertService, BuildContext context){
    if(alertService.getAlerts()[index].isRead != true){
      _markReadingState(index, alertService, context);
    }
  }

  _markReadingState(int index, AlertService alertService, BuildContext context) async{
    String uid = await Provider.of<AccessHandler>(context, listen: false).getUID();
    alertService.markAsRead(uid, alertService.getAlerts()[index]);
  }
}
