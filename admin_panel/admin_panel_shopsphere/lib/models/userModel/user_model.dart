// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel UserModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String UserModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String id;
  String? image;
  String name;
  String email;
  String? notificationToken;
  String password;

  UserModel(
      {required this.id,
      required this.image,
      required this.name,
       this.notificationToken,
      required this.email, required this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      notificationToken: json["notificationToken"]??"",
      image: json["image"],
      name: json["name"],
      password: json["password"],
      email: json["email"]);

  Map<String, dynamic> toJson() =>
      {"id": id,
      "notificationToken":notificationToken,
       "image": image,
        "name": name,
         "email": email};
  @override
  UserModel copyWith({
    String? name,
    image,
  }) =>
      UserModel(
          id: id,
          password: password,
          name: name ?? this.name,
          image: image ?? this.image,
          email: email);
}
