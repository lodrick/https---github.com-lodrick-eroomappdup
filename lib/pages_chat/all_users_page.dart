import 'package:eRoomApp/api/firebase_api.dart';
import 'package:eRoomApp/constants.dart';
import 'package:eRoomApp/models/user_model.dart';
import 'package:eRoomApp/shared/sharedPreferences.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets_chat/chat_body_wiget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllUsersChat extends StatefulWidget {
  final String contactNumber;
  final String currentIdUser;
  AllUsersChat({
    required this.contactNumber,
    required this.currentIdUser,
    Key? key,
  }) : super(key: key);
  @override
  _AllUsersChatState createState() => _AllUsersChatState();
}

class _AllUsersChatState extends State<AllUsersChat> {
  String? contactNumber;
  @override
  void initState() {
    super.initState();
    SharedPrefs.getContactNumber().then((res) {
      setState(() {
        contactNumber = res;
      });
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white70),
        title: Text(
          'Select Contact',
          style: TextStyle(
            fontSize: 22.0.sp,
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          Icon(Icons.search),
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.selectContactCoices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(
                      color: MyColors.primaryColor,
                    ),
                  ),
                );
              }).toList();
            },
            elevation: 0.0,
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0.r),
              topRight: Radius.circular(20.0.r),
            ),
          ),
          child: StreamBuilder<List<User>>(
            stream: FirebaseApi.getUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return buildText('Something Went Wrong Try again later, ' +
                        snapshot.error.toString());
                  } else {
                    var users = snapshot.data;
                    for (int index = 0; index < users!.length; index++) {
                      if (users[index].contactNumber == widget.contactNumber) {
                        users.removeAt(index);
                      }
                    }
                    if (users.isEmpty) {
                      return buildText('No Users Found');
                    } else {
                      return Column(
                        children: <Widget>[
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
      ),
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );

  void choiceAction(String choice) {
    if (choice == Constants.PROFILE) {
      print('Settings');
    } else if (choice == Constants.SIGNOUT) {
      print('Sign Out');
    }
  }
}
