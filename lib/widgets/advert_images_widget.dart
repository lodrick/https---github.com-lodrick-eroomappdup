import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdvertImgWidget extends StatelessWidget {
  final List<File> imageFiles;

  AdvertImgWidget({required this.imageFiles, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100.h,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0.r),
          topRight: Radius.circular(20.0.r),
        ),
        color: Colors.black12,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.0.h,
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.29.h,
              child: GridView.builder(
                itemCount: imageFiles.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300.0,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  File imageFile = imageFiles[index];

                  return Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Image.file(
                              imageFile,
                              width: 500.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
