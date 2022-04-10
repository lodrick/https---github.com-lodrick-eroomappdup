import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String? hintTxt;
  final String? labelTxt;
  final Icon? icon;
  final String? initialValue;
  final TextEditingController? controller;
  final String? errorText;
  final TextInputType? textInputType;

  CustomTextField({
    this.hintTxt,
    this.labelTxt,
    this.icon,
    this.initialValue,
    this.controller,
    this.errorText,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 3.h,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0.r),
        ),
        child: TextFormField(
          autocorrect: true,
          enableInteractiveSelection: true,
          initialValue: initialValue,
          validator: (value) {
            if ((value == null && value!.isEmpty)) {
              return errorText;
            }
            return null;
          },
          keyboardType: textInputType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(0.0),
              child: icon,
            ),
            filled: false,
            hintStyle: new TextStyle(color: Colors.grey[800]),
            hintText: hintTxt,
            labelText: '$labelTxt*',
            border: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: 16.0.sp,
          ),
          controller: controller,
        ),
      ),
    );
  }
}
