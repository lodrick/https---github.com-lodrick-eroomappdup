import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/models/advert_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class FireBusinessApi {
  static Stream<List<Advert>> getAdverts() {
    Stream<QuerySnapshot<Object?>> querySnapshot = FirebaseFirestore.instance
        .collection('adverts')
        .orderBy(AdvertField.updatedAt, descending: true)
        .snapshots();
    //.transform(Utils.transformer(Advert.fromJson));
    return querySnapshot.map((document) {
      return document.docs.map((e) {
        return Advert.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  static Stream<List<Advert>> getFavouriteAdvert(String idUser, bool liked) {
    Stream<QuerySnapshot<Object?>> querySnapshot = FirebaseFirestore.instance
        .collection('adverts')
        .orderBy(AdvertField.updatedAt, descending: true)
        .where('userId', isEqualTo: idUser)
        .where('liked', isEqualTo: true)
        .snapshots();
    //.transform(Utils.transformer(Advert.fromJson));
    return querySnapshot.map((document) {
      return document.docs.map((e) {
        return Advert.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  static Stream<List<Advert>> getMyAdverts(String idUser) {
    Stream<QuerySnapshot<Object?>> querySnapshot = FirebaseFirestore.instance
        .collection('adverts')
        //.orderBy(AdvertField.updatedAt, descending: true)
        .where('userId', isEqualTo: idUser)
        .snapshots();
    //.transform(Utils.transformer(Advert.fromJson));
    return querySnapshot.map((document) {
      return document.docs.map((e) {
        return Advert.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  static Stream<List<Advert>> getSearchResultAdvert(
      double minprice, double maxPrice, String suburb, String city) {
    Stream<QuerySnapshot<Object?>> querySnapshot = FirebaseFirestore.instance
        .collection('adverts')
        .where('price', isGreaterThan: minprice)
        .where('price', isLessThan: maxPrice)
        .where('suburb', isEqualTo: suburb)
        .where('status', isEqualTo: 'approved')
        .where('city', isEqualTo: city)
        .snapshots();
    //.transform(Utils.transformer(Advert.fromJson));
    return querySnapshot.map((document) {
      return document.docs.map((e) {
        return Advert.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  static Future addAdvert(Advert advert, List<File> files) async {
    FirebaseFirestore.instance.collection('adverts').add({
      'id': advert.id,
      'roomType': advert.roomType,
      'price': advert.price,
      'title': advert.title,
      'description': advert.decription,
      'province': advert.province,
      'city': advert.city,
      'suburb': advert.suburb,
      'userId': advert.userId,
      'email': advert.email,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'status': advert.status,
      'likes': 0
    }).then((advertRuslt) {
      List<String> urlImages = [];

      for (File file in files) {
        getAdvertImageUrl(file: file, userId: advert.userId!).then((path) {
          print(path);
          urlImages.add(path);
          FirebaseFirestore.instance
              .collection('adverts')
              .doc(advertRuslt.id)
              .update(Advert.adPhotos(id: advertRuslt.id, photoUrl: path))
              .then((res) {})
              .catchError((e) {
            print(e.toString());
          });
        }).catchError((e) {
          print(e.toString());
        });
      }
    });
  }

  static Future<void> updateAdvert(Advert advert, adId) async {
    FirebaseFirestore.instance.collection('adverts').doc(adId).update({
      //'id': advert.id,
      'roomType': advert.roomType,
      'price': advert.price,
      'title': advert.title,
      'description': advert.decription,
      'province': advert.province,
      'city': advert.city,
      'suburb': advert.suburb,
      'userId': advert.userId,
      'createdAt': advert.createdAt,
      'updatedAt': DateTime.now(),
      'status': advert.status,
    });
  }

  static Future addAdvertImage(AdvertImage advertImage) async {
    FirebaseFirestore.instance.collection('advertImages').add({
      'advertId': advertImage.advertId,
      'imageUrl': advertImage.imageUrl,
    }).then((result) {
      FirebaseFirestore.instance
          .collection('advertImages')
          .doc(result.id)
          .update({
        'imageId': result.id,
      }).then((res) {
        print('Success');
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  static Future<String> getAdvertImageUrl(
      {required File file, required String userId}) async {
    String fileName = Path.basename(file.path);
    var downLoadUrl;

    Uint8List fileByte = file.readAsBytesSync();
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('advertImages/$userId/$fileName')
        .putData(fileByte);
    downLoadUrl = await snapshot.ref.getDownloadURL();

    return downLoadUrl;
  }

  static Stream<List<AdvertImage>> retrieveAdvertImages(String advertId) {
    Stream<QuerySnapshot<Object?>> querySnapshot = FirebaseFirestore.instance
        .collection('advertImages')
        .orderBy(AdvertImageField.createdAt, descending: true)
        .where('advertId', isEqualTo: advertId)
        .snapshots();
    //.transform(Utils.transformer(AdvertImage.fromJson));
    return querySnapshot.map((document) {
      return document.docs.map((e) {
        return AdvertImage.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  static Future<void> updateLikes(String? adId, int like) async {
    FirebaseFirestore.instance
        .collection('adverts')
        .doc(adId)
        .update(Advert.updateLikes(adId: adId, like: like))
        .then((value) => print('you like this post'))
        .catchError((onError) => print(onError.toString()));
  }

  static Stream<List<Advert>> getFavAdverts(List<String> advertsIds) async* {
    List<Advert> adverts = [];
    QueryDocumentSnapshot? documentSnapshot;

    for (String advertsId in advertsIds) {
      var result = await FirebaseFirestore.instance
          .collection('adverts')
          .where('id', isEqualTo: advertsId)
          .get();
      result.docs.forEach((res) {
        documentSnapshot = res;
      });

      if (documentSnapshot != null) {
        adverts.add(
            Advert.fromJson(documentSnapshot!.data() as Map<String, dynamic>));
      }
    }

    yield adverts;
  }
}
//com.kwepilecorp.eRoomApp
