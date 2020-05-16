import 'dart:io';

import 'package:dorf_app/basic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewsEdit extends StatefulWidget {
  @override
  _NewsEditState createState() => _NewsEditState();
}

class _NewsEditState extends State<NewsEdit> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File _image;
  DateTime selectedDate = DateTime.now();
  TimeOfDay time;

  Future _pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<Null> _pickDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  _pickTime(BuildContext context) async {
    final TimeOfDay t = await showTimePicker(
      initialTime: time,
      context: context,
    );
    if (t != null)
      setState(() {
        time = t;
      });
  }

  @override
  void initState() {
    super.initState();
    time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit News'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              child: _image == null
                  ? Center(
                      child: RaisedButton(
                        child: Text('Select an Image ',
                            style: Theme.of(context).textTheme.headline2),
                        onPressed: () {
                          _pickImage();
                        },
                      ),
                    )
                  : Center(
                      child: Image.file(_image, fit: BoxFit.cover),
                    ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                        "Date: ${selectedDate.year}, ${selectedDate.month}, ${selectedDate.day}"),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: () {
                      _pickDate(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                        "Time:  ${time.hour}:${time.minute}"),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: () {
                      _pickTime(context);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                          hintText: 'Titel eingeben', labelText: 'Titel'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Bitte einen Titel eingeben';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'Beschreibung eingeben',
                          labelText: 'Beschreibung'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Beschreibung eingeben';
                        }
                        return null;
                      },
                    ),
                    RaisedButton(
                      child: Text('Erstellen'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          print("Working");
                        }
                        print('Titel: ' +
                            _titleController.text +
                            ' Beschreibung: ' +
                            _descriptionController.text);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
