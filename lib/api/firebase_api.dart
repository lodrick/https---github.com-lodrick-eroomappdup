import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eRoomApp/models_chat/message.dart';
import 'package:eRoomApp/models/user_model.dart';
import 'package:eRoomApp/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseApi {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Stream<List<User>> getUsers() {
    Stream<QuerySnapshot<Object?>> querySnapshot = FirebaseFirestore.instance
        .collection('users')
        .orderBy(UserField.lastMessageTime, descending: true)
        .snapshots();

    return querySnapshot.map((document) {
      return document.docs.map((e) {
        return User.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
    //.transform(Utils.transformer(User.fromJson));
  }

  static Future uploadMessage({
    String? groupChatId,
    String? content,
    String? currentUserId,
    String? peerId,
    int? type,
  }) async {
    if (content?.trim() != '') {
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId!)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(documentReference, {
          'idFrom': currentUserId,
          'idTo': peerId,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'message': content,
          'type': type
        });
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'chattingWith': peerId, 'lastMessageTime': DateTime.now()});
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: MyColors.primaryColor,
          textColor: Colors.red);
    }
  }

  static uploadFile({
    String? currentUserId,
    String? peerId,
    String? groupChatId,
    File? imageFile,
    int? type,
  }) async {
    String imageUrl;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile!);

    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();

      uploadMessage(
        currentUserId: currentUserId,
        peerId: peerId,
        groupChatId: groupChatId,
        content: imageUrl,
        type: type,
      );
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  static Stream<List<Message>> getMessages(String groupChatId) {
    Stream<QuerySnapshot<Object?>> querySnapshot = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: true)
        .snapshots();
    //.transform(Utils.transformer(Message.fromJson));
    return querySnapshot.map((document) {
      return document.docs.map((e) {
        return Message.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  static Future addRandomUsers(List<User> users) async {
    final refUsers = FirebaseFirestore.instance.collection('users');

    final allUsers = await refUsers.get();
    print(allUsers.docs);
    if (allUsers.size != 0) {
      return;
    } else {
      for (final user in users) {
        final userDoc = refUsers.doc();
        final newUser = user.copyWith(idUser: userDoc.id);

        await userDoc.set(newUser.toJson());
      }
    }
  }

  static Future addRandomUser(User user) async {
    final refUser = FirebaseFirestore.instance.collection('users');

    final user1 = await refUser.get();
    if (user1.size != 0)
      return;
    else {
      final userDoc = refUser.doc();
      final newUser = user.copyWith(idUser: userDoc.id);

      await userDoc.set(newUser.toJson());
    }
  }

  static Future<User?> addUser(User user) async {
    FirebaseFirestore.instance.collection('users').add({
      'idUser': user.idUser,
      'name': user.name,
      'surname': user.surname,
      'email': user.email,
      'password': user.password,
      'country': user.country,
      'contactNumber': user.contactNumber,
      'userType': user.userType,
      'imageUrl': user.imageUrl,
      'lastMessageTime': user.lastMessageTime,
      'token': user.token,
    }).then((result) {
      FirebaseFirestore.instance.collection('users').doc(result.id).update({
        'idUser': result.id,
      }).then((res) {
        print('Success');
        firebaseMessaging.getToken().then((token) {
          FirebaseFirestore.instance.collection('users').doc(result.id).update({
            'token': token,
          });
        }).catchError((err) {
          print('Error: ' + err.toString());
        });
      });
    });
    return retriveUser(user.contactNumber);
  }

  static Future<User?> retriveUser(String contactNumber) async {
    QueryDocumentSnapshot? documentSnapshot;
    var result = await FirebaseFirestore.instance
        .collection('users')
        .where('contactNumber', isEqualTo: contactNumber)
        .get();

    result.docs.forEach((res) {
      documentSnapshot = res;
    });

    if (documentSnapshot == null) {
      return null;
    }
    return User.fromJson(documentSnapshot!.data() as Map<String, dynamic>);
  }

  static Future<User?> retriveUserByID(String? idUser) async {
    QueryDocumentSnapshot? documentSnapshot;
    var result = await FirebaseFirestore.instance
        .collection('users')
        .where('idUser', isEqualTo: idUser)
        .get();

    result.docs.forEach((res) {
      documentSnapshot = res;
    });

    if (documentSnapshot == null) {
      return null;
    }
    return User.fromJson(documentSnapshot!.data() as Map<String, dynamic>);
  }

  static Future<User?> updateUser(User userToupdate, idUser) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(idUser)
        .update({
          'name': userToupdate.name,
          'surname': userToupdate.surname,
          'email': userToupdate.email,
          'contactNumber': userToupdate.contactNumber,
          'imageUrl': userToupdate.imageUrl,
          'lastMessageTime': userToupdate.lastMessageTime,
        })
        .then((value) => print('user updated:'))
        .catchError((error) => print('Failed to update user: $error'));
    return retriveUser(userToupdate.contactNumber);
  }

  static Future<void> updateUserByField({
    String? field,
    String? value,
    String? idUser,
  }) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(idUser)
        .update({field!: value})
        .then((value) => print('user updated'))
        .catchError((error) => print('Failed to update $error'));
  }

  static Future uploadImageUrl(String imageUrl, idUser) {
    var user = FirebaseFirestore.instance.collection('users');
    return user
        .doc(idUser)
        .update({'imageUrl': imageUrl})
        .then((value) => print('ImageUrl updated'))
        .catchError((error) => print('Failed to update user imageUrl $error'));
  }
}
