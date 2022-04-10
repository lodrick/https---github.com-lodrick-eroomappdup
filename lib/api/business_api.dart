import 'dart:convert';
import 'dart:io';

import 'package:eRoomApp/models/advert.dart';
import 'package:eRoomApp/models/advert_image.dart';
import 'package:eRoomApp/models/token.dart';
import 'package:eRoomApp/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
//import 'package:path_provider/path_provider.dart';

class BusinessApi {
  static String url = 'https://radiant-tundra-36813.herokuapp.com/api/v1/';

  static Future getUser({userId, authTohen}) async {
    int statusCode = 1;
    Map<String, dynamic> jsonData = Map<String, dynamic>();
    await http.get(Uri.parse(url + 'users/' + userId), headers: {
      'Accept': 'application/json',
      'Authorization': authTohen
    }).then((response) {
      print(response.body);
      statusCode = response.statusCode;
      jsonData = jsonDecode(response.body);
    });
    if (statusCode == 200)
      return jsonData;
    else if (statusCode == 401)
      return jsonData;
    else
      throw Exception('User Not found');
  }

  static Future<Token> authenticate(String phoneNumber) async {
    int statusCode = 1;
    Map<String, dynamic> jsonData = Map<String, dynamic>();
    await http.post(Uri.parse(url + 'auth/login'), headers: {
      'Accept': 'application/json',
    }, body: {
      'phone_number': phoneNumber,
      'password': 'password',
    }).then((response) {
      //print(response.statusCode);
      print(response.body);
      statusCode = response.statusCode;
      jsonData = jsonDecode(response.body);
    }).catchError((e) {
      print('Error login for api ' + e.toString());
    });

    if (statusCode == 200) {
      return Token(data: jsonData, statusCode: statusCode);
    } else if (statusCode == 401) {
      print('This is an invalid user, yes statusCode= $statusCode');
      return Token(data: jsonData, statusCode: statusCode);
    } else if (statusCode == 500) {
      return Token(data: jsonData, statusCode: statusCode);
    } else {
      throw Exception('Login failled');
    }
  }

  static Future signUp(User user) async {
    int statusCode = 1;
    Map<String, dynamic> jsonData = Map<String, dynamic>();
    await http.post(Uri.parse(url + 'signup'), headers: {
      'Accept': 'application/json',
    }, body: {
      'first_name': user.name,
      'last_name': user.surname,
      'email': user.email,
      'password': user.password,
      'password_confirmation': user.password,
      'country': user.country,
      'phone_number': user.contactNumber,
      'user_type': user.userType,
    }).then((response) {
      statusCode = response.statusCode;
      jsonData = jsonDecode(response.body);
    });

    if (statusCode == 200)
      return User.fromJson(jsonData);
    else
      Exception();
  }

  static Future<bool> addAdvert(Advert advert, authToken) async {
    int statusCode = 1;

    final msg = jsonEncode(advert.toJson());
    print(msg);
    await http
        .post(Uri.parse(url + 'adverts'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': authToken
            },
            body: msg)
        .then((response) {
      statusCode = response.statusCode;
    }).catchError((e) {
      print(e.toString());
    });

    if (statusCode == 201)
      return true;
    else
      Exception("Error adding ad.");
    return false;
  }

  static Stream<List<Advert>> requestAdverts(String authToken) async* {
    List<Advert> adverts = [];
    List<AdvertImage> advertsTpUrl = [];
    var response = await http.get(Uri.parse(url + 'adverts'), headers: {
      'Accept': 'application/json',
      'Authorization': authToken,
    });
    var extractData = jsonDecode(response.body);
    var tempAdverts = extractData[1]['adverts'] as List;
    var tempImages = extractData[0]['images'] as List;

    List<Advert> advertsTp =
        tempAdverts.map((advert) => Advert.fromJson(advert)).toList();

    List<AdvertImage> advertImages = tempImages
        .map((advertImage) => AdvertImage.fromJson(advertImage))
        .toList();

    for (Advert advert in advertsTp) {
      for (AdvertImage advertImage in advertImages) {
        if (advert.id == advertImage.advertId) {
          advertsTpUrl.add(advertImage);
        }
      }
      //advert.advertImages = advertsTpUrl;
      adverts.add(advert);
      advertsTpUrl = [];
    }

    yield adverts;
  }

  static Future<int?> updateAdvert(
      Advert advert, String advertId, String authToken) async {
    Uri url = Uri.parse(
        'https://radiant-tundra-36813.herokuapp.com/api/v1/adverts/' +
            advertId);
    final imageUploadRequest = http.MultipartRequest('PUT', url);
    imageUploadRequest.headers['Authorization'] = authToken;
    // Attach the file in the request
    imageUploadRequest.fields['room_type'] = advert.roomType!;
    imageUploadRequest.fields['price'] = advert.price.toString();
    imageUploadRequest.fields['title'] = advert.title!;
    imageUploadRequest.fields['description'] = advert.decription!;
    imageUploadRequest.fields['province'] = advert.province!;
    imageUploadRequest.fields['city'] = advert.city!;
    imageUploadRequest.fields['suburb'] = advert.suburb!;
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Advert Successfully Created.');
        return 200;
      } else {
        print('Advert not Successfully Created');
        return null;
      }
      //final responseData = json.decode(response.body);
      //return responseData;
    } catch (e) {
      print('Whats wrong ' + e.toString());
      return null;
    }
  }

  static Uri apiUrl =
      Uri.parse('https://radiant-tundra-36813.herokuapp.com/api/v1/adverts');

  static Future<List<dynamic>?> uploadAdvert(
      List<File> imageFiles, Advert advert, String authToken) async {
    List<MultipartFile> newImageList = [];

    for (File file in imageFiles) {
      final mimeTypeData =
          lookupMimeType(file.path, headerBytes: [0xFF, 0xD8])?.split('/');
      var multiPartFile = await http.MultipartFile.fromPath(
          'images[]', file.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      newImageList.add(multiPartFile);
    }

    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', apiUrl);
    imageUploadRequest.headers['Authorization'] = authToken;

    // Attach the file in the request
    imageUploadRequest.files.addAll(newImageList);
    imageUploadRequest.fields['room_type'] = advert.roomType!;
    imageUploadRequest.fields['price'] = advert.price.toString();
    imageUploadRequest.fields['title'] = advert.title!;
    imageUploadRequest.fields['description'] = advert.decription!;
    imageUploadRequest.fields['province'] = advert.province!;
    imageUploadRequest.fields['city'] = advert.city!;
    imageUploadRequest.fields['suburb'] = advert.suburb!;

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 201) {
        print('Advert Successfully Created.');
      } else {
        print('Advert not Successfully Created');
        return null;
      }
      final List<dynamic> responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      print('Whats wrong ' + e.toString());
      return null;
    }
  }

  static Future<bool> createFavouriteAdvert(userId, advertId, authToken) async {
    int statusCode = 1;

    await http.post(Uri.parse(url + '/users/' + userId + '/adverts'), headers: {
      'Accept': 'application/json',
      'Authorization': authToken,
    }, body: {}).then((response) {
      statusCode = response.statusCode;
    }).catchError((error) {
      print(error.toString());
    });

    if (statusCode == 200) {
      print("Favorite ad succesfully add");
      return true;
    } else {
      print("Error Adding Favourite");
      Exception('Error Adding Favourite');
      return false;
    }
  }

  static Stream<List<Advert>> getFavouriteAdvert(userId, authToken) async* {
    List<Advert> adverts = [];
    List<AdvertImage> advertsTpUrl = [];
    var response = await http
        .get(Uri.parse(url + '/users/' + userId + '/adverts'), headers: {
      'Accept': 'application/json',
      'Authorization': authToken,
    });

    var extractData = jsonDecode(response.body);
    var tempAdverts = extractData[1]['adverts'] as List;
    var tempImages = extractData[0]['images'] as List;

    List<Advert> advertsTp =
        tempAdverts.map((advert) => Advert.fromJson(advert)).toList();

    List<AdvertImage> advertImages = tempImages
        .map((advertImage) => AdvertImage.fromJson(advertImage))
        .toList();

    for (Advert advert in advertsTp) {
      for (AdvertImage advertImage in advertImages) {
        if (advert.id == advertImage.advertId) {
          advertsTpUrl.add(advertImage);
        }
      }
      //advert.advertImages = advertsTpUrl;
      adverts.add(advert);
    }

    yield adverts;
  }
}
