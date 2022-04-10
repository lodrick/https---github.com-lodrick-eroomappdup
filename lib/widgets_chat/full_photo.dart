import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

import '../theme.dart';

class FullPhoto extends StatelessWidget {
  final String? url;
  const FullPhoto({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white70),
        backgroundColor: MyColors.primaryColor,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: FullPhotoScreen(url: this.url!),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;
  const FullPhotoScreen({Key? key, required this.url}) : super(key: key);

  @override
  _FullPhotoScreenState createState() => _FullPhotoScreenState();
}

class _FullPhotoScreenState extends State<FullPhotoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0.r),
          topRight: Radius.circular(25.0.r),
        ),
      ),
      child: PhotoView(
        imageProvider: NetworkImage(widget.url),
      ),
    );
  }
}
