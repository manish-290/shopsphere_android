import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_sphere/authentication_page/login.dart';
import 'package:shop_sphere/authentication_page/verifyEmail.dart';

import '../firebase_helper/firebase_auth.dart';

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
      backgroundColor: Color.fromARGB(255, 137, 137, 131),
      appBar: AppBar(
        leading: Icon(Icons.supervised_user_circle,color: Colors.white,),
        backgroundColor: Colors.black,
        title:
            Text('SignUp to ShopSphere', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: Image.asset(
                  'assets/images/shopsphere.png',
                  width: 150,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                        ),
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
                          
                          decoration: InputDecoration(
                            border:InputBorder.none,
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: TextFormField(
                          
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              value!.isEmpty ? "Provide your email!" : null,
                          controller: emailController,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: Container(
                        decoration:BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) => (value!.length < 6)
                              ? "Please fill password of at least 6 characters!"
                              : null,
                          controller: passwordController,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                              label: Text('Enter Password'),
                              labelStyle: TextStyle(color: Color.fromARGB(218, 3, 64, 114)),
                              prefixIcon: Icon(
                                Icons.password_rounded,
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: TextFormField(
                          obscureText: true,
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                              label: Text('Confirm Password'),
                              labelStyle: TextStyle(color: Color.fromARGB(220, 4, 62, 109)),
                              prefixIcon: Icon(Icons.password_sharp,
                                  color: Colors.black)),
                        ),
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
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 4, 50, 88),
                      borderRadius: BorderRadius.circular(20)),
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
                Text('Already have an account?',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    "Login",
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
