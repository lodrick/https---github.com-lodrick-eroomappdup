import 'dart:io';

import 'package:eRoomApp/shared/sharedPreferences.dart';
import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:eRoomApp/api/firebase_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewMessageWidget extends StatefulWidget {
  final String idUser;
  final String contactNumber;
  final String currentUserId;

  const NewMessageWidget({
    required this.idUser,
    required this.contactNumber,
    required this.currentUserId,
    Key? key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';
  String groupChatId = '';
  String currentUserId = '';
  String peerId = '';
  File? imageFile;

  void getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;
    currentUserId = widget.currentUserId;
    peerId = widget.idUser;

    if (widget.currentUserId.hashCode <= widget.idUser.hashCode) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }

    // ignore: deprecated_member_use
    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        FirebaseApi.uploadFile(
          groupChatId: groupChatId,
          imageFile: imageFile,
          currentUserId: currentUserId,
          peerId: peerId,
          type: 1,
        );
      }
    }
  }

  void sendMessage() async {
    currentUserId = widget.currentUserId;
    peerId = widget.idUser;

    if (widget.currentUserId.hashCode <= widget.idUser.hashCode) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
    FocusScope.of(context).unfocus();
    FirebaseApi.uploadMessage(
      content: message,
      currentUserId: widget.currentUserId,
      peerId: widget.idUser,
      groupChatId: groupChatId,
      type: 0,
    );

    FirebaseApi.retriveUser(widget.contactNumber).then((userResult) {
      SharedPrefs.saveIdUser('${userResult!.idUser}');
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: MyColors.primaryColor.withOpacity(.2)),
          color: Colors.white,
        ),
        //color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 8.w,
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo),
              iconSize: 25.sp,
              color: MyColors.primaryColor,
              onPressed: getImage,
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                minLines: 3,
                maxLines: 10,
                enableSuggestions: true,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message...',
                ),
                onChanged: (value) => setState(() {
                  message = value;
                }),
              ),
            ),
            SizedBox(width: 20.w),
            GestureDetector(
              onTap: message.trim().isEmpty ? null : sendMessage,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: MyColors.primaryColor.withOpacity(.15),
                  ),
                ),
                child: Transform.rotate(
                  angle: -45,
                  child: Icon(
                    Icons.send_outlined,
                    color: MyColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
