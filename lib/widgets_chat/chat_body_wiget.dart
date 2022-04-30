import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:eRoomApp/models/user_model.dart';
import 'package:eRoomApp/pages_chat/chat_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBodyWidget extends StatefulWidget {
  final List<User> users;
  final String contactNumber;
  final String currentIdUser;

  const ChatBodyWidget({
    required this.users,
    required this.contactNumber,
    required this.currentIdUser,
    Key? key,
  }) : super(key: key);

  @override
  _ChatBodyWidgetState createState() => _ChatBodyWidgetState();
}

class _ChatBodyWidgetState extends State<ChatBodyWidget> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.r),
              topRight: Radius.circular(25.r),
            ),
          ),
          child: buildChats(),
        ),
      );

  Widget buildChats() => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final user = widget.users[index];

          String names = '${user.name} ${user.surname}';
          if (widget.currentIdUser == user.idUser) {
            return SizedBox.shrink();
          } else {
            return Container(
              height: 75.0.h,
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatPage(
                      user: user,
                      contactNumber: widget.contactNumber,
                      currentIdUser: widget.currentIdUser,
                    ),
                  ));
                },
                leading: CircleAvatar(
                  radius: 25.r,
                  backgroundImage: NetworkImage(user.imageUrl),
                ),
                title: Text(names),
              ),
            );
          }
        },
        itemCount: widget.users.length,
      );
  void registerNotification() {
    //firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;

      var messageVar = message as Map<String, dynamic>;
      Platform.isAndroid
          ? showNotification(messageVar['notification'])
          : showNotification(messageVar['aps']['alert']);
    });

    /*firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });*/

    firebaseMessaging.getToken().then((token) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentIdUser)
          .update({'token': token});
    }).catchError((err) {
      print('Error: ' + err.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('launch_background');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? '' : '',
      'Eroom chat',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    print(message);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }
}
