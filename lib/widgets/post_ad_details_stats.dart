import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostAdDetailStatus extends StatelessWidget {
  final Color? color;
  final String? textStatus;
  PostAdDetailStatus({
    Key? key,
    this.color,
    this.textStatus,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0.h,
      decoration: BoxDecoration(
        //color: Color(0xFF26ED41),
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0.r),
          topRight: Radius.circular(30.0.r),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              textStatus!.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0.sp,
                //fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
