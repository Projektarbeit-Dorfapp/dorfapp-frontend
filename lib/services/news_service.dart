import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/news_model.dart';


class NewsService {
  CollectionReference _newsCollectionReference = Firestore.instance.collection("Veranstaltung");
  
   void insertNews(NewsModel news) async{
    DocumentReference ref = await _newsCollectionReference
        .add({
      'title': news.title,
      'description': news.description,
      'startTime': news.startDateTime,
      'endTime': news.endDateTime,
      'createdAt': DateTime.now(),
      'address': news.address,
    });
  }
}
