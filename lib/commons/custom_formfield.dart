import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final IconData iconDara;
  final String hintText;
  final String labelText;
  const CustomTextFormField({
    required Key key,
    required this.controller ,
    required this.iconDara,
    required this.hintText,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Icon(
                iconDara,
                color: MyColors.primaryColor,
              ),
            ),
            filled: false,
            hintStyle: new TextStyle(fontSize: 16.0, color: Colors.grey[800]),
            hintText: hintText,
            labelText: labelText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
