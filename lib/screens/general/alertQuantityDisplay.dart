import 'package:dorf_app/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
///
/// Displays a number that indicates how many unread alerts the currently logged user has
///
class AlertQuantityDisplay extends StatefulWidget {
  final double borderRadius;
  final double height;
  final double width;
  final Color color;
  final Color textColor;
  final bool showIcon;
  final double iconSize;
  final Color iconColor;
  AlertQuantityDisplay({this.borderRadius, this.height, this.width, this.color, this.textColor, this.showIcon, this.iconSize, this.iconColor});
  @override
  _AlertQuantityDisplayState createState() => _AlertQuantityDisplayState();
}

class _AlertQuantityDisplayState extends State<AlertQuantityDisplay> {

  AlertService _alertService;
  int _unreadAlerts;
  @override
  void initState() {
    _alertService = Provider.of<AlertService>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _unreadAlerts = _getUnreadAlerts();
    return _unreadAlerts != 0 ? Container(
      width: widget.height != null ? widget.width : 50,
      height: widget.height != null ? widget.height : 50,
      decoration: BoxDecoration(
        color: widget.color != null ? widget.color : Colors.white,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Center(
        child: widget.showIcon == false || widget.showIcon == null ? Text(_unreadAlerts.toString(),
        style: TextStyle(
          color: widget.textColor != null ? widget.textColor : Colors.black,
          fontSize: 17,
        ),
        ) : Icon(Icons.notification_important,
          color: widget.iconColor != null ? widget.iconColor : Colors.black,
          size: widget.iconSize != null ? widget.iconSize : 20,)
      ),
    ) : Container();
  }
  int _getUnreadAlerts(){
    int quantity = 0;
    for(var alert in _alertService.getAlerts()){
      if(alert.isRead != true){
        quantity++;
      }
    }
    return quantity;
  }
}
