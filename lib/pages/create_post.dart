import 'dart:io';
import 'dart:typed_data';

import 'package:eRoomApp/api/fire_business_api.dart';
import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/models/static_data.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/dialog_box_post_confirm.dart';
import 'package:eRoomApp/widgets/popover.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreatePost extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String idUser;
  final String email;
  final String contactNumber;

  CreatePost({
    required this.firstName,
    required this.lastName,
    required this.idUser,
    required this.email,
    required this.contactNumber,
    Key? key,
  }) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final formKey = GlobalKey<FormState>();
  List<File>? imageFiles;
  String? _province;
  String? _roomType;
  String? _city;

  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController decriptionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController suburbController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    priceController.dispose();
    titleController.dispose();
    decriptionController.dispose();
    cityController.dispose();
    suburbController.dispose();
  }

  void filePicker() async {
    Navigator.of(context).pop();
    String error = 'No Error Detected';
    final _imagePicker = ImagePicker();
    if (imageFiles == null) {
      imageFiles = [];
    }

    PickedFile? image;

    File? file;
    try {
      await Permission.photos.request();
      var permissionStatus = await Permission.photos.status;
      if (permissionStatus.isGranted) {
        // ignore: deprecated_member_use
        image = await _imagePicker.getImage(source: ImageSource.camera);
        file = File(image!.path);
        print(file.path);
        Uint8List fileBytes = file.readAsBytesSync();
        print('file byte Length ${fileBytes.length}');
      } else {
        print('Permission not granted. Try again with permission access');
      }
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }

    if (!mounted) return;

    setState(() {
      imageFiles!.add(file!);
    });
  }

  void filesPicker() async {
    Navigator.of(context).pop();
    if (imageFiles == null) {
      imageFiles = [];
    }
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for (File file in files) {
        Uint8List fileBytes = file.readAsBytesSync();
        print('file byte Length ${fileBytes.length}');
      }

      setState(() {
        imageFiles!.addAll(files);
      });
    }
  }

  Widget getTextField({
    required String hintTxt,
    required String labelTxt,
    required Icon icon,
    required TextEditingController controller,
    required TextInputType textInputType,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 3.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0.r),
      ),
      child: TextFormField(
        autocorrect: true,
        enableInteractiveSelection: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$labelTxt is required.';
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
          labelText: labelTxt + '*',
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 16.0.sp,
        ),
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Form(
        key: formKey,
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0.r),
                topRight: Radius.circular(30.0.r),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 25.0.h,
                  left: 16.0.w,
                  right: 16.0.w,
                ),
                child: Column(
                  children: <Widget>[
                    //CustomDropdown(text: 'Call to nothing'),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0.w,
                        vertical: 2.0.h,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.textFieldColor,
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                      child: DropdownButtonFormField(
                        dropdownColor: Colors.white,
                        decoration: InputDecoration.collapsed(hintText: ''),
                        //underline: SizedBox(),
                        value: _roomType,
                        hint: Text(
                          'Select Room/Type',
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
                        validator: (value) =>
                            value == null ? 'Room/Type is required*' : null,
                        items: StaticData.roomTypesCottage.map(
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
                            _roomType = val as String?;
                            print('Yeah: ' + _roomType!);
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 4.0.h),
                    getTextField(
                      hintTxt: '4800.00',
                      labelTxt: 'Price',
                      icon: Icon(
                        Icons.money,
                        color: MyColors.primaryColor,
                      ),
                      controller: priceController,
                      textInputType: TextInputType.number,
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0.r),
                      ),
                      child: TextFormField(
                        autocorrect: true,
                        enableInteractiveSelection: true,
                        validator: (value) {
                          if (value == null && value!.isEmpty) {
                            return 'Title is required.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.title,
                              color: MyColors.primaryColor,
                            ),
                          ),
                          filled: false,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: 'An incredible room the bachelar',
                          labelText: 'Title*',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 16.0.sp,
                        ),
                        controller: titleController,
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0.r),
                      ),
                      child: TextFormField(
                        autocorrect: true,
                        enableInteractiveSelection: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.description,
                              color: MyColors.primaryColor,
                            ),
                          ),
                          filled: false,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText:
                              'A stylish great room suitable for a stylish',
                          labelText: 'Description*',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 16.0.sp,
                        ),
                        controller: decriptionController,
                      ),
                    ),
                    SizedBox(height: 4.0.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0.w,
                        vertical: 2.0.h,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.textFieldColor,
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                      child: DropdownButtonFormField(
                        dropdownColor: Colors.white,
                        decoration: InputDecoration.collapsed(hintText: ''),
                        //underline: SizedBox(),
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
                        validator: (value) =>
                            value == null ? 'Province is required*' : null,
                        items: StaticData.provinces.map(
                          (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(
                                val,
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(() {
                            _province = val as String?;
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
                        color: MyColors.textFieldColor,
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                      child: DropdownButtonFormField(
                        dropdownColor: Colors.blueGrey[100],
                        decoration: InputDecoration.collapsed(hintText: ''),
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0.r),
                      ),
                      child: TextFormField(
                        autocorrect: true,
                        enableInteractiveSelection: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Suburb is required.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.location_city,
                              color: MyColors.primaryColor,
                            ),
                          ),
                          filled: false,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: 'Midrand',
                          labelText: 'Suburb*',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 16.0.sp,
                        ),
                        controller: suburbController,
                      ),
                    ),
                    SizedBox(height: 3.0.h),
                    IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        color: MyColors.primaryColor,
                        size: 40.0.sp,
                      ),
                      tooltip: 'Add Images',
                      onPressed: () {
                        showModalBottomSheet<int>(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Popover(
                              child: Padding(
                                padding: EdgeInsets.zero,
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height /
                                      3.8.h,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(
                                      parent: BouncingScrollPhysics(),
                                    ),
                                    itemCount: 1,
                                    itemBuilder: (BuildContext context, index) {
                                      return GestureDetector(
                                        onTap: () => Navigator.of(context)
                                            .pop(), // Closing the sheet.
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 8.h,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0.r),
                                            ),
                                          ),
                                          child: Container(
                                              child: Column(
                                            children: <Widget>[
                                              Text(
                                                'Upload Picture',
                                                style: TextStyle(
                                                  fontSize: 24.0.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: filePicker,
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.photo_camera,
                                                    color:
                                                        MyColors.primaryColor,
                                                  ),
                                                  title: Text(
                                                    "Take picture",
                                                    style: TextStyle(
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                thickness: 1.0,
                                              ),
                                              GestureDetector(
                                                onTap: filesPicker,
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.photo_album,
                                                    color:
                                                        MyColors.primaryColor,
                                                  ),
                                                  title: Text(
                                                    "Browse picture",
                                                    style: TextStyle(
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ).whenComplete(() {
                          //Navigator.of(context).pop();
                        });
                      },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 24.h,
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imageFiles != null
                              ? Container(
                                  height: 70.0.h,
                                  padding: EdgeInsets.all(1.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.grey,
                                          Colors.white,
                                        ]),
                                  ),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imageFiles != null
                                        ? imageFiles!.length
                                        : 0,
                                    itemBuilder: (context, index) {
                                      final imageFile = imageFiles![index];
                                      if (imageFiles!.length <= 0) {
                                        return SizedBox.shrink();
                                      } else {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 8.h,
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 8.h,
                                          ),
                                          width: 75.0.w,
                                          child: IconButton(
                                            splashColor: MyColors.primaryColor,
                                            icon: Icon(
                                              Icons.cancel_outlined,
                                              size: 40.sp,
                                              color: Colors.black54,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                imageFiles!.removeAt(imageFiles!
                                                    .indexOf(imageFile));
                                              });
                                            },
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                              image: FileImage(imageFile),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.blueGrey,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            var price = double.parse(priceController.text.toString());
            if (imageFiles != null && imageFiles!.length > 0) {
              Advert advert = Advert(
                roomType: _roomType!.toLowerCase(),
                price: price,
                title: titleController.text.toLowerCase(),
                decription: decriptionController.text.toLowerCase(),
                province: _province!.toLowerCase(),
                city: _city!.toLowerCase(),
                suburb: suburbController.text.toLowerCase(),
                userId: widget.idUser,
                email: widget.email,
                status: 'pending',
              );
              FireBusinessApi.addAdvert(advert, imageFiles!).then((result) {
                showDialog(
                  context: context,
                  builder: (context) => DialogBoxPost(
                    title: '${advert.title}',
                    descrition:
                        'Your post is under review, you will receive an email when it has been declined or approved',
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    contactNumber: widget.contactNumber,
                    idUser: widget.idUser,
                    isContinue: true,
                  ),
                );
              }).catchError((e) {
                debugPrint('${e.toString()}');
              });
            } else {
              Fluttertoast.showToast(
                backgroundColor: Colors.black38.withOpacity(0.8),
                msg: 'Aleast 1 Image is required.',
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.redAccent,
                toastLength: Toast.LENGTH_LONG,
                fontSize: 16.sp,
              );
            }
          }
        },
        child: Icon(
          Icons.check,
          color: Colors.white70,
        ),
        backgroundColor: MyColors.primaryColor,
      ),
    );
  }
}
