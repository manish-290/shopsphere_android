import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_sphere/authentication_page/login.dart';
import 'package:shop_sphere/firebase_helper/firebase_firestore.dart';
import 'package:shop_sphere/model/user.dart';
import 'package:shop_sphere/model/userModel/user_model.dart';

class FirebaseAuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseAuthHelper instance = FirebaseAuthHelper();

  //create user object based on firebase User
  User_obj? _userFromFirebaseUser(User user) {
    return user != null ? User_obj(uid: user.uid) : null;
  }

  //it emit out the user objects
//for logout state null object is returned and user object for user object
  Stream<User_obj?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  Future login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      print("Error : $e");
      return null;
    }
  }

  Future signup(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //it converts the userModel data to json format
      // _firestore.collection("users").doc(userModel.id).set(userModel.toJson());
      User? user = result.user;
      UserModel userModel =
          UserModel(id: user!.uid, image: null, name: username, email: email,password: password);

           //it converts the userModel data to json format
      _firestore.collection("users").doc(userModel.id).set(userModel.toJson());
      //create the new document for the user with uid
      await DatabaseService(uid: user!.uid)
          .updateUserData(email, '${password}', username);

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (error) {
      print('Cannot create the user:$error');
      return null;
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
  //delete the user
//   Future<void> deleteUser(String email, String pass,BuildContext context) async {
//   try {
//     User? user = _auth.currentUser;
//     AuthCredential credential = EmailAuthProvider.credential(email: email, password: pass);
//     await user?.reauthenticateWithCredential(credential).then((value){
//       value.user!.delete().then((res){
//         Navigator.push(context, MaterialPageRoute(
//           builder: (context)=>const Login()));
//          const SnackBar(content: Text("User Deleted!"));
//       });
//     });

//   } catch (e) {
//     print('Error deleting user: $e');
//   }
// }
}
