import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/forum/addEntryPage/provider/entryState.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEntryButton extends StatelessWidget {
  final BoardCategory category;
  final Color categoryColor;
  final GlobalKey<FormState> formKey;
  AddEntryButton(this.category, this.categoryColor, this.formKey);

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

}
