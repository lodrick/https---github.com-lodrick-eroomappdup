import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Drawer Header',
            ),
            decoration: BoxDecoration(
              color: MyColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
