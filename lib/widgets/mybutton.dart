import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String? text;
  final IconData? iconData;
  final double? textSize;
  final double? height;
  final Widget? widget;

  MyButton({this.text, this.iconData, this.textSize, this.height, this.widget});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            iconData,
            color: MyColors.primaryColor,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            '$text',
            style: TextStyle(shadows: [
              Shadow(
                  color: Colors.black.withOpacity(0.8),
                  offset: Offset(8.0, 6.0),
                  blurRadius: 15.0),
            ], color: MyColors.primaryColorLight, fontSize: textSize),
          ),
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget!,
          ),
        );
      },
    );
  }
}
