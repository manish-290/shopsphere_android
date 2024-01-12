import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
class FirebaseStorageHelper{
  static FirebaseStorageHelper instance = FirebaseStorageHelper();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String?> uploadCategoryFiles(String id,File image) async{
  try {
    TaskSnapshot taskSnapshot = await _storage.ref(id).putFile(image);
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  } catch (error) {
    print('Error uploading or retrieving URL: $error');
    return null; 
  } 
  
  }


    Future<String?> uploadCategoryNew(String userId,File image) async{
   TaskSnapshot taskSnapshot = await _storage.ref(userId).putFile(image);
   final imageUrl = await taskSnapshot.ref.getDownloadURL();
   return imageUrl;
  }
 
}