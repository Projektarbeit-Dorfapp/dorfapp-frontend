import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/screens/forum/addEntryPage/provider/entryState.dart';
import 'package:dorf_app/screens/forum/addEntryPage/widgets/AddEntryButton.dart';
import 'package:dorf_app/screens/forum/addEntryPage/widgets/AddEntryTitleField.dart';
import 'package:dorf_app/screens/forum/addEntryPage/widgets/addEntryDescriptionField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class AddEntryPage extends StatelessWidget {
  final BoardCategory category;
  final Color categoryColor;
  final GlobalKey<FormState> formKey;
  final ScrollController boardEntryScrollController;
  AddEntryPage({this.category, this.categoryColor, this.formKey, this.boardEntryScrollController});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.05;
    return ChangeNotifierProvider(
      create: (context) => EntryState(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: categoryColor,
          centerTitle: true,
          title: const Text("Neues Thema"),
        ),
        floatingActionButton: Container(
          width: 80,
          height: 80,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10, right: 10),
            child: AddEntryButton(category, categoryColor, formKey, boardEntryScrollController),
          ),
        ),
        body: Container(
          height: 225,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: formKey,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: width,
                  child: AddEntryTitleField(

                  ),
                ),
                Positioned(
                  top: 65,
                  left: width,
                  //width: MediaQuery.of(context).size.width,
                  child: AddEntryDescriptionField(

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
