import 'package:eRoomApp/api/firebase_api.dart';
import 'package:eRoomApp/pages/main_posts_page.dart';
import 'package:eRoomApp/shared/sharedPreferences.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eRoomApp/pages/login_page.dart';
import 'package:eRoomApp/stores/login_store.dart';
import 'package:eRoomApp/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<LoginStore>(context, listen: false)
        .isAlreadyAuthenticated()
        .then((result) {
      if (result) {
        currentUser();
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (Route<dynamic> route) => false);
      }
    });
  }

  void currentUser() {
    SharedPrefs.getContactNumber().then((cNumber) {
      if (cNumber.isNotEmpty) {
        FirebaseApi.retriveUser(cNumber).then((result) {
          if (result != null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => MainPostsPage(
                    firstName: '${result.name}',
                    lastName: '${result.surname}',
                    email: '${result.email}',
                    contactNumber: '${result.contactNumber}',
                    idUser: '${result.idUser}',
                  ),
                ),
                (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => LoginPage(),
                ),
                (Route<dynamic> route) => false);
          }
        }).catchError((e) {
          print(e.toString());
        });
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
    );
  }
}
