import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/screens/forum/addEntryPage/provider/entryState.dart';
import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEntryButton extends StatelessWidget {
  final BoardCategory category;
  AddEntryButton(this.category);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(

      child: Icon(Icons.check),
      backgroundColor: Theme.of(context).buttonColor,
      onPressed: () async{
        final entryState = Provider.of<EntryState>(context, listen: false);
        final authentication = Provider.of<Authentication>(context, listen: false);
        FirebaseUser user = await authentication.getCurrentUser();
        final createdEntry = entryState.createBoardEntry(user.uid, category);
        final entryService = Provider.of<BoardEntryService>(context, listen: false);
        entryService.insertEntry(createdEntry);
        Navigator.pop(context);
      },
    );
  }
}
