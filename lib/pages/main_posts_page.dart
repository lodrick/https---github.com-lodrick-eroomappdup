import 'package:eRoomApp/api/business_api.dart';
import 'package:eRoomApp/api/firebase_api.dart';
import 'package:eRoomApp/app_launcher_utils.dart';
import 'package:eRoomApp/constants.dart';
import 'package:eRoomApp/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:eRoomApp/pages/contact_us.dart';
import 'package:eRoomApp/pages/create_post.dart';
import 'package:eRoomApp/pages/favourites.dart';
import 'package:eRoomApp/pages/inbox.dart';
import 'package:eRoomApp/pages/main_search_post_page.dart';

import 'package:eRoomApp/widgets/mybutton.dart';
import 'package:eRoomApp/widgets/post_cards.dart';
import 'package:eRoomApp/widgets/posts_list_apartments.dart';
import 'package:flutter/material.dart';
import 'package:eRoomApp/pages/profile_page_user_detail_save.dart';
import 'package:eRoomApp/pages_chat/chats_page.dart';
import 'package:eRoomApp/stores/login_store.dart';
import 'package:provider/provider.dart';
import 'package:eRoomApp/theme.dart';

class MainPostsPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String idUser;
  final String email;
  final String contactNumber;

  const MainPostsPage({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.idUser,
    required this.contactNumber,
    Key? key,
  }) : super(key: key);
  @override
  _MainPostsPageState createState() => _MainPostsPageState();
}

class _MainPostsPageState extends State<MainPostsPage> {
  String url = BusinessApi.url;
  int _bottomBarIndex = 0;
  var currentImageUrl;
  String? contactNumber;
  String? currentIdUser;

  void _onItemTap(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double menuContainerHeight = mediaQuery.height / 2;

    List<Widget> _widgetOptions = <Widget>[
      PostCards(
        contactNumber: widget.contactNumber,
      ),
      CreatePost(
        firstName: widget.firstName,
        lastName: widget.lastName,
        contactNumber: widget.contactNumber,
        email: widget.email,
        idUser: widget.idUser,
      ),
      MainSearchPostPage(
        contactNumber: widget.contactNumber,
      ),
    ];

    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        String names = '';
        String email = '';
        String name = '';
        String surname = '';

        return FutureBuilder<User?>(
          future: FirebaseApi.retriveUser(
              loginStore.firebaseUser.phoneNumber.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
            } else if (snapshot.hasData) {
              names = '${snapshot.data!.name} ${snapshot.data!.surname}';
              email = snapshot.data!.email;
              currentImageUrl = snapshot.data!.imageUrl;

              if ((snapshot.data!.name.toString().isNotEmpty) &&
                  (snapshot.data!.surname.toString().isNotEmpty) &&
                  (snapshot.data!.email.toString().isNotEmpty)) {
                contactNumber = snapshot.data!.contactNumber;
                currentIdUser = snapshot.data!.idUser;
                name = snapshot.data!.name;
                surname = snapshot.data!.surname;
              }
            }
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white70),
                centerTitle: false,
                backgroundColor: MyColors.primaryColor,
                title: Text(
                  'eRoom',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                elevation: 0.0,
                actions: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Favourites(
                          firstName: name,
                          lastName: surname,
                          idUser: currentIdUser!,
                          email: email,
                          contactNumber: contactNumber!,
                        ),
                      ),
                    ),
                    child: Icon(Icons.favorite, size: 25.0.sp),
                  ),
                  Container(
                    child: PopupMenuButton(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case IconsMenu.PROFILE:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePageUserDetailSave(
                                  imageUrl: currentImageUrl,
                                  currentIdUser: currentIdUser!,
                                ),
                              ),
                            );
                            break;
                          default:
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
                                      leading: Icon(item.iconData,
                                          size: 25.sp, color: MyColors.sidebar),
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
                  ),
                ],
              ),
              body: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: _widgetOptions.elementAt(_bottomBarIndex),
                ),
              ),
              drawer: Drawer(
                child: SingleChildScrollView(
                  physics:
                      BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/img/black-house-01.jpeg',
                              bundle: null,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.black54,
                                    MyColors.primaryColor
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 25.h),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 105.h,
                                        width: 105.h,
                                        decoration: new BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                            Radius.circular(60.r),
                                          ),
                                          image: new DecorationImage(
                                            image: new AssetImage(
                                                'assets/img/black-house-01.jpeg'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: GestureDetector(
                                          onTap: _navigatorToprofile,
                                          child: CircleAvatar(
                                            radius: 30.r,
                                            backgroundImage: NetworkImage(
                                                currentImageUrl ??
                                                    'assets/img/black-house-01.jpeg'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        names != null ? names : 'John Doe',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        email != null
                                            ? email
                                            : 'johndoe@gmail.com',
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Container(
                                width: double.infinity,
                                height: menuContainerHeight * 1.45.h,
                                child: Column(
                                  children: <Widget>[
                                    MyButton(
                                      text: 'Profile',
                                      iconData: Icons.person,
                                      textSize: 16.sp,
                                      height: (menuContainerHeight) / 8.h,
                                      widget: ProfilePageUserDetailSave(
                                        imageUrl: currentImageUrl,
                                        currentIdUser: currentIdUser,
                                      ),
                                    ),
                                    MyButton(
                                      text: 'Notifications',
                                      iconData: Icons.notifications,
                                      textSize: 16.sp,
                                      height: (menuContainerHeight) / 8.h,
                                      widget: Inbox(
                                        idUser: widget.idUser,
                                      ),
                                    ),
                                    MyButton(
                                      text: 'My Post',
                                      iconData: Icons.ad_units,
                                      textSize: 16.sp,
                                      height: (menuContainerHeight) / 8.h,
                                      widget: PostsListApartments(
                                        contactNumber: widget.contactNumber,
                                        email: widget.email,
                                        firstName: widget.firstName,
                                        lastName: widget.lastName,
                                        idUser: widget.idUser,
                                      ),
                                    ),
                                    MyButton(
                                      text: 'eRoom Chats',
                                      iconData: Icons.chat,
                                      textSize: 16.sp,
                                      height: (menuContainerHeight) / 8.h,
                                      widget: ChatsPage(
                                        contactNumber: '$contactNumber',
                                        currentIdUser: '$currentIdUser',
                                        currentImageUrl: '$currentImageUrl',
                                      ),
                                    ),
                                    MyButton(
                                      text: 'Favourites',
                                      iconData: Icons.favorite,
                                      textSize: 16.sp,
                                      height: (menuContainerHeight) / 8.h,
                                      widget: Favourites(
                                        idUser: widget.idUser,
                                        contactNumber: widget.contactNumber,
                                        email: widget.email,
                                        firstName: widget.firstName,
                                        lastName: widget.lastName,
                                      ),
                                    ),
                                    MyButton(
                                      text: 'Contact Us',
                                      iconData: Icons.contact_phone,
                                      textSize: 16.sp,
                                      height: (menuContainerHeight) / 8.h,
                                      widget: ContactUs(),
                                    ),
                                    Divider(
                                      thickness: 1.sp,
                                      color: MyColors.primaryColor,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 22.h),
                                      child: GestureDetector(
                                        onTap: () => AppLauncherUtils.openLink(
                                            url:
                                                'https://kwepilecorp.wordpress.com/'),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'terms and conditions',
                                              style: TextStyle(
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    offset: Offset(8.0, 6.0),
                                                    blurRadius: 15.0.r,
                                                  ),
                                                ],
                                                color:
                                                    MyColors.primaryColorLight,
                                                fontSize: 18.sp,
                                              ),
                                            ),
                                            Icon(
                                              Icons.edit_sharp,
                                              color: MyColors.primaryColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: _createBottomNavigationBar(),
            );
          },
        );
      },
    );
  }

  _navigatorToprofile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePageUserDetailSave(
          imageUrl: currentImageUrl,
          currentIdUser: currentIdUser!,
        ),
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.PROFILE) {
      print('Profile');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePageUserDetailSave(
            imageUrl: currentImageUrl,
            currentIdUser: currentIdUser!,
          ),
        ),
      );
    }
  }

  Widget _createBottomNavigationBar() {
    return Container(
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: MyColors.primaryColor,
        unselectedItemColor: Colors.blueGrey,
        selectedFontSize: 15.0.sp,
        unselectedFontSize: 14.0.sp,
        onTap: _onItemTap,
        currentIndex: _bottomBarIndex,
        backgroundColor: MyColors.kBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Create Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search Post',
          ),
        ],
      ),
    );
  }
}
