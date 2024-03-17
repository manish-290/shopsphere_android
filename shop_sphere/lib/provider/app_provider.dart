import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_sphere/firebase_helper/firebase_storage.dart';
import 'package:shop_sphere/firebase_helper/firestore_helper.dart';
import 'package:shop_sphere/model/product_model/product_model.dart';

import '../model/userModel/user_model.dart';

class AppProvider with ChangeNotifier {
//for adding to the cart
  final List<ProductModel> _cartProductList = [];

  UserModel? _userModel;
  UserModel get getUserInformation => _userModel!;

  //property to store the user id
   String _userId='';
  String get getUserId => _userId;

  void getUserInfo() async {
    UserModel userdata = 
    await FirebaseFirestoreHelper.instance.getUserInformation() ;
    _userId = userdata.id;
    _userModel = await FirebaseFirestoreHelper.instance.getUserInformation();
    notifyListeners();
  }

  //get the updated info of user
  void updateUserInfo(
      BuildContext context, UserModel userModel, File? file) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(content: Builder(builder: (context) {
              return SizedBox(
                  width: 100,
                  height: 100,
                  child: Column(
                    children: [
                      const CircularProgressIndicator(
                        color: Color.fromARGB(255, 2, 56, 100),
                      ),
                      SizedBox(height: 15),
                      Container(
                          margin: EdgeInsets.only(left: 7),
                          child: Text("Loading...",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold, fontSize: 16)))
                    ],
                  ));
            })));
    //for added dialog

    if (file == null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userModel.id)
          .set(userModel.toJson());
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      String imageUrl =
          await FirebaseStorageHelper.instance.uploadUserFiles(file);
      _userModel = userModel.copyWith(image: imageUrl);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
    }
    

    showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) => AlertDialog(content: Builder(builder: (context) {
              return SizedBox(
                  width: 50,
                  height: 50,
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 7),
                          child: Column(
                            children: [
                              Icon(
                                Icons.check_box,
                                color: Colors.green,
                              ),
                              Text("Updated!",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: const Color.fromARGB(
                                          255, 2, 66, 118))),
                            ],
                          ))
                    ],
                  ));
            })));
    notifyListeners();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  void addCartProduct(ProductModel productModel) {
    _cartProductList.add(productModel);
    notifyListeners();
  }

  void removeCartProduct(ProductModel productModel) {
    _cartProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getCartProductList => _cartProductList;

//for favourites
  final List<ProductModel> _favouriteProductList = [];

  void addFavouriteProduct(ProductModel productModel) {
    _favouriteProductList.add(productModel);
    notifyListeners();
  }

  void removeFavouriteProduct(ProductModel productModel) {
    _favouriteProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getFavouriteProductList => _favouriteProductList;


double totalPrice(){
  double totalprice =0.0;
  for(var product in _cartProductList){
    double price = double.parse(product.price);

    totalprice += price * product.counter!;
  }
  return totalprice;
}
double totalPriceBuyProductsList(){
  double totalprice =0.0;
  for(var product in _buyProductsList){
    double price = double.parse(product.price);

    totalprice += price * product.counter!;
  }
  return totalprice;
}

double IndividualPrice(ProductModel productModel){
  double Indprice =0.0;
 
    double price = double.parse(productModel.price);
    Indprice = price * productModel.counter!;
  return Indprice;
}


  void updateQuantity(ProductModel productModel, double counter){
    int index = _cartProductList.indexOf(productModel);
    _cartProductList[index].counter= counter;
    notifyListeners();
  }

  //add the buy products
  final List<ProductModel> _buyProductsList=[];
  List<ProductModel> get getBuyProductsList=>_buyProductsList;

  void addBuyProducts(ProductModel productModel){
    _buyProductsList.add(productModel);
    notifyListeners();
  }


  //add the list from cart
   void addBuyProductsCartList(){
    _buyProductsList.addAll(_cartProductList);
    notifyListeners();
  }
  //clear the cart list
   void clearCartList(){
    _cartProductList.clear();
    notifyListeners();
  }
  //clear buy product
   void clearBuyProducts(){
    _buyProductsList.clear();
    notifyListeners();
  }
}
