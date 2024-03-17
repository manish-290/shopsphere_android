// // ignore_for_file: use_build_context_synchronously, unused_import, prefer_final_fields, depend_on_referenced_packages, non_constant_identifier_names
//
// import 'package:admin_panel/constants/constants.dart';
// import 'package:admin_panel/models/admin_model/adminmodel.dart';
// import 'package:admin_panel/models/user_model/user_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class FirebaseAuthHelper {
//   static  FirebaseAuthHelper instance = FirebaseAuthHelper();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Stream<User?> get getAuthChange => _auth.authStateChanges();
//
//   Future<bool> login(
//       String email, String password, BuildContext context) async {
//     try {
//       showLoaderDialog(context);
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       Navigator.of(context,rootNavigator: true).pop();
//       return true;
//     } on FirebaseAuthException catch (error) {
//       Navigator.of(context,rootNavigator: true).pop();
//       showMessage(error.code.toString());
//       return false;
//     }
//   }
//   Future<bool> signUp(
//       String name,String email, String password, BuildContext context) async {
//     try {
//       showLoaderDialog(context);
//
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       AdminModel adminModel = AdminModel(id: userCredential.user!.uid, name: name, email: email);
//
//       _firestore.collection("admin").doc(adminModel.id).set(adminModel.toJson());
//       Navigator.of(context,rootNavigator: true).pop();
//       return true;
//     } on FirebaseAuthException catch (error) {
//       Navigator.of(context,rootNavigator: true).pop();
//       showMessage(error.code.toString());
//       return false;
//     }
//   }
//   void signOut() async{
//     await _auth.signOut();
//   }
//   Future<bool> ChangePassword(
//       String password, BuildContext context) async {
//     try {
//       showLoaderDialog(context);
//       _auth.currentUser!.updatePassword(password);
//       // UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       // UserModel userModel = UserModel(id: userCredential.user!.uid, name: name, email: email,image: null);
//       //
//       // _firestore.collection("users").doc(userModel.id).set(userModel.toJson());
//       Navigator.of(context,rootNavigator: true).pop();
//       showMessage("Password changed");
//       Navigator.of(context).pop();
//       return true;
//     } on FirebaseAuthException catch (error) {
//       showMessage(error.code.toString());
//       return false;
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../models/Admin_model.dart';
import '../models/user.dart';
import '../models/userModel/user_model.dart';
import 'database_service.dart';

class FirebaseAuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseAuthHelper instance = FirebaseAuthHelper();

  //create user object based on firebase User
//   User_obj? _userFromFirebaseUser(User user) {
//     return user != null ? User_obj(uid: user.uid) : null;
//   }
//
//   //it emit out the user objects
// //for logout state null object is returned and user object for user object
//   Stream<User_obj?> get user {
//     return _auth
//         .authStateChanges()
//         .map((User? user) => _userFromFirebaseUser(user!));
//   }
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  Future<bool> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // User? user = result.user;
      // return _userFromFirebaseUser(user!);
      return true;
    } on FirebaseAuthException catch (e) {
      print("Error : $e");
      return false;
    }
  }

  Future<bool> signup(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      AdminModel adminModel = AdminModel(id: result.user!.uid, name: username, email: email);
      _firestore.collection("admin info").doc(adminModel.id).set(adminModel.toJson());
      //it converts the userModel data to json format
      // User? user = result.user;
      // UserModel userModel =
      // UserModel(id: user!.uid, image: null, name: username, email: email,password: password);

      //it converts the userModel data to json format
      // _firestore.collection("admin info").doc(userModel.id).set(userModel.toJson());
      // //create the new document for the user with uid
      // await DatabaseService(uid: user.uid)
      //     .updateUserData(email, '${password}', username);

      // return _userFromFirebaseUser(user);
      return true;
    } on FirebaseAuthException catch (error) {
      print('Cannot create the user:$error');
      return false;
    }

  }

  //update password
  Future updatePassword( String password,BuildContext context) async {
    try {
      _auth.currentUser!.updatePassword(password);
    } on FirebaseAuthException catch (error) {
      print('Cannot create the user:$error');
      return null;
    }
//update password
  }
  //signout
  Future signout() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      print('error meaasge:$error');
    }
  }

}
