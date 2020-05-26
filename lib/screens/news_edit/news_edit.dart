import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/services/news_service.dart';
import 'package:dorf_app/models/news_model.dart';

//Hannes Hauenstein

class NewsEdit extends StatefulWidget {
  @override
  _NewsEditState createState() => _NewsEditState();
}

class _NewsEditState extends State<NewsEdit> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _newsService = NewsService();

  NewsModel news = new NewsModel();

  File _image;
  DateTime selectedDate = DateTime.now();
  TimeOfDay time;
  TimeOfDay startTime;
  TimeOfDay endTime;
  DateTime startDate;
  DateTime endDate;

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
      body: StreamBuilder<Object>(
        stream: Firestore.instance.collection("Veranstaltung").snapshots(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
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
                            "Beginn Datum: ${selectedDate.day}, ${selectedDate.month}, ${selectedDate.year}"),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        onTap: () {
                          _pickDate(context);
                          startDate = selectedDate;
                        },
                      ),
                      ListTile(
                        title: Text(
                            "Beginn Uhrzeit:  ${time.hour}:${time.minute}"),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        onTap: () {
                          _pickTime(context);
                          startTime = time;
                        },
                      ),
                      ListTile(
                        title: Text(
                            "Ende Datum: ${selectedDate.day}, ${selectedDate.month}, ${selectedDate.year}"),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        onTap: () {
                          _pickDate(context);
                          endDate = selectedDate;
                        },
                      ),
                      ListTile(
                        title: Text(
                            "Ende Uhrzeit:  ${time.hour}:${time.minute}"),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        onTap: () {
                          _pickTime(context);
                          endTime = time;
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
                              news.title = _titleController.text;
                              news.description = _descriptionController.text;
                              news.startTime = new DateTime(startDate.year, selectedDate.month, selectedDate.day, time.hour, time.minute);
                              _newsService.insertNews(news);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
