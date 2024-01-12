// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:shop_sphere/model/product_model/product_model.dart';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  String? orderId;
  double? totalprice;
  String? payment;
  String? status;
  String userId;
  List<ProductModel?> products;

  OrderModel(
      {required this.orderId,
      required this.userId,
      required this.totalprice,
      required this.payment,
      required this.status,
      required this.products});

  factory OrderModel.fromJson(Map<String?, dynamic> json) {
    List<dynamic> productMap = json["products"];
    return OrderModel(
      userId: json["userId"],
        orderId: json["orderId"],
        payment: json["payment"],
        totalprice: json["totalprice"],
        products: productMap.map((e) => ProductModel.fromJson(e)).toList(),
        status: json["status"]);
  }

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "status": status,
        "payment": payment,
        "totalprice": totalprice,
        "products": products,
        "userId":userId
      };
}
