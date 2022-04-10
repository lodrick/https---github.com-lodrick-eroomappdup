import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:provider/provider.dart';
import 'package:eRoomApp/stores/login_store.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/loader_hud.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({
    Key? key,
  }) : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String text = '';

  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40.h,
        width: 40.w,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0),
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
        ),
        child: Center(
          child: Text(
            text[position],
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
    } catch (e) {
      return Container(
        height: 40.h,
        width: 40.w,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0),
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isOtpLoading,
            child: Scaffold(
              backgroundColor: Colors.white,
              key: loginStore.otpScaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                  icon: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.r),
                      ),
                      color: MyColors.primaryColorLight.withAlpha(20),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: MyColors.primaryColor,
                      size: 16.sp,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                // ignore: deprecated_member_use
                brightness: Brightness.light,
              ),
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 40.h,
                                ),
                                child: Wrap(
                                  children: [
                                    Text(
                                      'Enter 6 digits verification code sent to your number',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 500.0.w,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    otpNumberWidget(0),
                                    otpNumberWidget(1),
                                    otpNumberWidget(2),
                                    otpNumberWidget(3),
                                    otpNumberWidget(4),
                                    otpNumberWidget(5),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                            ),
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              onPressed: () {
                                loginStore.validateOtpAndLogin(context, text);
                              },
                              color: MyColors.primaryColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(14),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Confirm',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(
                                        8.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                            20,
                                          ),
                                        ),
                                        color: MyColors.primaryColorLight,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          NumericKeyboard(
                            onKeyboardTap: _onKeyboardTap,
                            textColor: MyColors.primaryColorLight,
                            rightIcon: Icon(
                              Icons.backspace,
                              color: MyColors.primaryColorLight,
                            ),
                            rightButtonFn: () {
                              setState(() {
                                text = text.substring(0, text.length - 1);
                              });
                            },
                          )
                        ],
                      ),
                    )
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
