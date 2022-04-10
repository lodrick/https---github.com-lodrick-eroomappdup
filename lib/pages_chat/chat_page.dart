import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';
import 'package:eRoomApp/models/user_model.dart';
import 'package:eRoomApp/widgets_chat/messages_widget.dart';
import 'package:eRoomApp/widgets_chat/new_message_widget.dart';
import 'package:eRoomApp/widgets_chat/profile_header_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatPage extends StatefulWidget {
  final User user;
  final String contactNumber;
  final String currentIdUser;

  const ChatPage({
    required this.user,
    required this.contactNumber,
    required this.currentIdUser,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: MyColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeaderWidget(
                imageUri: '${widget.user.imageUrl}',
                name: '${widget.user.name} ${widget.user.surname}'),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.r),
                    topRight: Radius.circular(25.r),
                  ),
                ),
                child: MessagesWidget(
                  peerAvatar: '${widget.user.imageUrl}',
                  peerId: '${widget.user.idUser}',
                  currentUserId: widget.currentIdUser,
                ),
              ),
            ),
            NewMessageWidget(
              currentUserId: widget.currentIdUser,
              idUser: '${widget.user.idUser}',
              contactNumber: widget.contactNumber,
            ),
          ],
        ),
      ),
    );
  }
}
