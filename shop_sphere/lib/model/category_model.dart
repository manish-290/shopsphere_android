// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

CategoryModel CategoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String CategoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
    String id;
    String image;
    String name;
   

    CategoryModel({
        required this.id,
        required this.image,
        required this.name
 
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        image: json["image"],
        name: json["name"]
      

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name":name
       
    };
}