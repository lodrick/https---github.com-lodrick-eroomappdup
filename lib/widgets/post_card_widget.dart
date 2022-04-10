// ignore: import_of_legacy_library_into_null_safe
import 'package:basic_utils/basic_utils.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/shared/sharedPreferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/post_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCardWidget extends StatefulWidget {
  final List<Advert> adverts;
  final String contactNumber;

  const PostCardWidget({
    required this.adverts,
    required this.contactNumber,
    Key? key,
  }) : super(key: key);

  @override
  _PostCardWidgetState createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  bool isLiked = false;
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
        /*for (String data in result) {
          if (data.contains(widget.advert.id)) {
            isLiked = true;
          }
        }*/
      });
    });
  }

  Map<String, bool> testLike = Map<String, bool>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: buildAdverts(),
    );
  }

  Widget buildAdverts() => ListView.builder(
        physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
        reverse: false,
        itemCount: widget.adverts.length,
        itemBuilder: (context, index) {
          Advert advert = widget.adverts[index];
          String _url = '';
          isLiked = false;
          String _updatedAt = DateFormat('dd-MM-yyy')
              .format(DateTime.parse(advert.updatedAt.toDate().toString()));

          if (bookMarkedFavourates != null) {
            for (String likedId in bookMarkedFavourates!) {
              if (likedId.contains(advert.id!)) {
                isLiked = true;
              }
            }
          }

          if (advert.photosUrl != null) {
            advert.photosUrl.forEach((e) {
              _url = e['photoUrl'];
            });
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostInfo(
                    contactNumber: widget.contactNumber,
                    advert: advert,
                  ),
                ),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height.h / 2.1.h,
              padding: EdgeInsets.only(bottom: 10.0.h),
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 400.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(_url.isNotEmpty
                                ? _url
                                : 'https://i.imgur.com/GXoYikT.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.house,
                        color: MyColors.primaryColor,
                        size: 30.sp,
                      ),
                      title: Container(
                        width: MediaQuery.of(context).size.width.w * 0.45,
                        child: Text(
                          StringUtils.capitalize(advert.title!),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      subtitle: Container(
                        width: MediaQuery.of(context).size.width.w * 0.45,
                        child: Text(
                          StringUtils.capitalize(advert.decription!),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 18.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.lock_clock,
                                  color: Colors.blueGrey,
                                ),
                                Text(_updatedAt)
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                'Available',
                                style: TextStyle(
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.amberAccent,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.add_shopping_cart,
                                    color: MyColors.primaryColor,
                                  ),
                                  Text(
                                    'R ' + advert.price.toString(),
                                    style: TextStyle(
                                      color: MyColors.primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 18.w),
                                  GestureDetector(
                                    onTap: null,
                                    child: Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isLiked
                                          ? Colors.pink[400]
                                          : Colors.black54,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.0.w,
                                  ),
                                  Text(
                                    '${advert.likes}',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
