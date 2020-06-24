import 'package:dorf_app/screens/forum/boardMessagePage/provider/boardMessageHandler.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/widgets/sendBoardMessageButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardMessageTextField extends StatefulWidget {
  @override
  _BoardMessageTextFieldState createState() => _BoardMessageTextFieldState();
}

class _BoardMessageTextFieldState extends State<BoardMessageTextField> {
  TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0.1,
                blurRadius: 4,
                offset: Offset(0, -1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Icon(
                  Icons.insert_emoticon,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.82,
                child: Consumer<BoardMessageHandler>(
                  builder: (context, messageHandler,_){
                    _controller.text = messageHandler.currentMessage;
                    return TextFormField(
                      controller: _controller,
                      onChanged: (textValue) {
                        messageHandler.setMessage(textValue);
                      },
                      style: TextStyle(
                        fontFamily: "Raleway",
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Schreib was"),
                    );
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: SendBoardMessageButton()),
            ],
          )),
    );
  }
}
