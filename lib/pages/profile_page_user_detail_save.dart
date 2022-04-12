import 'dart:io';
import 'dart:typed_data';

import 'package:eRoomApp/api/firebase_api.dart';
import 'package:eRoomApp/shared/sharedPreferences.dart';
import 'package:eRoomApp/stores/login_store.dart';
import 'package:eRoomApp/widgets/loader_hud.dart';
import 'package:eRoomApp/widgets/popover.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:eRoomApp/models/user_model.dart';
import 'package:eRoomApp/theme.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;

class ProfilePageUserDetailSave extends StatefulWidget {
  final String? imageUrl;
  final String? currentIdUser;

  ProfilePageUserDetailSave({
    this.imageUrl,
    this.currentIdUser,
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePageUserDetailSaveState createState() =>
      _ProfilePageUserDetailSaveState();
}

class _ProfilePageUserDetailSaveState extends State<ProfilePageUserDetailSave> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userShortDescriptionController =
      TextEditingController();
  String? _idUser;
  String _userDesc = 'User availability status description...';
  String? phoneNumber;
  var imageUrl;

  @override
  void initState() {
    super.initState();
    SharedPrefs.getUserStatus().then((value) {
      setState(() {
        if (value != null) {
          _userDesc = value;
        }
      });
    });
  }

  @override
  void dispose() {
    firstNameController.clear();
    lastNameController.clear();
    contactNumberController.clear();
    emailController.clear();
    userShortDescriptionController.clear();
    super.dispose();
  }

  _uploadImageFromCamera() async {
    final _imagePicker = ImagePicker();
    PickedFile? image;

    //var firebaseUser = FirebaseAuth.instance.currentUser;

    //User? userUpdateInfo;
    //Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      // ignore: deprecated_member_use
      image = await _imagePicker.getImage(source: ImageSource.camera);
      var file = File(image!.path);
      String fileName = image.path.split('/').last;
      print(fileName);
      // ignore: unnecessary_null_comparison
      if (file != null) {
        //Upload to Firebase
        String fileName = Path.basename(file.path);
        Uint8List fileByte = file.readAsBytesSync();

        var snapshot = await FirebaseStorage.instance
            .ref()
            .child('profiles/${widget.currentIdUser}/$fileName')
            .putData(fileByte);

        var downLoadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downLoadUrl;
          FirebaseApi.uploadImageUrl(downLoadUrl, widget.currentIdUser);
          //userUpdateInfo!.photoURL = downLoadUrl;
          //firebaseUser.updateProfile(userUpdateInfo);
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try again with permission access');
    }
  }

  _uploadImageFromLocal() async {
    final _imagePicker = ImagePicker();
    PickedFile? image;

    //var firebaseUser = FirebaseAuth.instance.currentUser;
    //User userUpdateInfo;
    //Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      // ignore: deprecated_member_use
      image = await _imagePicker.getImage(source: ImageSource.gallery);
      var file = File(image!.path);

      // ignore: unnecessary_null_comparison
      if (file != null) {
        String fileName = Path.basename(file.path);
        Uint8List fileByte = file.readAsBytesSync();

        var snapshot = await FirebaseStorage.instance
            .ref()
            .child('profiles/${widget.currentIdUser}/$fileName')
            .putData(fileByte);

        var downLoadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downLoadUrl;
          FirebaseApi.uploadImageUrl(downLoadUrl, widget.currentIdUser);

          //userUpdateInfo.photoUrl = downLoadUrl;
          //firebaseUser.updateProfile(userUpdateInfo);
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try again with permission access');
    }
  }

  Widget getTextField({
    required String hint,
    required String labelText,
    required TextEditingController controller,
    required String errorText,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if ((value == null && value!.isEmpty) ||
            !RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
          //!RegExp(r'^[a-z A-Z]+$').hasMatch(value)

          return errorText;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0.r),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        filled: true,
        fillColor: MyColors.textFieldColor,
        hintText: hint,
        labelText: labelText + '*',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget rowUser({
    required IconData fieldIconData,
    required String text,
    required String desc,
    required String field,
    IconData? iconData,
  }) {
    TextEditingController _controller = TextEditingController();
    _controller.text = text;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Icon(
          fieldIconData,
          color: Theme.of(context).primaryColor,
          size: 28.sp,
        ),
        SizedBox(width: 10.w),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    text,
                    style: TextStyle(
                      color: MyColors.primaryTextColor.withOpacity(.8),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.r),
                                  topRight: Radius.circular(30.r),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Please update your ' +
                                        desc.toLowerCase() +
                                        ':',
                                    style: TextStyle(
                                      color: MyColors.darkTextColor,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextFormField(
                                          controller: _controller,
                                          validator: (value) {
                                            if ((value == null &&
                                                    value!.isEmpty) ||
                                                !RegExp(r'^[A-Za-z0-9]+$')
                                                    .hasMatch(value)) {
                                              //!RegExp(r'^[a-z A-Z]+$').hasMatch(value)

                                              return '';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0.r),
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 0,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 0,
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                              vertical: 14.h,
                                            ),
                                            filled: true,
                                            fillColor: MyColors.textFieldColor,
                                            //-hintText: 'hint',
                                            //labelText: labelText + '*',
                                            hintStyle: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      SizedBox(
                                        width: 40.w,
                                        child: ClipOval(
                                          child: Material(
                                            color: MyColors.primaryColor,
                                            child: InkWell(
                                              splashColor: Colors.blueGrey,
                                              onTap: () {
                                                FirebaseApi.updateUserByField(
                                                  field: field,
                                                  value: _controller.text,
                                                  idUser: _idUser!,
                                                ).then((value) {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        '$desc successfully udapted.',
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        MyColors.darkTextColor,
                                                    textColor: Colors.white,
                                                    fontSize: 16.sp,
                                                  );
                                                }).catchError((onError) {});
                                              },
                                              child: SizedBox(
                                                width: 40.w,
                                                height: 40.h,
                                                child: Icon(
                                                  FontAwesomeIcons.check,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      iconData,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusWidget() {
    TextEditingController _controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _userDesc,
              style: TextStyle(
                color: MyColors.primaryTextColor.withOpacity(.8),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: MyColors.kBackgroundColor,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .16.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            topRight: Radius.circular(30.r),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Status update:',
                              style: TextStyle(
                                color: MyColors.darkTextColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    controller: _controller,
                                    validator: (value) {
                                      if ((value == null && value!.isEmpty) ||
                                          !RegExp(r'^[A-Za-z0-9]+$')
                                              .hasMatch(value)) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 14.h,
                                      ),
                                      filled: true,
                                      //fillColor: MyColors.textFieldColor,
                                      //-hintText: 'hint',
                                      //labelText: labelText + '*',
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                SizedBox(
                                  width: 40.w,
                                  child: ClipOval(
                                    child: Material(
                                      color: MyColors.primaryColor,
                                      child: InkWell(
                                        splashColor: Colors.blueGrey,
                                        onTap: () {
                                          print(_controller.text);
                                          /*setState(() {
                                            _userDesc = _controller.text;
                                          });*/
                                          SharedPrefs.saveUserSatus(
                                              _controller.text);
                                          SharedPrefs.getUserStatus()
                                              .then((value) {
                                            setState(() {
                                              if (value != null) {
                                                _userDesc = value;
                                              }
                                            });
                                          });
                                        },
                                        child: SizedBox(
                                          width: 40.w,
                                          height: 40.h,
                                          child: Icon(
                                            FontAwesomeIcons.check,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.edit,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        const Text(
          'Status',
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _handleFABPressed() {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Popover(
          child: Padding(
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3.8.h,
              child: ListView.builder(
                physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                itemCount: 1,
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 0.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            5.0.r,
                          ),
                        ),
                      ),
                      child: Container(
                          child: Column(
                        children: <Widget>[
                          Text(
                            'Profile Picture',
                            style: TextStyle(
                              fontSize: 24.0.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: _uploadImageFromCamera,
                            child: ListTile(
                              leading: Icon(
                                Icons.photo_camera,
                                color: MyColors.primaryColor,
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
                            onTap: _uploadImageFromLocal,
                            child: ListTile(
                              leading: Icon(
                                Icons.photo_album,
                                color: MyColors.primaryColor,
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
    );
  }

  Widget buildText(String text) => Container(
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: Colors.blueGrey[300],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white70),
          backgroundColor: Colors.transparent,
          title: Text(
            'User Details',
            style: TextStyle(
              fontSize: 22.0.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Container(
            decoration: new BoxDecoration(
              color: MyColors.kBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0.r),
                topRight: Radius.circular(30.0.r),
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height.h,
                child: Column(
                  children: [
                    Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 17.w,
                            vertical: 17.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0.r),
                              topRight: Radius.circular(30.0.r),
                            ),
                            image: new DecorationImage(
                              image: new AssetImage(
                                'assets/img/black-house.jpeg',
                                bundle: null,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          child: GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: MyColors.primaryColor,
                              radius: 50.0.r,
                              backgroundImage: NetworkImage(
                                widget.imageUrl ??
                                    imageUrl ??
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/President_Barack_Obama.jpg/480px-President_Barack_Obama.jpg',
                              ),
                            ),
                            //onTap: uploadImage,
                            onTap: _handleFABPressed,
                          ),
                          top: 105.0.h,
                          left: 16.0.w,
                          right: 16.0.w,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 8.h,
                      ),
                      child: new Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            height: 120.0.h,
                            width: double.maxFinite,
                            color: Colors.white,
                            child: Card(
                              elevation: 5.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.infoCircle,
                                          color: Theme.of(context).primaryColor,
                                          size: 28.sp,
                                        ),
                                        SizedBox(width: 10.w),
                                        Flexible(
                                          child: _statusWidget(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                        ],
                      ),
                    ),
                    Consumer<LoginStore>(builder: (_, loginStore, __) {
                      return Observer(
                        builder: (_) => LoaderHUD(
                          inAsyncCall: loginStore.isLoginLoading,
                          child: FutureBuilder<User?>(
                            future: FirebaseApi.retriveUser(
                                loginStore.firebaseUser.phoneNumber.toString()),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Container(
                                    color: Colors.transparent,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                default:
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                    return buildText(
                                        'Something Went Wrong Try again later, ' +
                                            snapshot.error.toString());
                                  } else {
                                    if (snapshot.data != null) {
                                      if (snapshot.data!.name.isNotEmpty) {
                                        firstNameController.text =
                                            snapshot.data!.name.toString();
                                      }

                                      if (snapshot.data!.surname.isNotEmpty) {
                                        lastNameController.text =
                                            snapshot.data!.surname.toString();
                                      }

                                      if (snapshot.data!.email.isNotEmpty) {
                                        emailController.text =
                                            snapshot.data!.email.toString();
                                      }

                                      if (snapshot
                                          .data!.contactNumber.isNotEmpty) {
                                        contactNumberController.text = snapshot
                                            .data!.contactNumber
                                            .toString();
                                      }
                                      if (snapshot.data!.idUser!.isNotEmpty) {
                                        _idUser =
                                            snapshot.data!.idUser.toString();
                                      }
                                    }

                                    phoneNumber = loginStore
                                        .firebaseUser.phoneNumber
                                        .toString();
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 8.h,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          rowUser(
                                            fieldIconData:
                                                FontAwesomeIcons.userAlt,
                                            text: firstNameController.text,
                                            desc: 'Name',
                                            iconData: Icons.edit,
                                            field: 'name',
                                          ),
                                          const Divider(thickness: 1),
                                          rowUser(
                                            fieldIconData:
                                                FontAwesomeIcons.userAlt,
                                            text: lastNameController.text,
                                            desc: 'Surname',
                                            iconData: Icons.edit,
                                            field: 'surname',
                                          ),
                                          const Divider(thickness: 1),
                                          rowUser(
                                            fieldIconData:
                                                FontAwesomeIcons.envelope,
                                            text: emailController.text,
                                            desc: 'Email',
                                            iconData: Icons.edit,
                                            field: 'email',
                                          ),
                                          const Divider(thickness: 1),
                                          rowUser(
                                            fieldIconData:
                                                FontAwesomeIcons.phone,
                                            text: contactNumberController.text,
                                            desc: 'Phone',
                                            field: 'contactNumber',
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SizedBox.shrink(),
      ),
    );
  }
}
