import 'dart:convert';

import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();

  void showSnackBarFn(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "$message",
          style: GoogleFonts.lato(
            color: Colors.white,
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: Text(
          "Notification Screen",
          style: GoogleFonts.lato(
            color:Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextFormField(
                  controller: _title,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      hintText: "Notification title"),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextFormField(
                  controller: _body,
                  maxLines: 5,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      hintText: "Notification body"),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(230, 22, 7, 1),
                ),
                onPressed: () async{
                  if (_title.text.isNotEmpty && _body.text.isNotEmpty) {
                    List<String?> usersToken =  appProvider.getUsersToken;
                  sendNotificationToAllUsers(usersToken, _title.text, _body.text);
                                     // sendNotificationToAllUsers(
                    //   //appProvider.getUsersToken
                    //  FirebaseMessaging.instance.getToken() , _title.text, _body.text);
                    _title.clear();
                    _body.clear();
                  } else {
                    showSnackBarFn(context, "Fill the details");
                  }
                },
                child: const Text("Send",style:TextStyle(color:Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> sendNotificationToAllUsers(
    List<String?> usersToken, String title, String body) async {
      print(usersToken);
  List<String> newAllUserToken = [];
  // List<String> allUserToken = [];

  for (var element in usersToken ) {
    print("hello");
    if (element != null || element != "") {
      newAllUserToken.add(element!);
    }
  }
  // allUserToken = newAllUserToken;
  const String serverKey =
      'AAAAwOyonWU:APA91bHlK3csKyPZFJbXK3Jc8O0a18q3q-n_aKXyMFUuOPJKkaDJgRQ3_BOy__cOWPnf84jWcl88wKgrrNyz7YnAb6uCHw8QWbimoIcDKeKDn6LN2OqUPZgCgFXp9rQVHCRRYkw0KTFc';
  const String firebaseUrl =
      'https://fcm.googleapis.com/fcm/send'; // Use the correct FCM URL

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };
  final Map<String, dynamic> notification = {
    'title': title, 
    'body': body,
    };
  final Map<String, dynamic> requestBody = {
    'notification': notification, // Correct key name
    'priority': 'high',
    'registration_ids': newAllUserToken
  };

  final String encodedBody = jsonEncode(requestBody);

  final http.Response response = await http.post(
    Uri.parse(firebaseUrl),
    headers: headers,
    body: encodedBody,
  );
  print(response.body);
  if (response.statusCode == 200) {
    print("Notification sent successfully");
  } else {
    print("Notifications sending failed with ${response.statusCode}");
  }
}


// import 'dart:convert';

// import 'package:admin_panel_shopsphere/provider/app_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   TextEditingController _title = TextEditingController();
//   TextEditingController _body = TextEditingController();

//   void showSnackBarFn(BuildContext context, String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(
//           backgroundColor: Colors.red,
//           content: Text("$message",
//         style:GoogleFonts.lato(
//           color:Colors.white,
        
//            ))));
//   }

//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     return Scaffold(
//         appBar: AppBar(
//             backgroundColor: Colors.black,
//             elevation: 10,
//             title: Text("Notification Screen",
//                 style: GoogleFonts.lato(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ))),
//         body: Padding(
//           padding: const EdgeInsets.only(top: 20.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 20.0, vertical: 10),
//                   child: TextFormField(
//                     controller: _title,
//                     decoration: InputDecoration(
//                         enabledBorder: OutlineInputBorder(),
//                         hintText: "Notification title"),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 20.0, vertical: 10),
//                   child: TextFormField(
//                     controller: _body,
//                     maxLines: 5,
//                     decoration: InputDecoration(
//                         enabledBorder: OutlineInputBorder(),
//                         hintText: "Notification body"),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         primary: Color.fromRGBO(230, 22, 7, 1)),
//                     onPressed: () {
//                       if (_title.text.isNotEmpty && _body.text.isNotEmpty) {
//                         sendNotificationToAllUsers(
//                             appProvider.getUsersToken, _title.text, _body.text);
//                         _title.clear();
//                         _body.clear();
//                       } else {
//                         showSnackBarFn(context, "Fill the details");
//                       }
//                     },
//                     child: Text("Send"))
//               ],
//             ),
//           ),
//         ));
//   }
// }

// Future<void> sendNotificationToAllUsers(
//     List<String?> usersToken, String title, String body) async {
//   List<String> newAllUserToken = [];
//   List<String> allUserToken = [];

//   for (var element in usersToken) {
//     if (element != null || element != "") {
//       newAllUserToken.add(element!);
//     }
//   }
//   allUserToken = newAllUserToken;
//   const String serverKey =
//       'BI9uyNC2T1v11yHrqF-fJrEF3qINgA55G_e8GE0in3olSJCmv3hQid93vNU93dEHbjPMh0PtkrT2hbPVz5NLFKY';

//   String firebaseUrl = 'fJrEF3qINgA55G_e8GE0in3olSJCmv3hQid93vNU93dEHbjPMh0PtkrT2hbPVz5NLFKY';
//   final Map<String, String> headers = {
//     'Content-Type': 'application/json',
//     "Authorization": 'key=${serverKey}'
//   };
//   final Map<String, dynamic> notification = {'title': title, 'body': body};
//   final Map<String, dynamic> requestBody = {
//     'notifications': notification,
//     'priority': 'high',
//     'registration_ids': allUserToken
//   };
// // requestBody['registration_ids']=usersToken;
//   final String encodedBody = jsonEncode(requestBody);

//   final http.Response response = await http.post(Uri.parse('$firebaseUrl'),
//       headers: headers, body: encodedBody);
//   if (response.statusCode == 200) {
//     print("Notification sent successfully");
//   } else {
//     print("Notifications sending failed with ${response.statusCode}");
//   }
// }
