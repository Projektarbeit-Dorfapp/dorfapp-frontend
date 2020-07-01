import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/screens/forum/addEntryPage/provider/entryState.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEntryButton extends StatelessWidget {
  final BoardCategory category;
  AddEntryButton(this.category);
  @override
  Widget build(BuildContext context) {
    final bool showFAB = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return showFAB
        ? FloatingActionButton(
            child: const Icon(Icons.check),
            backgroundColor: Theme.of(context).buttonColor,
            onPressed: () async {
              final entryState = Provider.of<EntryState>(context, listen: false);
              final authentication = Provider.of<Authentication>(context, listen: false);
              final userService = Provider.of<UserService>(context, listen: false);

              FirebaseUser user = await authentication.getCurrentUser();
              User u = await userService.getUser(user.uid);
              final createdEntry = entryState.createBoardEntry(user.uid, category, u);
              final entryService = Provider.of<BoardEntryService>(context, listen: false);
              entryService.insertEntry(createdEntry);
              Navigator.pop(context);
            },
          )
        : Container();
  }
}
