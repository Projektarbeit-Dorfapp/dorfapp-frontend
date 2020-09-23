import 'package:dorf_app/models/alert_model.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/boardMessagePage.dart';
import 'package:dorf_app/screens/news/news_detail.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import 'package:flutter/material.dart';

///Matthias Maxelon
class AlertDisplay extends StatelessWidget {
  final int builderIndex;
  final AlertService alertService;
  AlertDisplay({@required this.builderIndex, @required this.alertService});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        _navigate(context);
      },
      child: ListTile(
        leading: _getLeadingIcon(context),
        title: Text(alertService.getAlerts()[builderIndex].additionalMessage),
        subtitle: RelativeDate(alertService.getAlerts()[builderIndex].creationDate.toDate(), Colors.grey, 16),
      ),
    );
  }

  ///depending on AlertType -> Navigate to a specific page
  _navigate(BuildContext context) async{
    if(alertService.getAlerts()[builderIndex].alertType == AlertType.boardMessage || alertService.getAlerts()[builderIndex].alertType == AlertType.entry){
      Alert alert = alertService.getAlerts()[builderIndex];
      Navigator.push(context, MaterialPageRoute(builder: (context) => BoardMessagePage(
        entryDocumentID: alert.documentReference, boardCategoryColor: alert.alertColor, boardCategoryHeadline: alert.secondHeadline,)));
      BoardEntryService().incrementWatchCount(alert.documentReference);
    }
    if(alertService.getAlerts()[builderIndex].alertType == AlertType.news) {
      Alert alert = alertService.getAlerts()[builderIndex];
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetail(alert.documentReference)));
    }
  }
  
  Icon _getLeadingIcon(BuildContext context){
    final alertType = alertService.getAlerts()[builderIndex].alertType;
    Icon icon;
    Color color = Theme.of(context).buttonColor;
    switch(alertType){
      case AlertType.boardMessage:
        icon = Icon(Icons.message, color: color);
        break;
      case AlertType.pin_notification:
        icon = Icon(Icons.bookmark_border, color: color,);
        break;
      case AlertType.news:
        icon = Icon(Icons.event, color: color,);
        break;
      case AlertType.entry:
        icon = Icon(Icons.forum, color: color,);
        break;
      default:
        icon = Icon(Icons.notification_important, color: color,);
        break;
    }
    return icon;
  }
}
