import 'package:eRoomApp/app_launcher_utils.dart';
import 'package:eRoomApp/shared/sharedPreferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:eRoomApp/stores/login_store.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/loader_hud.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  String phoneNumber = '';
  bool _checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isLoginLoading,
            child: Scaffold(
              backgroundColor: Colors.white,
              key: loginStore.loginScaffoldKey,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height.h,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 20.h),
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                        height: 240.h,
                                        constraints: BoxConstraints(
                                          maxWidth: 500.w,
                                        ),
                                        margin: EdgeInsets.only(
                                          top: 100.h,
                                        ),
                                        decoration: BoxDecoration(
                                          //color: Color(0xFFE1E0F5),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30.r),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxHeight: 300.h,
                                        ),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 8.0.w,
                                          vertical: 5.0.h,
                                        ),
                                        child: Image.asset(
                                            'assets/img/eroom_logo.jpeg'),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 400.w,
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                ),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: 'We will send you an ',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'One Time Password ',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'on this mobile number',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              Container(
                                height: 40.h,
                                constraints: BoxConstraints(
                                  maxWidth: 400.w,
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                child: CupertinoTextField(
                                  enableInteractiveSelection: true,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4.r),
                                    ),
                                  ),
                                  controller: phoneController,
                                  clearButtonMode:
                                      OverlayVisibilityMode.editing,
                                  keyboardType: TextInputType.phone,
                                  maxLines: 1,
                                  placeholder: '076...',
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                constraints: BoxConstraints(
                                  maxWidth: 500.w,
                                ),
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  onPressed: _checkBoxValue
                                      ? () {
                                          if (phoneController.text.isNotEmpty) {
                                            if (phoneController.text
                                                .startsWith('+27')) {
                                              phoneNumber = phoneController.text
                                                  .toString();
                                            } else if (phoneController.text
                                                .startsWith('0')) {
                                              phoneNumber = phoneController.text
                                                  .replaceFirst('0', '+27');
                                              print(phoneNumber);
                                            } else {
                                              loginStore.loginScaffoldKey
                                                  .currentState!
                                                  // ignore: deprecated_member_use
                                                  .showSnackBar(
                                                SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor: Colors.black
                                                      .withOpacity(0.8),
                                                  content: Text(
                                                    'Please enter a correct phone number formart',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }

                                            loginStore.getCodeWithPhoneNumber(
                                                context, phoneNumber);
                                            SharedPrefs.saveContactNumber(
                                                phoneNumber);
                                          } else {
                                            loginStore
                                                .loginScaffoldKey.currentState!
                                                // ignore: deprecated_member_use
                                                .showSnackBar(SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.8),
                                              content: Text(
                                                'Please enter a phone number',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ));
                                          }
                                        }
                                      : null,
                                  color: MyColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14.r),
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                      horizontal: 8.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Next',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.r),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.r),
                                            ),
                                            color: MyColors.primaryColorLight,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 16.sp,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                height: MediaQuery.of(context).size.height * .06,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Checkbox(
                        value: _checkBoxValue,
                        onChanged: (onChanged) {
                          setState(() {
                            _checkBoxValue = onChanged!;
                          });
                        }),
                    SizedBox(width: 10.w),
                    Column(
                      //alignment: WrapAlignment.center,
                      children: <Widget>[
                        Text(
                          'By signing in to eRoom you agree to our',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: MyColors.lightTextColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => AppLauncherUtils.openLink(
                              url: 'https://kwepilecorp.wordpress.com/'),
                          child: Text(
                            'terms and conditions',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: MyColors.purpleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
