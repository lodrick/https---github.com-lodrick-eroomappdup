import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdvertField {
  static final String updatedAt = 'updatedAt';
}

class Advert {
  final String? id;
  String? roomType;
  double? price;
  String? title;
  String? decription;
  String? province;
  String? city;
  String? suburb;
  final String? userId;
  final String? email;
  final createdAt;
  final updatedAt;
  String? status;
  final int? likes;
  final dynamic photosUrl;

  Advert({
    this.id,
    this.roomType,
    this.price,
    this.title,
    this.decription,
    this.province,
    this.city,
    this.suburb,
    this.userId,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.photosUrl,
    this.likes,
  });

  Advert copyWith({
    String? id,
    String? roomType,
    double? price,
    String? title,
    String? decription,
    String? province,
    String? city,
    String? suburb,
    String? userId,
    String? email,
    String? createdAt,
    String? updatedAt,
    String? status,
    int? likes,
    dynamic photosUrl,
  }) =>
      Advert(
        id: id ?? this.id,
        roomType: roomType ?? this.roomType,
        price: price ?? this.price,
        title: title ?? this.title,
        decription: decription ?? this.decription,
        province: province ?? this.province,
        city: city ?? this.city,
        suburb: suburb ?? this.suburb,
        userId: userId ?? this.userId,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        likes: likes ?? this.likes,
        photosUrl: photosUrl ?? this.photosUrl,
      );

  static Advert fromJson(Map<String, dynamic> json) => Advert(
        id: json['id'],
        roomType: json['roomType'],
        price: json['price'],
        title: json['title'],
        decription: json['description'],
        city: json['city'],
        suburb: json['suburb'],
        userId: json['userId'],
        email: json['email'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        status: json['status'],
        photosUrl: json['photosUrl'],
        likes: json['likes'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'roomType': roomType,
        'price': price,
        'title': title,
        'description': decription,
        'province': province,
        'city': city,
        'suburb': suburb,
        'userId': userId,
        'email': email,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'status': status,
        'photosUrl': photosUrl,
        'likes': likes,
      };

  static Map<String, dynamic> adPhotos(
      {required String photoUrl, required String id}) {
    return {
      'photosUrl': FieldValue.arrayUnion([
        {
          'photoUrl': photoUrl,
        }
      ]),
      'id': id
    };
  }

  static Map<String, dynamic> updateLikes(
      {@required String? adId, @required int? like}) {
    return {
      'likes': like,
    };
  }
}
