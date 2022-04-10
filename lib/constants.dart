import 'package:flutter/material.dart';

class Constants {
  static const String PROFILE = 'Profile';
  static const String SIGNOUT = 'Sign Out';

  static const String REFRESH = 'Refresh';
  static const String HELP = 'Help';

  static const List<String> choices = <String>[
    PROFILE,
    SIGNOUT,
  ];

  static const List<String> selectContactCoices = <String>[
    REFRESH,
    HELP,
  ];
}

class IconMenu {
  final String text;
  final IconData iconData;

  const IconMenu({
    required this.text,
    required this.iconData,
  });
}

class IconsMenu {
  static const PROFILE = IconMenu(
    text: 'Profile',
    iconData: Icons.account_circle,
  );

  /*static const SIGNOUT = IconMenu(
    text: 'Logout',
    iconData: Icons.logout,
  );*/

  static const items = <IconMenu>[
    PROFILE,
    //SIGNOUT,
  ];
}
