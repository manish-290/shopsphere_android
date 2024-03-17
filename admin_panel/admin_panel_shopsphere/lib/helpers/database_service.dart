import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

//create firestore object

  final CollectionReference Collection =
  FirebaseFirestore.instance.collection('admin info');

  Future updateUserData(String email, String username, String password) async {
    return await Collection.doc(uid).set({
      'uid': uid,
      'email': email,
      'password': password,
      'username': username
    });
  }

}
