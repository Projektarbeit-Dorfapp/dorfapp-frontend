import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

///Matthias Maxelon
class MessageQuantity extends ChangeNotifier{
  MessageQuantity(this._quantity);
  int _quantity;

  get quantity => _quantity;

  increment(){
    _quantity++;
    notifyListeners();
  }
}