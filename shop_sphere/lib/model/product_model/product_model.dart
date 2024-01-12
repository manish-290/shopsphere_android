// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    String id;
    String name;
    String image;
    String price;
    String description;
    String status;
    bool isFavourite;
    double? counter;

    ProductModel({
        required this.id,
        required this.name,
        required this.image,
        required this.price,
        required this.description,
        required this.status,
        required this.isFavourite,
         this.counter,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        price:json["price"],
        description:json["description"],
        status:json["status"],
        isFavourite:false,
        counter:json["counter"]

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "price":price,
        "description":description,
        "status":status,
        "isFavorite":isFavourite,
        "counter":counter
    };

    @override
    ProductModel copyWith({
      double? counter
    })=>ProductModel(
      id: id,
       name: name, 
       image: image,
        price: price, 
        description: description, 
        status: status, 
        counter:counter??this.counter,
        isFavourite: isFavourite);
}