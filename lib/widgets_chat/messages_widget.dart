import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets_chat/message_widget.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessagesWidget extends StatefulWidget {
  final String peerId;
  final String currentUserId;
  final String peerAvatar;

  const MessagesWidget({
    required this.peerAvatar,
    required this.peerId,
    required this.currentUserId,
    Key? key,
  }) : super(key: key);

  @override
  _MessagesWidgetState createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ScrollController listScrollController = ScrollController();

  bool isLoading = false;
  List<QueryDocumentSnapshot> listMessage = new List.from([]);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = '';
    String peerId = '';
    String groupChatId = '';
    currentUserId = widget.currentUserId;
    peerId = widget.peerId;

    if (widget.currentUserId.hashCode <= widget.peerId.hashCode) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
    return groupChatId.isNotEmpty
        ? StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .doc(groupChatId)
                .collection(groupChatId)
                .orderBy('timestamp', descending: true)
                .limit(200)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return buildText('Something Went Wrong Try later, ' +
                        snapshot.error.toString());
                  } else {
                    listMessage.addAll(snapshot.data!.docs);
                    final messages = snapshot.data;
                    print(messages!.size);

                    return messages.size < 1
                        ? buildText('Type a message...')
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            reverse: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return MessageWidget(
                                peerAvatar: widget.peerAvatar,
                                currentUserId: widget.currentUserId,
                                document: snapshot.data!.docs[index],
                                index: index,
                              );
                            },
                          );
                  }
              }
            },
          )
        : Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
            ),
          );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24.sp,
            color: Colors.black.withOpacity(.6),
          ),
        ),
      );

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {}
  }
}
