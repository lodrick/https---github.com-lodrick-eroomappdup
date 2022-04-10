import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';

class CoordidateField extends StatefulWidget {
  @override
  _CoordidateFieldState createState() => _CoordidateFieldState();
}

class _CoordidateFieldState extends State<CoordidateField> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.location_pin,
                          color: MyColors.primaryColor,
                        ),
                      ),
                      filled: false,
                      hintStyle: new TextStyle(color: Colors.grey[800]),
                      hintText: '1',
                      labelText: 'Min',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.location_pin,
                          color: MyColors.primaryColor,
                        ),
                      ),
                      filled: false,
                      hintStyle: new TextStyle(color: Colors.grey[800]),
                      hintText: '500',
                      labelText: 'Max',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
