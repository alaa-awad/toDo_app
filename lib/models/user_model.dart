class UserModel {
  late String name;
  late String email;
  late String uId;

  UserModel({
    required this.name,
    required this.email,
    required this.uId,
  });

  // json is type from Map<String,dynamic>
  UserModel.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uId': uId,
    };
  }
}
