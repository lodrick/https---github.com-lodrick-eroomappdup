import 'package:eRoomApp/app_launcher_utils.dart';
import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ContactUs extends StatelessWidget {
  static Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: EdgeInsets.only(top: 8.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white70),
        title: Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 20.0.sp,
            color: Colors.white70,
          ),
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0.r),
                    topRight: Radius.circular(30.0.r),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListView(
                    children: [
                      Container(
                        height: 240.0.h,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(30.0.r),
                            topRight: Radius.circular(30.0.r),
                          ),
                          image: new DecorationImage(
                            image: new AssetImage('assets/img/living_room.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      titleSection,
                      buttonSection,
                      textSection,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Container(
          width: 600.0.w,
          child: Text(
            'Copyright 2021, All Rights Reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
            softWrap: true,
          ),
        ),
        GestureDetector(
          onTap: () => AppLauncherUtils.openLink(url: 'https://flutter.dev/'),
          child: Container(
            width: 600.0.w,
            child: Text(
              'Powered by ReaCode',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueAccent[900],
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget titleSection = Container(
    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 8.0.h),
                child: Text(
                  'eRoom for the win',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ),
              Text(
                'Johannesburg, South Africa',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget buttonSection = Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => AppLauncherUtils.openPhoneCall(
            phoneNumber: '+27692309961',
          ),
          child: _buildButtonColumn(
            MyColors.primaryColor,
            Icons.call,
            'CALL',
          ),
        ),
        GestureDetector(
          onTap: () => AppLauncherUtils.openWhatsApp(
            phoneNumber: '+27692309961',
            message: 'The room is available.',
          ),
          child: _buildButtonColumn(
            MyColors.primaryColor,
            Icons.near_me,
            'WHATSAPP',
          ),
        ),
        GestureDetector(
          onTap: () => AppLauncherUtils.openEmail(
            toEmail: 'eroom-us@kwepillecorp.com',
            subject: 'Subject',
            body: 'Hi how are you.',
          ),
          child: _buildButtonColumn(
            MyColors.primaryColor,
            Icons.email,
            'EMAIL',
          ),
        ),
      ],
    ),
  );

  Widget textSection = Container(
    padding: EdgeInsets.symmetric(
      horizontal: 30.w,
      vertical: 30.h,
    ),
    child: Text(
      'Its a great platform that connects the property owners who have  '
      'available rooms or cottages for rental. '
      'Its a platform that showcases rooms and cottages for people to rent. '
      'If you are renting out rooms or cottages or you are simply looking for a '
      'room or cottage to rent you have made an incredible choice by '
      'downloading this App. The Simplicity of finding everything suitable to '
      'your needs right at your fingertips, worry not, you have found what you '
      'are looking for. Welcome to eRoom',
      softWrap: true,
    ),
  );
}
