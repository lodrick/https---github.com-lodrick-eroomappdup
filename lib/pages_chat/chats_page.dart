import 'package:eRoomApp/constants.dart';
import 'package:eRoomApp/pages/profile_page_user_detail_save.dart';
import 'package:eRoomApp/pages_chat/all_users_page.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/dialog_box_exit_app.dart';
import 'package:flutter/material.dart';
import 'package:eRoomApp/models/user_model.dart';
import 'package:eRoomApp/api/firebase_api.dart';
import 'package:eRoomApp/widgets_chat/chat_body_wiget.dart';
import 'package:eRoomApp/widgets_chat/chat_header_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatsPage extends StatefulWidget {
  final String contactNumber;
  final String currentIdUser;
  final String currentImageUrl;
  ChatsPage({
    required this.contactNumber,
    required this.currentIdUser,
    required this.currentImageUrl,
    Key? key,
  }) : super(key: key);
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: MyColors.primaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white70),
          backgroundColor: MyColors.primaryColor,
          elevation: 0.0,
          title: Text(
            'Chats',
            style: TextStyle(
              fontSize: 22.0.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          actions: <Widget>[
            Container(
              child: PopupMenuButton(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                onSelected: (value) {
                  switch (value) {
                    case IconsMenu.PROFILE:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePageUserDetailSave(
                            imageUrl: widget.currentImageUrl,
                            currentIdUser: widget.currentIdUser,
                          ),
                        ),
                      );
                      break;
                    default:
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialogBox(
                          title: 'Exit App',
                          descriptions:
                              'Are you sure you want to exit the app?',
                          text: 'bluh bluh',
                          imgUrl: widget.currentImageUrl != null
                              ? widget.currentImageUrl
                              : 'assets/img/black-house-01.jpeg',
                        ),
                      );
                      break;
                  }
                },
                itemBuilder: (context) => IconsMenu.items
                    .map((item) => PopupMenuItem<IconMenu>(
                          value: item,
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  item.iconData,
                                  size: 25.0.sp,
                                  color: MyColors.sidebar,
                                ),
                                title: Text(
                                  item.text,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: MyColors.sidebar,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Divider(
                                color: MyColors.primaryColorLight,
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: StreamBuilder<List<User>>(
            stream: FirebaseApi.getUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return buildText('Something Went Wrong Try later, ' +
                        snapshot.error.toString());
                  } else {
                    final users = snapshot.data;

                    if (users!.isEmpty) {
                      return buildText('No Users Found.');
                    } else {
                      return Column(
                        children: [
                          ChatHeaderWidget(
                            users: users,
                            contactNumber: widget.contactNumber,
                            currentIdUser: widget.currentIdUser,
                          ),
                          ChatBodyWidget(
                            users: users,
                            contactNumber: widget.contactNumber,
                            currentIdUser: widget.currentIdUser,
                          ),
                        ],
                      );
                    }
                  }
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllUsersChat(
                  contactNumber: widget.contactNumber,
                  currentIdUser: widget.currentIdUser,
                ),
              ),
            );
          },
          child: Icon(
            Icons.chat,
            color: Colors.white,
          ),
          backgroundColor: MyColors.primaryColor,
        ),
        primary: true,
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );

  void choiceAction(String choice) {
    if (choice == Constants.PROFILE) {
      print('Profile');
    } else if (choice == Constants.SIGNOUT) {
      print('Sign Out');
    }
  }
}
