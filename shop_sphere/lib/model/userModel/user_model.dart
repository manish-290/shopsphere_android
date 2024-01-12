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
  String password;

  UserModel(
      {required this.id,
      required this.image,
      required this.password,
      required this.name,
      required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      image: json["image"],
      password: json["password"],
      name: json["name"],
      email: json["email"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "image": image, "name": name,"password":password, "email": email};
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
