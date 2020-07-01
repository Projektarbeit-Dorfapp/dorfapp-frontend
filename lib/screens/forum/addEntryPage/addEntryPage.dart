import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/screens/forum/addEntryPage/provider/entryState.dart';
import 'package:dorf_app/screens/forum/addEntryPage/widgets/AddEntryButton.dart';
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
          title: const Text("Neues Thema"),
        ),
        floatingActionButton: Container(
          width: 80,
          height: 80,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10, right: 10),
            child: AddEntryButton(
                category),
          ),
        ),
        body: AddEntryTitleField(),
      ),
    );
  }
}
