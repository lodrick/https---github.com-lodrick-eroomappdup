import 'package:eRoomApp/models/token.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static String? contactNumber;
  static String? prefIdUser;
  static saveContactNumber(String contactNumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('contactNumber', contactNumber);
  }

  static Future setProfileUserUrl(String imageUrl) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('profileimageUrl', imageUrl);
  }

  static Future<String> getContactNumber() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    contactNumber = (preferences.getString('contactNumber') ?? '0');
    return contactNumber!;
  }

  static saveIdUser(String idUser) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('idUser', idUser);
  }

  static Future<String> getIdUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    prefIdUser = (preferences.getString('idUser') ?? '');
    return prefIdUser!;
  }

  static saveTokenData(Token token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('auth_token', token.authToken!);
    preferences.setString('message', token.message!);
    preferences.setString('id', token.id!);
    preferences.setString('first_name', token.firstName!);
    preferences.setString('last_name', token.lastName!);
    preferences.setString('email', token.email!);
  }

  static saveUserSatus(String userStatus) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userStatus', userStatus);
  }

  static Future<String> getUserStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('userStatus')!;
  }

  static Future bookMarkFavourates(List<String> idPosts) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('idposts', idPosts);
  }

  static Future<List<String>> getBookMarkFavourates() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getStringList('idposts')!;
  }
}
