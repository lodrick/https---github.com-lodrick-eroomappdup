import 'package:eRoomApp/pages/main_posts_page.dart';
import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogBoxPost extends StatelessWidget {
  final String title;
  final String descrition;
  final String firstName;
  final String lastName;
  final String contactNumber;
  final String email;
  final String idUser;
  final bool isContinue;

  DialogBoxPost({
    required this.title,
    required this.descrition,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.email,
    required this.idUser,
    required this.isContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor.withAlpha(3).withOpacity(.2),
      body: Container(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: dialogContent(context),
        ),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          margin: EdgeInsets.only(top: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(17.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 16.0),
              Text(descrition, style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(width: 8.0),
                    // ignore: deprecated_member_use
                    FlatButton(
                      splashColor: Colors.blueGrey,
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: isContinue
                          ? Text(
                              'Continue Posting'.toUpperCase(),
                              style: TextStyle(
                                color: MyColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    SizedBox(width: 3.0.w),
                    // ignore: deprecated_member_use
                    FlatButton(
                      splashColor: Colors.blueGrey,
                      color: MyColors.primaryColor,
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => MainPostsPage(
                              firstName: firstName,
                              lastName: lastName,
                              contactNumber: contactNumber,
                              email: email,
                              idUser: idUser,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(
                        'Done'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
