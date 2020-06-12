import 'package:dorf_app/screens/forum/addEntryPage/provider/entryState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEntryTitleField extends StatefulWidget {
  @override
  _AddEntryTitleFieldState createState() => _AddEntryTitleFieldState();
}

class _AddEntryTitleFieldState extends State<AddEntryTitleField> {
  @override
  Widget build(BuildContext context) {
    final entryState = Provider.of<EntryState>(context, listen: false);
    return TextFormField(
      onChanged: (value){
        entryState.title = value;
      },
      decoration: InputDecoration(
          labelText: "Titel"
      ),
    );
  }
}
