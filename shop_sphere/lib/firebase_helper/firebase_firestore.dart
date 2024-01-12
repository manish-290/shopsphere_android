import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shop_sphere/model/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

//create firestore object

  final CollectionReference Collection =
      FirebaseFirestore.instance.collection('info');

  Future updateUserData(String email, String username, String password) async {
    return await Collection.doc(uid).set({
      'uid': uid,
      'email': email,
      'password': password,
      'username': username
    });
  }
// list of infos of user from current state(snapshot)

// List<UserData> _UserInfoFromSnapShot(QuerySnapshot snapshot){
//   return snapshot.docs.map((doc){
//     //single user object
//     return UserData(
//       username:doc.get('username')??'',
//       email:doc.get('email')??'',
//       password:doc.get('password')??'',
//       uid:doc.get('uid')??'',
//      );
//   }).toList();
// }

// //userdata from snapshot
// UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
//   return UserData(
//     email: snapshot.get('email'),
//     password:snapshot.get('password') ,
//     uid:snapshot.get('uid'),
//     username:snapshot.get('username')
//     );
// }
// //get infos streams
// Stream<List<UserData>> get info{
//   return Collection.snapshots().map(_UserInfoFromSnapShot);
// }
// //get user doc streams
// Stream<UserData> get userData{
//   return Collection.doc(uid).snapshots().map(_userDataFromSnapshot);
// }
}
