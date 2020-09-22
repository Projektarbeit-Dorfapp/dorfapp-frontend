import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:dorf_app/models/address_model.dart';
import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/models/topComment_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/material.dart';

import 'comment_service.dart';

  //Hannes Hauenstein,

class NewsService {
  CollectionReference _newsCollectionReference = Firestore.instance.collection("Veranstaltung");
  final CommentService _commentService = CommentService();

  void insertNews(News news) async {
    await _newsCollectionReference.add({
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

  Future<void> updateNews(News news) async{
    await _newsCollectionReference.document(news.id).updateData({
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
    }
    );
  }

  Future<News> getNews(String newsID) async {
    News newsModel;

    try {
      await _newsCollectionReference.document(newsID).get().then((dataSnapshot) {
        newsModel = new News(
            id: newsID,
            title: dataSnapshot.data['title'].toString(),
            description: dataSnapshot.data['description'].toString(),
            startTime: dataSnapshot.data['startTime'],
            endTime: dataSnapshot.data['endTime'],
            address: convertSnapshotToAddress(dataSnapshot),
            imagePath: dataSnapshot.data['imagePath'],
            comments: List(),
            likes: List(),
            isNews: dataSnapshot.data['isNews'],
            createdAt: dataSnapshot.data['createdAt'],
            modifiedAt: dataSnapshot.data['modifiedAt'],
            createdBy: dataSnapshot.data['createdBy']);
      });

      await _newsCollectionReference.document(newsID).collection("Likes").getDocuments().then((dataSnapshot) {
        if (dataSnapshot.documents.length > 0) {
          var userList = List<User>();
          for (var document in dataSnapshot.documents) {
            userList.add(new User(
                uid: document.documentID, firstName: document.data['firstName'], lastName: document.data['lastName']));
          }
          newsModel.likes = userList;
        }
      });

      await _newsCollectionReference
          .document(newsID)
          .collection("Gepinnt")
          .getDocuments()
          .then((dataSnapshot) {
        if (dataSnapshot.documents.length > 0) {
          var pinnedList = List<User>();
          for (var document in dataSnapshot.documents) {
            pinnedList.add(new User(uid: document.documentID));
          }
          newsModel.bookmarks = pinnedList;
        }
      });

      await _newsCollectionReference.document(newsID).collection("Kommentare").getDocuments().then((dataSnapshot) {
        if (dataSnapshot.documents.length > 0) {
          var commentList = List<TopComment>();
          for (var document in dataSnapshot.documents) {
            commentList.add(new TopComment(
              new Comment(
                id: document.documentID,
                content: document.data["content"],
                createdAt: document.data["createdAt"],
                modifiedAt: document.data["modifiedAt"],
                isDeleted: document.data["isDeleted"],
                user: new User(
                    uid: document.data["userID"],
                    firstName: document.data["firstName"],
                    lastName: document.data["lastName"])), []));
          }
          newsModel.comments = commentList;
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

  Future<List<News>> getAllNews(String sortMode, String searchTerm) async {
    List<News> news = [];
    try {
      QuerySnapshot querySnapshot;
      switch (sortMode) {
        case MenuButtons.SORT_ASCENDING:
          {
            querySnapshot = await _newsCollectionReference.orderBy("startTime", descending: false).getDocuments();
          }
          break;
        case MenuButtons.SORT_DESCENDING:
          {
            querySnapshot = await _newsCollectionReference.orderBy("startTime", descending: true).getDocuments();
          }
          break;
        default:
          {
            querySnapshot = await _newsCollectionReference.getDocuments();
          }
      }

      for (var document in querySnapshot.documents) {
        if (searchTerm != null) {
          var lowerString = document.data['title'].toString().toLowerCase();
          if (!lowerString.contains(searchTerm)) {
              continue;
          }
        }
        News newsModel = new News(
            id: document.documentID,
            title: document.data['title'].toString(),
            description: document.data['description'].toString(),
            startTime: document.data['startTime'],
            endTime: document.data['endTime'],
            imagePath: document.data['imagePath'].toString(),
            isNews: false,
            createdAt: document.data['createdAt'],
            createdBy: document.data['createdBy']);

        ///Problem: Da die Likes in Subcollections gespeichert sind, muss für jeden Eintrag einzeln via await ausgelsen werden, ob er Likes besitzt. --> Langsam!
        ///Falls wir das beschleunigen wollen, müsste man die Anzahl der Likes im Veranstaltungs-Dokument selbst speichern, aber das darf man dann auch jedesmal mit updaten wenn ein Like gegeben/genommen wird
        /*if (sortMode == MenuButtons.SORT_TOP) {
          await _newsCollectionReference
              .document(document.documentID)
              .collection("Likes")
              .getDocuments()
              .then((dataSnapshot) {
            if (dataSnapshot.documents.length > 0) {
              var userList = List<User>();
              for (var document in dataSnapshot.documents) {
                userList.add(new User(
                    uid: document.documentID,
                    firstName: document.data['firstName'],
                    lastName: document.data['lastName']));
              }
              newsModel.likes = userList;
            } else {
              newsModel.likes = List<User>();
            }
          });
        }*/
        news.add(newsModel);
      }
    } catch (error) {
      print(error.toString());
    }
    if (sortMode == MenuButtons.SORT_TOP && news.length > 0) {
      ///Ascending: (a,b). Descending: (b,a).
      news.sort((a, b) => b.likes.length.compareTo(a.likes.length));
    }
    return news;
  }

  Future<List<News>>getPinnedNews(AsyncSnapshot<List<DocumentSnapshot>> snapshot) async {
    List<News> pinnedNews = [];
    try {
      for(DocumentSnapshot doc in snapshot.data){
        pinnedNews.add(await getNews(doc.data["DocumentReference"]));
      }
    } catch (error) {
      print(error.toString());
    }
    return pinnedNews;
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
