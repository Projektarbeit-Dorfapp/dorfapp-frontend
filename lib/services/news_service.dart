import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/address_model.dart';
import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/screens/login/models/user_model.dart';

class NewsService {
  CollectionReference _newsCollectionReference =
      Firestore.instance.collection("Veranstaltung");

  void insertNews(NewsModel news) async {
    DocumentReference ref = await _newsCollectionReference.add({
      'title': news.title,
      'description': news.description,
      'startTime': news.startTime,
      'endTime': news.endTime,
      'createdAt': DateTime.now(),
      'address': {
        'street': news.address.street,
        'houseNumber': news.address.houseNumber,
        'district': news.address.district,
        'zipCode': news.address.zipCode,
      },
      'isNews': news.isNews,
      'imagePath': news.imagePath,
      'createdBy': news.createdBy
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
            imagePath: null,
            comments: List(),
            likes: List(),
            //isNews: dataSnapshot.data['isNews'],
            isNews: false,
            createdAt: dataSnapshot.data['createdAt'],
            modifiedAt: dataSnapshot.data['modifiedAt'],
            createdBy: dataSnapshot.data['createdBy']);
      });

      await _newsCollectionReference.document(newsID).collection("likes").getDocuments().then((dataSnapshot) {
        if (dataSnapshot.documents.length > 0)
          {
            var userlist = List<User>();
            for (var document in dataSnapshot.documents)
            {
              userlist.add(new User(
                uid: document.documentID,
                firstName: document.data['firstName'],
                lastName: document.data['lastName']
              ));
            }
            newsModel.likes = userlist;
          }
      });
    } catch (err) {
      print(err.toString());
    }

    return newsModel;
  }

  /*
  likes: List<User>.from(dataSnapshot.data['likes'].map((item) {
  return new User(
  uid: item["uid"],
  firstName: item["firstName"],
  lastName: item["lastName"]);
  })),
   */

  Future<List<NewsModel>> getAllNews() async {
    List<NewsModel> news = [];
    try {
      QuerySnapshot querySnapshot =
          await _newsCollectionReference.getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        NewsModel newsModel = new NewsModel(
            id: querySnapshot.documents[i].documentID,
            title: querySnapshot.documents[i].data['title'].toString(),
            description:
                querySnapshot.documents[i].data['description'].toString(),
            imagePath: querySnapshot.documents[i].data['imagePath'].toString(),
            isNews: false,
            createdAt: querySnapshot.documents[i].data['createdAt'],
            createdBy: querySnapshot.documents[i].data['createdBy']);
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

  List<User> convertLikeListToUserList(DocumentSnapshot ds) {
    List<User> userList = new List<User>();

    if (ds.data['likes'] != null) {}
  }
}
