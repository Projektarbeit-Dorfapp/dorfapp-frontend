import 'package:flutter/cupertino.dart';

class MessageQuantity extends ChangeNotifier{
  MessageQuantity(this._quantity);
  int _quantity;
  get quantity => _quantity;

  setQuantity(int quantity){
    _quantity = quantity;
    notifyListeners();
  }


}