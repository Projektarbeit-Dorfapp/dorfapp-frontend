import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/address_model.dart';
import 'package:dorf_app/models/news_model.dart';


class NewsService {
  CollectionReference _newsCollectionReference = Firestore.instance.collection("Veranstaltung");
  
   void insertNews(NewsModel news) async {
     DocumentReference ref = await _newsCollectionReference
         .add({
       'title': news.title,
       'description': news.description,
       'startTime': news.startTime,
       'endTime': news.endTime,
       'createdAt': DateTime.now(),
       'address': news.address,
     });
   }


  Future<NewsModel> getNews(String newsID) async {
    NewsModel newsModel;

    try {
      await _newsCollectionReference
          .document(newsID)
          .get()
          .then((dataSnapshot) {
        newsModel = new NewsModel(
            id: newsID,
            title: dataSnapshot.data['title'].toString(),
            description: dataSnapshot.data['description'].toString(),
            startTime: dataSnapshot.data['startTime'],
            endTime: dataSnapshot.data['endTime'],
            address: convertSnapshotToAddress(dataSnapshot),
            imagePath: dataSnapshot.data['imagePath'].toString(),
            likes: List(),
            comments: List(),
            //isNews: dataSnapshot.data['isNews'],
            isNews: false,
            createdAt: dataSnapshot.data['createdAt'],
            modifiedAt: dataSnapshot.data['modifiedAt']);
      });
    } catch (err) {
      print(err.toString());
    }

    return newsModel;
  }

  Future<List<NewsModel>> getAllNews() async {
    List<NewsModel> news = [];
    try {
      QuerySnapshot querySnapshot =
          await _newsCollectionReference.getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        NewsModel newsModel = new NewsModel(
            id: querySnapshot.documents[i].documentID,
            title: querySnapshot.documents[i].data['title'].toString(),
            description: querySnapshot.documents[i].data['description'].toString(),
            imagePath: querySnapshot.documents[i].data['imagePath'].toString(),
            isNews: false,
            createdAt: querySnapshot.documents[i].data['createdAt']
            );
        news.add(newsModel);
      }
    } catch (error) {
      print(error.toString());
    }
    return news;
  }
  Address convertSnapshotToAddress(DocumentSnapshot ds) {
    Address address;
    if (ds.data['address'] != null) {
      address = Address(
          street: ds.data['address']['street'].toString(),
          houseNumber: ds.data['address']['houseNumber'].toString(),
          zipCode: ds.data['address']['zipCode'].toString(),
          district: ds.data['address']['district'].toString());
    }
    return address;
  }
}
