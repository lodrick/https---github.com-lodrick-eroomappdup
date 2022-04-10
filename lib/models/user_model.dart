import 'package:eRoomApp/utils.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String? idUser;
  final String name;
  final String surname;
  final String email;
  final String password;
  final String country;
  final String contactNumber;
  final String userType;
  final String imageUrl;
  final lastMessageTime;
  final createdAt;
  final updatedAt;
  final String? token;

  User(
      {this.idUser,
      required this.name,
      required this.surname,
      required this.email,
      required this.password,
      required this.country,
      required this.contactNumber,
      required this.userType,
      required this.imageUrl,
      this.lastMessageTime,
      this.createdAt,
      this.updatedAt,
      this.token});

  User copyWith({
    String? idUser,
    String? name,
    String? surname,
    String? email,
    String? password,
    String? country,
    String? contactNumber,
    String? userType,
    String? imageUrl,
    String? lastMessageTime,
    String? createdAt,
    String? updatedAt,
    String? token,
  }) =>
      User(
        idUser: idUser ?? this.idUser,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        password: password ?? this.password,
        country: country ?? this.country,
        contactNumber: contactNumber ?? this.contactNumber,
        userType: userType ?? this.userType,
        imageUrl: imageUrl ?? this.imageUrl,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        token: token ?? this.token,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        idUser: json['idUser'],
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        password: json['password'],
        country: json['country'],
        contactNumber: json['contactNumber'],
        userType: json['userType'],
        imageUrl: json['imageUrl'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'surname': surname,
        'email': email,
        'password': password,
        'country': country,
        'contactNumber': contactNumber,
        'userType': userType,
        'imageUrl': imageUrl,
        'lastMessageTime': lastMessageTime,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'token': token,
      };

  /*factory User.fromJson(final json) {
    return User(
      token: json['token'],
    );
  }*/
}
