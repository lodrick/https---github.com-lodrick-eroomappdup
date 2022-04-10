import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String? text;
  final IconData? iconData;
  final double? textSize;
  final double? height;
  final Widget? widget;

  MyButton({
    this.text,
    this.iconData,
    this.textSize,
    this.height,
    this.widget,
  });
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
            color: Colors.white60,
          ),
          SizedBox(width: 10.0),
          Text(
            '$text',
            style: TextStyle(color: Colors.white60, fontSize: textSize),
          ),
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget!));
      },
    );
  }
}
