
import 'dart:io';

import 'package:admin_panel_shopsphere/helpers/firebasePush.dart';
import 'package:admin_panel_shopsphere/helpers/firestore_helper.dart';
import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:admin_panel_shopsphere/screens/homePage/home_page.dart';
import 'package:admin_panel_shopsphere/screens/notificationScreen/notification_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
      options:kIsWeb || Platform.isAndroid? FirebaseOptions(
          apiKey: 'AIzaSyDUZ-4RoWfM1QOoMujLGAzyDZQlm7k7rS4',
          appId: '1:828604194149:android:a3e00a2a26c5869fe4d58c',
          messagingSenderId: '828604194149',
           storageBucket: "shopsphere-commerce.appspot.com",
          projectId: 'shopsphere-4ea75'):null);
          //for notification:
  //          FirebaseMessaging messaging = FirebaseMessaging.instance;
  // await messaging.requestPermission();
  // String? token = await messaging.getToken();
  // print('FCM Token: $token');
          // await FirebaseApi().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (context)=>AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title:"Admin-Panel",
        theme:ThemeData(
          primarySwatch: Colors.blue
        ),
        home:HomePageAdmin()
      ),
    );
  }
}