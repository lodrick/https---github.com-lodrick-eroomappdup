class Token {
  int? statusCode;
  String? authToken;
  String? message;
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;

  /*Token({
    this.id,
    this.firstName,
    this.lastName,
    this.email,

    this.authToken,
    this.message,
  });*/
  Token({required Map<String, dynamic> data, required int statusCode}) {
    print('StatusCode $statusCode');
    this.statusCode = statusCode;
    this.authToken = data['auth_token'];
    this.message = data['message'] ?? data['error'];
    this.id = data['id'];
    this.firstName = data['first_name'];
    this.lastName = data['last_name'];
    this.phoneNumber = data['phone_number'];
    this.email = data['email'];
  }
}
