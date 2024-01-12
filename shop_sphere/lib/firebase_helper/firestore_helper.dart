import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shop_sphere/model/product_model/product_model.dart';
import '../model/category_model.dart';
import '../model/order_model.dart';
import '../model/userModel/user_model.dart';

class FirebaseFirestoreHelper {
  FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("catagories").get();

      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();

      return categoriesList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //now time for products
  Future<List<ProductModel>> getBestProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collectionGroup("products").get();

      List<ProductModel> bestProductsList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();

      return bestProductsList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //get category view
  Future<List<ProductModel>> getCategoryViewProducts(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("catagories")
              .doc(id)
              .collection("products")
              .get();

      List<ProductModel> bestProductsList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();

      return bestProductsList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //get the user information for account screen
  Future<UserModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _firebaseFirestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    return UserModel.fromJson(documentSnapshot.data()!);
  }

  //store the order details in firestore
  Future<bool> uploadOrderedproducts(
      List<ProductModel> list, BuildContext context, String payment) async {
    try {
      double totalprice = 0.0;
      for (var element in list) {
        try {
          double price = double.parse(element.price);
          totalprice += price * element.counter!;
          print("no error");
        } catch (e) {
          print("error parsing the price :${e.toString()}");
        }
      }
      DocumentReference documentReference = _firebaseFirestore
          .collection("UsersOrder")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .doc();
String uid= FirebaseAuth.instance.currentUser!.uid;
      documentReference.set({
        "products": list.map((e) => e.toJson()),
        "totalprice": totalprice,
        'payment': payment,
        "status": "Pending",
        "userId":uid,
        "orderId": documentReference.id
      });
      //for admin
      DocumentReference admin = _firebaseFirestore.collection("orders").doc(documentReference.id);
 
      admin.set({
        "products": list.map((e) => e.toJson()),
        "totalprice": totalprice,
        'payment': payment,
        "status": "Pending",
        "userId":uid,
        "orderId": admin.id,
      });

      return true;
    } catch (e) {
      return false;
    }
  }


//using stream to get the user order
Stream<List<OrderModel>> getUserOrder(BuildContext context) {
  try {
    var userUid = FirebaseAuth.instance.currentUser?.uid;

    if (userUid == null) {
      return Stream.error("User not logged in");
    }

    var ordersCollection = _firebaseFirestore
        .collection("UsersOrder")
        .doc(userUid)
        .collection('orders');

    return ordersCollection.snapshots().map((querySnapshot) {
      List<OrderModel> orderList = querySnapshot.docs
          .map((element) => OrderModel.fromJson(element.data()))
          .toList();
      return orderList;
    });
  } catch (e) {
    print(e.toString());
    return Stream.error("Failed to get user orders");
  }
}

// get user orrder
  // Future<List<OrderModel>> getUserOrder(BuildContext context) async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore
  //             .collection("UsersOrder")
  //             .doc(FirebaseAuth.instance.currentUser!.uid)
  //             .collection('orders')
  //             .get();

  //     List<OrderModel> orderList = querySnapshot.docs
  //         .map((element) => OrderModel.fromJson(element.data()))
  //         .toList();
  //     return orderList;
  //   } catch (e) {
  //     print(e.toString());
  //     return [];
  //   }
  // }

//get the token for the fcm notification
FirebaseFirestoreHelper(){
  FirebaseMessaging firebaseMessage = FirebaseMessaging.instance;
  firebaseMessage.onTokenRefresh.listen((String? newToken) { 
    if(newToken != null ){
      updateTokenFromFirebase(newToken);
    }
  });

  //retrieve the initial fcm token
  FirebaseMessaging.instance.getToken().then((String? initialToken){
    if(initialToken != null){
      updateTokenFromFirebase(initialToken);
    }
  });
}

  Future<void> updateTokenFromFirebase(String newToken) async {
    try {
      // String? token = await FirebaseMessaging.instance.getToken();
      await _firebaseFirestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update({"notificationsToken": newToken});
      print('FCM  token updated');
        } catch (e) {
      print(e.toString());
    }
  }

  //update order

  Future<void> updateOrder(OrderModel orderModel,String status) async{
   await _firebaseFirestore
          .collection("UsersOrder")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc(orderModel.orderId)
          .update({
            "status":status
          });
     await _firebaseFirestore
          .collection("orders")
          .doc(orderModel.orderId)
          .update({
            "status":status
          });

  }
}
