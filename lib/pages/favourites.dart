import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';

import 'package:eRoomApp/shared/sharedPreferences.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/dialog_box_stats.dart';
import 'package:eRoomApp/widgets/post_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Favourites extends StatefulWidget {
  final String idUser;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;

  Favourites({
    required this.idUser,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<String>? bookMarkedFavourates;
  @override
  void initState() {
    super.initState();
    getBookMarkFavourates();
  }

  void getBookMarkFavourates() async {
    bookMarkedFavourates = [];
    SharedPrefs.getBookMarkFavourates().then((result) {
      setState(() {
        bookMarkedFavourates = result;
        print(bookMarkedFavourates!.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white70),
        title: Text(
          'Favourite Post',
          style: TextStyle(
            fontSize: 22.0.sp,
            color: Colors.white70,
          ),
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0.r),
            topRight: Radius.circular(30.0.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 8.h,
          ),
          child: StreamBuilder<List<Advert>>(
            stream: FireBusinessApi.getFavAdverts(bookMarkedFavourates!),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return buildText(
                      'Something Went Wrong Try again later, ' +
                          snapshot.error.toString(),
                    );
                  } else {
                    var adverts = snapshot.data;
                    if (adverts!.isEmpty) {
                      return buildText('No Adverts Found');
                    } else {
                      return ClipRRect(
                        child: ListView.builder(
                          itemCount: adverts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Advert advert = adverts[index];
                            List<String> _imageUrls = [];
                            String _imageUrl = '';

                            advert.photosUrl.forEach((e) {
                              _imageUrls.add(e['photoUrl']);
                              _imageUrl = e['photoUrl'];
                            });

                            Icon icons = Icon(
                              Icons.deck,
                              color: Colors.yellow[500],
                              size: 45.0.sp,
                            );

                            Color? colors = MyColors.primaryColor;
                            if (advert.status == 'pending') {
                              icons = Icon(
                                Icons.hourglass_top_rounded,
                                color: Colors.yellow[500],
                                size: 45.0.sp,
                              );
                              colors = Colors.yellow[500];
                            } else if (advert.status == 'approved') {
                              icons = Icon(
                                Icons.check,
                                color: MyColors.primaryColor,
                                size: 45.0.sp,
                              );
                              colors = MyColors.primaryColor;
                            } else {
                              Icon(
                                Icons.cancel,
                                color: Colors.red[500],
                                size: 45.0.sp,
                              );
                              colors = Colors.red[500];
                            }
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PostInfo(
                                    advert: advert,
                                    contactNumber: widget.contactNumber,
                                  ),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 5.0.h,
                                  bottom: 5.0.h,
                                  right: 5.0.w,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.0.w,
                                  vertical: 10.0.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFEFEE),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0.r),
                                    topRight: Radius.circular(20.0.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 35.0.r,
                                          backgroundImage: NetworkImage(
                                            _imageUrl.isNotEmpty
                                                ? _imageUrl
                                                : 'https://images.unsplash.com/photo-1492106087820-71f1a00d2b11?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                                          ),
                                        ),
                                        SizedBox(width: 10.0.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '${advert.title}',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.0.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5.0.h),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45.w,
                                              child: Text(
                                                '${advert.decription}',
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15.0.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => DialogAdReview(
                                            title: '${advert.status}',
                                            imageUrl: _imageUrl,
                                            descrition:
                                                'You are doing a great job please keep it up you are the best',
                                          ),
                                        );
                                      },
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                icons,
                                                Text(
                                                  advert.status!
                                                          .substring(0, 1)
                                                          .toUpperCase() +
                                                      advert.status!
                                                          .substring(1),
                                                  style: TextStyle(
                                                    color: colors,
                                                    fontSize: 13.5.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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
          style: TextStyle(
            fontSize: 24,
            color: Colors.blueGrey[300],
          ),
        ),
      );
}
