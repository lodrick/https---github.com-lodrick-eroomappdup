import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets_chat/full_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageWidget extends StatelessWidget {
  final String peerAvatar;
  final DocumentSnapshot document;
  final currentUserId;
  final int index;

  const MessageWidget({
    required this.peerAvatar,
    required this.currentUserId,
    required this.document,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12.0.r);
    final borderRadius = BorderRadius.all(radius);
    print(this.currentUserId);
    return Row(
      mainAxisAlignment: document.get('idFrom') == this.currentUserId
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: <Widget>[
        if (this.currentUserId != document.get('idFrom'))
          CircleAvatar(
            radius: 16.r,
            backgroundImage: NetworkImage(this.peerAvatar),
          ),
        document.get('type') == 0
            ? Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 9.0.w,
                  vertical: 9.0.h,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                constraints: BoxConstraints(maxWidth: 250.w),
                decoration: BoxDecoration(
                  color: this.currentUserId == document.get('idFrom')
                      ? MyColors.primaryColorLight
                      : Color(0xFFFFEFEE),
                  borderRadius: this.currentUserId == document.get('idFrom')
                      ? borderRadius
                          .subtract(BorderRadius.only(bottomRight: radius))
                      : borderRadius
                          .subtract(BorderRadius.only(bottomLeft: radius)),
                ),
                child: Column(
                  crossAxisAlignment:
                      this.currentUserId != document.get('idFrom')
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      document.get('message').toString(),
                      style: TextStyle(
                          color: currentUserId == document.get('idFrom')
                              ? Colors.white
                              : Colors.black54),
                      textAlign: currentUserId == document.get('idFrom')
                          ? TextAlign.end
                          : TextAlign.start,
                    ),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 9.0.w,
                  vertical: 9.0.h,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 8.0.w,
                  vertical: 8.0.h,
                ),
                constraints: BoxConstraints(maxWidth: 250.w),
                decoration: BoxDecoration(
                  color: this.currentUserId == document.get('idFrom')
                      ? MyColors.primaryColorLight
                      : Color(0xFFFFEFEE),
                  borderRadius: this.currentUserId == document.get('idFrom')
                      ? borderRadius
                          .subtract(BorderRadius.only(bottomRight: radius))
                      : borderRadius
                          .subtract(BorderRadius.only(bottomLeft: radius)),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullPhoto(
                          url: document.get('message'),
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    document.get("message"),
                    loadingBuilder: (BuildContext? context, Widget? child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child!;
                      return Container(
                        decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0.r),
                          ),
                        ),
                        width: 200.0.w,
                        height: 200.0.h,
                        child: Center(
                          child: CircularProgressIndicator(
                            //color: primaryColor,
                            value: loadingProgress.expectedTotalBytes != null &&
                                    loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return Material(
                        child: Image.asset(
                          'images/img_not_available.jpeg',
                          width: 200.0.w,
                          height: 200.0.h,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      );
                    },
                    width: 180.0.w,
                    height: 180.0.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ],
    );
  }
}
