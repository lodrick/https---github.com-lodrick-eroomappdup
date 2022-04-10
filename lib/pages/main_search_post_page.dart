import 'package:eRoomApp/api/business_api.dart';

//import 'package:eRoomApp/models/province.dart';
import 'package:eRoomApp/models/static_data.dart';
import 'package:eRoomApp/pages/post_search_results_display.dart';
import 'package:eRoomApp/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:eRoomApp/theme.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MainSearchPostPage extends StatefulWidget {
  final String contactNumber;
  MainSearchPostPage({
    required this.contactNumber,
    Key? key,
  }) : super(key: key);

  @override
  _MainSearchPostPageState createState() => _MainSearchPostPageState();
}

class _MainSearchPostPageState extends State<MainSearchPostPage> {
  TextEditingController suburbController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceControler = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isMenuOpen = false;
  String url = BusinessApi.url;
  String? _province;
  String? _city;

  @override
  void dispose() {
    super.dispose();
    suburbController.dispose();
    maxPriceControler.dispose();
    minPriceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0.r),
                    topRight: Radius.circular(30.0.r),
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 30.h,
                      ),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Price Range',
                              style: TextStyle(
                                fontSize: 24.0.sp,
                                fontFamily: 'OpenSans',
                                color: Colors.blueGrey[600],
                                fontWeight: FontWeight.w400,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(2.0, 4.0),
                                    blurRadius: 10.0.r,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFF8E1),
                                        borderRadius:
                                            BorderRadius.circular(30.0.r),
                                      ),
                                      child: TextFormField(
                                        controller: minPriceController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if ((value == null &&
                                                  value!.isEmpty) ||
                                              !RegExp(r'^[A-Za-z0-9]+$')
                                                  .hasMatch(value)) {
                                            return 'Minimum price is required.';
                                          }
                                          return null;
                                        },
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
                                          hintStyle: GoogleFonts.lato(
                                              color: Colors.grey[700]),
                                          hintText: 'R1',
                                          labelText: 'Min',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFF8E1),
                                        borderRadius: BorderRadius.circular(
                                          30.0.r,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: maxPriceControler,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if ((value == null &&
                                                  value!.isEmpty) ||
                                              !RegExp(r'^[A-Za-z0-9]+$')
                                                  .hasMatch(value)) {
                                            return 'Maximum price is required.';
                                          }
                                          return null;
                                        },
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
                                          hintStyle: GoogleFonts.lato(
                                              color: Colors.grey[700]),
                                          hintText: 'R500',
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
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0.w,
                              vertical: 2.0.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(25.0.r),
                            ),
                            child: DropdownButtonFormField(
                              dropdownColor: Colors.white,
                              decoration:
                                  InputDecoration.collapsed(hintText: ''),
                              value: _province,
                              hint: Text(
                                'Select Province',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              isExpanded: true,
                              iconSize: 30.0.sp,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              validator: (value) => value == null
                                  ? 'Province is required*'
                                  : null,
                              items: StaticData.provinces.map(
                                (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(
                                      val,
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 18.0.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _province = val as String?;
                                  print('_province $_province');
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10.0.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0.w,
                              vertical: 2.0.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(25.0.r),
                            ),
                            child: DropdownButtonFormField(
                              dropdownColor: Colors.blueGrey[100],
                              decoration:
                                  InputDecoration.collapsed(hintText: ''),
                              isExpanded: true,
                              iconSize: 30.0.sp,
                              value: _city,
                              hint: Text(
                                'Select City',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              validator: (value) =>
                                  value == null ? 'City is required*' : null,
                              items: StaticData.cities.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 18.0.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  this._city = val as String?;
                                  print('City: $_city');
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 4.0.h),
                          CustomTextField(
                            errorText: 'Suburb is required.',
                            controller: suburbController,
                            hintTxt: 'Centurion',
                            labelTxt: 'Suburb',
                            icon: Icon(
                              Icons.location_city,
                              color: MyColors.primaryColor,
                            ),
                            textInputType: TextInputType.text,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostSearchResultsDisplay(
                  minPrice: double.parse(minPriceController.text.toString()),
                  maxPrice: double.parse(maxPriceControler.text.toString()),
                  suburb: suburbController.text.toLowerCase(),
                  contactNumber: widget.contactNumber,
                  city: _city!.toLowerCase(),
                ),
              ),
            );
          }
        },
        child: Icon(
          Icons.search,
          color: Colors.white70,
        ),
        backgroundColor: MyColors.primaryColor,
      ),
    );
  }
}
