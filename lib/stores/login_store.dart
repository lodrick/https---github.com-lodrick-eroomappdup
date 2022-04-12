import 'package:eRoomApp/api/firebase_api.dart';
import 'package:eRoomApp/pages/main_posts_page.dart';
import 'package:eRoomApp/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:eRoomApp/pages/login_page.dart';
import 'package:eRoomApp/pages/otp_page.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String actualCode = "";

  @observable
  bool isLoginLoading = false;
  @observable
  bool isOtpLoading = false;

  @observable
  GlobalKey<ScaffoldState> loginScaffoldKey = GlobalKey<ScaffoldState>();
  @observable
  GlobalKey<ScaffoldState> otpScaffoldKey = GlobalKey<ScaffoldState>();

  @observable
  late User firebaseUser;

  @action
  Future<bool> isAlreadyAuthenticated() async {
    //firebaseUser = _auth.currentUser!;
    if (_auth.currentUser != null) {
      firebaseUser = _auth.currentUser!;
      return true;
    }
    return false;
    /*if (firebaseUser != null) {
      return true;
    } else {
      return false;
    }*/
  }

  @action
  Future<void> getCodeWithPhoneNumber(
      BuildContext context, String phoneNumber) async {
    isLoginLoading = true;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential auth) async {
        await _auth.signInWithCredential(auth).then(
          (UserCredential value) {
            if (value.user != null) {
              print('Authentication successful');
              onAuthenticationSuccessful(context: context, result: value);
            } else {
              // ignore: deprecated_member_use
              loginScaffoldKey.currentState!.showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(
                    'Invalid code/invalid authentication',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          },
        ).catchError(
          (error) {
            // ignore: deprecated_member_use
            loginScaffoldKey.currentState!.showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.deepOrange[400],
                content: Text(
                  'Something has gone wrong, please try later.',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      },
      verificationFailed: (FirebaseAuthException authException) {
        print('Error message: ' + authException.message!);
        // ignore: deprecated_member_use
        loginScaffoldKey.currentState!.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.deepOrange[400],
            content: Text(
              'The phone number format is incorrect. Please enter your number in E.164 format. [+][country code][number]',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
        isLoginLoading = false;
      },
      codeSent: (String verificationId, [int? forceResendingToken]) async {
        actualCode = verificationId;
        isLoginLoading = false;
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const OtpPage()));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        actualCode = verificationId;
      },
    );
  }

  @action
  Future<void> validateOtpAndLogin(BuildContext context, String smsCode) async {
    isOtpLoading = true;

    final AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: actualCode, smsCode: smsCode);

    await _auth.signInWithCredential(_authCredential).catchError((error) {
      isOtpLoading = false;
      isLoginLoading = false;
      // ignore: deprecated_member_use
      otpScaffoldKey.currentState!.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.deepOrange[400],
          content: Text(
            'Wrong code ! Please enter the last code received.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }).then(
      (UserCredential authResult) {
        if (authResult.user != null) {
          print('Authentication successful');

          onAuthenticationSuccessful(context: context, result: authResult);
        } else {}
      },
    );
  }

  Future<void> onAuthenticationSuccessful(
      {BuildContext? context, UserCredential? result}) async {
    isLoginLoading = true;
    isOtpLoading = true;
    firebaseUser = result!.user!;

    if (firebaseUser.phoneNumber != null ||
        firebaseUser.phoneNumber!.isNotEmpty) {
      FirebaseApi.retriveUser(firebaseUser.phoneNumber!).then((user) {
        print(user);
        if (user != null) {
          Navigator.of(context!).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => MainPostsPage(
                  firstName: user.name,
                  lastName: user.surname,
                  email: user.email,
                  idUser: user.idUser!,
                  contactNumber: user.contactNumber,
                ),
              ),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context!).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) =>
                    RegisterPage(phoneNumber: firebaseUser.phoneNumber!),
              ),
              (Route<dynamic> route) => false);
        }
      }).catchError((e) {
        print(e.toString());
      });
    }

    isLoginLoading = false;
    isOtpLoading = false;
  }

  @action
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (Route<dynamic> route) => false);
    //firebaseUser = null;
  }
}
