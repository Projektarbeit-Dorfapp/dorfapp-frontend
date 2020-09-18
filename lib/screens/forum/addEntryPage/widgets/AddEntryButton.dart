import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/alert_model.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/forum/addEntryPage/provider/entryState.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class AddEntryButton extends StatelessWidget {
  final BoardCategory category;
  final Color categoryColor;
  final GlobalKey<FormState> formKey;
  final ScrollController boardEntryScrollController;
  AddEntryButton(this.category, this.categoryColor, this.formKey, this.boardEntryScrollController);

  @override
  Widget build(BuildContext context) {
    final bool showFAB = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return showFAB
        ? FloatingActionButton(
            child: const Icon(Icons.check),
            backgroundColor: categoryColor,
            onPressed: () async {
              if(formKey.currentState.validate()){
                final entryState = Provider.of<EntryState>(context, listen: false);
                final accessHandler = Provider.of<AccessHandler>(context, listen: false);
                User u = await accessHandler.getUser();
                final createdEntry = entryState.createBoardEntry(category, u, categoryColor);
                _insertionProcess(createdEntry, context);
                Navigator.pop(context);
              }
            },
          )
        : Container();
  }

  ///Inserts BoardEntry
  _insertionProcess(BoardEntry createdEntry, BuildContext context) async{
    final _entryService = BoardEntryService();
    DocumentReference docRef = await _entryService.insertEntry(createdEntry);
    _subscribe(docRef, context, createdEntry);
    _notifyMunicipal(context, docRef, createdEntry);
    boardEntryScrollController.animateTo(0.0, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  ///Subscribe to own content on insertion
  _subscribe(DocumentReference docRef, BuildContext context, BoardEntry createdEntry) async{
    final _subscriptionService = SubscriptionService();
    final _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    _subscriptionService.subscribe(
    subscriptionType: SubscriptionType.entry,
        loggedUser: await _accessHandler.getUser(),
        topLevelDocumentID: docRef.documentID,);

  }
  ///Notifies municipal that new entry was posted
  _notifyMunicipal(BuildContext context, DocumentReference documentReference, BoardEntry createdEntry) async{
    try{
      final alertS = Provider.of<AlertService>(context, listen: false);
      final userS = Provider.of<UserService>(context, listen: false);
      final accessH = Provider.of<AccessHandler>(context, listen: false);
      User loggedUser = await accessH.getUser();
      List<User> userList = await userS.getUsers(loggedUser);
      List<String> uidList = _convertUserToUID(userList);
      Alert alert = _createAlert(documentReference, createdEntry);
      alertS.insertAlerts(uidList, alert);

    }catch(e){
      print(e);
    }


  }

  List<String> _convertUserToUID(List<User> userList){
    List<String> uidList = [];
    for(var user in userList){
      uidList.add(user.uid);
    }
    return uidList;
  }

  Alert _createAlert(DocumentReference documentReference, BoardEntry createdEntry){
    return Alert(
      secondHeadline: createdEntry.boardCategoryTitle,
      alertColor: createdEntry.categoryColor,
      alertType: AlertType.entry,
      creationDate: Timestamp.now(),
      documentReference: documentReference.documentID,
      fromFirstName: createdEntry.firstName,
      fromLastName: createdEntry.lastName,
      fromUserName: createdEntry.userName,
      headline: createdEntry.title,
      additionalMessage: '${createdEntry.firstName}' + ' ${createdEntry.lastName} hat das Thema "${createdEntry.title}" in Kategorie "${createdEntry.boardCategoryTitle}" hinzugefügt',
    );
  }

}
