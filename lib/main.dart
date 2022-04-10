import 'package:eRoomApp/themes/custom_theme.dart';
//import 'package:eRoomApp/users.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:eRoomApp/pages/splash_page.dart';
import 'package:eRoomApp/stores/login_store.dart';
//import 'api/firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FirebaseApi.addRandomUsers(Users.initUsers);
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ScreenUtilInit(
        builder: () => MultiProvider(
          providers: [
            Provider<LoginStore>(
              create: (_) => LoginStore(),
            )
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: CustomTheme.lightTheme,
            home: SplashPage(),
          ),
        ),
        designSize: Size(constraints.maxWidth, constraints.maxHeight),
      );
    });
  }
}
