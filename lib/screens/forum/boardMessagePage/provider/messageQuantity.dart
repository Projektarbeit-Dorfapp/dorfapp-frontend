import 'package:flutter/cupertino.dart';

///Matthias Maxelon
class MessageQuantity extends ChangeNotifier{
  MessageQuantity(this._quantity);
  int _quantity;
  String _sortMode;
  get quantity => _quantity;
  get sortMode => _sortMode;

  setQuantity(int quantity){
    _quantity = quantity;
    notifyListeners();
  }

  setSortMode(String sortMode) {
    _sortMode = sortMode;
    notifyListeners();
  }


}