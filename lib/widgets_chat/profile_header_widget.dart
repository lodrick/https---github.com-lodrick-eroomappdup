import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String imageUri;

  const ProfileHeaderWidget({
    required this.name,
    required this.imageUri,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 80.h,
        padding: EdgeInsets.all(16).copyWith(left: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: Colors.white),
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: NetworkImage(imageUri),
                ),
                SizedBox(width: 8.0.w),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.more_vert,
                  size: 25.sp,
                  color: Colors.white,
                ),
              ],
            )
          ],
        ),
      );

  Widget buildIcon(IconData icon) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white54,
        ),
        child: Icon(
          icon,
          size: 25.sp,
          color: Colors.white,
        ),
      );
}
