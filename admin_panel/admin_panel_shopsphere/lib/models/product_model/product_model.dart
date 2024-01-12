// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String id, categoryId;
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
    required this.categoryId,
    this.counter,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      id: json["id"]?.toString()??"",
      name: json["name"]??"",
      categoryId: json["categoryId"] ?? "",
      image: json["image"]??"",
      price: json["price"]??"",
      description: json["description"]??"",
      status: json["status"]??"",
      isFavourite: false,
      counter: (json["counter"] as num?)?.toDouble()
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryId": categoryId,
        "name": name,
        "image": image,
        "price": price,
        "description": description,
        "status": status,
        "isFavorite": isFavourite,
        "counter": counter
      };

  ProductModel copyWith(
          {String? name,
          String? image,
          String? description,
          String? id,
          String? categoryId,
          String? price}) =>
      ProductModel(
          id: id ?? this.id,
          name: name ?? this.name,
          image: image ?? this.image,
          price: price ?? this.price,
          description: description ?? this.description,
          status: status,
          isFavourite: isFavourite,
          counter:1.0,
          categoryId: categoryId ?? this.categoryId);
}
