import 'dart:io';

import 'package:admin_panel_shopsphere/helpers/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Admin_model.dart';
import '../models/category_model.dart';
import '../models/order_model.dart';
import '../models/product_model/product_model.dart';
import '../models/userModel/user_model.dart';

class FirebaseFirestoreHelper {
  FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getUserList() async {
   try{
     QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection("users")
            .get();
    return querySnapshot.docs.map(((e) => UserModel.fromJson(e.data()))).toList();
   }catch(e){
    print("Error fetching the list");
    return [];
   }
  }



  //get the admin information for account screen
  Future<AdminModel> getAdminInformation() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await _firebaseFirestore
        .collection("admin info")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return AdminModel.fromJson(documentSnapshot.data()!);
  }

  Future<List<CategoryModel>> getCategoriesList() async {
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

  //delete single user
  Future<String> deleteSingleUser(String id) async {
    try {
       await _firebaseFirestore.collection("users").doc(id).delete();
      return "Successfully Deleted";
    } catch (e) {
      return e.toString();
    }
  }

  //category delete
  Future<String> deleteSingleCategory(String id) async {
    try {
       await _firebaseFirestore.collection("catagories").doc(id).delete();
      await Future.delayed(Duration(seconds: 3), () {});
      return "Successfully Deleted";
    } catch (e) {
      return e.toString();
    }
  }

  //category update
  Future<void> updateSingleCatagory(CategoryModel categoryModel) async {
    try {
      await _firebaseFirestore
          .collection("catagories")
          .doc(categoryModel.id)
          .update(categoryModel.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  //product update
  Future<void> updateSingleProduct(ProductModel productModel) async {
    try {
      await _firebaseFirestore
          .collection("catagories")
          .doc(productModel.categoryId)
          .collection("products")
          .doc(productModel.id)
          .update(productModel.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  //add category
  Future<CategoryModel> addSingleCatagory(File image, String name) async {
    DocumentReference reference =
         _firebaseFirestore.collection("catagories").doc();
    String? imageUrl = await FirebaseStorageHelper.instance
        .uploadCategoryFiles(reference.id, image);
    CategoryModel addCategory =
        CategoryModel(id: reference.id, image: imageUrl!, name: name);
    await reference.set(addCategory.toJson());
    return addCategory;
  }
  //add Product

  Future<ProductModel> addSingleProduct(
      File image,
      String name,
      String description,
      String price,
      String categoryId,
      String status) async {
    DocumentReference reference = await _firebaseFirestore
        .collection("catagories")
        .doc(categoryId)
        .collection("products")
        .doc();

    String? imageUrl = await FirebaseStorageHelper.instance
        .uploadCategoryFiles(reference.id, image);
    ProductModel addProduct = ProductModel(
      categoryId: categoryId,
      image: imageUrl!,
      name: name,
      description: description,
      price: price,
      isFavourite: false,
      status: status,
      id: reference.id,
    );
    await reference.set(addProduct.toJson());
    return addProduct;
  }

  //now time for products
  Future<List<ProductModel>> getProductsList() async {
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

  //delete the products
  Future<String> deleteSingleProduct(
      String categoryId, String productId) async {
    try {
       await _firebaseFirestore.collection("catagories")
       .doc(categoryId)
       .collection("products")
       .doc(productId).delete();
      await Future.delayed(Duration(seconds: 3), () {});
      return "Successfully Deleted";
    } catch (e) {
      return e.toString();
    }
  }

//completed order
  Future<List<OrderModel>> getCompletedOrderFirebase() async {
    QuerySnapshot<Map<String, dynamic>> completedorder =
        await _firebaseFirestore
            .collection("orders")
            .where("status", isEqualTo: "Completed")
            .get();
    List<OrderModel> completedOrderslist =
        completedorder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return completedOrderslist;
  }

  //pending order
  Future<List<OrderModel>> getPendingOrderFirebase() async {
    QuerySnapshot<Map<String, dynamic>> pendingorder =
        await _firebaseFirestore
            .collection("orders")
            .where("status", isEqualTo: "Pending")
            .get();
    List<OrderModel> pendingOrderlist =
        pendingorder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return pendingOrderlist;
  }
  //cancel order
   Future<List<OrderModel>> getCancelOrderFirebase() async {
    QuerySnapshot<Map<String, dynamic>> cancelorder =
        await _firebaseFirestore
            .collection("orders")
            .where("status", isEqualTo: "Cancel")
            .get();
    List<OrderModel> cancelOrderlist =
        cancelorder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return cancelOrderlist;
  }
  //delivery order
    Future<List<OrderModel>> getDeliveryOrderFirebase() async {
    QuerySnapshot<Map<String, dynamic>> deliveryorder =
        await _firebaseFirestore
            .collection("orders")
            .where("status", isEqualTo: "Delivery")
            .get();
    List<OrderModel> deliveryOrderlist =
        deliveryorder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return deliveryOrderlist;
  }


//update order
  Future<void> updateOrder(OrderModel orderModel, String status) async {
  DocumentSnapshot userOrderDoc = await _firebaseFirestore
      .collection("UsersOrder")
      .doc(orderModel.userId)
      .collection("orders")
      .doc(orderModel.orderId)
      .get();

  DocumentSnapshot orderDoc = await _firebaseFirestore
      .collection("orders")
      .doc(orderModel.orderId)
      .get();

  if (userOrderDoc.exists) {
    await userOrderDoc.reference.update({"status": status});
  }

  if (orderDoc.exists) {
    await orderDoc.reference.update({"status": status});
  }
}



  //update order
  //  Future<void> updateOrder(OrderModel orderModel,String status) async{
  //  await _firebaseFirestore
  //         .collection("UsersOrder")
  //         .doc(orderModel.userId)
  //         .collection("orders")
  //         .doc(orderModel.orderId)
  //         .update({
  //           "status":status
  //         });
  //    await _firebaseFirestore
  //         .collection("orders")
  //         .doc(orderModel.orderId)
  //         .update({
  //           "status":status
  //         });

  // }
//   //get category view
//   Future<List<ProductModel>> getCategoryViewProducts(String id) async {
//     try {
//       QuerySnapshot<Map<String, dynamic>> querySnapshot =
//           await _firebaseFirestore
//               .collection("catagories")
//               .doc(id)
//               .collection("products")
//               .get();

//       List<ProductModel> bestProductsList = querySnapshot.docs
//           .map((e) => ProductModel.fromJson(e.data()))
//           .toList();

//       return bestProductsList;
//     } catch (e) {
//       print(e.toString());
//       return [];
//     }
//   }

//   //get the user information for account screen
//   Future<UserModel> getUserInformation() async {
//     DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
//         await _firebaseFirestore
//             .collection("users")
//             .doc(FirebaseAuth.instance.currentUser!.uid)
//             .get();

//     return UserModel.fromJson(documentSnapshot.data()!);
//   }

//   //store the order details in firestore
//   Future<bool> uploadOrderedproducts(
//       List<ProductModel> list, BuildContext context, String payment) async {
//     try {
//       double totalprice = 0.0;
//       for (var element in list) {
//         try {
//           double price = double.parse(element.price);
//           totalprice += price * element.counter!;
//           print("no error");
//         } catch (e) {
//           print("error parsing the price :${e.toString()}");
//         }
//       }
//       DocumentReference documentReference = _firebaseFirestore
//           .collection("UsersOrder")
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection('orders')
//           .doc();

//       documentReference.set({
//         "products": list.map((e) => e.toJson()),
//         "totalprice": totalprice,
//         'payment': payment,
//         "status": "Pending",
//         "orderId": documentReference.id
//       });
//       //for admin
//       DocumentReference admin = _firebaseFirestore.collection("orders").doc();

//       admin.set({
//         "products": list.map((e) => e.toJson()),
//         "totalprice": totalprice,
//         'payment': payment,
//         "status": "Pending",
//         "orderId": admin.id,
//       });

//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

// // get user orrder
//   Future<List<OrderModel>> getUserOrder(BuildContext context) async {
//     try {
//       QuerySnapshot<Map<String, dynamic>> querySnapshot =
//           await _firebaseFirestore
//               .collection("UsersOrder")
//               .doc(FirebaseAuth.instance.currentUser!.uid)
//               .collection('orders')
//               .get();

//       List<OrderModel> orderList = querySnapshot.docs
//           .map((element) => OrderModel.fromJson(element.data()))
//           .toList();
//       return orderList;
//     } catch (e) {
//       print(e.toString());
//       return [];
//     }
//   }

// //get the token for the fcm notification
//   void updateTokenFromFirebase() async {
//     try {
//       String? token = await FirebaseMessaging.instance.getToken();
//       if (token != null) {
//         await _firebaseFirestore
//             .collection("users")
//             .doc(_auth.currentUser!.uid)
//             .update({"notificationsToken": token});
//         print('FCM  token updated');
//       } else {
//         print('fcm token is null');
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }
}
