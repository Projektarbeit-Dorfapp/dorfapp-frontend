import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/services/news_service.dart';
import 'package:dorf_app/models/news_model.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

//Hannes Hauenstein

class NewsEdit extends StatefulWidget {

  final String newsID;
  const NewsEdit([this.newsID]);

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
  final f = new DateFormat('dd.MM.yyyy HH:mm');
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now();

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
                        title: Text('Start: ' + f.format(startDateTime)),
                        onTap:  () {
                          DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2022, 6, 7), onChanged: (date) {
                            }, onConfirm: (date) {
                            setState(() {
                              startDateTime = date;
                            });
                            }, currentTime: DateTime.now(), locale: LocaleType.de);
                          },
                        trailing: Icon(Icons.keyboard_arrow_down),
                      ),
                      ListTile(
                        title: Text('Ende: ' +  f.format(endDateTime)),
                        onTap:  () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime(2022, 6, 7), onChanged: (date) {
                              }, onConfirm: (date) {
                                setState(() {
                                  endDateTime = date;
                                });
                              }, currentTime: DateTime.now(), locale: LocaleType.de);
                        },
                        trailing: Icon(Icons.keyboard_arrow_down),
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
                        _addNewsButton(widget.newsID),
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
  Future _pickImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
  }

  RaisedButton _addNewsButton(String newsID) {
    if (newsID != null){
      return RaisedButton(
        child: Text('Aktualisieren'),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            news.title = _titleController.text;
            news.description = _descriptionController.text;
            news.startTime = Timestamp.fromDate(startDateTime);
            news.endTime = Timestamp.fromDate(endDateTime);
            _newsService.insertNews(news);
          }
        },
      );
    }
    else {
      return RaisedButton(
        child: Text('Erstellen'),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            news.title = _titleController.text;
            news.description = _descriptionController.text;
            news.startTime = Timestamp.fromDate(startDateTime);
            news.endTime = Timestamp.fromDate(endDateTime);
            _newsService.insertNews(news);
          }
        },
      );
    }
  }
}
