import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/api/firebase_api.dart';
import 'package:eRoomApp/app_launcher_utils.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/models/user_model.dart';
import 'package:eRoomApp/pages_chat/chat_page.dart';
import 'package:eRoomApp/shared/sharedPreferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:basic_utils/basic_utils.dart';

// ignore: unnecessary_import
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class PostInfo extends StatefulWidget {
  final String contactNumber;

  final Advert advert;

  PostInfo({
    required this.advert,
    required this.contactNumber,
  });

  @override
  _PostInfoState createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {
  bool isLiked = false;
  int likeCount = 0;
  String? currentUserId;
  List<String>? imageUrls;
  List<String> bookMarkedFavourates = [];
  User? posterUserInfo;

  void currentUser() async {
    SharedPrefs.getContactNumber().then((currentUserPhone) {
      FirebaseApi.retriveUser(currentUserPhone).then((currentUser) {
        setState(() {
          currentUserId = currentUser!.idUser;
        });
      });
    });
  }

  void posterUser() async {
    FirebaseApi.retriveUserByID(widget.advert.userId).then((value) {
      setState(() {
        posterUserInfo = value;
      });
    });
  }

  void likeCounts() async {
    if (widget.advert.likes != null) {
      likeCount = widget.advert.likes!;
    }
  }

  void addPostFramecallback() {
    imageUrls = [];

    widget.advert.photosUrl.forEach((e) {
      imageUrls!.add(e['photoUrl']);
    });

    if (imageUrls!.isNotEmpty && imageUrls!.length > 0) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (imageUrls!.isNotEmpty) {
          imageUrls!.forEach((imageUrl) {
            precacheImage(NetworkImage(imageUrl), context);
          });
        }
      });
    }
  }

  void getBookMarkFavourates() async {
    bookMarkedFavourates = [];
    SharedPrefs.getBookMarkFavourates().then((result) {
      setState(() {
        bookMarkedFavourates = result;
        if (bookMarkedFavourates.isNotEmpty) {
          for (String data in result) {
            if (data.contains('${widget.advert.id}')) {
              isLiked = true;
            }
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser();
    addPostFramecallback();
    getBookMarkFavourates();
    posterUser();
  }

  @override
  void dispose() {
    imageUrls!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          iconTheme: IconThemeData(color: Colors.white70),
          centerTitle: false,
          title: Text(
            'Post Info',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
              ),
              child: GestureDetector(
                onTap: share,
                child: Icon(Icons.share, size: 22.0.sp),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15.0.w),
              child: GestureDetector(
                onTap: () {
                  String msg = '';
                  setState(() {
                    if (isLiked) {
                      bookMarkedFavourates.remove(widget.advert.id);
                      isLiked = false;
                      if (likeCount != 0) {
                        likeCount -= 1;
                      }

                      FireBusinessApi.updateLikes(widget.advert.id, likeCount);
                      SharedPrefs.bookMarkFavourates(bookMarkedFavourates);
                      msg = 'Post removed from your favorite bookmark...';
                    } else {
                      isLiked = true;
                      likeCount += 1;
                      FireBusinessApi.updateLikes(widget.advert.id, likeCount);
                      bookMarkedFavourates.add(widget.advert.id!);
                      SharedPrefs.bookMarkFavourates(bookMarkedFavourates);
                      msg = 'Post added to your favorite bookmark...';
                    }
                  });

                  Fluttertoast.showToast(
                    msg: msg,
                    fontSize: 18.0.sp,
                    backgroundColor: Colors.black87.withOpacity(.7),
                    textColor: Colors.white,
                  );
                },
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.pink[400] : Colors.white70,
                  size: 22.0,
                ),
              ),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            return Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0.r),
                          topRight: Radius.circular(30.0.r),
                        ),
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                              child: Container(
                                child: CarouselSlider.builder(
                                  itemCount: imageUrls!.length,
                                  options: CarouselOptions(
                                      autoPlay: false,
                                      aspectRatio: 2.1,
                                      enlargeCenterPage: true),
                                  itemBuilder: (context, index, realIdx) {
                                    return Container(
                                      child: Center(
                                        child: Image.network(
                                          imageUrls![index],
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            new SingleChildScrollView(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 32.w,
                                        vertical: 20.h,
                                      ),
                                      child: titleSection(
                                        title: StringUtils.capitalize(
                                            widget.advert.title!),
                                        description: StringUtils.capitalize(
                                            widget.advert.decription!),
                                        updatedAt:
                                            DateFormat('dd-MM-yyy').format(
                                          DateTime.parse(
                                            widget.advert.updatedAt
                                                .toDate()
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 32.0.w,
                                        bottom: 20.0.h,
                                        right: 32.0.w,
                                      ),
                                      child: Column(
                                        children: [
                                          buildPostInfo(
                                            desc: 'City:',
                                            data: StringUtils.capitalize(
                                                widget.advert.city!),
                                          ),
                                          Divider(color: MyColors.primaryColor),
                                          buildPostInfo(
                                            desc: 'Suburb:',
                                            data: StringUtils.capitalize(
                                                widget.advert.suburb!),
                                          ),
                                          Divider(color: MyColors.primaryColor),
                                          buildPostInfo(
                                              desc: 'Price:',
                                              data: 'R ${widget.advert.price}'),
                                          Divider(color: MyColors.primaryColor),
                                          buildPostInfo(
                                              desc: 'Status:',
                                              data: '${widget.advert.status}'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5.0.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        _buildButtonColumn(
                                          MyColors.primaryColor,
                                          IconButton(
                                            icon: const Icon(
                                              Icons.chat,
                                              color: MyColors.primaryColor,
                                            ),
                                            tooltip:
                                                'Click here to chat about the post.',
                                            onPressed: () {
                                              setState(
                                                () {
                                                  FirebaseApi.retriveUser(
                                                          widget.contactNumber)
                                                      .then(
                                                    (result) {
                                                      if (currentUserId ==
                                                          result!.idUser) {
                                                        final snackBar =
                                                            SnackBar(
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors.black38
                                                                  .withOpacity(
                                                                      0.8),
                                                          content: Text(
                                                            'You own this post you can not chat with yourself.',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                0.7,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                        Scaffold.of(context)
                                                            // ignore: deprecated_member_use
                                                            .showSnackBar(
                                                          snackBar,
                                                        );
                                                      } else {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ChatPage(
                                                              currentIdUser:
                                                                  currentUserId!,
                                                              user: result,
                                                              contactNumber: widget
                                                                  .contactNumber,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          'eRoom Chat',
                                        ),
                                        _buildButtonColumn(
                                          MyColors.primaryColor,
                                          IconButton(
                                            icon: Icon(
                                              Icons.call,
                                              color: MyColors.primaryColor,
                                            ),
                                            onPressed: () =>
                                                AppLauncherUtils.openPhoneCall(
                                              phoneNumber:
                                                  '${posterUserInfo!.contactNumber}',
                                            ),
                                          ),
                                          'Call Us',
                                        ),
                                        _buildButtonColumn(
                                          MyColors.primaryColor,
                                          IconButton(
                                            icon: Icon(
                                              Icons.sms,
                                              color: MyColors.primaryColor,
                                            ),
                                            onPressed: () =>
                                                AppLauncherUtils.openSMS(
                                              phoneNumber:
                                                  '${posterUserInfo!.contactNumber}',
                                            ),
                                          ),
                                          'SMS',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildPostInfo({String? desc, String? data}) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildText(
                  text: '$desc',
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.bold),
              SizedBox(
                width: 50.0.w,
              ),
              buildText(
                text: '$data',
                color: Colors.grey.shade900,
              ),
            ],
          ),
        ],
      );

  Widget buildText({String? text, Color? color, FontWeight? fontWeight}) =>
      Container(
        padding: EdgeInsets.only(top: 5.0.h),
        child: Text(
          '$text',
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: 14.0.sp,
            color: color,
          ),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget titleSection(
          {String? title, String? description, String? updatedAt}) =>
      Container(
        padding: EdgeInsets.only(bottom: 3.5.h, right: 10.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade800,
              width: 2.0.w,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 8.0.h),
                    child: Text(
                      title ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0.sp,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    description ?? '',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16.sp,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
            Icon(
              FontAwesomeIcons.calendar,
              color: MyColors.primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                '$updatedAt',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: MyColors.primaryTextColor,
                ),
              ),
            ),
          ],
        ),
      );

  static Column _buildButtonColumn(
      Color color, IconButton iconButton, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconButton,
        Container(
          margin: EdgeInsets.only(top: 8.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> share() async {
    String text = 'https://medium.com/@suryadevsingh24032000';
    String subject = 'follow me';
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share(
      text,
      subject: subject,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}
