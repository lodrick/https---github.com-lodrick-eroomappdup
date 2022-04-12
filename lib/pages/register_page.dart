import 'package:eRoomApp/models/user_model.dart';
import 'package:eRoomApp/pages/main_posts_page.dart';
import 'package:eRoomApp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../api/firebase_api.dart';

class RegisterPage extends StatefulWidget {
  final String phoneNumber;
  const RegisterPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    firstNameController.clear();
    lastNameController.clear();
    contactNumberController.clear();
    emailController.clear();
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
        if ((value == null && value!.isEmpty)) {
          //!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)
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

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: MyColors.textFieldColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.h,
              floating: true,
              pinned: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.bottomRight,
                    end: FractionalOffset.topRight,
                    stops: const [.02, .8],
                    colors: [
                      const Color.fromARGB(255, 191, 210, 214).withOpacity(.6),
                      MyColors.primaryColor,
                    ],
                  ),
                ),
                child: const FlexibleSpaceBar(
                  background: Image(
                    image: AssetImage('assets/img/black-house.jpeg'),
                    fit: BoxFit.fill,
                  ),
                  collapseMode: CollapseMode.pin,
                  title: Text(
                    'Profile Details',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    softWrap: true,
                  ),
                ),
              ),
              actions: [],
            ),
            buildRegisterWidget()
          ],
        ),
        bottomNavigationBar: buildRegisterButton(formKey),
      ),
    );
  }

  Widget buildRegisterWidget() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: MyColors.kBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0.r),
                topRight: Radius.circular(30.0.r),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            child: SingleChildScrollView(
                child: Container(
              child: Column(
                children: [
                  getTextField(
                    hint: 'John',
                    labelText: 'Name:',
                    controller: firstNameController,
                    errorText: 'Please enter your name',
                  ),
                  SizedBox(height: 16.h),
                  getTextField(
                      hint: 'Doe',
                      labelText: 'Surname:',
                      controller: lastNameController,
                      errorText: 'Please enter your surname'),
                  SizedBox(height: 16.h),
                  getTextField(
                    hint: 'john.doe@gmail.com',
                    labelText: 'Email:',
                    controller: emailController,
                    errorText: 'Please enter your email',
                  ),
                ],
              ),
            )),
          ),
        ),
      );

  Widget buildRegisterButton(formKey) => Container(
        color: MyColors.textFieldColor,
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 5.h,
        ),
        height: 70.h,
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      User user = User(
                        name: firstNameController.text.trim(),
                        surname: lastNameController.text.trim(),
                        contactNumber: widget.phoneNumber.trim(),
                        email: emailController.text.trim(),
                        country: 'South Africa',
                        imageUrl:
                            'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pngfind.com%2Fmpng%2FmJbmTb_png-file-svg-add-employee-icon-transparent-png%2F&psig=AOvVaw26wyGBlxMUHpu2LNYOjDJg&ust=1626003509118000&source=images&cd=vfe&ved=0CAoQjRxqFwoTCJDWw6O12PECFQAAAAAdAAAAABAD',
                        lastMessageTime: DateTime.now(),
                        password: 'password',
                        userType: 'client',
                      );

                      FirebaseApi.addUser(user).then((result) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainPostsPage(
                              firstName: '${result!.name}',
                              lastName: '${result.surname}',
                              email: '${result.email}',
                              contactNumber: '${result.contactNumber}',
                              idUser: '${result.idUser}',
                            ),
                          ),
                        );
                        Fluttertoast.showToast(
                          msg: 'User Successfully saved.',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: MyColors.darkTextColor,
                          textColor: Colors.white,
                          fontSize: 16.sp,
                        );
                      }).catchError((e) {
                        debugPrint('Error adding a user from firestore: ' +
                            e.toString());
                      });
                    }
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: MyColors.borderColor,
                      ),
                    ),
                    foregroundColor: MaterialStateProperty.all(
                      MyColors.darkTextColor,
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      MyColors.primaryColor,
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    textStyle: MaterialStateProperty.all(
                      TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.h,
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.h,
                        ),
                        child: Icon(
                          FontAwesomeIcons.solidArrowAltCircleRight,
                          size: 25.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
