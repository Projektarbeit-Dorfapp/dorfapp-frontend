import 'package:dorf_app/models/address_model.dart';
import 'package:flutter/cupertino.dart';

class NewsModel{

  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final String startDate;
  final String endDate;
  final Address address;
  final String imagePath;

  NewsModel(this.title, this.description, this.startTime, this.endTime, this.startDate, this.endDate, this.address, this.imagePath);

}