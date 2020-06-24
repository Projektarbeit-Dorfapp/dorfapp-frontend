import 'package:dorf_app/models/boardCategory_model.dart';
import 'file:///C:/Users/R4pture/AndroidStudioProjects/dorfapp-frontend/lib/screens/forum/addEntryPage/widgets/AddEntryButton.dart';
import 'package:dorf_app/screens/forum/addEntryPage/provider/entryState.dart';
import 'package:dorf_app/screens/forum/addEntryPage/widgets/AddEntryTitleField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEntryPage extends StatelessWidget {
  final BoardCategory category;
  AddEntryPage({this.category});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EntryState(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Neues Thema"),
        ),
        floatingActionButton: AddEntryButton(category),
        body: AddEntryTitleField(),
      ),
    );
  }
}
