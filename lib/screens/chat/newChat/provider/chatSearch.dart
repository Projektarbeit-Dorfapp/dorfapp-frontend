import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';

///Matthias Maxelon
class ChatSearch extends ChangeNotifier{
  List<User> _municipal;
  List<User> _searchedMunicipal;
  ChatSearch(List<User> municipal){
    _municipal = municipal;
    _searchedMunicipal = municipal; ///initial _searchedMunicipal is always = _municipal
  }

  List<User> getSearchedUsers() => _searchedMunicipal;
  get searchLength => _searchedMunicipal.length;

  ///searches for specific users and notify consumers
  search(String searchValue){

    _searchedMunicipal = [];
    for(var user in _municipal){
      String combinedName = user.firstName + " " + user.lastName;
      combinedName = combinedName.toLowerCase();
      if (combinedName.contains(searchValue.toLowerCase())){
        _searchedMunicipal.add(user);
      }
    }
    notifyListeners();
  }
  ///Clears search state and notifies consumers
  clear(){
    _searchedMunicipal = _municipal;
    notifyListeners();
  }
}