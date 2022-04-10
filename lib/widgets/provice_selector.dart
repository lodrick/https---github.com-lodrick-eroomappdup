import 'package:flutter/material.dart';

class SelectProvice extends StatefulWidget {
  @override
  _SelectProviceState createState() => _SelectProviceState();
}

class _SelectProviceState extends State<SelectProvice> {
  String? _dropDownValue;
  List<String> provices = [];
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
                color: Colors.black38,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
      isExpanded: true,
      iconSize: 30.0,
      style: TextStyle(
        color: Colors.black38,
      ),
      items: ['Gauteng', 'Nelspuit', 'Pretoria'].map(
        (val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(
              val,
              style: TextStyle(
                color: Colors.black26,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ).toList(),
      onChanged: (val) {
        setState(() {
          _dropDownValue = val as String?;
        });
      },
    );
  }
}
