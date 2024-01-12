// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:admin_panel_shopsphere/models/product_model/product_model.dart';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  String? orderId;
  double? totalprice;
  String? payment;
  String? status;
  String? userId;
  List<ProductModel?> products;

  OrderModel(
      {required this.orderId,
      required this.totalprice,
      required this.payment,
      required this.status,
      required this.userId,
      required this.products});

  factory OrderModel.fromJson(Map<String?, dynamic> json) {
    List<dynamic> productMap = json["products"];
      double? parsedTotalPrice = parseDouble(json["totalprice"]);

    return OrderModel(
        orderId: json["orderId"],
        userId: json["userId"],
        payment: json["payment"],
        totalprice: parsedTotalPrice,
        products: productMap.map((e) => ProductModel.fromJson(e)).toList(),
        status: json["status"]);
  }

  static double? parseDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "userId":userId,
        "status": status,
        "payment": payment,
        "totalprice": totalprice,
        "products": products
      };
}
