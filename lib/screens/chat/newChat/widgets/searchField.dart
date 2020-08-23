import 'package:dorf_app/screens/chat/newChat/provider/chatSearch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchField extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final chatSearch = Provider.of<ChatSearch>(context, listen: false);
    return TextField(
      onChanged: (textValue){
        _onChanged(context, textValue, chatSearch);
      },
      autofocus: true,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        ),
        hintText: "Suchen...",

        hintStyle: TextStyle(
          color: Colors.black
        ),
      ),
      style: TextStyle(
        color: Colors.black
      ),
    );
  }
  _onChanged(BuildContext context, String inputValue, ChatSearch chatSearch){
    chatSearch.search(inputValue);
  }
}
