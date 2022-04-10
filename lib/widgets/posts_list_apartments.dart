// ignore: import_of_legacy_library_into_null_safe
import 'package:basic_utils/basic_utils.dart';
import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/dialog_box_stats.dart';
import 'package:flutter/material.dart';
import 'package:eRoomApp/pages/post_ad_edit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostsListApartments extends StatefulWidget {
  final String idUser;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;

  PostsListApartments({
    required this.idUser,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.email,
    Key? key,
  }) : super(key: key);
  @override
  _PostsListApartmentsState createState() => _PostsListApartmentsState();
}

class _PostsListApartmentsState extends State<PostsListApartments> {
  List? adverts;
  var _controller = ScrollController();
  ScrollPhysics _physics = ClampingScrollPhysics();

  Future<void> makeRequest() async {
    setState(() {
      _controller.addListener(() {
        if (_controller.position.pixels <= 56)
          setState(() => _physics = ClampingScrollPhysics());
        else
          setState(() => _physics = BouncingScrollPhysics());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white70),
        title: Text(
          'My Post',
          style: TextStyle(
            fontSize: 22.0.sp,
            fontWeight: FontWeight.w600,
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
          padding: EdgeInsets.only(left: 16.0.w, top: 8.0.h),
          child: StreamBuilder<List<Advert>>(
            stream: FireBusinessApi.getMyAdverts(widget.idUser),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return buildText('Something Went Wrong Try again later, ' +
                        snapshot.error.toString());
                  } else {
                    var adverts = snapshot.data;
                    String _imageUrl = '';
                    List<String> _imageUrls = [];
                    if (adverts!.isEmpty) {
                      return buildText('No Adverts Found');
                    } else {
                      return ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0.r),
                          topRight: Radius.circular(30.0.r),
                        ),
                        child: ListView.builder(
                          controller: _controller,
                          physics: _physics,
                          itemCount: adverts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Advert advert = adverts[index];

                            advert.photosUrl.forEach((e) {
                              _imageUrls.add(e['photoUrl']);
                              _imageUrl = e['photoUrl'];
                            });

                            String description = '';
                            Icon icons = Icon(
                              Icons.deck,
                              color: Colors.yellow[500],
                              size: 45.0.sp,
                            );

                            Color? colors = MyColors.primaryColor;
                            if (advert.status == 'pending') {
                              description =
                                  'Your post is under review, you will receive an email when it has been approved or declined';
                              icons = Icon(
                                Icons.hourglass_top_rounded,
                                color: Colors.yellow[500],
                                size: 45.0.sp,
                              );
                              colors = Colors.yellow[500];
                            } else if (advert.status == 'approved') {
                              description =
                                  'Your post has been Accepted and can be viewed online';
                              icons = Icon(
                                Icons.check,
                                color: MyColors.primaryColor,
                                size: 45.0.sp,
                              );
                              colors = MyColors.primaryColor;
                            } else {
                              description =
                                  'Your post has been declined, please check your email why it was declined';
                              icons = Icon(
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
                                  builder: (_) => PostAdEdit(
                                    advert: advert,
                                    contactNumber: widget.contactNumber,
                                    email: widget.email,
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    idUser: widget.idUser,
                                  ),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 5.0.h,
                                  bottom: 5.0.h,
                                  right: 20.0.w,
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
                                          backgroundColor:
                                              MyColors.primaryColor,
                                        ),
                                        SizedBox(width: 10.0.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              StringUtils.capitalize(
                                                  advert.title!),
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
                                                StringUtils.capitalize(
                                                    advert.decription!),
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15.0.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => DialogAdReview(
                                            imageUrl: _imageUrl,
                                            title: advert.status!
                                                    .substring(0, 1)
                                                    .toLowerCase() +
                                                advert.status!.substring(1),
                                            descrition: description,
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
            fontSize: 24.sp,
            color: Colors.blueGrey[300],
          ),
        ),
      );
}
