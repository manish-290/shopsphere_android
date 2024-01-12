import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi{
  //create an instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  //function to initialize the notifications
  Future<void> initNotifications() async{

    //request permission from user
    await _firebaseMessaging.requestPermission();

    //fetch the fcm token for this device
  final fcmToken = await _firebaseMessaging.getToken();
  print(fcmToken);

  }
}