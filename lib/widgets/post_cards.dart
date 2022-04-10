import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostCards extends StatefulWidget {
  final String contactNumber;

  PostCards({
    required this.contactNumber,
    Key? key,
  }) : super(key: key);

  @override
  _PostCardsState createState() => _PostCardsState();
}

class _PostCardsState extends State<PostCards> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0.r),
              topRight: Radius.circular(20.0.r),
            ),
          ),
          child: StreamBuilder<List<Advert>>(
            stream: FireBusinessApi.getAdverts(),
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

                    adverts!
                        .removeWhere((advert) => advert.status != 'approved');

                    if (adverts.isEmpty) {
                      return buildText('No Advert Found');
                    } else {
                      return PostCardWidget(
                        adverts: adverts,
                        contactNumber: widget.contactNumber,
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
