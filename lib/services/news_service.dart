import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/address_model.dart';
import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/models/user_model.dart';

//Kilian Berthold & Meike Nedwidek
class NewsService {
  CollectionReference _newsCollectionReference =
      Firestore.instance.collection('Veranstaltung');

  Future<NewsModel> getNews(String newsID) async {
    NewsModel newsModel;

    try {
     await _newsCollectionReference.document(newsID).get().then((dataSnapshot) {
          newsModel = new NewsModel(
              id: newsID,
              title: dataSnapshot.data['title'].toString(),
              description: dataSnapshot.data['description'].toString(),
              startTime: dataSnapshot.data['startTime'],
              endTime: dataSnapshot.data['endTime'],
              address: null,
              imagePath: dataSnapshot.data['imagePath'].toString(),
              likes: List(),
              comments: List(),
              //isNews: dataSnapshot.data['isNews'],
              isNews: false,
              createdAt: dataSnapshot.data['createdAt'],
              modifiedAt: dataSnapshot.data['modifiedAt']
          );
      });
    }
    catch (err) {
      print(err.toString());
    }

    return newsModel;

  }

  Address convertSnapshotToAddress(DocumentSnapshot ds) {
    Address address;
    if (ds.data['address'] != null) {
      address = Address(
          street: ds.data['address']['street'].toString(),
          houseNumber: ds.data['address']['houseNumber'].toString(),
          zipCode: ds.data['address']['zipCode'].toString(),
          district: ds.data['address']['district'].toString()
      );
    }
    return address;
  }
}