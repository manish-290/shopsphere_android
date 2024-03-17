// import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin_panel_shopsphere/authentication%20page/admin-login.dart';
import 'package:admin_panel_shopsphere/authentication%20page/verifyEmail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/firebase-auth.dart';
// import 'package:shop_sphere/authentication_page/login.dart';
// import 'package:shop_sphere/authentication_page/verifyEmail.dart';
//
// import '../firebase_helper/firebase_auth.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  String username = '';
  String email = '';
  String password = '';
  String error = '';

  bool loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FirebaseAuthHelper _auth = FirebaseAuthHelper();
  bool isHidePasswordFirst = true;
  bool isHidePasswordSecond = true;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: const Color.fromARGB(255, 137, 137, 131),
      appBar: AppBar(
        leading: const Icon(Icons.supervised_user_circle,color: Colors.white,),
         backgroundColor: Colors.transparent,
          flexibleSpace:Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color.fromARGB(255, 3, 65, 115), Color.fromARGB(255, 176, 5, 202)], // Add your desired colors here
              ),
            ),
          ) ,
        title:
        Text(' Admin Sign-Up', style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: Image.asset(
                  'assets/images/app-icon.jpg',
                  width: 150,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: TextFormField(
                        validator: (value) =>
                        value!.isEmpty ? "Enter your username!" : null,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {
                          setState(() {
                            username = val;
                          });
                        },
                        controller: usernameController,

                        decoration: const InputDecoration(

                            border:OutlineInputBorder(
                                borderSide: BorderSide(width: 2,color:Colors.black)
                            ),
                            label: Text('Username'),
                            labelStyle: TextStyle(color: Color.fromARGB(255, 3, 70, 125)),
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: TextFormField(

                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                        value!.isEmpty ? "Provide your admin email!" : null,
                        controller: emailController,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        decoration: const InputDecoration(
                            border:OutlineInputBorder(
                                borderSide: BorderSide(width: 2,color:Colors.black)
                            ),
                            label: Text('Email'),
                            labelStyle: TextStyle(color: Color.fromARGB(206, 3, 70, 124)),
                            hintText: 'Email@...',

                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) => (value!.length < 6)
                            ? "Please fill password of at least 6 characters!"
                            : null,
                        controller: passwordController,
                        obscureText: isHidePasswordFirst,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        decoration:  InputDecoration(
                            border:OutlineInputBorder(
                                borderSide: BorderSide(width: 2,color:Colors.black)
                            ),
                            label: Text('Enter Password'),
                            labelStyle: TextStyle(color: Color.fromARGB(218, 3, 64, 114)),
                            suffixIcon:  MaterialButton(
                                child: isHidePasswordFirst
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    isHidePasswordFirst = !isHidePasswordFirst;
                                  });
                                }),
                            prefixIcon: Icon(
                              Icons.password_rounded,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child:  TextFormField(
                        obscureText: isHidePasswordSecond,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        keyboardType: TextInputType.text,
                        validator: (value) => (value!.length < 6)
                            ? "Please match your password!"
                            : null,
                        controller: passwordController,
                        decoration:  InputDecoration(
                            border:OutlineInputBorder(
                                borderSide: BorderSide(width: 2,color:Colors.black)
                            ),
                            label: Text('Confirm Password'),
                            labelStyle: TextStyle(color: Color.fromARGB(220, 4, 62, 109)),
                            suffixIcon:  MaterialButton(
                                child: isHidePasswordSecond
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    isHidePasswordSecond = !isHidePasswordSecond;
                                  });
                                }),
                            prefixIcon: Icon(Icons.password_sharp,
                                color: Colors.black)),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate(
                  )) {
                    setState(() {
                      loading = true;
                    });
                    try {

                      dynamic result = await _auth.signup(email, password,username);
                      if (result == null) {
                        error = 'Please enter the valid email and password';
                        loading = false;
                      } else {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => VerifyEmailPage()));
                      }
                    } catch (e) {
                      print('tell me error:$e');
                    }
                  }
                },
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 127, 2, 96),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('SignUp',
                          style: GoogleFonts.lato(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an Admin account?',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    "Login",
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
