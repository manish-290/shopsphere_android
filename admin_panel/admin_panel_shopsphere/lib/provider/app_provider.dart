import 'dart:ffi';
import 'dart:io';

import 'package:admin_panel_shopsphere/models/category_model.dart';
import 'package:admin_panel_shopsphere/models/product_model/product_model.dart';
import 'package:flutter/material.dart';
import '../helpers/firestore_helper.dart';
import '../models/order_model.dart';
import '../models/userModel/user_model.dart';

class AppProvider with ChangeNotifier {
  List<UserModel> _userList = [];
  List<CategoryModel> _categoriesList = [];
  List<ProductModel> _productsList = [];
  List<OrderModel> _completedOrderList = [];
    List<OrderModel> _pendingOrderList = [];
  List<OrderModel> _cancelOrderList = [];
  List<OrderModel> _deliveryOrderList = [];
  List<String?> _userToken=[];


double totalEarning = 0.0;

  Future<void> getUserListFirebase() async {
    _userList = await FirebaseFirestoreHelper.instance.getUserList();
  _userToken = _userList.map((e) => e.notificationToken).toList();
    notifyListeners();
  }

  Future<void> getCategoriesListFirebase() async {
    _categoriesList =
        await FirebaseFirestoreHelper.instance.getCategoriesList();
    notifyListeners();
  }

  Future<void> getProductsListFirebase() async {
    _productsList = await FirebaseFirestoreHelper.instance.getProductsList();
    notifyListeners();
  }

  //completed order
  Future<void> getCompletedOrder() async {
    _completedOrderList =
        await FirebaseFirestoreHelper.instance.getCompletedOrderFirebase();
    for(var element in _completedOrderList){
      totalEarning += ( element.totalprice!) as num ;
    }
    notifyListeners();
  }
  //pending order
   Future<void> getPendingOrder() async {
    _pendingOrderList =
        await FirebaseFirestoreHelper.instance.getPendingOrderFirebase();
    notifyListeners();
  }
  //cancel order
    Future<void> getCancelOrder() async {
    _cancelOrderList =
        await FirebaseFirestoreHelper.instance.getCancelOrderFirebase();
   
    notifyListeners();
  }
  //delivery order
     Future<void> getDeliveryOrder() async {
    _deliveryOrderList =
        await FirebaseFirestoreHelper.instance.getDeliveryOrderFirebase();
   
    notifyListeners();
  }

 
  Future<void> deleteUserFromFirebase(UserModel userModel) async {
    notifyListeners();

    String value =
        await FirebaseFirestoreHelper.instance.deleteSingleUser(userModel.id);
    if (value == "Successfully Deleted") {
      _userList.remove(userModel);
    }
    notifyListeners();
  }

 double  get getTotalEarnings => totalEarning;
   List<OrderModel> get getCompletedOrderList => _completedOrderList;
   List<OrderModel> get getCancelOrderList => _cancelOrderList;
   List<OrderModel> get getDeliveryOrderList => _deliveryOrderList;
  List<OrderModel> get getPendingOrderList => _pendingOrderList;
  List<ProductModel> get getProductsList => _productsList;
  List<UserModel> get getUserList => _userList;
  List<CategoryModel> get getCategoriesList => _categoriesList;
  List<String?> get getUsersToken =>_userToken;

  Future<void> callBackFunction() async {
    await getUserListFirebase();
    await getCategoriesListFirebase();
    await getProductsListFirebase();
    getCompletedOrder();
    getPendingOrder();
    getCancelOrder();
    getDeliveryOrder();
  }

//delete category
  Future<void> deleteCategoryFromFirebase(CategoryModel categoryModel) async {
    String value = await FirebaseFirestoreHelper.instance
        .deleteSingleCategory(categoryModel.id);
    if (value == "Successfully Deleted") {
      _categoriesList.remove(categoryModel);
    }
    notifyListeners();
  }

  //delete product
  Future<void> deleteProductFromFirebase(ProductModel productModel) async {
    String value = await FirebaseFirestoreHelper.instance
        .deleteSingleProduct(productModel.categoryId, productModel.id);
    if (value == "Successfully Deleted") {
      _productsList.remove(productModel);
    }
    notifyListeners();
  }

  //update category
  void updateCategoryList(
      BuildContext context, int index, CategoryModel categoryModel) async {
    await FirebaseFirestoreHelper.instance.updateSingleCatagory(categoryModel);
    _categoriesList[index] = categoryModel;
    notifyListeners();
  }

  //update product
  void updateProductList(
      BuildContext context, int index, ProductModel productModel) async {
    await FirebaseFirestoreHelper.instance.updateSingleProduct(productModel);
    _productsList[index] = productModel;
    notifyListeners();
  }

  //add category
  void addCategory(File image, String name) async {
    CategoryModel categoryModel =
        await FirebaseFirestoreHelper.instance.addSingleCatagory(image, name);
    _categoriesList.add(categoryModel);
    notifyListeners();
  }

  //add product
  void addProduct(File image, String name, String description, String price,
      String categoryId, String status) async {
    ProductModel productModel = await FirebaseFirestoreHelper.instance
        .addSingleProduct(image, name, description, price, categoryId, status);
    _productsList.add(productModel);
    notifyListeners();
  }
  void updatePendingOrder(OrderModel orderModel) async{
    _deliveryOrderList.add(orderModel);
   await _pendingOrderList.remove(orderModel);
    notifyListeners();
  }

  void updateCancelDeliveryOrder(OrderModel orderModel){
    _cancelOrderList.add(orderModel);
    _deliveryOrderList.remove(orderModel);
    notifyListeners();
  }
   void updateCancelPendingOrder(OrderModel orderModel){
    _cancelOrderList.add(orderModel);
    _pendingOrderList.remove(orderModel);
    notifyListeners();
  }

  void updateCompletedOrder(OrderModel orderModel){
    _completedOrderList.add(orderModel);
    _deliveryOrderList.remove(orderModel);
    notifyListeners();
  
  }
}
