import 'package:eRoomApp/stores/login_store.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/loader_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomDialogBox extends StatelessWidget {
  final String? title, descriptions, text;
  final String? imgUrl;

  const CustomDialogBox({
    Key? key,
    this.title,
    this.descriptions,
    this.text,
    this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isLoginLoading,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ConstantVal.padding),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: contentBox(context, loginStore),
            ),
          ),
        );
      },
    );
  }

  contentBox(context, loginStore) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: ConstantVal.padding.w,
            top: ConstantVal.avatarRadius + ConstantVal.padding.h,
            right: ConstantVal.padding.w,
            bottom: ConstantVal.padding.h,
          ),
          margin: EdgeInsets.only(top: ConstantVal.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(ConstantVal.padding.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 5.0),
                  blurRadius: 6.0.r,
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$title',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                '$descriptions',
                style: TextStyle(fontSize: 14.sp, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 22.h),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 18.sp, color: MyColors.primaryColor),
                      ),
                    ),
                    SizedBox(width: 10.0.w),
                    // ignore: deprecated_member_use
                    FlatButton(
                      color: MyColors.primaryColor,
                      onPressed: () {
                        loginStore.signOut(context);
                      },
                      child: Text(
                        'Yes'.toUpperCase(),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: ConstantVal.padding.w,
          right: ConstantVal.padding.w,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 50.r,
            child: CircleAvatar(
              backgroundColor: MyColors.primaryColor,
              radius: 50.0.r,
              backgroundImage: NetworkImage(
                imgUrl ??
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/President_Barack_Obama.jpg/480px-President_Barack_Obama.jpg',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ConstantVal {
  ConstantVal._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
