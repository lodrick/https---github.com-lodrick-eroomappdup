import 'package:eRoomApp/commons/radial_progress.dart';
import 'package:eRoomApp/commons/rounded_image.dart';
import 'package:eRoomApp/text_style.dart';
import 'package:flutter/material.dart';

class MyInfo extends StatelessWidget {
  const MyInfo({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: RadialProgress(
              width: 4,
              goalCompleted: 0.9,
              child: RoundedImage(
                imagePath: 'assets/img/eRoom.png',
                size: Size.fromWidth(120.0),
              ),
            ),
          ),
          SizedBox(height: 0.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Anne Grethe', style: whiteNameTextStyle),
              Text(', 24', style: whiteNameTextStyle),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('anne@gmail.com', style: whiteSubHeadingTextStyle),
            ],
          ),
        ],
      ),
    );
  }
}
