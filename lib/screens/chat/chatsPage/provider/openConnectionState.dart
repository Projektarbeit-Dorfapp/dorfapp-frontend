import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:flutter/cupertino.dart';
///Matthias Maxelon
class OpenConnectionState extends ChangeNotifier{

  List<OpenChat> _openConnections;

  setOpenConnections(List<OpenChat> openConnections){
    _openConnections = openConnections;
  }
  List<OpenChat> getOpenConnections() => _openConnections;

}
