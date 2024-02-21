import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:shop_sphere/authentication_page/login.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
   Timer? timer;
@override 
void initState(){
  super.initState();
  //user needs to be created before
  isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

  if(!isEmailVerified){
    sendVerificationEmail();

   timer = Timer.periodic(Duration(seconds:3), (_)=>checkEmailVerified());
  }
}
@override 
void dispose(){
  timer?.cancel();
  super.dispose();
}
//check for email verification
Future checkEmailVerified() async{
 try{
 await FirebaseAuth.instance.currentUser!.reload();
  setState(() {
    isEmailVerified=  FirebaseAuth.instance.currentUser!.emailVerified;
  });
  if(isEmailVerified) timer?.cancel();
 } on FirebaseAuthException catch(e){
  print('Firebase Auth Exception : ${e.code}:${e.message}');
 }
}



 Future sendVerificationEmail() async{
    try{
      final user =  FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
    }catch(e){
      print("Error sending verification email");
    }
  }

  @override
  Widget build(BuildContext context) =>isEmailVerified
  ?const Login()
  :Scaffold(
    backgroundColor: Colors.grey[400],
    appBar: AppBar(
      centerTitle: true,
      backgroundColor: Colors.black.withOpacity(0.5),
    title: Text('Verify Email'),
  ),
  body:const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Please verify your email",
        style:TextStyle(
          fontSize:20,
          fontWeight: FontWeight.bold,
          color:Colors.white
        )),
        Gutter(),
        Icon(Icons.email,color:Colors.green)
      ],
    ),
  ));
   
}