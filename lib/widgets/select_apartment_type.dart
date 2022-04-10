import 'package:flutter/material.dart';

class SelectApartmentType extends StatefulWidget {
  @override
  _SelectApartmentTypeState createState() => _SelectApartmentTypeState();
}

class _SelectApartmentTypeState extends State<SelectApartmentType> {
  String? _dropDownValue;
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      hint: _dropDownValue == null
          ? Text(
              'Dropdown',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            )
          : Text(
              _dropDownValue!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
      isExpanded: true,
      iconSize: 30.0,
      style: TextStyle(
        color: Colors.red,
      ),
      items: ['One', 'Two', 'Three'].map(
        (val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(
              val,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ).toList(),
      onChanged: (val) {
        setState(
          () {
            _dropDownValue = val as String?;
          },
        );
      },
    );
  }
}
