import 'dart:io';

import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/theme.dart';
import 'package:eRoomApp/widgets/advert_images_widget.dart';
import 'package:eRoomApp/widgets/popover.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';

class CreatePostPart2 extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String id;
  final String email;
  final String contactNumber;
  final String authToken;
  final Advert? advert;

  CreatePostPart2({
    this.advert,
    required this.authToken,
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.email,
    required this.contactNumber,
    Key? key,
  }) : super(key: key);

  @override
  _CreatePostPart2State createState() => _CreatePostPart2State();
}

class _CreatePostPart2State extends State<CreatePostPart2> {
  // ignore: unused_field
  String _error = 'No Error Detected';
  //List<Asset> images = <Asset>[];
  List<File> imageFiles = <File>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  /*Future<List<File>> fileConvert(List<Asset> resultList) async {
    List<File> files = <File>[];

    //int index = 0; index < resultList.length; index++
    for (Asset asset in resultList) {
      final tempImageFile =
          File("${(await getTemporaryDirectory()).path}/${asset.name}");
      files.add(tempImageFile);
      print(tempImageFile.path);
    }

    return files;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: 'Photos'),
        materialOptions: MaterialOptions(
          actionBarColor: '#FF30C6D1',
          actionBarTitle: 'eRoom App',
          allViewTitle: 'Room Images',
          useDetailsView: true,
          selectCircleStrokeColor: '#000000',
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() async {
      _error = error;

      fileConvert(resultList).then((result) {
        setState(() {
          imageFiles.addAll(result);
          isLoading = false;
        });
      }).catchError((e) {});
    });
  }*/

  _uploadImageFromCamera() async {
    String error = 'No Error Detected';
    final _imagePicker = ImagePicker();
    PickedFile image;
    File? file;
    try {
      //Check Permissions
      await Permission.photos.request();
      var permissionStatus = await Permission.photos.status;
      if (permissionStatus.isGranted) {
        //Select Image
        // ignore: deprecated_member_use
        image = (await _imagePicker.getImage(source: ImageSource.camera))!;
        file = File(image.path);
        print(file.path);
      } else {
        print('Permission not granted. Try again with permission access');
      }
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      _error = error;
      imageFiles.add(file!);
    });
    //print(images.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white70),
        backgroundColor: Colors.transparent,
        title: Text(
          'Create Post',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        elevation: 0.00,
        centerTitle: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<int>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return Popover(
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 3.8,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            itemCount: 1,
                            itemBuilder: (BuildContext context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.all(5.0),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0.0, vertical: 0.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  child: Container(
                                      child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Upload Picture',
                                        style: TextStyle(
                                          fontSize: 24.0,
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
                                        //onTap: loadAssets,
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
                ).whenComplete(() {
                  Navigator.of(context).pop();
                });
              },
              child: Icon(Icons.add_a_photo, size: 25.0),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<int>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Popover(
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 3.8,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  itemCount: 1,
                                  itemBuilder: (BuildContext context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: EdgeInsets.all(.0),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.0, vertical: 0.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Container(
                                            child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Upload Picture',
                                              style: TextStyle(
                                                fontSize: 24.0,
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
                                              //onTap: loadAssets,
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
                    },
                    child: imageFiles.isNotEmpty
                        ? AdvertImgWidget(imageFiles: imageFiles)
                        : Container(
                            height: MediaQuery.of(context).size.height - 100,
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              color: Colors.black12,
                              image: new DecorationImage(
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                                image: NetworkImage(
                                  'https://www.pinclipart.com/picdir/big/126-1266771_post-page-to-add-pictures-comments-add-post.png',
                                  scale: 1.0,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //widget.advert.images = images;
          //print('Creator token: ' + _token);

          // BusinessApi.uploadAdvert(imageFiles, widget.advert, widget.authToken)
          //     .then((advert) {
          //   final snackBar = SnackBar(
          //     behavior: SnackBarBehavior.floating,
          //     backgroundColor: Colors.black38.withOpacity(0.8),
          //     content: Text(
          //       'Your Post has been added.',
          //       style: TextStyle(
          //         color: Colors.white.withOpacity(
          //           0.7,
          //         ),
          //       ),
          //     ),
          //   );
          //   Scaffold.of(context).showSnackBar(
          //     snackBar,
          //   );
          // }).catchError((error) {});
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MainPostsPage(
          //       firstName: widget.firstName,
          //       lastName: widget.lastName,
          //       contactNumber: widget.contactNumber,
          //       authToken: widget.authToken,
          //       email: widget.email,
          //       id: widget.id,
          //     ),
          //   ),
          // );
          print("using firebase");
          //FireBusinessApi.addAdvert(widget.advert);
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
